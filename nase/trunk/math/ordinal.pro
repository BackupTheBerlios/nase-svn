;+
; NAME:
;  Ordinal()
;
; VERSION:
;  $Id$
;
; AIM:
;  checks if a given variable type is countable
;
; PURPOSE:
;  This is a simple check, if a variable is countable.
;  This holds for IDL type likes <*>BYTE</*>... but not for
;  <*>FLOAT</*>... .
;
; CATEGORY:
;  Algebra
;  DataStructures
;
; CALLING SEQUENCE:
;* o = Ordinal(A)
;
; INPUTS:
;  A:: an arbitrary scalar or array
;
; OUTPUTS:
;  o:: Boolean, indicating if <*>A</*> is ordinal.
;
; EXAMPLE:
;* print, ordinal(5b), ordinal(1.)
;* > 1 0
;
; SEE ALSO:
;  <A>TypeOf</A>
;
;-
FUNCTION Ordinal, a

RETURN, BYTE(InSet(Typeof(A), ['BYTE', 'INT', 'LONG', 'UINT', 'ULONG', 'LONG64']))

END
