;+
; NAME:
;  WLT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Wavelettransformation of a data set
;
; PURPOSE:
;  An array (up to 7 dimensions) of signals is transformed by a wavelet with specified <*>frequency</*>
;  an number of periods <*>NPERIODS</*>. This function is called by <A>WLA</A> with different frequencies
;  to create a transformation over time and frequency. For further description of the comparability with the
;  <A>Spectrum</A> function see in the documentation of <A>WLA</A>. In this function a scaling factor is used
;  to deliver for pure sine signals the same values as <*>Spectrum</*> at the frequency: <BR>
;  <*>f = nperiods*1000 / SSIZE</*>  (factor 1000 because SSIZE is given in ms)<BR>
;  where <*>SSIZE</*> is the length of the signal fragment, when <*>Spectrum</*> is used in combination with
;  <A>Slices</A>. (A fragment of length SSIZE will contain just nperiods periods of frequency f).
;
; CATEGORY:
;  Algebra
;  Math
;  Signals
;
;
; CALLING SEQUENCE:
;*    ts = WLT(signal, fsample, frequency [,NPERIODS=...] [,/AMPLITUDE] [,/POWER])
;
;
; INPUTS:
;  signal:: An array containing in the first dimension the time
;  fsample:: The sample frequency
;  frequency:: The frequency of the wavelet with which the convolution shall be performed.
;
; INPUT KEYWORDS:
;  NPERIODS:: Number of periods of the wavelet. Standard value is 7.
;  AMPLITUDE:: If this keyword is set, the function will return the magnitude of the complex output (which is float or double type)
;  POWER:: If this keyword is set, the function will return the square of the magnitude (which is float or double type)
;
; OUTPUTS:
;  ts:: An array with the same dimensional structure as <*>signal</*> containing the transformation of the signal. The type will be
;       complex if the keywords <*>AMPLITUDE</*> or <*>POWER</*> are not set, complex otherwise.
;
; RESTRICTIONS:
;  IDL supports arrays only in up to 8 dimensions
;
; PROCEDURE:
;  The function creates an complex array which contains a wavelet (via <A>WL</A>) and uses <A>IConvol</A> to compute the
;  convolution product of the input signal and the wavelet.
;
; EXAMPLE:
;  Plot the wavelettransformation of a cosine signal at 50Hz
;*  s = Cosine(50, 0, 500, 500)
;*  plot, FIndGen(500)/500, WLT(s, 500, 50, /AMP)
;*  oplot, FIndGen(500)/500, WLT(s, 500, 40, /AMP), color=rgb('green')
;*  oplot, FIndGen(500)/500, WLT(s, 500, 60, /AMP), color=rgb('red')
;
; SEE ALSO:
;  <A>WLA</A>,<A>WL</A>,<A>IConvol</A>
;
;-



FUNCTION  WLT, signal, fsample_, frequency_, nperiods = nperiods_, Amplitude=Amplitude, Power=Power


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------


   IF  (Set(signal)) THEN  BEGIN
      IF (Size(signal, /N_Dim) EQ 0)  THEN  Console,  '  signal must be (array of) data set. ', /fatal
      TypeSig = Size(signal, /type)
      IF (TypeSig GE 7) AND (TypeSig LE 11) AND (TypeSig NE 9)  THEN  Console, '  signal is of wrong type.', /fatal
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF  (Set(fsample_)) THEN  BEGIN
      IF (Size(fsample_, /N_Dim) GT 0)  THEN  Console,  '  fsample must be one-dimensional. ', /fatal
      TypeAb = Size(fsample_, /type)
      IF  (TypeAb GE 6) AND (TypeAb LE 11)  THEN  Console, '  fsample is of wrong type.', /fatal
      fsample = Float(fsample_)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF (fsample LE 0) THEN  Console,  ' fsample must be positive. ', /fatal
   IF  (Set(frequency_)) THEN  BEGIN
      IF  (Size(frequency_, /N_Dim) GT 0)  THEN Console,  '  frequency must be scalar. ', /fatal
      TypeFreq = Size(frequency_, /type)
      IF  (TypeFreq GE 6) AND (TypeFreq LE 11)  THEN  Console, '  frequency is of wrong type.', /fatal
      SizeFreq = Size(frequency_, /dim)
      frequency = Float(frequency_)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF (frequency LE 0) THEN  Console,  ' frequency must be positive. ', /fatal
   IF (frequency GE fsample/2.) THEN  Console,  ' frequency to high for sample frequency ',  /fatal
   IF  (Keyword_Set(nperiods_)) THEN  BEGIN
      IF  (Size(nperiods_, /N_Dim) GT 0)  THEN Console,  '  nperiods must be scalar. ', /fatal
      TypePer = Size(nperiods_, /type)
      IF  (TypePer GE 6) AND (TypePer LE 11)  THEN  Console,  '  nperiods is of wrong type.', /fatal
      nperiods = Float(nperiods_)
   ENDIF ELSE nperiods = 7.0



   ;----------------------------------------------------------------------------------------------------------------------
   ; Getting a wavelet and computing the wavelettransformation:
   ;----------------------------------------------------------------------------------------------------------------------

   WAVEL = WL(fsample, frequency, nperiods = nperiods)
   N  = Size(signal, /dim)
   N = N(0)
   IF  N LE N_ELEMENTS(WAVEL)  THEN  Console, '   Signal to short for wavelet.', /fatal


   WLSignals = IConvol(Signal,WAVEL) * 13.5829 / (fsample*1.5+1)
   IF (Keyword_Set(Power)) THEN BEGIN
     WLSignals = ABS(Temporary(WLSignals) * 0.178885)^2
     RETURN, WLSignals
   ENDIF
   WLSignals = Temporary(WLSignals) / sqrt(frequency / nperiods)
   IF (Keyword_Set(Amplitude)) THEN WLSignals = ABS(Temporary(WLSignals))

   RETURN, WLSignals


END
