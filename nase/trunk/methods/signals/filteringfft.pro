;+
; NAME:
;  FilteringFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Filters a discrete signal via the frequency domain.
;
; PURPOSE:
;  This function applies a digital frequency-domain filter function to a signal epoch or to several signal epochs
;  arranged in a multi-dimensional array, and returns the filtered signal epoch(s), which has (have) the same type as the
;  original <*>signal</*>. In the multi-dimensional case, each epoch is treated independently of the others, and the
;  first dimension is interpreted as the variable parameter within each epoch (e.g., time). If you have several signal
;  epochs of equal length to be filtered, it is advisable to pass all of them in one array instead of using a <C>FOR</C>
;  loop in your program, so that the queries at the beginning of this routine are run through only once. In fact, handling
;  multi-dimensional arrays of signal epochs is the main purpose of this routine, since the actual operation of filtering
;  is just one command line and could well be done in the caller program unit. For several signal epochs, however, you
;  would need one or more <C>FOR</C> loops in your source code, which makes it less readible.<BR>
;  By default, this routine uses the <A>CosFlankFilter</A> function to generate the frequency-domain filter. It therefore
;  accepts the same keywords and inherits them. Please refer to the documentation of <A>CosFlankFilter</A> for further
;  details. If you want to supply your own frequency-domain filter function, you can do this via the keyword
;  <*>FILTER</*>.<BR>
;  Since this routine spends most of its time calculating FFTs, the length of the signal epochs should be a power of 2.
;  In such cases, then, this algorithm is faster than convolving the signal with a time-domain filter kernel.<BR>
;  By using the discrete Fourier transform, this routine implicitly assumes that each signal epoch is repeated
;  periodically to infinity in both directions. This constitutes a further difference to filtering in the time-domain
;  (unless the keyword <*>EDGE_WRAP</*> is set in the call of the IDL <*>Convol</*> function) and will generally lead to
;  different results of the two algorithms, especially near the edges of the signal epoch(s).<BR>
;
; CATEGORY:
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* fsignal = FilteringFFT(signal, fS  [, FLOW=...] [, FHIGH=...] [, WLOW=...] [, WHIGH=...] [, /HERTZ] [, ATTENUATION=...]
;*                                 |  [, FILTER=...]
;
; INPUTS:
;  signal::  An integer, float or complex array containing the signal epoch(s) in the 1st dimension.
;  fS::      An integer or float scalar giving the frequency (in Hz) which was used for sampling the signal epoch(s).
;
; INPUT KEYWORDS:
;  FLOW::         cf. <A>CosFlankFilter</A>
;  FHIGH::        cf. <A>CosFlankFilter</A>
;  WLOW::         cf. <A>CosFlankFilter</A>
;  WHIGH::        cf. <A>CosFlankFilter</A>
;  HERTZ::        cf. <A>CosFlankFilter</A>
;  ATTENUATION::  cf. <A>CosFlankFilter</A>
;  FILTER::       If want to treat your signal(s) with a more elaborate, quite special filter instead of just a simple
;                 bandpass or bandstop filter, set this keyword to an integer, float or complex array which you want
;                 to be used as the frequency-domain transfer function. <*>FILTER</*> must be of the same length as
;                 <*>signal</*>; otherwise this routine stops execution with a fatal error message. Please note that the
;                 filter function must be constructed in an FFT-compatible way, i.e., with the negative frequency branch
;                 attached to the upper end of the positive frequency branch, and special attention paid to the zero and
;                 Nyquist frequency bins occurring only once each (if the number of data points is even). If this keyword
;                 is set, all other keywords are ignored.
;
; OUTPUTS:
;  fsignal::  An array of the same type and dimensional structure as <*>signal</*>, containing the filtered signal
;             epoch(s).
;
; RESTRICTIONS:
;  The filtered signal <*>fsignal</*> is always of the same type as <*>signal</*>. This might lead to undesired digitizing
;  effects when <*>signal</*> is an integer array; in this case you would have to pass <*>signal</*> as a float array.<BR>
;  If signal epochs are not thought of to be repeated periodically, undesired filtering effects will occur near the edges.
;  In this case, it is advisable to pass somewhat longer epochs and use only the central part of the interpolated epochs
;  afterwards.
;
; PROCEDURE:
;  A DFT is applied to each <*>signal</*> epoch, the respective Fourier spectrum is multiplied by the filter function,
;  the result is transformed back to the time domain and converted to the original data type. That's it.
;
; EXAMPLE:
;  Generate a stochastic signal and compare the computation times for frequency- and time-domain filtering:
;
;* Signal  = RandomN(seed, 1024, 1000)
;* t0 = SysTime(1)
;* SignalF = FilteringFFT(Signal, 500, FLOW = 5.0, FHIGH = 10.0)
;* Print, 'Frequency domain:             ', SysTime(1)-t0, ' s'
;* t0 = SysTime(1)
;* SignalT = FltArr(1024,1000, /nozero)
;* FilterT = CosFlankFilter(1024, 500, FLOW = 5.0, FHIGH = 10.0, /TIME)
;* FOR i=0,999 DO SignalT[*,i] = (Convol([Signal[*,i],Signal[*,i],Signal[*,i]], FilterT))[1024:2047]
;* Print, 'Time domain concatenation:    ', SysTime(1)-t0, ' s'
;* t0 = SysTime(1)
;* FOR i=0,999 DO SignalT[*,i] = Convol(Signal[*,i], FilterT, /EDGE_WRAP)
;* Print, 'Time domain keyword EDGE_WRAP:', SysTime(1)-t0, ' s'
;* Plot , Signal[*,0]
;* OPlot, SignalF[*,0], color = RGB('red')
;
;  IDLs plots one signal epoch and the corresponding filtered signal epoch and prints (for example, depending on the
;  machine speed):
;
;* >Frequency domain:                   0.75100005 s
;* >Time domain concatenation:           6.4990000 s
;* >Time domain keyword EDGE_WRAP:       14.501000 s
;
; SEE ALSO:
;  For details on the default frequency-domain transfer function used by this algorithm, cf. <A>CosFlankFilter</A>.
;-



FUNCTION  FilteringFFT,   Signal, fS_,  $
                          filter = filter,  $
                          flow = flow, fhigh = fhigh, wlow = wlow, whigh = whigh, hertz = hertz, attenuation = attenuation


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(Signal) AND Set(fS_))  THEN  Console, '   Not all arguments defined.', /fatal
   SizeSignal = Size([Signal])
   DimsSignal = Size([Signal], /dim)
   NSignal    = DimsSignal[0]    ; number of data points in one signal epoch
   TypeSignal = SizeSignal[SizeSignal[0]+1]
   TypefS     = Size(fS_, /type)
   IF  (TypeSignal GE 7) AND (TypeSignal LE 11) AND (TypeSignal NE 9)  THEN  Console, '  Signal is of wrong type', /fatal
   IF  (TypefS     GE 6) AND (TypefS     LE 11)                        THEN  Console, '  fS is of wrong type', /fatal
   IF  NSignal     LT 2  THEN  Console, '  Array epoch must have more than one element.', /fatal
   IF  SizeSignal[0] EQ 1  THEN  NEpochs = 1  $
                           ELSE  NEpochs = Product(DimsSignal[1:*])   ; number of signal epochs in the whole array
   fS = Float(fS_[0])   ; If fS is an array, only the first value is taken seriously.

   ;----------------------------------------------------------------------------------------------------------------------
   ; Preparing the filter function and the array for the result:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  NOT Keyword_Set(filter)  THEN  $
       Filter = CosFlankFilter(NSignal, fS,   fl = flow, fh = fhigh, wl = wlow, wh = whigh, h = hertz, att = attenuation)
   SizeFilter = Size(Filter)
   IF  (SizeFilter[0] NE 1) OR (SizeFilter[1] NE NSignal)  THEN  Console, '  Filter length does not match signal length.', /fatal

   FSignal = Make_Array(size = SizeSignal, /nozero)   ; array for the filtered signal epochs

   ;----------------------------------------------------------------------------------------------------------------------
   ; Filtering the signal epochs in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   FOR  e = 0L, NEpochs-1  DO  BEGIN
     ; Start and stop indices for addressing the current epoch:
     s1 = e  * NSignal
     s2 = s1 + NSignal - 1
     ; The actual filtering process:
     FSignal[s1:s2] = FFT(Filter * FFT(Signal[s1:s2]), 1)
   ENDFOR

   RETURN, FSignal


END
