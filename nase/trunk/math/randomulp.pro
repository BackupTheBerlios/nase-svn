;+
; NAME:
;  RandomuLP()
;
; VERSION:
;  $Id$
;
; AIM:
;  generates sequence of uniformly distributed, low pass filtered
;  random values 
;
; PURPOSE:
;   This function computes uniformly distributed pseudo random values
;   in a low frequency range. This is no trivial problem, since
;   filtering of random signal introduces serial correlations that
;   change the underlying statistics.<BR>
;   <B>Copyright (c) 2001, MUA Research (Th. Schanze, Marburg, Germany)</B>
;
; CATEGORY:
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;  R = RandomuLP(n, f [,MYSEED=...] [,/GAUSS] [,/TAPER])
;
; INPUTS:
;  n :: The number of data points to be computed.
;  f :: Transition frequency of the low pass filter. Note that 0 < f <= 0.5 must hold;
;	f=0.5 means filtering at the Nyquist frequency. If round(f*n)<1 then f=1/n is set.
;       Note that for a good uniform distribution f*n>=50 should hold.
;
; INPUT KEYWORDS:
;  MYSEED:: provide a specific seed value for the random generator
;   GAUSS:: a slower but exact transformation for the Gaussian
;	    PDF is used
;   TAPER:: If set, then a slight tapering achieves an exact -3 dB point at f>0.
;
; OUTPUTS:
;  R:: Contains a sequence of n uniformly distributed random values that are correlated
;      (equivalent to low pass filtering). However, the power spectral distribution can be
;      obtained via (abs(fft(result,1))^2.
;      Note that for a good uniform distribution f*n>=50 should hold.
;
; COMMON BLOCKS:
;  COMMON_RANDOM  
;
; EXAMPLE:
;*R=RandomuLP(1000,0.2,/taper)
;  Result contains a vector of n uniformly distributed random values, which are correlated
;  temporally.
;
; PROCEDURE:
;  A Gaussian variable is generated. After low pass filtering in the Fourier domain it is
;  transformed to a uniformly distributed random variable. Note that due Fourier filter
;  the correlation is cyclical.
;
;-

function randomuLP,n,f,myseed=myseed,Gauss=Gauss,taper=taper

COMMON common_random, seed

  m=10; for better GWN
  x=0
  
  IF (f LT 0) OR (f GT 0.5) THEN Console, 'requirement violated: 0<=f<= 0.5', /FATAL
  oh=round(1.0*f*n); frequency bin
  if oh lt 1 then oh=1; check
  IF KEYWORD_SET(MYSEED) THEN BEGIN
      for i=1,m do x=x+randomn(myseed,n) ; makes better GWN
  END ELSE BEGIN
      for i=1,m do x=x+randomn(seed,n) ; makes better GWN
  END
  x=fft(1.0d*x,1); double reduces fft underflow errors
  for i=oh+1,n-oh-1 do x(i)=0; symmetric filter in the frequency domain
  if keyword_set(taper) and (oh gt 0) then begin; soft tapering; makes -3 dB point
    x(oh)=sqrt(0.5)*x(oh)
    x(n-oh)=sqrt(0.5)*x(n-oh)
  end
  x=float(fft(x,-1)); only real data are needed
  x=x/stdev(x); normalisation
  if keyword_set(Gauss) then begin; making of uniformly distributed data
    x=Gauss_pdf(x); ideal transformation, if the data are exactly Gaussian
  end else begin
    fac1=sqrt(2./!pi); inspiration is sometimes helpful
    fac2=0.0715
    x=fac1*x
    x=0.5*(tanh(x+x^3*fac2)+1); a good approx. to Gauss_pdf, faster!
  end
  return,x
end
