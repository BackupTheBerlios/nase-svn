;+
; NAME:               InSet
;
; AIM:                checks if an element is part of a set (array)
;
; PURPOSE:            Ist so ne Art Erweiterung des EQ-Vergleichs.
;                     InSet schaut ob ein Element I in einem Array
;                     (einer Menge) vorhanden ist; liefert TRUE, wenn
;                     ja und FALSE sonst.
;
; CATEGORY:           MISC ARRAY
;
; CALLING SEQUENCE:   yn = InSet(I,S)
;
; INPUTS:             I: ein Element, das vielleicht in S enthalten ist.
;                     S: die Vergleichsmenge
;
; OUTPUTS:            yn: TRUE, wenn I Element von S; FALSE, sonst
;
; EXAMPLE:
;                     IF InSet(1,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;                     ;    NOPE
;                     IF InSet(7,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;                     ;    YUPP
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2000/09/25 09:12:55  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.3  1999/09/22 12:41:28  kupper
;     Changed algorithm from a loop (uargh!) to an array-operation.
;
;     Revision 1.2  1999/02/05 19:14:10  saam
;           + return if an error occurs
;
;     Revision 1.1  1998/06/23 19:15:44  saam
;           scarcely worth to talk of
;
;
;-
FUNCTION InSet, I, S

   On_Error, 2

   IF N_Params() NE 2 THEN Message, 'you have to pass two arguments'

   NI = N_Elements(I)
   IF NI NE 1 THEN Message, 'first argument has to be scalar or a one-element-array'
   
   RETURN, Total( I(0) eq S )
   ;;Result of Total is of type float. All non-zero floats are TRUE.

END
