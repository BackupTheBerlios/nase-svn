;+
; NAME:
;  Odd()
;
; VERSION:
;  $Id$
;
; AIM:
;  checks if a variable is odd
;
; PURPOSE:
;  Checks if a given variable is odd. You can specify scalars or
;  arrays. In the latter case, the check is performed element-wise and
;  an array of same dimensions as the argument is returned.
;
; CATEGORY:
;  Algebra
;  NumberTheory
;
; CALLING SEQUENCE:
;* e = Odd(A)
;
; INPUTS:
;  A:: an arbitrary scalar or array of an ordinal data type
;
; OUTPUTS:
;  e:: boolean (BYTE, scalar or array), indicating if <*>A</*> (or its
;      elemets) is odd.
;
; EXAMPLE:
;* print, odd([1,2,3])
;* > 1  0  1
;
; SEE ALSO:
;  <A>Even</A>
;
;-
FUNCTION Odd, n

ON_Error, 2
IF N_Params() NE 1 THEN Console, 'illegal argument', /FATAL
IF NOT Ordinal(n) THEN Console, 'argument not ordinal!', /FATAL

RETURN, BYTE(n MOD 2)

END
