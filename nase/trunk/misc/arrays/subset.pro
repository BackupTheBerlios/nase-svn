;+
; NAME:
;   SubSet()
;
; AIM:
;   checks if a set is a subset of another set (array)
;
; PURPOSE:
;   Check whether all distinct elements of the first argument (<*>SetA</*>) are contained in the second argument
;   (<*>SetB</*>).<BR>
;   This function is a extension of <A>InSet</A>. In contrast to <A>InSet</A> here the first argument
;   can be a set (array). For <*>SetA</*> being a scalar both functions are identical.<BR>
;   The result is TRUE(=1B) or FALSE(=0B). It is independent of whether <*>SetA</*> is a real set or an array containing
;   multiple instances of the same value. I.e. identical entries of <*>SetA</*> are checked only once for their existence
;   in <*>SetB</*>.
;
; CATEGORY:
;   Array
;   Math
;
; CALLING SEQUENCE:
;*   yn = SubSet(SetA,SetB)
;
; INPUTS:
;   SetA:: the potential subset
;   SetB:: the set to be searched through for elements of <*>SetA</*>
;
; OUTPUTS:
;   yn:: TRUE(=1B), if all distinct element of <*>SetA</*> are in <*>SetA</*>; FALSE(=0B), else.
;
; RESTRICTIONS:
;  If one argument is of type string, then the other has to be as well.
;
; EXAMPLE:
;*     IF SubSet([1,7]  ,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;*     >NOPE
;*     IF SubSet([3,7]  ,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;*     >YUPP
;*     IF SubSet([3,3,7],[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;*     >YUPP
;*     IF SubSet( 7     ,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;*     >YUPP
;
; SEE ALSO:
;  <A>InSet</A>, <A>Equal</A>, <A>CutSet</A>, <A>UniSet</A>, <A>DiffSet</A>
;
;-

FUNCTION SubSet, SetA, SetB

   On_Error, 2

   IF NOT (Set(SetA) AND Set(SetB)) THEN Console, 'invalid arguments', /FATAL

   ; reduce to a set for the case that SetA contains multiple instances of the same value (array!)
   ElmA = Elements(SetA,NElmA)
   InS  = BYTARR(NSubS,/nozero)
   ; InS(n) contains the information whether ElmA(n) is in SetB
   FOR n=0,NElmA-1 DO InS(n) = Total(ElmA(n) EQ SetB) NE 0

   Return, Total(InS) EQ NElmA

END
