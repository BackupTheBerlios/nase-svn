;+
; NAME:                InsSubArray
;
; PURPOSE:             Fuegt ein zweidimensionales Array in ein anderes zweidimensionales
;                      Array ein. Eigentlich triviale Routine, aber man spart sich die
;                      Indexhexerei und ein paar bequeme Optionen.
;
; CATEGORY:            MISC ARRAY
;
; CALLING SEQUENCE:    c = InsSubArray(a, b [,x] [,y] [,/CENTER])
;
; INPUTS:              a: array, in das eingefuegt werden soll
;                      b: array, das eingefuegt werden soll
;
; OPTIONAL INPUTS:     x/y: relative Position zum Arrayursprung(0,0) bzw. zur Arraymitte,
;                           falls Keyword CENTER gesetzt ist. Default: x=0,y=0
;
; KEYWORD PARAMETERS: CENTER: das Array b wird zentriert mit Offset x,y in Array a eingesetzt
;
; OUTPUTS:            c: das resultierende Array
;
; EXAMPLE:
;                     a=IntArr( 8, 8)
;                     b=Indgen(3,3)
;                     print, InsSubArray(a,b, /CENTER)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/06/03 14:27:59  saam
;           Yeah Yeah Yeah
;
;
;-
FUNCTION InsSubArray, _A, B, x, y, CENTER=CENTER

   On_Error, 2

   IF N_Params() LT 2 OR N_Params() GT 4 THEN Message, 'wrong number of parameters, check syntax'
   Default, x, 0
   Default, y, 0
   

   A = _A
   sa = SIZE(A)
   sb = SIZE(B)

   IF (sa(1) LT sb(1)) OR (sa(2) LT sb(2)) THEN Message, 'array to be inserted is larger than original array' 
   
   IF Keyword_Set(CENTER) THEN BEGIN
      x = x+sa(2)/2-sb(2)/2
      y = y+sa(1)/2-sb(1)/2
   END
   
   IF sa(0) NE 2 THEN Message, 'First array has to be 2d'
   IF sb(0) NE 2 THEN Message, 'Second array has to be 2d'
   
   A(y:y+sb(1)-1,x:x+sb(2)-1) = B
   
   RETURN, A

END
