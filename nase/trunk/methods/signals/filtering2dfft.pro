;+
; NAME:
;  Filtering2DFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Filters a 2-dimensional signal (image) via the frequency domain.
;
; PURPOSE:
;  This function applies a digital 2-dimensional frequency-domain filter function to a 2D-signal (image) or to several
;  signals arranged in a multi-dimensional array, and returns the filtered image(s), which has (have) the same type as the
;  original <*>signal</*>. In the multi-dimensional case, each signal is treated independently of the others, and the
;  first two dimensions are interpreted as the x- and y-coordinates of each 2D-signal. If you have several signals of
;  equal size to be filtered, it is advisable to pass all of them in one array instead of using a <C>FOR</C> loop in your
;  program, so that the queries at the beginning of this routine are run through only once. In fact, handling
;  multi-dimensional arrays of signals is the main purpose of this routine, since the actual operation of filtering is
;  just one command line and could well be done in the caller program unit. For several signals, however, you would need
;  one or more <C>FOR</C> loops in your source code, which makes it less readible.<BR>
;  By default, this routine uses the <A>CosFlankFilter2D</A> function to generate the frequency-domain filter. It
;  therefore accepts the same keywords and inherits them. Please refer to the documentation of <A>CosFlankFilter2D</A>
;  for further details. If you want to supply your own frequency-domain filter function, you can do this via the keyword
;  <*>FILTER</*>.<BR>
;  Since this routine spends most of its time calculating FFTs, the size of the signals should be a power of 2 in both
;  directions. In such cases, then, this algorithm is <I>much</I> faster than convolving the signal with a time-domain
;  filter kernel.<BR>
;  By using the discrete Fourier transform, this routine implicitly assumes that each signal epoch is repeated
;  periodically to infinity in all directions. This will generally lead to different results of the two algorithms,
;  especially near the edges of the signal epoch(s).<BR>
;
; CATEGORY:
;  Image
;  Signals
;
; CALLING SEQUENCE:
;* fsignal = FilteringFFT(signal,  [, FLOW=...] [, FHIGH=...] [, WLOW=...] [, WHIGH=...] [, /ABSOLUTEWIDTHS]
;*                                 [, ATTENUATION=...] [, ORIENTATION=...]
;*                              |  [, FILTER=...]
;
; INPUTS:
;  signal::  An integer, float or complex array containing the signal(s) or image(s) in the first two dimensions.
;
; INPUT KEYWORDS:
;  FLOW::           cf. <A>CosFlankFilter2D</A>
;  FHIGH::          cf. <A>CosFlankFilter2D</A>
;  WLOW::           cf. <A>CosFlankFilter2D</A>
;  WHIGH::          cf. <A>CosFlankFilter2D</A>
;  ABSOLUTEWIDTHS:: cf. <A>CosFlankFilter2D</A>
;  ATTENUATION::    cf. <A>CosFlankFilter2D</A>
;  ORIENTATION::    cf. <A>CosFlankFilter2D</A>
;  FILTER::         If want to treat your signal(s) with a more elaborate, quite special filter instead of just a simple
;                   bandpass or bandstop filter, set this keyword to an integer, float or complex array which you want
;                   to be used as the frequency-domain transfer function. <*>FILTER</*> must be of the same size as one
;                   signal (image); otherwise this routine stops execution with a fatal error message. Please note that
;                   the filter function must be constructed in an FFT-compatible way, i.e., with the origin of frequency
;                   space not in the middle of the array, but in the lower left corner, and the negative frequencies
;                   shifted 1st, 2nd and 4th quadrant. If this keyword is set, all other keywords are ignored.
;
; OUTPUTS:
;  fsignal::  An array of the same type and dimensional structure as <*>signal</*>, containing the filtered signal(s).
;
; RESTRICTIONS:
;  The filtered signal <*>fsignal</*> is always of the same type as <*>signal</*>. This might lead to undesired digitizing
;  effects when <*>signal</*> is an integer array; in this case you would have to pass <*>signal</*> as a float array.<BR>
;  If signals are not thought of to be repeated periodically, undesired filtering effects will occur near the edges.
;  In this case, it is advisable to pass somewhat larger signals and use only the central part of the filtered signals
;  afterwards.
;
; PROCEDURE:
;  A DFT is applied to each <*>signal</*> epoch, the respective Fourier spectrum is multiplied by the filter function,
;  the result is transformed back to the time domain and converted to the original data type. That's it.
;
; EXAMPLE:
;  Generate some stochastic images and apply an oriented lowpass filter to them:
;
;* Images  = RandomN(seed, 256, 384, 10)
;* ImagesF = Filtering2DFFT(Images, FHIGH = [0.05,1.0], ORIENTATION = 30)
;* TVScl, ImagesF(*,*,0)
;
; SEE ALSO:
;  For details on the default frequency-domain transfer function used by this algorithm, cf. <A>CosFlankFilter2D</A>.
;-



FUNCTION  Filtering2DFFT,   Signal,  $
                            flow = flow, fhigh = fhigh, wlow = wlow, whigh = whigh, absolutewidths = absolutewidths,  $
                            attenuation = attenuation, orientation = orientation,  $
                            filter = filter


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(Signal))  THEN  Console, '  Argument SIGNAL not defined.', /fatal
   SizeSignal = Size(Signal)
   DimsSignal = Size(Signal, /dim)
   TypeSignal = Size(Signal, /type)
   IF  (TypeSignal GE 7) AND (TypeSignal LE 11) AND (TypeSignal NE 9)  THEN  Console, '  SIGNAL is of wrong type.', /fatal
   IF  SizeSignal(0) LT 2  THEN  Console, '  SIGNAL must be at least 2-dimensional.', /fatal
   NX = DimsSignal(0)
   NY = DimsSignal(1)
   N  = N_Elements(Signal) / (NX*NY)
   IF  (NX LT 2) OR (NY LT 2)  THEN  Console, '  X and Y dimensions must have more than one element each.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Preparing the filter function and the array for the result:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  NOT Keyword_Set(filter)  THEN  $
       Filter = CosFlankFilter2D([NX,NY], fl = flow, fh = fhigh, wl = wlow, wh = whigh, absolute = absolutewidhts,  $
                                          att = attenuation, orient = orientation)
   SizeFilter = Size(Filter)
   IF  (SizeFilter(0) NE 2) OR (SizeFilter(1) NE NX) OR (SizeFilter(2) NE NY)  $
       THEN  Console, '  Filter size does not match signal size.', /fatal

   SignalF = Make_Array(size = SizeSignal, /nozero)   ; array for the filtered signal epochs

   ;----------------------------------------------------------------------------------------------------------------------
   ; Filtering the signals (images) in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   Signal  = Reform(Signal , NX, NY, N, /overwrite)
   SignalF = Reform(SignalF, NX, NY, N, /overwrite)

   ; The actual filtering process:
   FOR  i = 0L, N-1  DO  SignalF(*,*,i) = FFT(Filter * FFT(Signal(*,*,i)), 1)

   Signal  = Reform(Signal , DimsSignal, /overwrite)
   SignalF = Reform(SignalF, DimsSignal, /overwrite)

   RETURN, SignalF


END
