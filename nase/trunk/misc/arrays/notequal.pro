;+
; NAME:
;  NotEqual()
;
; AIM:
;  check which elements of an array are not equal to an element of another array
;
; PURPOSE:
;  Marks each element of the first array (A) where it not contains an element of the second array (B).<BR>
;  This function is the negation of the function <A>Equal</A> and only implemented for convenience.
;  Because <A>Equal</A> returns a byte array <*>E</*> of 0B and 1B values, the negated form <*>NOT E</*>
;  will contain even and odd (but not neccessarily 0B und 1B) values. This is impractical when being used
;  as argument e.g. for the <*>Where</*> function.
;
; CATEGORY:
;  Algebra
;  Array
;  Math
;
; CALLING SEQUENCE:
;*    ynarr = NotEqual(ArrA, ArrB)
;
; INPUTS:
;  ArrA:: the array to be search through (of any type)
;  ArrB:: the array with the elements being searched for in ArrA (of any type)
;
; OUTPUTS:
;  ynarr:: a byte array with the same size as the input ArrA
;          TRUE(=0B) where ArrA does not contain an element of ArrB
;          FALSE(=0B) where ArrA contains an element of ArrB
;
;
; PROCEDURE:
;  Negation of <A>Equal</A>
;
; EXAMPLE:
;*  Print, Not Equal([6,4,7,3,4,9],[4,6])
;*  >254 254 255 255 254 255
;*  Print, NotEqual([6,4,7,3,4,9],[4,6])
;*  >  0   0   1   1   0   1
;
; SEE ALSO:
;  <*>NE</*>, <A>Equal</A>
;-

FUNCTION  NotEqual,  ArrA, ArrB

  On_Error, 2

  IF N_Params() NE 2 THEN Console, 'illegal arguments', /FATAL

  Return, 1B - Equal(ArrA, ArrB)

END
