;+
; NAME:
;  FZT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes Fisher's Z transform (= arctanh()).
;
; PURPOSE:
;  Fisher's Z transform is a transformation which is recommended to be performed on values that have been normalized to
;  the interval (or the positive or negative part of the interval) [-1,1], like correlation or coherence values, before
;  performing any other operations on them (like averaging, subtracting, dividing, z-score evaluation, etc.). Ratios
;  between values are <I>not</I> correctly mapped by the normalized correlation or other normalization measures, i.e., an
;  increase, e.g., from 0.2 to 0.3 is not as significant as an increase from 0.8 to 0.9. Therefore, values close to 1
;  (or -1) have to be weighted more heavily in operations like the above-mentioned. This is done by Fisher's Z transform,
;  which maps the interval [-1,1] onto [-inf,inf]. By this, in addition, values become normally distributed, given that
;  they were normally distributed before normalization. Fisher's Z transformation, by the way, is actually nothing else
;  than the inverse hyperbolic tangens, i.e., arctanh().
;
; CATEGORY:
;  Algebra
;  Math
;  Statistics
;
; CALLING SEQUENCE:
;* y = FZT(x [, direction] [, /OVERWRITE] [, INFIND = ...)
;
; INPUTS:
;  x::  Any integer or float scalar or array containing the value(s) to be transformed.
;
; OPTIONAL INPUTS:
;  direction::  An integer scalar giving the direction of the transform. In accordance with IDL's <*>FFT()</*> function,
;               setting <*>x</*> to -1 converts correlation values into Fisher's Z values (forward transform, the
;               default), while setting <*>x</*> to 1 results in the inverse transform (mapping [-inf,inf] onto [-1,1]).
;               Other values than -1 or 1 are not accepted for <*>direction</*>.
;
; INPUT KEYWORDS:
;  OVERWRITE::  Set this keyword if you want the computation to be done "in place" in memory. This is significantly less
;               memory-consuming, but of course it is only suitable if you do not need the original argument any longer.
;
; OUTPUTS:
;  y::  A float (or double, if <*>x</*> is of double type) variable of the same structure as <*>x</*>, containing the
;       values resulting from the specified transform.
;
; OPTIONAL OUTPUTS:
;  INFIND::  Set this keyword to a named variable which on return will be a one-dimensional array containing the
;            (one-dimensional) subscript indices (as they would be obtained with IDL's <*>Where</*> function) into those
;            elements of <*>x</*> which are outside the (open) interval (-1,1) and which have therefore been mapped
;            onto -inf or inf, respectively. If <*>x</*> does not contain such irregular elements, a scalar -1 is
;            returned in <*>INFIND</*>. Note that the indices are <I>not</I> sorted, because this can take quite
;            a lot of time and is mostly not necessary. They are rather arranged in two sorted blocks, the first one
;            containing the indices into elements <=-1 (if there are any) and the second containing the indices into
;            elements >=+1 (if there are any). Remember that you sort the indices by yourself if you would like to have
;            them sorted.<BR>
;            This keyword has no effect when the inverse transform is specified (<*>direction</*>=1).
;
;
; RESTRICTIONS:
;  If <*>direction</*> is absent or -1, <*>x</*> values must lie between -1 and 1. Otherwise, values are clipped to +/-1;
;  the result of the transform is +inf and -inf, respectively. A corresponding console warning message is given. (It is,
;  however, not given for values which are =-1 or =+1, even though these values are mapped onto +/-inf, as well.)
;
; EXAMPLE:
;* Print, FZT([ -0.2 , 0.2 , 0.8 , 0.9 , 0.99 , 1.0 ])
;
;  IDL prints:
;
;*     -0.202733     0.202733      1.09861      1.47222      2.64665          Inf
;
; SEE ALSO:
;  A routine for averaging values in "Fisher's Z domain" and transforming back the resulting value(s) is available in the
;  NASE library: <A>FZTMean</A>.
;
;-



FUNCTION   FZT, X, Direction,   overwrite = overwrite, infind = infind


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors, assigning default value:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   TypeX = Size(X, /type)
   IF   TypeX EQ 0                     THEN  Console, '   Argument x not defined.'     , /fatal
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '   Argument x is of wrong type.', /fatal
   IF  TypeX EQ 5  THEN  Infinity = !Values.D_Infinity  $
   ELSE  Infinity = !Values.F_Infinity
   
   Default, Direction, -1
   ;; A copy of X is made unless the OVERWRITE keyword is set, in
   ;; which case X is simply renamed to _X: 
   IF  Keyword_Set(overwrite)  THEN  _X = Temporary(X)  $
   ELSE  _X = X
   ;;----------------------------------------------------------------------------------------------------------------------
   ;; Fisher's Z transform:
   ;;----------------------------------------------------------------------------------------------------------------------

   CASE  Direction  OF

      1:  BEGIN
         ;;look if any value is inf
         ;;[-inf,inf] has to transformed to [-1,1]
         inf_index = where((_X EQ -infinity) OR (_X EQ infinity), inf_count)
         if inf_count GT 0 then begin
            sign = signum(_X(inf_index))
            _X(inf_index) = 0.0
         endif
         ;; This seemingly strange way of computing
         ;; (exp(x)-exp(-x))/(exp(x)+exp(-x)) reduces time and memory
         ;; effort:
         _X = 1.0 - 2.0 / (exp(2.0*Temporary(_X))+1.0)
         if inf_count GT 0 then begin
            _X(inf_index) = sign
         endif
         return, _X
      END

     -1:  BEGIN
        ;; Checking whether values lie outside
        ;; the interval (-1,1), and determining
        ;; their subscripts (separately 
        ;; for values <= -1 and >= +1, respectively):
        MaxX = Max(X, min = MinX)
        ;; If values outside the interval [-1,1] exist, an extra
        ;; warning message is given: 
        IF  (MinX LT -1) OR (MaxX GT 1)  THEN  Console, '   Range of x beyond [-1,1]. Clipping values.', /warning
 
        ;; Computing the forward Fisher's Z transform. The values
        ;; outside the interval (-1,1) are not transformed, 
        ;; since computations producing math errors take much more
        ;; time; instead, X is set to 0 in the critical 
        ;; positions (which does not produce math errors), and the
        ;; result in the corresponding positions is explicitly 
        ;; set to +/-inf:
        one_index = where((_X GE 1.0) OR (_X LE -1.0), one_count)
        if one_count GT 0 then begin
           sign = signum(_X(one_index))
           _X(one_index) = 0.0
        ENDIF
        _X =  0.5 * alog(2.0/(1.0-Temporary(_X)) - 1.0)
        if one_count GT 0 then begin
           _X(one_index) = sign*infinity
        endif
        return, _X
     end

     ELSE:  Console, '   Direction of transform must be -1 or 1.', /fatal

   ENDCASE


END
