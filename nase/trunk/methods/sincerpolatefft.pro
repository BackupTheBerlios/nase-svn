;+
; NAME:
;  SincerpolateFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes a SINC interpolation of a discrete signal via the frequency domain.
;
; PURPOSE:
;  This function returns the SINC interpolated version of a discrete signal epoch or of several such signal epochs,
;  arranged in a multi-dimensional array. In the latter case, each epoch is treated independently of the others,
;  and the first dimension is interpreted as the variable parameter within each epoch (e.g., time). If you have
;  several signal epochs of equal length to be interpolated, it is advisable to pass all of them in one array
;  instead of using a <C>FOR</C> loop in your program, so that the queries at the beginning of this routine are
;  run through only once.<BR>
;  Since this routine spends most of its time calculating FFTs, <I>both</I> the length of the signal epochs <I>and</I>
;  the interpolation factor should be powers of 2. In such cases, then, this routine is faster than <*>Sincerpolate</*>,
;  the actual speed ratio depending on the interpolation <*>factor</*> (with typical data array sizes, e.g., ratio=2:1
;  for <*>factor</*>=8 or ratio=20:1 for <*>factor</*>=64).<BR>
;  The interpolation is exact on the assumption that each signal epoch is repeated periodically to infinity
;  in both directions. This constitutes a further difference to <*>Sincerpolate</*> and will generally lead to
;  different results of the two functions, especially near the edges of the signal epochs.
;
; CATEGORY:
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* out = SincerpolateFFT(signal, factor)
;
; INPUTS:
;  signal:: An array of any integer, float or complex type, containing the signal epoch(s) in the 1st dimension.
;  factor:: The factor by which the number of data points is to be increased. This need not be an integer value;
;           in order to have an effect, it must be greater than 1.
;
; OUTPUTS:
;  out:: An array of the same type and dimensional structure as <*>signal</*>, containing the interpolated signal
;        epoch(s) in the 1st dimension. The 1st dimension, of course, contains <*>factor</*> times as many
;        elements as in <*>signal</*>.
;
; RESTRICTIONS:
;  The <*>signal</*> array must not be of any other type than integer, float, or complex.<BR>
;  <B>Caution:</B> The interpolated signal <*>out</*> is always of the same type as <*>signal</*>. This might lead to
;  undesired effects when <*>signal</*> is an integer array which you want to be interpolated with float values;
;  in this case you would have to pass <*>signal</*> already as a float array.<BR>
;  The interpolation <*>factor</*> must be greater than 1. In fact, if the number of data points per signal epoch
;  is not increased at least by 2, the algorithm cannot work, and <*>signal</*> is returned without change (in which
;  case a corresponding console message appears).<BR>
;  If signal epochs are not thought of to be repeated periodically, undesired interpolation effects will occur near
;  the edges. In this case, it is advisable to pass somewhat longer epochs and use only the central part of the
;  interpolated epochs afterwards.
;
; PROCEDURE:
;  SINC interpolation is achieved here in the following way:<BR>
;  1. Each signal epoch is transformed to the frequency domain via FFT. (To avoid several interlocking <C>FOR</C> loops
;  in the case of a multi-dimensional array, epochs are addressed with linearized indices in one <C>FOR</C> loop.)<BR>
;  2. In order to mimic a higher sampling rate, bins representing higher frequencies are then added in the middle of
;  the complex spectrum between the positive and the negative frequency branch. The number of these bins is determined
;  by <*>factor</*> (i.e., with F denoting the <*>factor</*>, and N being the original number of data points per signal
;  epoch, another (F-1)*N frequency bins are added to the spectrum). (If N is even, the value at the Nyquist frequency
;  has to be split in halves and distributed among two bins.)<BR>
;  3. Assuming that the original signal was sampled according to the Nyquist theorem, the additional frequency bins
;  are all set to zero. Formally, this is equivalent to multiplying the spectrum with a rectangular "Nyquist low-pass"
;  in the frequency domain or to convolving the sampling points of the signal epoch with a corresponding SINC kernel
;  in the time domain.<BR>
;  Periodicity of the original signal is implicitly assumed due to the use of the discrete Fourier transform.
;
; EXAMPLE:
;  Create a simple signal and display it together with its interpolated version:
;
;* s = Randomn(seed, 8)  &  i = SincerpolateFFT(s, 16)  &  ts = Findgen(8)  &  ti = Findgen(16*8)/16
;* Plot, ti, i  &  OPlot, ts, s, psym=6
;
; SEE ALSO:
;  <A>Sincerpolate</A>
;
;-



FUNCTION  SincerpolateFFT, Signal, Factor


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  N_Params()    LT 2  THEN  Console, '  Wrong number of arguments.', /fatal
   SizeSignal = Size([Signal])
   DimsSignal = Size([Signal], /dim)
   TypeSignal = SizeSignal(SizeSignal(0)+1)
   NSignal    = SizeSignal(1)    ; number of data points in one signal epoch
   IF  (TypeSignal GE 7) AND (TypeSignal LE 11) AND (TypeSignal NE 9)  THEN  Console, '  Signal is of wrong type', /fatal
   IF  NSignal       LT 2  THEN  Console, '  Signal epoch must have more than one element.', /fatal
   IF  SizeSignal(0) EQ 1  THEN  NEpochs = 1  $
                           ELSE  NEpochs = Product(DimsSignal(1:*))   ; number of signal epochs in the whole array

   NInterp = Round(Factor * NSignal)   ; number of data points in one interpolated signal epoch

   ; A minimum difference of 2 between NInterp and NSignal is needed for the operations below;
   ; otherwise an interpolation is not carried out:
   IF  (NInterp-NSignal) LT 2  THEN  BEGIN
     Console, '  Interpolation factor too small. Signal is returned without change.', /msg
     Return, Signal
   ENDIF

   SizeInterp    = SizeSignal   ; copy of IDL size vector of the signal array
   SizeInterp(1) = NInterp      ; artificially created IDL size vector for the interpolated signal array defined below
   IntSignal     = MAKE_ARRAY(size = SizeInterp, /nozero)   ; the interpolated signal array

   ;----------------------------------------------------------------------------------------------------------------------
   ; Interpolating the signal:
   ;----------------------------------------------------------------------------------------------------------------------

   ; Two different modes depending on whether the number of data points in one signal epoch is even or not:
   IF  (NSignal MOD 2) EQ 0  THEN  FOR  e = 0L, NEpochs-1  DO  BEGIN
     ; Start and stop indices for addressing the current epoch are defined:
     s1 = e  * NSignal
     s2 = s1 + NSignal - 1
     i1 = e  * NInterp
     i2 = i1 + NInterp - 1
     ; The interpolation itself:
     FFT_S = FFT(Signal(s1:s2),-1)
     FFT_S(NSignal/2) = 0.5 * FFT_S(NSignal/2)
     IntSignal(i1:i2) = FFT([ FFT_S(0:NSignal/2) , ComplexArr(NInterp-NSignal-1) , FFT_S(NSignal/2:*)   ], 1)
   ENDFOR  ELSE  FOR  e = 0L, NEpochs-1  DO  BEGIN
     s1 = e  * NSignal
     s2 = s1 + NSignal - 1
     i1 = e  * NInterp
     i2 = i1 + NInterp - 1
     FFT_S = FFT(Signal(s1:s2),-1)
     IntSignal(i1:i2) = FFT([ FFT_S(0:NSignal/2) , ComplexArr(NInterp-NSignal)   , FFT_S(NSignal/2+1:*) ], 1)
   ENDFOR

   RETURN, IntSignal


END
