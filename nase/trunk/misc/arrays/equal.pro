;+
; NAME:
;  Equal()
;
; AIM:
;  check which elements of an array are equal to an element of another array
;
; PURPOSE:
;  Marks each element of the first array (<*>ArrA</*>) where it contains an element of the second array (<*>ArrB</*>).<BR>
;  This is a generalization of IDLs' <*>EQ</*> whith the first argument being an array and the second a scalar.
;  In contrast to <*>EQ</*> here the second argument can be an array as well.
;  The result is a byte array of the same size as <*>ArrA</*>. It returns TRUE(=1B) where the element of <*>ArrA</*>
;  is an element of <*>ArrB</*> and FALSE(=0B) where the element of <*>ArrA</*> is not an element of <*>ArrB</*>.<BR>
;  This function can also be interpreted as a generalization of the function <A>InSet</A>. In fact, called with a scalar
;  (or one-element-array) first argument <A>Equal</A> yields the same result as <A>InSet</A>. In this case <A>InSet</A>
;  should be prefered because it is much faster. Conceptionally with the <A>Equal</A> function a (large) set <*>ArrA</*>
;  is searched through for elements of a (smaller) subset <*>ArrB</*> and the result describes a propery of <*>ArrA</*>.
;  Therefore <A>Equal</A> is optimized for <*>ArrA</*> being larger than <*>ArrB</*>.
;
; CATEGORY:
;  Algebra
;  Array
;  Math
;
; CALLING SEQUENCE:
;*    ynarr = Equal(ArrA, ArrB)
;
; INPUTS:
;  ArrA:: the array to be search through (any type, any dimension)
;  ArrB:: the array with the elements being searched for in ArrA (any type, any dimension)
;
; OUTPUTS:
;  ynarr:: a byte array with the same size as the input <*>ArrA</*>
;          TRUE(=0B) where <*>ArrA</*> contains an element of <*>ArrB</*>
;          FALSE(=0B) where <*>ArrA</*> does not contain an element of <*>ArrB</*>
;
;
; RESTRICTIONS:
;  If one argument is of type string, then the other has to be as well.
;
; PROCEDURE:
;  <*>ArrB</*> is checked for all distinct elements (using <A>Elements</A>.
;  Then a <*>FOR</*>-Loop runs with the number of iterations being equal to the number of
;  distinct elements of <*>ArrB</*>.
;
; EXAMPLE:
;*  Print, Equal([6,4,7,3,4,9],[4,6])
;*  >  1   1   0   0   1   0
;
; SEE ALSO:
;  <*>EQ</*>, <A>NotEqual</A>, <A>InSet</A>, <A>SubSet</A>
;-

FUNCTION  Equal,  ArrA, ArrB

  On_Error, 2

  IF N_Params() NE 2 THEN Console, 'illegal arguments', /FATAL

  EB = Elements(ArrB,NEB)

  ArrE =  ArrA EQ EB(0)
  FOR  n = 1L, NEB-1  DO  ArrE = ArrE OR (ArrA EQ EB(n))

  Return, ArrE

END
