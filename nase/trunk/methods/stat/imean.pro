;+
; NAME:
;  IMean()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the mean value(s) and (if desired) the standard deviation(s) of an array (index supported).
;
; PURPOSE:
;  This function computes the mean value(s) of an array <*>x</*> in one or more dimensions. On request, it also returns
;  the standard deviation(s) and the standard deviation(s) of the mean(s). For the sake of convenience, the syntax and the
;  structure of the output(s) is somewhat different from the <A>IMoment</A> routine. Most importantly, however, it is
;  usually much faster.
;
; CATEGORY:
;  Algebra
;  Array
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;* m = IMean(x, [, SD [, SDM]] [, DIMENSION = ...])
;
; INPUTS:
;  x::  Any integer, float or complex array with any dimensionality. This is the array of which the mean value(s) is (are)
;       to be determined (in any of its dimensions).
;
; INPUT KEYWORDS:
;  DIMENSION::  Set this keyword to an integer scalar or array giving the index(es) of the dimension(s) along which the
;               mean value(s) is (are) to be determined. By default, the mean of <*>x</*> as a whole is determined.
;               Setting <*>DIMENSION</*> to zero is equivalent to omitting it. Otherwise, <*>DIMENSION</*> must have
;               values between 1 and the number of dimensions of <*>x</*>. Like in the <*>Total</*> syntax, "1" (not "0")
;               denotes the first dimension, and so on. If <*>DIMENSION</*> is an array, its elements must be unique,
;               and it must not have more elements than <*>x</*> has dimensions.
;
; OUTPUTS:
;  m::  A float or complex array containing the mean value(s) of <*>x</*> in the specified dimension(s). It has the same
;       dimensional structure as <*>x</*>, but with the dimension(s) specified by <*>DIMENSION</*> missing. (With
;       <*>DIMENSION</*> not set or containing all dimensions, <*>m</*> is a scalar.
;
; OPTIONAL OUTPUTS:
;  SD::   Set this argument to a named variable (defined or undefined) which on return will contain the standard
;         deviation(s). The dimensional structure will be the same as that of <*>m</*>. If <*>x</*> is of complex type,
;         the usual definition of the standard deviation makes no sense; therefore <*>SD</*> will not be returned in this
;         case, even if it is set. A corresponding warning message will be given by the routine.
;  SDM::  Set this argument to a named variable (defined or undefined) which on return will contain the standard
;         deviation(s) of the mean(s). The dimensional structure will be the same as that of <*>m</*>. Due to the
;         positional character of <*>SD</*> and <*>SDM</*>, you also have to supply a variable for <*>SD</*>, even if you
;         are only interested in <*>SDM</*>. If <*>x</*> is of complex type, the usual definition of the standard
;         deviation makes no sense; therefore <*>SDM</*> will not be returned in this case, even if it is set.
;         A corresponding warning message will be given by the routine.
;
; PROCEDURE:
;  The routine uses IDL's <*>Total</*> function. The main point is to convert the argument <*>x</*> into a form to which
;  the <*>Total</*> function can be easily applied. This is especially difficult when <*>DIMENSION</*> has 2 or more
;  elements. In this case, <*>x</*> is transposed and reformed into a 2-dimensional array such that the "averaging
;  dimensions" are merged in the 1st dimension and the "iteration dimensions" are merged in the 2nd dimension. Afterwards,
;  the array containing the mean values is "reformed back". Furthermore, some precautions must be taken in order to
;  mirror the original dimensional structure of <*>x</*> in <*>m</*>, even if some of the dimensions contain only one
;  element and are therefore temporarily eliminated when they are transposed to the last position somewhere in the
;  algorithm.
;
; EXAMPLE:
;* x = RandomN(seed, 100,10,1,5,8,1,10) + 7
;* y = IMean(x, sd, DIMENSION = [6,2,5])
;* Help, x, y, sd
;
;  IDL prints:
;
;* >X               FLOAT     = Array[100, 10, 1, 5, 8, 1, 10]
;* >Y               FLOAT     = Array[100, 1, 5, 10]
;* >SD              FLOAT     = Array[100, 1, 5, 10]
;
; SEE ALSO:
;  <A>IMoment</A>
;
;-



FUNCTION  IMean,   X_, SD, SDM,  $
                   dimension = dimension


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   ; Checking the argument X:
   IF  NOT Set(X_)  THEN  Console, '   Argument X not defined.', /fatal
   SizeX  = Size(X_)
   DimsX  = Size(X_, /dim)
   TypeX  = Size(X_, /type)
   NDimsX = SizeX(0)
   XisComplex = (TypeX EQ 6) OR (TypeX EQ 9)
   IF  (TypeX GE 7) AND (TypeX LE 11)  AND (TypeX NE 9)  THEN  Console, '  Argument X is of wrong type.', /fatal
   IF  XisComplex   AND (N_Params() GE 2)                THEN  Console, '  X is of complex type. No standard deviation(s) defined.', /warning

   ; Checking the keyword DIMENSION:
   IF  Set(dimension)  THEN  BEGIN
     Dim     = dimension
     TypeDim = Size(Dim, /type)
     NDim    = N_Elements(Dim)   ; number of specified dimensions
     ; The type of the dimension index(es) must be convertable to integer type. The dimension index(es) must be >= 0,
     ; but <= the dimensionality of X. If multiple dimensions are specified, their number must not exceed the
     ; dimensionality of X, and all indexes must be >= 1. Furthermore, each dimension index must occur only once.
     IF  (TypeDim  GE 6) AND (TypeDim  LE 11)      THEN  Console, '  Argument Dim is of wrong type'               , /fatal
     IF  (Min(Dim) LT 0) OR  (Max(Dim) GT NDimsX)  THEN  Console, '  Specified dimension(s) out of allowed range.', /fatal
     IF  (Min(Dim) LT 1) AND (NDim     GE 2)       THEN  Console, '  Specified dimension(s) out of allowed range.', /fatal
     ; The condition "NDim = 0" will serve as an indicator that no particular dimension is specified:
     IF  Dim(0) EQ 0  THEN  NDim = 0
     ; If only one dimension is specified, the index is converted to a scalar variable:
     IF  NDim EQ 1  THEN  Dim = Dim(0)
     ; DIM is made one-dimensional:
     IF  NDim GE 2  THEN  Dim = Reform(Round(Dim), NDim)
     IF  N_Elements(Uniq(Dim, Sort(Dim))) NE NDim  THEN  Console, '  Specified dimensions are not unique.', /fatal
   ENDIF  ELSE  $
     NDim = 0

   ;----------------------------------------------------------------------------------------------------------------------
   ; If X is zero- or one-dimensional, or if no particular dimension is specified, or if all dimensions are specified,
   ; the mean value is computed over the array X as a whole:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  (NDimsX LE 1) OR (NDim EQ 0) OR (NDim EQ NDimsX)  THEN  BEGIN
     N = N_Elements(X_)
     M = Total(X_) / N
     IF  (N_Params() GE 2) AND NOT(XisComplex)  THEN  BEGIN
       SD  = Sqrt(Total((X_-M)^2) / (N-1))
       SDM = SD / Sqrt(N)
     ENDIF
     Return, M
   ENDIF

   ;----------------------------------------------------------------------------------------------------------------------
   ; If only one dimension index is specified, the mean value is computed over this dimension explicitly (n principle,
   ; this case could also be covered by the section below, but this variant is faster):
   ;----------------------------------------------------------------------------------------------------------------------

   IF  NDim EQ 1  THEN  BEGIN
     N = DimsX(Dim-1)
     M = Total(X_,Dim) / N
     IF  (N_Params() GE 2) AND NOT(XisComplex)  THEN  BEGIN
       ; The following procedure is analogous to that one used in REMOVEMEAN(); it blows M up to the size of X:
       DM = [Where(IndGen(8) NE (Dim-1)) , (Dim-1)]
       DX = ([DimsX , Replicate(1,8)])(0:7)
       MX = Rebin(M,  DX(DM(0)),DX(DM(1)),DX(DM(2)),DX(DM(3)),DX(DM(4)),DX(DM(5)),DX(DM(6)),DX(DM(7)), /sample)
       IF  (Size(MX))(0) NE 8  $
         ; If dimensions were lost because the last dimension has only one element:
         THEN  MX = Reform(Transpose(MX, Sort(DM(0:(Size(MX))(0)-1))), DimsX, /overwrite)  $
         ; If nothing scary has happened during the rebinning => everything all right:
         ELSE  MX = Transpose(MX, Sort(DM))
       ; Now M and X are of equal size and can be used within the same arithmetic expression:
       IF  N GE 2  THEN  SD = Sqrt(Total((X_-MX)^2,Dim) / (N-1))  ELSE  SD = Total((X_-MX)^2,Dim)
       SDM = SD / Sqrt(N)
     ENDIF
     Return, M
   ENDIF

   ;----------------------------------------------------------------------------------------------------------------------
   ; If more dimensions are specified, the X array is transposed and reformed to a 2-dimensional array with the 1st
   ; dimension containing all the values to be averaged and the 2nd dimension containing all iterations. Afterwards,
   ; the arrays containing the mean values and the standard deviations have to be reformed back:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The remaining cases should be covered by the following condition, i.e., the number of specified dimensions should now
   ; definitely be >= 2 and <= NDimsX-1:
   Assert, (NDim GE 2) AND (NDim LE (NDimsX-1)), '  IMean cannot handle the passed dimension vector. Please check source code.'

   Permutation = [ Dim-1 , DiffSet(IndGen(NDimsX), Dim-1) ]
   DimsM       = DimsX(Dim-1)                            ; the dimension vector of the dimensions for which the mean is computed
   DimsI       = DimsX(DiffSet(IndGen(NDimsX), Dim-1))   ; the dimension vector of the dimensions which stand for iterations (epochs)
   NM          = Product(DimsM)                          ; the number of elements for which the mean is computed
   NI          = Product(DimsI)                          ; the number of iterations (epochs)
   ; X is transposed and reformed such that all dimensions for averaging are merged in the 1st dimension and all
   ; iterations are merged in the 2nd dimension:
   X = Transpose(X_, Permutation)
   X = Reform(X, NM, NI, /overwrite)
   ; The mean value is computed:
   M = Total(X,1) / NM
   ; The standard deviation is computed:
   IF  (N_Params() GE 2) AND NOT(XisComplex)  THEN  BEGIN
     MX = Transpose(ReBin(M, NI, NM, /sample))   ; blowing M up to the size of X
     IF  NM GE 2  THEN  SD = Sqrt(Total((X-MX)^2,1) / (NM-1))  ELSE  SD = Total((X-MX)^2,1)
     SDM = SD / Sqrt(NM)
     SD  = Reform(SD , DimsI, /overwrite)
     SDM = Reform(SDM, DimsI, /overwrite)
   ENDIF
   M = Reform(M, DimsI, /overwrite)

   Return, M



END
