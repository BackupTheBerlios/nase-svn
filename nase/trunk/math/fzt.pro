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
;  the interval (or the positive or negative part of the interval) (-1,1), like correlation or coherence values, before
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
;* y = FZT(x [, direction] [, CLIPIND = ...)
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
;  CLIPIND::  Set this keyword to a named variable which on return will be a one-dimensional array containing the
;             (one-dimensional) subscript indices (as they would be obtained with IDL's <*>Where</*> function) into those
;             elements of <*>x</*> which were outside the interval (-1,1) and which were therefore clipped. This keyword
;             has no effect when the inverse transform is specified (<*>direction</*>=1). If <*>x</*> does not contain
;             such irregular elements, a scalar -1 is returned in <*>CLIPIND</*>.
;
; RESTRICTIONS:
;  If <*>direction</*> is absent or -1, <*>x</*> values must lie between -1 and 1 (excluding -1 and 1). Otherwise, values
;  are assumed to be meant to be "practically =1", and are replaced by the highest possible value <1, which depends on
;  the precision of the data type (single or double). A corresponding console warning message is given.
;
; EXAMPLE:
;  Print, FZT([0.2,0.3,0.8,0.9])
;
; SEE ALSO:
;  A routine for averaging values in "Fisher's Z domain" and transforming back the resulting value(s) is available in the
;  NASE library: <A>FZTMean</A>.
;
;-



FUNCTION   FZT, X, Direction,   overwrite = overwrite, clipind = clipind


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors, assigning default value:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   TypeX = Size(X, /type)
   IF   TypeX EQ 0                     THEN  Console, '   Argument x not defined.'     , /fatal
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '   Argument x is of wrong type.', /fatal

   Default, Direction, -1

   ;----------------------------------------------------------------------------------------------------------------------
   ; Fisher's Z transform:
   ;----------------------------------------------------------------------------------------------------------------------

   CASE  Direction  OF

      1:  BEGIN
            ; This seemingly strange way of computing (exp(x)-exp(-x))/(exp(x)+exp(-x)) reduces time and memory effort:
            IF  Keyword_Set(overwrite)  THEN  Return, 1.0 - 2.0 / (exp(2.0*Temporary(X))+1.0)  $
                                        ELSE  Return, 1.0 - 2.0 / (exp(2.0*          X )+1.0)
          END

     -1:  BEGIN
            ; The value (positive and negative) beyond which values are not accepted:
            IF  TypeX EQ 5  THEN  One = 0.9999999999999999D  $
                            ELSE  One = 0.9999999
            ; Checking whether values lie outside the interval (-1,1), and determining their subscripts:
            MaxX = Max(X, min = MinX)
            IF  (MinX LT -One) OR (MaxX GT One)  THEN  Console, '   Range of x beyond (-1,1). Clipping values.', /warning
            IF   MinX LT -One  THEN  iClipNeg = Where(X GT One, NClipNeg)  $
                               ELSE  iClipNeg = -1
            IF   MaxX GT  One  THEN  iClipPos = Where(X GT One, NClipPos)  $
                               ELSE  iClipPos = -1
            iClip = Elements([iClipNeg,iClipPos])
            ; A copy of X is made unless the OVERWRITE keyword is set:
            IF  Keyword_Set(overwrite)  THEN  X_ = Temporary(X)  $
                                        ELSE  X_ = X
            ; Clipping the critical values and computing the forward Fisher's Z transform:
            IF  NClipNeg GT 0  THEN  X_[iClipNeg] = -One
            IF  NClipPos GT 0  THEN  X_[iClipPos] =  One
            Return, 0.5 * alog(2.0/(1.0-Temporary(X_)) - 1.0)
          END

     ELSE:  Console, '   Direction of transform must be -1 or 1.', /fatal

   ENDCASE


END
