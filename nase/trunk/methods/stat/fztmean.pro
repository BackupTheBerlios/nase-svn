;+
; NAME:
;  FZTMean()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the mean(s) and the standard deviation(s) of an array in Fisher's Z space (index supported).
;
; PURPOSE:
;  This function computes the mean value(s) of an array <*>x</*> in one or more dimensions in Fisher's Z space. This is
;  useful when averaging correlation or coherence values, i.e., values which are normalized to +/-1, because such values
;  must not be averaged arithmetically, but first transformed to Fisher's Z space, then averaged, and then transformed
;  back. On request, this routine also returns the mean(s) plus/minus the standard deviation(s) (SDs) and the SD(s) of the
;  mean(s), i.e., the SD <I>intervals</I>. The SD(s) has (have) to be determined in Fisher's Z space, added to and
;  subtracted from the mean(s), and the results have to be transformed back (not the SD(s) itself (themselves)). The
;  lower and upper limits of the interval(s) do not lie symmetrically around the mean(s).<BR>
;  This routine essentially calls <A>IMean</A> and therefore uses quite a similar syntax.
;
; CATEGORY:
;  Algebra
;  Array
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;* m = FZTMean(x, [, sdint [, sdmint]] [, DIMENSION = ...] [, SD])
;
; INPUTS:
;  x::  Any integer or float array with any dimensionality and values between -1 and 1. This is the array of which the
;       Fisher's Z mean value(s) is (are) to be determined (in any of its dimensions).
;
; INPUT KEYWORDS:
;  DIMENSION::  Set this keyword to an integer scalar or array giving the index(es) of the dimension(s) along which the
;               mean value(s) is (are) to be determined. By default, the mean of <*>x</*> as a whole is determined.
;               Setting <*>DIMENSION</*> to zero is equivalent to omitting it. Otherwise, <*>DIMENSION</*> must have
;               values between 1 and the number of dimensions of <*>x</*>. Like in the <*>Total</*> syntax, "1" (not "0")
;               denotes the first dimension, and so on. If <*>DIMENSION</*> is an array, its elements must be unique,
;               and it must not have more elements than <*>x</*> has dimensions.
;  SDINTWIDTH:: Set this keyword to a float scalar giving the number of desired standard deviations used for the SD
;               interval(s) around the mean(s). This is because if you specify the single-SD interval around a mean
;               correlation value, you cannot get the double-SD interval by just multiplying the SD by 2. By default,
;               the single-SD interval is determined.
;
; OUTPUTS:
;  m::  A float or complex array containing the mean value(s) of <*>x</*> in the specified dimension(s). It has the same
;       dimensional structure as <*>x</*>, but with the dimension(s) specified by <*>DIMENSION</*> missing. (With
;       <*>DIMENSION</*> not set or containing all dimensions, <*>m</*> is a scalar.
;
; OPTIONAL OUTPUTS:
;  SDInt::   Set this argument to a named variable (defined or undefined) which on return will contain the SD interval(s).
;            The dimensional structure will be the same as that of <*>m</*>, except for an additional first dimension
;            containing the lower and the upper limit of the SD interval(s) in the form [mean-SD,mean+SD].
;  SDMInt::  Set this argument to a named variable (defined or undefined) which on return will contain the interval(s) for
;            the SD(s) of the mean(s). The dimensional structure will be the same as that of <*>m</*>, except for an
;            additional first dimension containing the lower and the upper limit of the SD interval(s) in the form
;            [mean-SDM,mean+SDM]. Due to the positional character of <*>SDInt</*> and <*>SDMInt</*>, you also have to
;            supply a variable for <*>SDInt</*>, even if you are only interested in <*>SDMInt</*>.
;
; RESTRICTIONS:
;  The values of <*>x</*> must lie within the interval [-1,1]. Otherwise they are set to -1 or 1, respectively, and a
;  corresponding warning message is given.<BR>
;  <B>Caution</B>: Even the values +/-1 are critical in this routine, because their Fisher-Z-transform is +/-<*>Inf</*>.
;  Thus, for a set of values that are to be averaged, the result will always be =1 if at least one of the values is =1,
;  and it will always be =-1 if at least one of the values is =-1, and it will be <*>-NaN</*> if the set contains both
;  +1 and -1. Standard deviations will always be <*>-NaN</*> if at least one of the values is +1 <I>or</I> -1. Note also
;  that computation time increases significantly if <*>x</*> contains values equal to +/-1, because calculations with
;  +/-<*>Inf</*> take quite a long time. <B>Thus, if you do not care about mathematical exactness, clip the values of
;  <*>x</*> to the interval [-0.9999999,0.9999999] for float values or to [-0.9999999999999999D,0.9999999999999999D] for
;  double values, respectively, before passing it to <*>FZTMean</*>!</B>
;
; PROCEDURE:
;  The routine performs Fisher's Z transform (via <A>FZT</A>) on <*>x</*>, calls <A>IMean</A>, constructs the SD
;  interval(s) and transforms all the results back to normal space.
;
; EXAMPLE:
;  Construct an array with values between 0 and 1 and determine "Fisher's Z mean" value(s) and the double-SD-of-the-mean
;  interval (i.e., the 95%-confidence interval).
;
;* x = RandomU(seed, 100,10,1,5,8,1,10)
;* m = FZTMean(x, sdint, sdmint, DIMENSION = [6,2,5], SD = 2)
;* Help, x, m, sdint, sdmint
;
;  IDL prints:
;
;* >X               FLOAT     = Array[100, 10, 1, 5, 8, 1, 10]
;* >M               FLOAT     = Array[100, 1, 5, 10]
;* >SDINT           FLOAT     = Array[2, 100, 1, 5, 10]
;* >SDMINT          FLOAT     = Array[2, 100, 1, 5, 10]
;
; SEE ALSO:
;  <A>FZT</A>, <A>IMean</A>
;
;-



FUNCTION  FZTMean,   X, SDInt, SDMInt,  $
                     dimension = dimension, sdintwidth = sdintwidth_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   ; Checking the argument X:
   IF  NOT Set(X)  THEN  Console, '   Argument X not defined.', /fatal
   TypeX  = Size(X, /type)
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '  Argument X is of wrong type.', /fatal

   ; Checking the keyword SD:
   IF  Keyword_Set(sdintwidth_)  THEN  BEGIN
     TypeSDIntWidth = Size(SDIntWidth_, /type)
     IF  (TypeSDIntWidth GE 6) AND (TypeSDIntWidth LE 11)  THEN  Console, '  Keyword SDINTWIDTH is of wrong type.', /fatal
     SDIntWidth = Float(SDIntWidth_(0))
   ENDIF  ELSE  $
     SDIntWidth = 1.0

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computation of the mean(s) and SD interval(s):
   ;----------------------------------------------------------------------------------------------------------------------

   Z = FZT(X)

   IF  N_Params() GE 2  THEN  BEGIN   ; SD intervals desired
     M = IMean(Temporary(Z), SD, SDM, dimension = dimension)
     DimsM  = Size(M, /dim)
     SDInt  = Make_Array(dimension = [2,DimsM], type = 4, /nozero)   ; array for the SD  intervals
     SDMInt = Make_Array(dimension = [2,DimsM], type = 4, /nozero)   ; array for the SDM intervals
     SDInt( 0,*,*,*,*,*,*,*) = M - SDIntWidth * SD    ; lower border of the SD  interval(s)
     SDInt( 1,*,*,*,*,*,*,*) = M + SDIntWidth * SD    ; upper border of the SD  interval(s)
     SDMInt(0,*,*,*,*,*,*,*) = M - SDIntWidth * SDM   ; lower border of the SDM interval(s)
     SDMInt(1,*,*,*,*,*,*,*) = M + SDIntWidth * SDM   ; upper border of the SDM interval(s)
     M      = FZT(M     ,1, /overwrite)
     SDInt  = FZT(SDInt ,1, /overwrite)
     SDMInt = FZT(SDMInt,1, /overwrite)
     Return, M
   ENDIF  ELSE  BEGIN   ; only the mean(s) desired
     M = IMean(Temporary(Z), dimension = dimension)
     M = FZT(M,1, /overwrite)
     Return, M
   ENDELSE


END
