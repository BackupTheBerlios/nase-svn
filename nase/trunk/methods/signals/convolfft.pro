;+
; NAME:
;  ConvolFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the convolution via the frequency domain.
;
; PURPOSE:
;  This function performs a convolution between a signal epoch <*>x</*> (or several signal epochs, arranged in a
;  multi-dimensional array) and a kernel <*>k</*>. The main differences to IDL's <*>Convol</*> function are:<BR>
;  (1.) Several signal epochs, arranged in multiple dimensions, can be treated in one command-line, and<BR>
;  (2.) the convolution product is computed via the frequency domain.<BR>
;  The routine spends most of its time computing FFT's; it is therefore advisable to use a power of 2 as the length
;  of the signal epochs. Even then, however, it is not guaranteed that this routine works faster than <*>Convol</*>.
;  It is mainly the kernel size which decides on which routine is faster; for long kernels, <*>Convol</*> is outperformed
;  by <*>ConvolFFT</*>, but not for short kernels.<BR>
;  Since the discrete Fourier transform assumes the signal to be repeated periodically, the equivalent <*>Convol</*> call
;  would have to include the keyword <*>EDGE_WRAP</*>, in which case the results of the two routines are identical.
;
; CATEGORY:
;  Algebra
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* c = ConvolFFT(x, k)
;
; INPUTS:
;  x::  Any integer, float or complex array of any dimensionality, with the first dimension representing the independent
;       variable within each signal epoch (e.g., time). Each signal epoch is treated independently of the others.
;  k::  A one-dimensional integer, float or complex array containing the convolution kernel, which is the same for each
;       signal epoch.
;
; OUTPUTS:
;  c::  An array of the same type and dimensional structure as <*>x</*>, containing the convolution products between the
;       signal epochs and the convolution kernel in the first dimension.
;
; RESTRICTIONS:
;  Note that, like with IDL's <*>Convol</*> function, the type of the result is the same as that of the input argument
;  <*>x</*>, <I>not</I> that of <*>k</*>, i.e., if the signal is of float type and the kernel is complex, the result will
;  nevertheless be converted to float type.
;
; PROCEDURE:
;  Each signal epoch is Fourier transformed, multiplied by the (conjugate complex) spectrum of the (zero-padded) kernel,
;  and the cross-spectrum is transformed back to the time domain.
;
; EXAMPLE:
;  Generate a random signal and smooth it by convolving it with a rectangular kernel:
;
;* x = RandomN(seed, 100)
;* k = Replicate(1, 10)
;* Plot, x
;* OPlot, ConvolFFT(x, k), color = RGB('red')
;
;-



FUNCTION  ConvolFFT, X, K


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X) AND Set(K))  THEN  Console, '   Not all arguments defined.', /fatal

   SizeX   = Size(X)
   DimsX   = Size(X, /dim)
   TypeX   = Size(X, /type)
   SizeK   = Size(K)
   TypeK   = Size(K, /type)
   NX      = DimsX(0)
   NK      = N_Elements(K)
   NEpochs = N_Elements(X) / NX

   IF  (TypeX GE 7) AND (TypeX LE 11) AND (TypeX NE 9)  THEN  Console, '  X is of wrong type.', /fatal
   IF  (TypeK GE 7) AND (TypeK LE 11) AND (TypeK NE 9)  THEN  Console, '  X is of wrong type.', /fatal
   IF  SizeK(0) GT 1   THEN  Console, '  K must be one-dimensional.', /fatal
   IF  NX       LT 2   THEN  Console, '  X epoch must have more than one element.', /fatal
   IF  NK       GT NX  THEN  Console, '  K must not have more elements than X.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the convolution product in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The spectrum of the convolution kernel (zero-padded), which stays constant in the loop:
   IF  NK LT NX  THEN  SpectrumK = Conj(FFT( [K , Replicate(0,NX-NK)] ))  $
                 ELSE  SpectrumK = Conj(FFT(  K ))

   ; All epochs are merged in one dimension, for easier handling of the arrays:
   X = Reform(X                                , NX, NEpochs, /overwrite)
   C = Reform(Make_Array(size = SizeX, /nozero), NX, NEpochs, /overwrite)

   ; The actual convolution procedure:
   FOR  i = 0L, NEpochs-1  DO  C(*,i) = NX * Shift(FFT( SpectrumK*FFT(X(*,i)), 1 ), NK/2)

   ; The arrays must be reformed back:
   X = Reform(X, DimsX, /overwrite)
   C = Reform(C, DimsX, /overwrite)

   Return, C


END
