;+
; NAME:
;  WL()
;
; VERSION:
;  $Id$
;
; AIM:
;  Creates a standard wavelet.
;
; PURPOSE:
;  The function returns a one dimensional complex array containing a wavelet form with specified
;  <*>frequency</*>, number of periods <*>nperiods</*> and sample frequency <*>fsample</*>. This
;  is used in the <A>WLT</A> function to compute a wavelet transform.
;
; CATEGORY:
;  Algebra
;  Math
;  Signals
;
; CALLING SEQUENCE:
;*    wave = WL(fsample, frequency [,NPERIODS=...])
;
; INPUTS:
;  fsample:: Sample frequency
;  frequency:: Frequency of the wavelet
;
; INPUT KEYWORDS:
;  NPERIODS:: Number of periods
;
; OUTPUTS:
;  wave:: A complex one dimensional array containing the wavelet form. It's length is given by: <BR>
;         <*> s = 1.5*nperiods*fsample/frequency + 1 </*>
;
; PROCEDURE:
;  The wavelet signal is
;  <*> w(t) = sqrt(2*frequency*sqrt(!PI)/nperiods) * EXP(-t^2/2/(frequency/nperiods)^2) * EXP(2*COMPLEX(0,1)*!pi*frequency*t) </*>
;  <BR>The signal starts and ends where (-t^2/2/(frequency/nperiods)^2) is about ABS(ALOG(1E-5))
;
; EXAMPLE:
;  Plot real and imaginary part of a wavelet with frequency 20Hz at 500Hz sample frequency
;*  plot, FIndGen(280)/500, WL(500, 20)
;*  oplot, FIndGen(280)/500, imaginary(WL(500,20)), color=rgb('green')
;
; SEE ALSO:
;  <A>WLT</A>,<A>WLA</A>
;
;-



FUNCTION  WL, fsample_, frequency_, nperiods = nperiods_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------


   IF  (Set(fsample_)) THEN  BEGIN
      IF (Size(fsample_, /N_Dim) GT 0)  THEN  Console,  '  fsample must be scalar. ', /fatal
      TypeAb = Size(fsample_, /type)
      IF  (TypeAb GE 6) AND (TypeAb LE 11)  THEN  Console, '  fsample is of wrong type.', /fatal
      fsample = Float(fsample_)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF (fsample LE 0) THEN  Console,  ' fsample must be positive. ', /fatal
   IF  (Set(frequency_)) THEN  BEGIN
      IF  (Size(frequency_, /N_Dim) GT 0)  THEN Console,  '  frequency must be scalar. ', /fatal
      TypeFreq = Size(frequency_, /type)
      IF  (TypeFreq GE 6) AND (TypeFreq LE 11)  THEN  Console, '  frequency is of wrong type.', /fatal
      f0 = FLOAT(frequency_)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF (f0 LE 0) THEN  Console,  ' frequency must be positive. ', /fatal
   IF (f0 GE fsample/2.) THEN  Console,  ' frequency to high for sample frequency ',  /fatal
   IF  (Keyword_Set(nperiods_)) THEN  BEGIN
      IF  (Size(nperiods_, /N_Dim) GT 0)  THEN Console,  '  nperiods must be scalar. ', /fatal
      TypePer = Size(nperiods_, /type)
      IF  (TypePer GE 6) AND (TypePer LE 11)  THEN  Console,  '  nperiods is of wrong type.', /fatal
      nperiods = Float(nperiods_)
   ENDIF ELSE nperiods = 7.0



   ;----------------------------------------------------------------------------------------------------------------------
   ; Creating a standard wavelet with the given frequency and number of periods:
   ;----------------------------------------------------------------------------------------------------------------------


   sf = f0 / nperiods
   st = 1 / (2*!pi*sf)
   A  = 1 / SQRT(st*SQRT(!pi))

   N = 1.5 * nperiods * fsample / f0 + 1
   t = (FINDGEN(N)-FLOOR(N/2))/fsample
   ExpArg = -t^2 / (2*st^2)
   Wavel = A * EXP(ExpArg) * EXP(2*COMPLEX(0,1)*!pi*f0*t)
   RETURN, Wavel


END
