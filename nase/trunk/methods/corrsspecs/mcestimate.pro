;+
; NAME:
;  mcestimate()
;
; VERSION:
;  $Id$
;
; AIM:      Computes the multiple coherence (MC) estimate
;  
;
; PURPOSE:
;           Multiple Coherence (MC) Estimate. In 1963, the multiple coherence estimate or <I>sample multiple
;           coherence</I> was introduced in [1]. The MC estimate between
;           a reference channel x<SUB>j</SUB> and channels
;           <*>x<SUB>i</SUB>,..,x<SUB>j-1</SUB>,x<SUB>j+1</SUB>,..,x<SUB>M</SUB></*> 
;           is defined as <BR><*>|C<SUB><FONT SIZE=-1>
;           j:1,..,j-1,j+1,..,M</FONT></SUB>(f)|<SUP>2</SUP> = 1 -
;           1/(S<SUB>jj</SUB>(f)S<SUP>jj</SUP>(f))</*>,<BR>
;           where <*>S<SUB>jj</SUB>(f)</*> is the j-th diagonal element of
;           the estimatetd cross spectral density matrix
;           <*>S<SUB>xx</SUB>(f)</*> and
;           <*>S<SUP>jj</SUP>(f)</*> ist the j-th diagonal element of the
;           inverse of <*>S<SUB>xx</SUB>(f)</*>. As with the pairwise
;           <A>COHERENCE</A>, the MC estimate is bounded between zero
;           and one. Furthermore, the MC estimate is equal 1 if and
;           only if <*>x<SUB>j</SUB></*> is exactly linearly related to the
;           other channels and if <*>x<SUB>j</SUB></*> is orthogonal to the
;           other channels, the MC estimate becomes zero. However, the
;           the MC estimate is in general not invariant to reordering
;           of the channels. The distributen of the estimate
;           conditioned on the value of multiple coherence function is
;           given in [1]. A multiple-channel nonparametric detector
;           based on MC estimate as defined before was introduced in [2].
;           <BR>Please note that the multiple
;           coherence for two channels <*>N=2</*> is identical to the pairwise <A>COHERENCE</A>
;
;           <BR>
;           [1] N. R. Goodman, "Statistical analysis based uppon a
;           certain multivariate complex gaussian distrobution (an
;           introduction)", Annals of Mathematical Statistics,
;           vol. 34, pp. 152-177, 1963.
;           <BR>
;           [2] R. D. Trueblood and D. L. Alspach, "Multiple coherence
;           as a detection statistic", Tech. Rep., Naval Ocean Systems
;           Center, San Diego, 1978.
;
; CATEGORY:
;  Signals
;  
;
; CALLING SEQUENCE:
;*mc = mcestimate (X [, F=F][, dimension=dimension][, SamplePeriod=SamplePeriod][, /double][, /correction])
;
; INPUTS:
;         X:: An  float (double) array of 3 or more dimensions,
;             representing the M signal ensembles between
;             which the generalized coherence is to be determined. The
;             1st dimension is interpreted to represent
;             the M channels, the independent
;             variable of the signal epochs (e.g., time) is always
;             assumed to be represented in the 2nd dimension. By
;             default, the 3nd dimension is interpreted to represent
;             different realizations, i.e., the members of the
;             ensemble(s) of signal epochs. This can be changed via the
;             keyword <*>DIMENSION</*>.
;
;
; INPUT KEYWORDS:
;         
;         DIMENSION::      Set this keyword to an integer scalar giving
;                          the dimension which is to be interpreted as the dimension
;                          containing the different realizations, i.e.,
;                          "trials" (default: 3). Since the 1st dimension is reserved
;                          for the signal epochs themselves, <*>DIMENSION</*> must be &gt;=3, and of course it must be
;                          &lt;= <*>N<SUB>Dim</SUB></*>, where <*>N<SUB>Dim</SUB></*> is the number of dimensions of <*>x</*> 
;         SAMPLEPERIOD::   Set this keyword to an float
;                          scalar giving the sample period (in seconds) which is assumed
;                          to have been used in sampling the signals <*>x</*> (default: 0.001). The only effect of
;                          this parameter is on the scaling of the frequency axis <*>f</*>.
;         DOUBLE::         Set this keyword if you want double precision
;
; OUTPUTS:
;   
;         mc::             A (double) float array of the same dimensional
;                          structure as <*>x</*>, but with the Channel (2nd) and DIMENSIONth dimension
;                          missing, and containing the generalized coherence
;                          function(s) in the 1st dimension. Moreover, the 1st
;                          dimension is reduced to half 
;                          of its original length (i.e., compared to x).
;
; OPTIONAL OUTPUTS:
;         F::              Set this keyword to a named variable which on return
;                          will be a 1-dimensional array of the same length as the
;                          1st dimension of <*>mc</*>, providing the frequency axis 
;                          for the coherence function(s).
;
; PROCEDURE:
;            IDL's version of multiple coherence (MC) estimate.
;
; EXAMPLE:
;  Generate three stochastic processes with a coherent oscillation at 60 Hz, and determine their coherence:
;
;* x = FltArr(128,3, 20) ;; array(time,channel,trials)
;* RandomPhases = RandomU(seed,3,20) * 2*!pi
;* FOR  i = 0, 19  DO  x[*,0,i] = RandomN(seed, 128) + Cosine(60.0, RandomPhases[i], 500.0, 128, /samples)
;* FOR  i = 0, 19  DO  x[*,1,i] = RandomN(seed, 128) + Cosine(60.0, RandomPhases[i], 500.0, 128, /samples)
;* FOR  i = 0, 19  DO  x[*,2,i] = RandomN(seed, 128) + Cosine(60.0, RandomPhases[i], 500.0, 128, /samples)
;* mc = mcestimate(x, SAMPLEPERIOD = 0.002, F = f)
;* !P.MULTI=[0,1,3]
;* Plot, f, mc(0,*), yrange = [0,1]
;* Plot, f, mc(1,*), yrange = [0,1]
;* Plot, f, mc(2,*), yrange = [0,1]
; SEE ALSO:
;  <A>COHERENCE</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


;;this was empirically estimated by gaussian white noise
function __mcbias, n_chan, n_epoch
   if n_epoch LE n_chan then begin
      console, "epoch number must be greater equal than channel number", /fatal
   endif
   return, double(n_chan-1)/double(n_epoch)
end

;;multiple coherence
function mcestimate, X, F=F, dimension=dimension, SamplePeriod=SamplePeriod, double=double, correction=correction, smooth=smooth_, _extra=e 


default, correction, 0;; correction against over estimates of coherence
default, SamplePeriod, 0.001
default, dimension, 3;; dimension to average
default, smooth_, 0
sizex = size(x)
n_chan = sizex(2);; channel dimension
n_time = sizex(1) ;; time window dimension
n_epoch = sizex(dimension) ;;epoch dimension (of average dimension)
n_epoch_tot = sizex(sizex(0)+2)/(n_chan*n_time);;total epoch dimension
fS = 1.0 / SamplePeriod  ;; the sample frequency

;;hamming window 
W = Hamming(n_time)

default, Double, (sizex[sizex[0]+1] eq 5)

;; the frequency axis is constructed:
f = fS * FIndGen(n_time) / n_time
f = f < (fS-f)
f  = f[ 0:n_time/2]

;;first index time, second index channel
if double eq 1 then begin
   A = dcomplexarr(n_chan, n_chan, n_time/2+1,n_epoch_tot)
   ;result = dblarr(n_chan, n_time/2+1, n_epoch_tot)
   result = dblarr(n_chan, n_time/2+1, n_epoch_tot/n_epoch)
end else begin
   A = complexarr(n_chan, n_chan, n_time/2+1,n_epoch_tot)
   result = fltarr(n_chan, n_time/2+1,n_epoch_tot/n_epoch)
   ;result = fltarr(n_chan, n_time/2+1,n_epoch_tot)
end

;;Reform the signal array for easier FOR-loop handling:
X = reform(X, n_time, n_chan, n_epoch_tot, /overwrite)

;;compute the GRAM-MATRIX (COV-matrix of spectra)
for i_e=0l,n_epoch_tot-1 do begin 
   for i_c=0l, n_chan-1 do begin
     
      if smooth_ Ge 1 then begin  
         ;;smoothing for siginficance enhancement
         Si = (shift(smooth(shift(FFT(X(*, i_c, i_e)*W), n_time/2-1), smooth_ , /EDGE), -(n_time/2-1)))(0:n_time/2)
      end else begin
         Si = (FFT(X(*, i_c, i_e)*W))(0:n_time/2)
      end
      
      for j_c=0l, i_c do begin
         if smooth_ Ge 1 then begin  
            ;Sj = (smooth((FFT(X(*, j_c, i_e)*W)), smooth_ , /EDGE))(0:n_time/2)
            Sj = (shift(smooth(shift(FFT(X(*, j_c, i_e)*W), n_time/2-1), smooth_ , /EDGE), -(n_time/2-1)))(0:n_time/2)
         end else begin
            Sj = (FFT(X(*, j_c, i_e)*W))(0:n_time/2)
         end
      
         ;;compute the cross spectra; array elements of gram matrix
         A(i_c,j_c, *, i_e)= Si*conj(Sj)
         
         if i_c ne j_c then A(j_c,i_c, *, i_e) = conj(A(i_c,j_c, *, i_e))
      endfor
   endfor
endfor
undef, Si
undef, Sj

;;back reform
X = Reform(X , sizex(1:sizex(0)), /overwrite)
A = Reform(A, [n_chan, n_chan, n_time/2+1, sizex(3:sizex(0))], /overwrite)

;;average over epochs
A = total(temporary(A), dimension+1)

;;reform for easier loop handling
A = REFORM(A, [n_chan, n_chan, n_time/2+1, n_epoch_tot/n_epoch], /overwrite)

diagIndex = LINDGEN(n_chan)*(n_chan+1)
;;compute the multiple coherence
for i_e=0l, n_epoch_tot/n_epoch-1  do begin
;for i_e=0l, n_epoch_tot-1 do begin
   for i_t=0l, n_time/2+1-1 do begin
      ;;compute the complex inverse COV-matrix and evaluate the
      ;;coherence for each reference channel
      ;;(extract diagonal vector)
     
      ;ADIAG = (reform(A(*, *, i_t, i_e)))(diagIndex)
      if idlversion(/float) GE 5.6 then begin
         ;ADIAG_inv = (LA_INVERT(reform(A(*, *, i_t, i_e)), double=double))(diagIndex)
         result(*, i_t, i_e) = ((reform(A(*, *, i_t, i_e)))(diagIndex) * $
          (LA_INVERT(reform(A(*, *, i_t, i_e)), double=double))(diagIndex))
      end else begin
         ;ADIAG_inv = (LU_COMPLEX(reform(A(*, *, i_t, i_e)), dummy, double=double, /inverse))(diagIndex)
         result(*, i_t, i_e) = ((reform(A(*, *, i_t, i_e)))(diagIndex) * $
          (LU_COMPLEX(reform(A(*, *, i_t, i_e)), dummy, double=double, /inverse))(diagIndex))
      end
      ;result(*, i_t, i_e) =  abs(ADIAG(*)*ADIAG_inv(*))
   endfor;;i_t
endfor;;i_e



;;find the back reform dimensions
for i=3, sizex(0) do begin
   if i ne dimension then dims =concat(dims, [sizex(i)], /extend)
endfor

;;free memmory
undef, A

;;reform dimension
if set(dims) then begin
   result = reform(1.0d - result^(-1.0d), [n_chan, n_time/2+1,dims], /overwrite)
end else result = reform(1.0 - result^(-1.0), /overwrite)

;;bias correction
if correction eq 1 then begin
   result = (temporary(result) - __mcbias(n_chan, n_epoch)) > 0
end
;;return the result

return, result
end

;maxn = 4
;plot, 1+indgen(maxn), indgen(maxn), yrange=[0, 1], /nodata
;for n=3, maxn-1 do begin


;ntrial = 50
;x = FltArr(128,n, ntrial) ;; array(time,channel,trials)
;RandomPhases = RandomU(seed,n,ntrial) * 2*!pi
;for j=0, n-1 do begin
;   FOR  i = 0, ntrial-1  DO  begin 
;         x[*,j,i] = RandomN(seed, 128)+ Cosine(60.0, RandomPhases[i], 500.0, 128, /samples) ;RandomN(seed, 128)
;         if  j eq 0 then x[*,j,i] = RandomN(seed, 128)
;   endfor;
;endfor

;mc = mcestimate(x, SAMPLEPERIOD = 0.002, F = f, /corr)

;;ptvs, mc,yrange=f, /legend, zrange=[0, 1]
; oplot,[n], [fztmean(mc)], psym=2
 
;endfor
;oplot, 1+findgen(maxn), (findgen(maxn))/double(ntrial)
;end
