;+
; NAME:
;  IMedian()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the median value(s) and (if desired) the mean deviation(s) from the median(s) of an array (index supported).
;
; PURPOSE:
;  This function computes the median value(s) of an array <*>x</*> in one or more dimensions. On request, it also returns
;  the mean deviation(s) from the median(s). The syntax and the structure of the output(s) is analogous to that of the
;  <A>IMean</A> routine.
;
; CATEGORY:
;  Algebra
;  Array
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;* m = IMedian(x, [, MD] [, DIMENSION = ...])
;
; INPUTS:
;  x::  Any integer or float array with any dimensionality. This is the array of which the median value(s) is (are)
;       to be determined (in any of its dimensions).
;
; INPUT KEYWORDS:
;  DIMENSION::  Set this keyword to an integer scalar or array giving the index(es) of the dimension(s) along which the
;               median(s) is (are) to be determined. By default, the median of <*>x</*> as a whole is determined.
;               Setting <*>DIMENSION</*> to zero is equivalent to omitting it. Otherwise, <*>DIMENSION</*> must have
;               values between 1 and the number of dimensions of <*>x</*>. Like in the <*>Total</*> syntax, "1" (not "0")
;               denotes the first dimension, and so on. If <*>DIMENSION</*> is an array, its elements must be unique,
;               and it must not have more elements than <*>x</*> has dimensions.
;
; OUTPUTS:
;  m::  A float array containing the median value(s) of <*>x</*> in the specified dimension(s). It has the same
;       dimensional structure as <*>x</*>, but with the dimension(s) specified by <*>DIMENSION</*> missing. (With
;       <*>DIMENSION</*> not set or containing all dimensions, <*>m</*> is a scalar.
;
; OPTIONAL OUTPUTS:
;  MD::   Set this argument to a named variable (defined or undefined) which on return will contain the (arithmetic)
;         mean deviation(s) from the median(s). The dimensional structure will be the same as that of <*>m</*>.
;
; PROCEDURE:
;  The procedure is almost identical to that one used by the <A>IMean</A> function, except that instead of the
;  <*>Total</*> function, IDL's <*>Median</*> routine is used.
;
; EXAMPLE:
;* x = RandomN(seed, 100,10,1,5,8,1,10) + 7
;* y = IMedian(x, md, DIMENSION = [6,2,5])
;* Help, x, y, md
;
;  IDL prints:
;
;* >X               FLOAT     = Array[100, 10, 1, 5, 8, 1, 10]
;* >Y               FLOAT     = Array[100, 1, 5, 10]
;* >MD              FLOAT     = Array[100, 1, 5, 10]
;
; SEE ALSO:
;  <A>IMean</A>
;
;-



FUNCTION  IMedian,   X_, MD,  $
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
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '  Argument X is of wrong type.', /fatal

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
     M = Median(X_)
     IF  N_Params() EQ 2  THEN  MD = IMean(Abs(X_-M))
     Return, M
   ENDIF

   ;----------------------------------------------------------------------------------------------------------------------
   ; If DIMENSION is specified, the X array is transposed and reformed to a 2-dimensional array with the 1st
   ; dimension containing all the values to be averaged and the 2nd dimension containing all iterations. Afterwards,
   ; the arrays containing the mean values and the standard deviations have to be reformed back:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The remaining cases should be covered by the following condition, i.e., the number of specified dimensions should now
   ; definitely be >= 1 and <= NDimsX-1:
   Assert, (NDim GE 1) AND (NDim LE (NDimsX-1)), '  IMean cannot handle the passed dimension vector. Please check source code.'

   Permutation = [ Dim-1 , DiffSet(IndGen(NDimsX), Dim-1) ]
   DimsM       = DimsX(Dim-1)                            ; the dimension vector of the dimensions for which the mean is computed
   DimsI       = DimsX(DiffSet(IndGen(NDimsX), Dim-1))   ; the dimension vector of the dimensions which stand for iterations (epochs)
   NM          = Product(DimsM)                          ; the number of elements for which the mean is computed
   NI          = Product(DimsI)                          ; the number of iterations (epochs)
   ; X is transposed and reformed such that all dimensions for averaging are merged in the 1st dimension and all
   ; iterations are merged in the 2nd dimension:
   X = Reform(Transpose(X_, Permutation), NM, NI, /overwrite)
   M = Make_Array(NI, /float, /nozero)
   ; The median value is computed:
   FOR  i = 0, NI-1  DO  M(i) = Median(X(*,i))
   ; The mean deviation is computed:
   IF  N_Params() EQ 2  THEN  BEGIN
     MX = Transpose(ReBin(M, NI, NM, /sample))   ; blowing M up to the size of X
     IF  NM GE 2  THEN  MD = IMean(Abs(X-MX), dim = 1)
     MD = Reform(MD, DimsI, /overwrite)
   ENDIF
   M = Reform(M, DimsI, /overwrite)

   Return, M



END
