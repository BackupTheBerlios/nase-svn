;+
; NAME:
;   DiffSet()
;
; AIM:
;   returns the difference set of two sets (arrays)
;
; PURPOSE:
;   This function returns all distinct elements of the first argument (<*>SetA</*>) that are
;   not in the second (<*>Sub</*>).<BR>
;   Set <*>Sub</*> does not necessarily need to be a subset of <*>SetA</*>. For example,
;   if the intersection of both sets is empty, then the result will be identical to <*>SetA</*>.
;   Multiple instances of the same value in <*>SetA</*> (which are possible due to the array nature of the input)
;   are only considered once. This default option can be turned off by setting the <*>ARRAY</*> keyword which also
;   prevents the result from being sorted in ascending order and keeps the original order.
;
; CATEGORY:
;   Array
;   Math
;
; CALLING SEQUENCE:
;*   ds = DiffSet(SetA,Sub)
;
; INPUTS:
;   SetA:: the set (array) that will be reduced (any type, any dimension)
;   Sub :: the set containing those elements that should be removed from <*>SetA</*> (any type, any dimension);
;          empty sets (=!None) may also be passed to the function
;
; OUTPUTS:
;   ds:: an linear array of the same type as the first argument;
;        if one of the arguments is an empty set (=!None, not undefined!)
;        the result will be identical to <*>SetA</*>.
;
; INPUT KEYWORDS:
;  ARRAY:: set this keyword to avoid sorting the result and removing multiple entries
;
; RESTRICTIONS:
;  If one argument is of type string, then the other has to be as well.
;
; EXAMPLE:
;*     Print, DiffSet([4,65,7,3,7,4],[1,3,5,4])
;*     >  7  65
;*     Print, DiffSet([4,65,7,3,7,4],[1,3,5,4], /array)
;*     > 65   7   7
;
; SEE ALSO:
;  <A>CutSet</A>, <A>UniSet</A>, <A>SubSet</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2001/03/15 15:07:12  gail
;     bug fix: string handling
;
;     Revision 1.3  2000/12/20 18:08:55  gail
;     * completely revised
;     * updated header
;
;     Revision 1.2  2000/09/25 09:12:54  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.1  1998/07/21 13:21:27  saam
;           urgently needed
;
;
;-

FUNCTION DiffSet, SetA, Sub, array=array

  On_Error, 2

  IF NOT (Set(SetA) AND Set(Sub)) THEN Console, 'invalid arguments', /FATAL

  ; handle string arguments
  IF (SIZE(SetA, /TYPE) EQ 7) XOR (SIZE(Sub, /TYPE) EQ 7) THEN  $
    Console, /FATAL, 'both or no arguments may be strings'

  ; if called with an empty set then return SetA (because there's nothing to do)
  IF (SIZE(SetA, /TYPE) EQ 7) THEN BEGIN
    IF (SetA(0) EQ ''   ) OR (Sub(0) EQ ''   ) THEN Return, SetA
  ENDIF ELSE BEGIN
    IF (SetA(0) EQ !None) OR (Sub(0) EQ !None) THEN Return, SetA
  ENDELSE

  ; evtl. reduce to a set for the case that SetA contains multiple instances of the same value (array!)
  IF Keyword_Set(array) THEN ElmA = SetA  $
                        ELSE ElmA = Elements(SetA)

  ; mark all elements of ElmA that are not in Sub and return them
  R = Where(NotEqual(ElmA,Sub))
  IF R(0) NE -1 THEN  Return, ElmA(R)  ELSE Return, !None

END
