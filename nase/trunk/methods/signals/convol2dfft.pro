;+
; NAME:
;  Convol2DFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the 2-dimensional convolution via the frequency domain.
;
; PURPOSE:
;  This function performs a 2-dimensional convolution between a signal epoch (image) <*>x</*> (or several signal epochs,
;  arranged in a multi-dimensional array) and a kernel <*>k</*>. The main differences to IDL's <*>Convol</*> function
;  are:<BR>
;  (1.) Several signal epochs, arranged in multiple dimensions, can be treated in one command-line, and<BR>
;  (2.) the convolution product is computed via the frequency domain.<BR>
;  The routine spends most of its time computing FFT's; it is therefore advisable to use a power of 2 as the length
;  of the signal epochs. For larger kernels, then, this routine usually works faster than <*>Convol</*>. This is
;  escpecially true when setting the keyword <*>EDGE_WRAP</*> in the <*>Convol</*> call, which is necessary for getting
;  identical results. (Since the discrete Fourier transform assumes the signal to be repeated periodically, the equivalent
;  <*>Convol</*> call has to include the keyword <*>EDGE_WRAP</*>, in which case the results of the two routines are
;  identical.) In the example below, the speed factor is approximately 100.
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
;  x::  Any integer, float or complex array of any dimensionality, with the first two dimensions representing the
;       x- and y-coordinates of each signal epoch. Each signal epoch is treated independently of the others.
;  k::  A 2-dimensional integer, float or complex array containing the convolution kernel, which is the same for each
;       signal epoch.
;
; OUTPUTS:
;  c::  An array of the same type and dimensional structure as <*>x</*>, containing the convolution products between the
;       signal epochs and the convolution kernel in the first two dimensions.
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
;  Generate a random signal and convolve it with a gaussian kernel (symbolizing, e.g., connection strengths):
;
;* x = RandomN(seed, 256,256)
;* k = exp(-0.01*Shift(Dist(80,80),40,40)^2)
;* Window, /free, xsize = 256, ysize = 256
;* TVScl, x
;* Window, /free, xsize = 256, ysize = 256
;* TVScl, Convol2DFFT(x, k)
;
;-



FUNCTION  Convol2DFFT, X, K


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

;   On_Error, 2

   IF  NOT(Set(X) AND Set(K))  THEN  Console, '   Not all arguments defined.', /fatal

   SizeX   = Size(X)
   DimsX   = Size(X, /dim)
   TypeX   = Size(X, /type)
   SizeK   = Size(K)
   TypeK   = Size(K, /type)

   IF  (TypeX GE 7) AND (TypeX LE 11) AND (TypeX NE 9)  THEN  Console, '  X is of wrong type.', /fatal
   IF  (TypeK GE 7) AND (TypeK LE 11) AND (TypeK NE 9)  THEN  Console, '  X is of wrong type.', /fatal
   IF  SizeX(0) LT 2   THEN  Console, '  X must be at least 2-dimensional.', /fatal
   IF  SizeK(0) NE 2   THEN  Console, '  K must be 2-dimensional.', /fatal
   NX      = DimsX(0:1)
   NK      = Size(K, /dim)
   NEpochs = N_Elements(X) / Product(NX)
   N       = Product(NX)   ; the number of elements in one image
   NShift  = NK / 2        ; the number of data points by which the result of the inverse FFT must be shifted (see below)
   IF  Min(NX)         LT 2  THEN  Console, '  X epoch must have more than one element in each dimension.', /fatal
   IF  Total(NK GE NX) GT 0  THEN  Console, '  K must be smaller in size than X.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the convolution product in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The spectrum of the convolution kernel (zero-padded), which stays constant in the loop:
   K_ = Make_Array(dim = NX, type = TypeK)
   K_(0:NK(0)-1,0:NK(1)-1) = K
   SpectrumK = Conj(FFT(K_))

   ; All epochs are merged in one dimension, for easier handling of the arrays:
   X = Reform(X                                , NX(0), NX(1), NEpochs, /overwrite)
   C = Reform(Make_Array(size = SizeX, /nozero), NX(0), NX(1), NEpochs, /overwrite)

   ; The actual convolution procedure:
   FOR  i = 0, NEpochs-1  DO  C(*,*,i) = N * Shift(FFT( SpectrumK*FFT(X(*,*,i)), 1 ), NShift(0),NShift(1))

   ; The arrays must be reformed back:
   X = Reform(X, DimsX, /overwrite)
   C = Reform(C, DimsX, /overwrite)

   Return, C


END
