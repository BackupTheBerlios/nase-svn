;+
; NAME:                InsSubArray
;
; AIM:                 inserts an array into another array (two dimensional)
;
; PURPOSE:             Inserts a two dimensional array into another
;                      two dimensional array. It allows convenient
;                      placement (including centering) and is aware
;                      of toroidal boundary conditions. This routine
;                      saves you from some sophisticated index magic.
;
; CATEGORY:            MISC ARRAY
;
; CALLING SEQUENCE:    c = InsSubArray(a, b [,i1] [,i2] [,/CENTER] [,/WRAP])
;
; INPUTS:              a: the array where b is inserted into
;                      b: array inserted into a
;
; OPTIONAL INPUTS:     i1/i2: relative position (i1,i2) according to the
;                             array's origin (0,0) or the center (if
;                             keyword CENTER is set). The default
;                             value is zero for both, i1 and i2. You
;                             can also omit i2, then the whole array
;                             is inserted at the position specified by
;                             the onedimensional index i1.
; 
;
; KEYWORD PARAMETERS: CENTER: array b will be centered in array a with a
;                             relative offset (i1,i2)
;                     WRAP:   toroidal boundary conditions will be
;                             used, when inserting b.
;   
; OUTPUTS:            c: resulting array with dimension identical to
;                        array a. If b doesn't fit into a, exceeding
;                        values will be cut, unless the keyword WRAP
;                        is set.
; 
;
; EXAMPLE:
;                     a=IntArr( 8, 8)
;                     b=Indgen(3,3)
;                     print, InsSubArray(a,b, /CENTER)
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/09/25 09:12:55  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.4  2000/07/04 13:59:51  saam
;           extended positional argument syntax
;           for 1d positions
;
;     Revision 1.3  2000/06/28 09:31:29  saam
;           + B may exeed A's borders now
;           + added new keyword WRAP
;           + translated DOC header
;           + messaged -> console
;
;     Revision 1.2  2000/02/29 12:55:31  kupper
;     Corrected order of indexing which was confused,
;     and added an informational message.
;
;     Revision 1.1  1998/06/03 14:27:59  saam
;           Yeah Yeah Yeah
;
;
;-
FUNCTION InsSubArray, _A, B, _y, _x, CENTER=CENTER, WRAP=wrap

   On_Error, 2

   IF N_Params() LT 2 OR N_Params() GT 4 THEN Console, 'wrong number of parameters, check syntax', /FATAL

   If n_Params() eq 4 then begin
      Console, "Caution: The order of x/y-indexing in INSSUBARRAY had been confused.", /WARN
      Console, "         This was a bug and not a feature.", /WARN
      Console, "         It has been corrected in rev. 1.2 (Feb 29 2000).", /WARN
      Console, "         To reflect the new behaviour, exchange 3rd and 4th parameter in the function call.", /WARN
      Console, "-- This warning may be removed in a coming revision. --", /WARN
   Endif
      
   
   A = _A
   sa = SIZE(A)
   sb = SIZE(B)

   IF (sa(1) LT sb(1)) OR (sa(2) LT sb(2)) THEN Console, 'array to be inserted is larger than original array', /FATAL

   CASE N_Params() OF
       3: BEGIN
           x = _y  /  SA(1)
           y = _y MOD SA(1)
          END
       4: BEGIN
           x = _x
           y = _y
          END
    ELSE: BEGIN
            Default, x, 0
            Default, y, 0
          END
   END

   IF Keyword_Set(CENTER) THEN BEGIN
      x = x+sa(2)/2-sb(2)/2
      y = y+sa(1)/2-sb(1)/2
   END
   
   IF sa(0) NE 2 THEN Console, 'First array has to be 2d', /FATAL
   IF sb(0) NE 2 THEN Console, 'Second array has to be 2d', /FATAL
   
;   A(y:y+sb(1)-1,x:x+sb(2)-1) = B (old assignment, before adding WRAP)
   IF Keyword_Set(WRAP) THEN BEGIN
       A=shift(A,-y,-x) 
       A(0:sb(1)-1, 0:sb(2)-1) = B
       A=shift(A, y, x) 
   END ELSE BEGIN 
       A(MAX([y,0]):MIN([sa(1)-1, y+sb(1)-1]), MAX([x,0]):MIN([sa(2)-1, x+sb(2)-1])) = B(MAX([-y,0]):MIN([y+sb(1)-1,sa(1)-1])-y,MAX([-x,0]):MIN([x+sb(2)-1,sa(2)-1])-x)
   END
   
   RETURN, A

END
