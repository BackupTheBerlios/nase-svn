;+
; NAME:
;  Envelope()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the amplitude envelope of a signal in a certain frequency band.
;
; PURPOSE:
;  This function computes the amplitude envelope for a signal epoch or for several signal epochs arranged in a
;  multi-dimensional array, and returns the envelope signal epoch(s), which has (have) the same type as the original
;  <*>signal</*>. In the multi-dimensional case, each epoch is treated independently of the others, and the first
;  dimension is interpreted as the variable parameter within each epoch (e.g., time). If you have several signal epochs
;  of equal length to be "enveloped", it is advisable to pass all of them in one array instead of using a <C>FOR</C>
;  loop in your program, so that the queries at the beginning of this routine are run through only once.<BR>
;  By default, this routine uses the <A>CosFlankFilter</A> function to generate the frequency-domain filter. It therefore
;  accepts the same keywords and inherits them. Please refer to the documentation of <A>CosFlankFilter</A> for further
;  details. If you want to supply your own frequency-domain filter function (not recommended), you can do this via the
;  keyword <*>FILTER</*>.<BR>
;  Since this routine spends most of its time calculating FFTs, the length of the signal epochs should be a power of 2.
;  By using the discrete Fourier transform, this routine implicitly assumes that each signal epoch is repeated
;  periodically to infinity in both directions. This might lead to counter-intuitive results near the edges of the signal
;  epoch(s).<BR>
;
; CATEGORY:
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* esignal = Envelope(signal, fS  [, FLOW=...] [, FHIGH=...] [, WLOW=...] [, WHIGH=...] [, /HERTZ] [, ATTENUATION=...]
;*                             |  [, FILTER=...]
;
; INPUTS:
;  signal::  An integer or float array containing the signal epoch(s) in the 1st dimension.
;  fS::      An integer or float scalar giving the frequency (in Hz) which was used for sampling the signal epoch(s).
;
; INPUT KEYWORDS:
;  FLOW::         cf. <A>CosFlankFilter</A>
;  FHIGH::        cf. <A>CosFlankFilter</A>
;  WLOW::         cf. <A>CosFlankFilter</A>
;  WHIGH::        cf. <A>CosFlankFilter</A>
;  HERTZ::        cf. <A>CosFlankFilter</A>
;  ATTENUATION::  cf. <A>CosFlankFilter</A>
;  FILTER::       If want to use a more elaborate, quite special filter for the envelopes instead of just a simple
;                 bandpass or bandstop filter, set this keyword to an integer, float or complex array which you want
;                 to be used as the frequency-domain transfer function. But take into consideration that the envelope
;                 concept makes sense only for a very limited class of filters, basically for bandpass filters. Do not
;                 supply your own filter if you are not really sure about what it means in this context.<BR>
;                 <*>FILTER</*> must be of the same length as <*>signal</*>; otherwise this routine stops execution with
;                 a fatal error message. Please note that the filter function must be constructed in an FFT-compatible
;                 way, i.e., with the negative frequency branch attached to the upper end of the positive frequency
;                 branch, and special attention paid to the zero and Nyquist frequency bins occurring only once each
;                 (if the number of data points is even). If this keyword is set, all other keywords are ignored.
;
; OUTPUTS:
;  fsignal::  An array of the same type and dimensional structure as <*>signal</*>, containing the amplitude envelope
;             signal epoch(s).
;
; RESTRICTIONS:
;  The envelope signal <*>esignal</*> is always of the same type as <*>signal</*>. This might lead to undesired digitizing
;  effects when <*>signal</*> is an integer array; in this case you would have to pass <*>signal</*> as a float array.<BR>
;  For usual purposes, the only filter type to be considered for computing envelopes is a bandpass. If any other filter
;  type is specified, the routine generates a corresponding warning message.<BR>
;  If signal epochs are not thought of to be repeated periodically, undesired effects will occur near the edges. In this
;  case, it is advisable to pass somewhat longer epochs and use only the central part of the envelope epochs afterwards.
;
; PROCEDURE:
;  A DFT is applied to each <*>signal</*> epoch, and the respective Fourier spectrum is multiplied by the filter function,
;  yielding the spectrum of the bandpass-filtered signal. The spectrum is then set to zero for negative frequencies, and
;  multiplied by 2 for positive frequencies. This modified spectrum is transformed back to the time domain, yielding
;  a complex signal whose modulus (amplitude) is the desired amplitude envelope. The theoretical background of this
;  procedure (concept of the <I>equivalent lowpass</I>) is treated in, e.g., Lüke, H.D., "Signalübertragung", 6. Auflage
;  (Springer, Berlin), chapters 5.4.2 and 5.4.3.
;
; EXAMPLE:
;  Generate a bandpass-filtered stochastic signal and display it together with its amplitude envelope:
;
;* Signal = RandomN(seed, 1000)
;* Plot , FilteringFFT(Signal, 500, FLOW = 50, FHIGH = 60, WLOW = 3, WHIGH = 3, /HERTZ)
;* OPlot, Envelope(    Signal, 500, FLOW = 50, FHIGH = 60, WLOW = 3, WHIGH = 3, /HERTZ), color = RGB('red')
;
; SEE ALSO:
;  For details on the default frequency-domain transfer function used by this routine, cf. <A>CosFlankFilter</A>.
;-



FUNCTION  Envelope,   Signal, fS_,  $
                      filter = filter,  $
                      flow = flow, fhigh = fhigh, wlow = wlow, whigh = whigh, hertz = hertz, attenuation = attenuation


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(Signal) AND Set(fS_))  THEN  Console, '   Not all arguments defined.', /fatal
   SizeSignal = Size([Signal])
   DimsSignal = Size([Signal], /dim)
   NSignal    = DimsSignal(0)    ; number of data points in one signal epoch
   TypeSignal = SizeSignal(SizeSignal(0)+1)
   TypefS     = Size(fS_, /type)
   IF  (TypeSignal GE 6) AND (TypeSignal LE 11)  THEN  Console, '  Signal is of wrong type', /fatal
   IF  (TypefS     GE 6) AND (TypefS     LE 11)  THEN  Console, '  fS is of wrong type', /fatal
   IF  NSignal     LT 2  THEN  Console, '  Array epoch must have more than one element.', /fatal
   IF  SizeSignal(0) EQ 1  THEN  NEpochs = 1  $
                           ELSE  NEpochs = Product(DimsSignal(1:*))   ; number of signal epochs in the whole array
   fS = Float(fS_(0))   ; If fS is an array, only the first value is taken seriously.

   ;----------------------------------------------------------------------------------------------------------------------
   ; Preparing the filter function and the array for the result:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  NOT Keyword_Set(filter)  THEN  BEGIN
     ; If the specified filter does not have the typical characteristics of a bandpass filter, the meaning of the
     ; envelope signal(s) might be questionable, and a corresponding warning message is given:
     IF  NOT(Set(flow) AND Set(fhigh))  $
       THEN  Console,  '  Specified filter is no bandpass filter. Please check parameters.', /warning  $
       ELSE  IF  (flow LE 0) OR (flow GE fS/2) OR (fhigh LE 0) OR (fhigh GE fS/2) OR (fhigh LE flow)  $
               THEN  Console, '  Specified filter is no bandpass filter. Please check parameters.', /warning
     ; The filter function is generated:
     Filter = CosFlankFilter(NSignal, fS,   fl = flow, fh = fhigh, wl = wlow, wh = whigh, h = hertz, att = attenuation)
   ENDIF
   SizeFilter = Size(Filter)
   IF  (SizeFilter(0) NE 1) OR (SizeFilter(1) NE NSignal)  THEN  Console, '  Filter length does not match signal length.', /fatal

   EnvSignal = Make_Array(size = SizeSignal, /nozero)   ; array for the filtered signal epochs

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the amplitude envelopes in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   nNyq = NSignal/2   ; the number of the Nyquist frequency bin

   FOR  e = 0L, NEpochs-1  DO  BEGIN
     ; Start and stop indices for addressing the current epoch:
     s1 = e  * NSignal
     s2 = s1 + NSignal - 1
     ; The actual procedure for computing the envelope signal:
     BPSpectrum           = Filter * FFT(Signal(s1:s2))   ; the bandpass spectrum of the signal epoch ...
     BPSpectrum(1:nNyq)   = 2*BPSpectrum(1:nNyq)          ; ... mulitplied by 2 for positive frequencies
     BPSpectrum(nNyq+1:*) = 0                             ; ... set to zero for negative frequencies
     EnvSignal(s1:s2)     = Abs(FFT(BPSpectrum,1))        ; modulus of the corresponding time-domain signal (= envelope)
   ENDFOR

   Return, EnvSignal


END
