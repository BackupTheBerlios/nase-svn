;+
; NAME:                
;        GetSubArray()
;
; VERSION:
;  $Id$
;
; AIM: returns a rectangular two-dimensional area of a supplied array
; 
;
; PURPOSE: Returns a two-dimensional sub-array of a suppled array, using a
;          convenient call.
;
; CATEGORY:
;  Array
;
; CALLING SEQUENCE:
;*   s = GetSubArray(a, width1, width2 [,pos1 ,pos2] [,/CENTER])
;
; INPUTS:
;   a:: array from which to extract the subarray.
;
; OPTIONAL INPUTS:
;   pos1,pos2:: Position of subarray's origin (0,0)  relative to
;               the origin of the mother array.
;               If Keyword CENTER is set: Position of subarray's
;               centre relative to the centre of the mother array.
;               Default: pos1=pos2=0.
;
; INPUT KEYWORDS: 
;   CENTER:: Positions denote array centres, not origins.
;
; OUTPUTS:
;   s:: The sub-array.
;
; RESTRICTIONS:
;   Sub-array must lie inside the boundaries of the mother array.
;   Anyway, an EDGE_WRAP keyword could be easily implemented using SHIFT().
;   Please feel free to do it :-).
;
; EXAMPLE:
;   a=IndGen( 5, 5)
;   print, GetSubArray(a,3,3, /CENTER)
;
; SEE ALSO:
;   <A>InsSubarray</A>.
;-

FUNCTION GetSubArray, A, height, width, y_, x_, CENTER=CENTER

   On_Error, 2

   If (N_Params() ne 3) and (N_Params() ne 5) then Message, 'Wrong number of ' + $
    'parameters. Check syntax.'

   default, x_, 0
   default, y_, 0

   x = x_
   y = y_

   sa = SIZE(A)

   IF (sa(1) LT height) OR (sa(2) LT width) THEN Message, 'Array to be returned is larger than original array'
   IF sa(0) NE 2 THEN Message, 'Array has to be 2dimensional.'
   
   IF Keyword_Set(CENTER) THEN BEGIN
      x = x+sa(2)/2-width/2
      y = y+sa(1)/2-height/2
   Endif
   
   If (x lt 0) or (y lt 0) or ((x+width) gt sa(2)) or ((y+height) gt sa(1)) then Begin
      Message, 'Area specified lies partly outside the array boundaries. ', /Continue
      Message, 'If you intended such use, expecting cyclic behaviour,', /Continue
      Message, 'you are encouraged to emplement an EDGE_WRAP keyword :-)'
   EndIf

   RETURN, A(y:y+height-1,x:x+width-1) 

END
