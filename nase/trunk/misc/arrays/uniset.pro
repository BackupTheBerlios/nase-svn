;+
; NAME:
;   UniSet()
;
; AIM:
;   returns the unification of two sets (arrays)
;
; PURPOSE:
;   This function returns all distinct elements of two sets (arrays).<BR>
;   Multiple instances of the same value are only considered once.
;
; CATEGORY:
;   Array
;   Math
;
; CALLING SEQUENCE:
;*   us = UniSet(SetA,SetB[,cnt])
;
; INPUTS:
;   SetA:: the first set (array) of any type and any dimension;
;          empty sets (=!None) may also be passed to the function
;   SetB:: cf. <*>SetA</*>
;
; OUTPUTS:
;   us:: a linear array (type according to IDL's type conversion rules for array concatenation)
;        the elements are sorted in ascending order (due to the way IDL's<*>Uniq</*> works);
;        if one of the arguments is an empty set (=!None, not undefined!)
;        the result will be the elements of the other argument;
;
; OPTIONAL OUTPUTS:
;   cnt:: a longinteger containing the number of elements in the resulting array (set); <BR>
;         zero if result represents empty set
;
; RESTRICTIONS:
;  If one argument is of type string, then the other has to be as well.
;
; EXAMPLE:
;*     Print, UniSet([1,7,5,4,4],[4,65,7,3,7,4])
;*     >  1  3  4  5  7  65
;*     Print, UniSet([1,7,5,4,4],CutSet([1,2,3],[4,5]))
;*     >  1  4  5  7
;  The second result represents !None.
;
; SEE ALSO:
;  <A>CutSet</A>, <A>DiffSet</A>, <A>SubSet</A>
;
;-

FUNCTION UniSet, SetA, SetB, cnt

  On_Error, 2

  IF NOT (Set(SetA) AND Set(SetB)) THEN Console, 'invalid arguments', /FATAL

  ; handle string arguments
  IF (SIZE(SetA, /TYPE) EQ 7) XOR (SIZE(SetB, /TYPE) EQ 7) THEN  $
    Console, /FATAL, 'both or no arguments may be strings'

; if called with two empty sets/array then return the first set
  IF EmptySet(SetA) AND EmptySet(SetB) THEN BEGIN cnt = 0  &  Return, Elements(SetA)  &  ENDIF
; if called with one empty/array set then return the elements of the other set
  IF EmptySet(SetA) THEN Return, Elements(SetB,cnt)
  IF EmptySet(SetB) THEN Return, Elements(SetA,cnt)

; if two non-empty sets then concatenate both sets and extract all distinct elements
  Return, Elements([Reform([SetA],N_Elements(SetA)),Reform([SetB],N_Elements(SetB))],cnt)


END
