;+
; NAME:               InSet
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
; OUTPUTS:            yn: 1, wenn I Element von S; 0, sonst
;
; EXAMPLE:
;                     IF InSet(1,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;                     ;    NOPE
;                     IF InSet(1,[4,65,7,3,7,4]) THEN print, 'YUPP' ELSE print, 'NOPE'
;                     ;    YUPP
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/06/23 19:15:44  saam
;           scarcely worth to talk of
;
;
;-
FUNCTION InSet, I, S

   IF N_Params() NE 2 THEN Message, 'you have to pass two arguments'

   NI = N_Elements(I)
   NS = N_Elements(S)
      
   IF NI NE 1 THEN Message, 'first argument has to be scalar'
   
   FOR x=0, NS-1 DO BEGIN
      IF I EQ S(x) THEN RETURN, 1
   END
   RETURN, 0

END
