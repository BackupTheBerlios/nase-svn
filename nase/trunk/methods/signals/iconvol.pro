;+
; NAME:
;  IConvol()
;
; VERSION:
;  $Id$
;
; AIM:
;  Convol in up to 7 dimensions
;
; PURPOSE:
;  This function performs a convolution between a signal epoch x (or several signal epochs, arranged in a
;  multi-dimensional array) and a kernel k. The main differences to IDL's <*>Convol</*> function are:<BR>
;  (1.) Several signal epochs, arranged in multiple dimensions, can be treated in one command-line, and<BR>
;  (2.) the output type depends on both the signal's and the kernel's type. So if the signal is float type and
;  the kernel is complex the output also would be complex.<BR>
;  Any byte or integer type data will be transformed into float data. So the optional input parameter <*>SCALE_FACTOR</*>
;  of the IDL <*>Convol</*> routine doesn't make sense any more.<BR>
;  The function supports the keywords <*>CENTER</*>, <*>EDGE_WRAP</*> and <*>EDGE_TRUNCATE</*> of the IDL <*>Convol</*>.
;
; CATEGORY:
;  Array
;  Algebra
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* c = IConvol(x, k [,/CENTER] [,/EDGE_WRAP] [,/EDGE_TRUNCATE])
;
; INPUTS:
;  x::  Any integer, float or complex array of any dimensionality, with the first dimension representing the independent
;       variable within each signal epoch (e.g., time). Each signal epoch is treated independently of the others.
;  k::  A one-dimensional integer, float or complex array containing the convolution kernel, which is the same for each
;       signal epoch.
;
; INPUT KEYWORDS:
;  CENTER:: Same as in convol function of IDL
;  EDGE_WRAP:: Same as in convol function of IDL
;  EDGE_TRUNCATE:: Same as in convol function of IDL
;
; OUTPUTS:
;  c::  An array of the same dimensional structure as <*>x</*> and the 'higher' type of both <*>x's</*> and <*>k's</*>,
;       containing the convolution products between the signal epochs and the convolution kernel in the first dimension.
;
; RESTRICTIONS:
;  IDL supports arrays only in up to 8 dimensions.
;
; PROCEDURE:
;  The routine reforms the input array and uses IDL's <*>Convol</*> in a FOR loop. If necessary, the data is 'upgraded'.
;  This function is in nearly all cases much faster than <A>ConvolFFT</A>.
;
; EXAMPLE:
;
; SEE ALSO:
;  <A>ConvolFFT</A>,<A>Convol2DFFT</A>
;
;-



FUNCTION  IConvol, X, K, _EXTRA=_EXTRA


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

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

   ; All epochs are merged in one dimension, for easier handling of the arrays:
   X = Reform(X, NX, NEpochs, /overwrite)

   ; The needed output type determined and the output array created:
   IF (TypeX LE 3) OR (TypeX GE 12) THEN XType = 4 ELSE XType = TypeX
   IF (XType LT (TypeK MOD 11)) THEN XType = TypeK
   C = Reform(Make_Array(dimension=DimsX, type=XType, /nozero), NX, NEpochs, /overwrite)

   ; Computing the convolution product in a FOR loop:

   FOR  i = 0L, NEpochs-1  DO  BEGIN
   ; The actual epoch is converted into the needed output type:
     CASE XType OF
      4: D = Float(X(*,i))
      5: D = Double(X(*,i))
      6: D = Complex(X(*,i))
      9: D = DComplex(X(*,i))
     ENDCASE
   ; The convolution procedure:
   C(*,i) = Convol(D, K, _EXTRA=_EXTRA)
   END

   ; The arrays must be reformed back:
   X = Reform(X, DimsX, /overwrite)
   C = Reform(C, DimsX, /overwrite)

   Return, C


END