;+
; NAME:
;   EmptySet()
;
; AIM:
;   decides wether a set is empty or not
;
; PURPOSE:
;   This function returns true (1B), if the argument contains other elements
;   than the representatives of empty sets, i.e. '' for string arguments or !none for number arguments.;
;
; CATEGORY:
;   Array
;   Math
;
; CALLING SEQUENCE:
;*   es = EmptySet(SetA[,cnt])
;
; INPUTS:
;   SetA:: a set (array) of any type and any dimension;
;
; OUTPUTS:
;   es:: false (0B) if <*>SetA</*> only contains <*>''</*> or <*>!none</*>, <BR>
;        true  (1B) else
;
; OPTIONAL OUTPUTS:
;   cnt:: A longinteger containing the number of distinct elements of the argument,
;         i.e. multiple instances of the same value are only considered once. <BR>
;         In contrast to <A>Elements</A>, here <*>cnt</*> is set to zero, if the elements exclusively represent
;         empty sets. If <*>SetA</*> is not empty <*>cnt</*> represents the number of distinct elements <i>including</i>
;         representatives of empty sets (cf. example no.4).
;
; RESTRICTIONS:
;  none
;
; EXAMPLE:
;*     Print, EmptySet(!none,cnt),   cnt
;*     >  1  0
;*     Print, EmptySet(['','',''],cnt),   cnt
;*     >  1  0
;*     Print, EmptySet([1,2,2,2,3],cnt),   cnt
;*     >  0  3
;*     Print, EmptySet(['','a','b'],cnt),   cnt
;*     >  0  3

;
; SEE ALSO:
;  <A>Elements</A>, <A>CutSet</A>, <A>UniSet</A>, <A>DiffSet</A>, <A>SubSet</A>
;
;-

FUNCTION EmptySet, _SetA, cnt

  On_Error, 2

  IF NOT Set(_SetA) THEN Console, 'invalid argument', /FATAL

  ; reduce to distinct elements:
  SetA = Elements(_SetA,nel)
  cnt  = 0L

; if not more than one distinct element, then look if argument equals !none or '' depending on type:
  IF nel EQ 1 THEN  $
    IF (SIZE(SetA, /TYPE) EQ 7) THEN BEGIN
      IF (SetA(0) EQ ''   ) THEN Return, 1B
    ENDIF ELSE BEGIN
      IF (SetA(0) EQ !None) THEN Return, 1B
    ENDELSE
; else:
  cnt = nel
  Return, 0B

END
