;+
; NAME:                InsSubArray
;
; PURPOSE:             Fuegt ein zweidimensionales Array in ein anderes zweidimensionales
;                      Array ein. Eigentlich triviale Routine, aber man spart sich die
;                      Indexhexerei und ein paar bequeme Optionen.
;
; CATEGORY:            MISC ARRAY
;
; CALLING SEQUENCE:    c = InsSubArray(a, b [,i1] [,i2] [,/CENTER])
;
; INPUTS:              a: array, in das eingefuegt werden soll
;                      b: array, das eingefuegt werden soll
;
; OPTIONAL INPUTS:     i1/i2: relative Position zum Arrayursprung(0,0) bzw. zur Arraymitte,
;                             falls Keyword CENTER gesetzt ist. Default: i1=0,i2=0
;                             i1 indiziert die erste Array-Dimension, i2 die zweite.
;
; KEYWORD PARAMETERS: CENTER: das Array b wird zentriert mit Offset (i1,i2) in
;                     Array a eingesetzt.
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
;     Revision 1.2  2000/02/29 12:55:31  kupper
;     Corrected order of indexing which was confused,
;     and added an informational message.
;
;     Revision 1.1  1998/06/03 14:27:59  saam
;           Yeah Yeah Yeah
;
;
;-
FUNCTION InsSubArray, _A, B, y, x, CENTER=CENTER

   On_Error, 2

   IF N_Params() LT 2 OR N_Params() GT 4 THEN Message, 'wrong number of parameters, check syntax'

   If n_Params() eq 4 then begin
      Message, /Info, "Caution: The order of x/y-indexing in INSSUBARRAY had been confused."
      Message, /Info, "         This was a bug and not a feature."
      Message, /Info, "         It has been corrected in rev. 1.2 (Feb 29 2000)."
      Message, /Info, "         To reflect the new behaviour, exchange 3rd and 4th parameter in the function call."
      Message, /Info, "-- This warning may be removed in a coming revision. --"
   Endif
      
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
