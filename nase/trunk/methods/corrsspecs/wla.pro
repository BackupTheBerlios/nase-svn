;+
; NAME:
;  WLA()
;
; VERSION:
;  $Id$
;
; AIM:
;  Waveletanalysis
;
; PURPOSE:
;  This function computes the complex, amplitude, or power wavelettransformation of a signal epoch or of
;  several signal epochs arranged in a multi-dimensional array. There are several differences to the
;  capacities of other methods of data analysis. The <*>EXAMPLE</*> shows some effects for <*>WLA</*> and
;  <A>Spectrum</A> in comparison. <BR>
;  The frequency resolution depends on the <*>frequency</*> (higher frequency - lower resolution) and on
;  the number of periods of the wavelets <*>NPERIODS</*> (more periods - higher resolution). <BR>
;  The time resolution depends on the <*>frequency</*> (higher frequency - higher resolution) and
;  on the number of periods <*>NPERIODS</*> (more periods - lower resolution). <BR>
;  Higher number of periods would be usefull to reduce noise. <BR>
;  You get no information at the begin and end of the time domain (especially at low frequencies and with
;  higher number of periods) because the transformation uses the <*>Convol</*> function of IDL with keyword
;  <*>CENTER</*> set. <BR>
;  For more information (e.g. the scaling) look at the documentation of <A>WLT</A>.
;
; CATEGORY:
;  Algebra
;  Math
;  Signals
;
; CALLING SEQUENCE:
;*    as = WLA(signals, fsample, frequency [,NPERIODS=...] [,/AMPLITUDE] [,/POWER])
;
; INPUTS:
;  signals:: An array of up to 7 dimensions containing in the first dimension the time domain
;  fsample:: The sample frequency
;  frequency:: A byte, integer or float scalar or one dimensional array containing the frequencies
;              for which the wavelettransformation shall be transformed.
;
; INPUT KEYWORDS:
;  NPERIODS:: The number of periods of the wavelets. Standard value is set to 7.
;  AMPLITUDE:: Set this keyword to compute the magnitude of the otherwise complex output.
;  POWER:: Set this keyword to compute the power of the output. This keyword overrides the keyword <*>AMPLITUDE</*>
;
; OUTPUTS:
;  as:: An array with the same dimensional structure as <*>signals</*> plus an extra (frequency) dimension.
;       The data type is complex, if the keywords <*>AMPLITUDE</*> or <*>POWER</*> are set it is float.
;
; SIDE EFFECTS:
;  See RESTRICTIONS
;
; RESTRICTIONS:
;  The input signal must not have more than 7 dimensions (including time domain), even if
;  <*>frequency</*> is a scalar, because the function will return an array with one dimension
;  more (which is the frequency domain) than <*>signals</*> has. <BR>
;  With short signals, the function can't be used with very low frequencies (about < 5Hz),
;  because the corresponding wavelet would be too long for a convolution with the signal.
;  The length of the wavelet is:<BR>
;  <*> l = 1.5 * NPERIODS * fsample / frequency + 1 </*>
;
; PROCEDURE:
;  The function uses <A>WLT</A> in a for loop for the different frequencies.
;
; EXAMPLE:
;  The following lines will show you some features of the <*>WLA</*> function in comparison to the <*>Spectrum</*> function
;  This will take some seconds.
;
;*  sig = FltArr(4096)
;*  inf = Cosine(108, !PI/2., 500, 400)
;*  sig(1800:2199) = sig(1800:2199) + inf(0:399)
;*  inf = Cosine(54, !PI/2., 500, 400)
;*  sig(1200:1599) = sig(1200:1599) + inf(0:399)
;*  inf = FIndGen(50)-25
;*  inf = exp(-1*(inf^4))*5
;*  sig(2600:2649) = sig(2600:2649) + inf(0:49)
;
;  Analysis with <*>Spectrum</*>
;
;*  sigslices = Slices(sig, SSHIFT=2, SAMPLEPERIOD=0.002, SSIZE=64)
;*  specout = Spectrum(sigslices, 500, f, PADDING=8, /Amp)
;
;  Analysis with <*>WLA</*>
;*  g = f(2:Size(f, /N_ELEM)-2)
;*  waveout7 = WLA(sig, 500, g, nperiods=7, /AMP)
;
; Ergebnisse ausgeben
;
;*  Window, /Free, XSize=580, YSize=420
;*  Shade_Surf, specOut
;*  XYOuts, 1, 0, 'Time'
;*  XYOuts, 100, 0, 'Frequency'
;*  XYOuts, 0, 4000, 'Spectrum'
;*  Window, /Free, XSize=580, YSize=420
;*  Shade_Surf, WaveOut7
;*  XYOuts, 1, 0, 'Time'
;*  XYOuts, 100, 0, 'Frequency'
;*  XYOuts, 0, 4000, 'WLA'
;
; SEE ALSO:
;  <A>WLT</A>, <A>Spectrum</A>
;
;-




FUNCTION  WLA, signals, fsample_, frequency_, nperiods = nperiods_, Amplitude=Amplitude, Power=Power


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------


   IF  (Set(signals)) THEN  BEGIN
      NSig = Size(signals, /N_Dim)
      IF (NSig EQ 0)  THEN  Console,  '  signals must be (array of) data set. ', /fatal
      TypeSig = Size(signals, /type)
      IF (TypeSig GE 7) AND (TypeSig LE 11) AND (TypeSig NE 9)  THEN  Console, '  signals is of wrong type.', /fatal
      SizeSig = Size(signals, /dim)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF  (Set(fsample_)) THEN  BEGIN
      IF (Size(fsample_, /N_Dim) GT 0)  THEN  Console,  '  fsample must be one-dimensional. ', /fatal
      TypeAb = Size(fsample_, /type)
      IF  (TypeAb GE 6) AND (TypeAb LE 11)  THEN  Console, '  fsample is of wrong type.', /fatal
      fsample = Float(fsample_)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   IF (fsample LE 0) THEN  Console,  ' fsample must be positive. ', /fatal
   IF  (Set(frequency_)) THEN  BEGIN
      IF  (Size(frequency_, /N_Dim) GE 2)  THEN Console,  '  frequency must be scalar or one-dim array. ', /fatal
      TypeFreq = Size(frequency_, /type)
      IF  (TypeFreq GE 6) AND (TypeFreq LE 11)  THEN  Console, '  frequency is of wrong type.', /fatal
      SizeFreq = Size(frequency_, /dim)
      SF = SizeFreq(0)
      frequency = Float(frequency_)
   ENDIF ELSE  Console, '   Not all arguments defined.', /fatal
   FOR i = 0, SF-1 DO $
      IF (frequency(i) LE 0) THEN  Console,  ' frequency must be >0 and <(fsample/2). ', /fatal
   IF  (Keyword_Set(nperiods_)) THEN  BEGIN
      IF  (Size(nperiods_, /N_Dim) GT 0)  THEN Console,  '  nperiods must be scalar. ', /fatal
      TypePer = Size(nperiods_, /type)
      IF  (TypePer GE 6) AND (TypePer LE 11)  THEN  Console,  '  nperiods is of wrong type.', /fatal
      nperiods = Float(nperiods_)
   ENDIF ELSE nperiods = 7.0


   ;----------------------------------------------------------------------------------------------------------------------


   ; For the first frequency the wavelettransformation is computed
   WLSignals = WLT(signals, fsample, frequency(0), nperiods = nperiods, Amplitude=Amplitude, Power=Power)
   ; If frequency is an array with more than one element, the other frequencies are handled
   ; The first dimension of the output array becomes the frequency domain
   IF (SF EQ 1) THEN BEGIN
      RefVec = LIndGen(NSig+1) + 1
      RefVec(1:NSig) = SizeSig
      WLSignals = Reform(WLSignals, RefVec, /overwrite)
     ENDIF ELSE BEGIN
      WLSignals = ReplicateArr(WLSignals, SizeFreq)
      TransVec  = IndGen(NSig+1)-1
      TransVec(0) = NSig
      WLSignals = Transpose(WLSignals, TransVec)
      FOR  j = 1, (SF-1)  DO  $
        WLSignals(j,*,*,*,*,*,*,*) = WLT(signals, fsample, frequency(j), nperiods = nperiods, Amplitude=Amplitude, Power=Power)
   ENDELSE


   RETURN, WLSignals


END
