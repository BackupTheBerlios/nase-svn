;+
; NAME:
;  PowerSpec()
;
; VERSION:
;  $Id$
;
; AIM:
;  computes one or several power spectra
;
; PURPOSE:
;  computes the power spectrum for a single or
;  multiple time series
;
; CATEGORY:
;  Signals
;
; CALLING SEQUENCE:
;* ps = PowerSpec( series [,xaxis] [,SAMPLEPERIOD=sampleperiod] [,/DOUBLE]
;*                        [,/HAMMING] [,PHASE=phase] [,TRUNC_PHASE=trunc_phase]
;*                        [,KERNEL=kernel])
;
; INPUTS:
;  series:: a single time series or multiple
;           time series (time is first dimension)
;           with at least 10 elements in the time dimension
;
; INPUT KEYWORDS:    
;  HAMMING::      filtering with a hamming window
;                  (see IDL Online Help)
;  DOUBLE::       calculation is done with double
;                  precision (only working for IDL
;                  versions >= 4.0)
;  TRUNC_PHASE::  phase contributions dP will be
;                  set to zero, if dP <= (TRUNC_PHASE * MAX(ps))
;                  with 0 <= TRUNC_PHASE <= 1
;  KERNEL::       filter kernel for smoothinh the
;                  cross spectrum (useful if
;                  PHASES are evaluated)
;  SAMPLEPERIOD:: sample period of time series in
;                  seconds (default: 0.001 sec) 
;  COMPLEX::      if set, the complex fourier
;                  spectrum is returned, instead
;                  of their absolute value
;  NEGFREQ::      outputs also negative frequency
;                  components
;
;
; OUTPUTS:
;  ps:: the calculated power spectra (frequency is the first dimension)
;
; OPTIONAL OUTPUTS:
;  xaxis:: returns the corresponding frequencies to <*>ps</*>
;  phase:: returns the phase angles 
;
; SIDE EFFECTS:
;  <*>xaxis</*> will be overwritten
;
; RESTRICTIONS:
;  <*>series</*> has to contain at least 10 elements
;
; EXAMPLE:          
;* f1 = 3
;* f2 = 30
;* f3 = 13
;                   
;* series = 0.1*sin(findgen(1000)/1000.*2*!Pi*f1)
;* series = series + 0.05*sin(findgen(1000)/1000.*2*!Pi*f2)
;* series = series + 0.07*sin(findgen(1000)/1000.*2*!Pi*f3)
;                        
;* Window,/FREE
;* !P.Multi = [0,1,2,0,0]
;                        
;* Plot, series, TITLE='Time Series'
;                        
;* ps = PowerSpec(series, xaxis)
;* Plot, xaxis(0:40), ps(0:40),$
;*     TITLE='Powerspektrum',$
;*     XTITLE='Frequency / Hz', YTITLE='Power'
;
;-

FUNCTION PowerSpec, series, xaxis, hamming=HAMMING, DOUBLE=Double ,Phase=Phase ,NEGFREQ=NegFreq ,$
                    TRUNC_PHASE=TRUNC_PHASE, KERNEL=kernel, SAMPLEPERIOD=sampleperiod, COMPLEX=Complex
 

   d = (SIZE(series))(1:(SIZE(series))(0))
   IF N_Elements(D) GT 1 THEN nsig = PRODUCT(d(1:N_Elements(d)-1)) ELSE nsig=1
   series = REFORM(series, d(0), nsig, /OVERWRITE)
   
   
   IF Set(Phase) THEN _PHASE=0  ; crosspower has a somewhat strange handling of the phase keyword....
   FOR i=0l, nsig-1 DO BEGIN
       _series = REFORM(series(*,i))
       _PSpec = crosspower( _series, _series, xaxis, hamming=HAMMING,NEGFREQ=NegFreq ,$
                            DOUBLE=Double ,Phase=_Phase ,TRUNC_PHASE=TRUNC_PHASE,KERNEL=kernel,SAMPLEPERIOD=SAMPLEPERIOD,COMPLEX=Complex)
       IF i EQ 0 THEN PSpec = REBIN(_pspec, N_ELements(xaxis), nsig, /SAMPLE) $; i hvae to know the numbers of the frequency axis
                 ELSE PSpec(*,i) = _PSpec
       IF Set(PHASE) THEN BEGIN 
           IF i EQ 0 THEN Phase = REBIN(_phase, N_Elements(xaxis), nsig, /SAMPLE) $
                     ELSE Phase(*,i)=_Phase 
       END
   END
   IF nsig GT 1 THEN BEGIN
       PSpec = REFORM(PSpec, [N_Elements(xaxis), d(1:N_Elements(D)-1)])
       IF Set(PHASE) THEN Phase = REFORM(Phase, [N_Elements(xaxis), d(1:N_Elements(D)-1)])
   END

   series = REFORM(series, d, /OVERWRITE)
   Return,PSpec
END
