;+
; NAME:
;   CutSet()
;
; AIM:
;   returns the intersection of two sets (arrays)
;
; PURPOSE:
;   This function returns all distinct elements two sets (arrays) have in common.<BR>
;   Multiple instances of the same value are only considered once. To minimize
;   computational effort the set containing less elements should be passed as the second argument.
;
; CATEGORY:
;   Array
;   Math
;
; CALLING SEQUENCE:
;*   cs = CutSet(SetA,SetB)
;
; INPUTS:
;   SetA:: the first set (array) of any type and any dimension;
;          empty sets (=!None) may also be passed to the function
;   SetB:: well, let me guess ...
;
; OUTPUTS:
;   cs:: a linear array of the same type as the first argument;
;        the elements are sorted in ascending order (due to the way IDL's <*>Uniq</*> works);
;        if one of the arguments is an empty set (=!None, not undefined!)
;        the result will also be empty (=!None)
;
; RESTRICTIONS:
;  If one argument is of type string, then the other has to be as well.
;
; EXAMPLE:
;*     Print, CutSet([1,7,5,4],[4,65,7,3,7,4])
;*     >  4  7
;*     Print, CutSet([1,2,5,9],[4,65,7,3,7,4])
;*     >  -999999.
;  The second result represents !None.
;
; SEE ALSO:
;  <A>SubSet</A>, <A>UniSet</A>, <A>DiffSet</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2001/03/15 15:07:12  gail
;     bug fix: string handling
;
;     Revision 1.4  2000/12/20 18:07:26  gail
;     * fixed header bug (example code)
;
;     Revision 1.3  2000/12/20 15:17:54  gail
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

FUNCTION CutSet, SetA, SetB

  On_Error, 2

  IF NOT (Set(SetA) AND Set(SetB)) THEN Console, /FATAL, 'invalid arguments'

  ; handle string arguments
  IF (SIZE(SetA, /TYPE) EQ 7) XOR (SIZE(SetB, /TYPE) EQ 7) THEN  $
    Console, /FATAL, 'both or no arguments may be strings'

; if called with an empty set then return an empty set
  IF (SIZE(SetA, /TYPE) EQ 7) THEN BEGIN
    IF (SetA(0) EQ '')    OR (SetB(0) EQ '')    THEN Return, ''
  ENDIF ELSE BEGIN
    IF (SetA(0) EQ !None) OR (SetB(0) EQ !None) THEN Return, !None
  ENDELSE

; reduce to a set for the case that SetA contains multiple instances of the same value (array!)
  ElmA = Elements(SetA)

  ; mark all elements of ElmA that are also in SetB and return them
  R = Where(Equal(ElmA,SetB))
  IF R(0) NE -1 THEN  Return, ElmA(R)  ELSE Return, !None

END
