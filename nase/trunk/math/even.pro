;+
; NAME:
;  Even()
;
; VERSION:
;  $Id$
;
; AIM:
;  checks if a variable is even
;
; PURPOSE:
;  Checks if a given variable is even. You can specify scalars or
;  arrays. In the latter case, the check is performed element-wise and
;  an array of same dimensions as the argument is returned.
;
; CATEGORY:
;  Algebra
;  NumberTheory
;
; CALLING SEQUENCE:
;* e = Even(A)
;
; INPUTS:
;  A:: an arbitrary scalar or array of an ordinal data type
;
; OUTPUTS:
;  e:: boolean (BYTE, scalar or array), indicating if <*>A</*> (or its
;      elemets) is even.
;
; EXAMPLE:
;* print, even([1,2,3])
;* > 0  1  0
;
; SEE ALSO:
;  <A>Odd</A>
;
;-
FUNCTION Even, n

On_Error, 2

IF N_Params() NE 1 THEN Console, 'illegal argument', /FATAL
IF NOT Ordinal(n) THEN Console, 'argument not ordinal!', /FATAL

RETURN, BYTE((n+1) MOD 2)

END
