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
;*   s = GetSubArray(a, width1, width2 [,pos1 ,pos2] [,/CENTER]
;*                   { [,/EDGE_WRAP] |
;*                     [,EDGE_TRUNCATE [,TRUNC_VALUE=...]] }
;*                  )
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
;   CENTER       :: Positions denote array centres, not origins.
;   EDGE_WRAP    :: Wrap edges of source array cyclic, if requested array
;                   bounds lie outside the source array.
;   EDGE_TRUNCATE:: Fill area outside the source array with a constant
;                   value, if requested array
;                   bounds lie outside the source array.
;   TRUNC_VALUE  :: Value used to fill up. Used in conjunction with
;                   the <*>EDGE_TRUNCATE</*> keyword. Default: 0.
;
; OUTPUTS:
;   s:: The sub-array.
;
; RESTRICTIONS:
;   If the "sub"array is (in any dimension) actually larger than the
;   original array, <C>/EDGE_TRUNCATE</C> <B>must</B> be used.<BR>
;   Multiple replication could be implemented for <C>/EDGE_WRAP</C>,
;   but this is not currently available.
;
; EXAMPLE:
;   a=IndGen( 5, 5)
;   print, GetSubArray(a,3,3, /CENTER)
;
; SEE ALSO:
;   <A>InsSubarray</A>, <A>NoRot_Shift()</A>.
;-

FUNCTION GetSubArray, A, height, width, y_, x_, $
                      CENTER=CENTER, EDGE_WRAP=EDGE_WRAP, $
                      EDGE_TRUNCATE=EDGE_TRUNCATE, TRUNC_VALUE=TRUNC_VALUE


   On_Error, 2

   If (N_Params() ne 3) and (N_Params() ne 5) then Message, 'Wrong number of ' + $
    'parameters. Check syntax.'

   default, x_, 0
   default, y_, 0
   default, TRUNC_VALUE, 0

   x = x_
   y = y_

   sa = SIZE(A)

   IF sa(0) NE 2 THEN Message, 'Array has to be 2dimensional.'
   
   IF Keyword_Set(CENTER) THEN BEGIN
      x = x+sa(2)/2-width/2
      y = y+sa(1)/2-height/2
   Endif
   
   If Keyword_Set(EDGE_WRAP) then begin
      IF (sa(1) LT height) OR (sa(2) LT width) THEN begin
         Message, '/EDGE_WRAP set and array to be returned is larger ' + $
                  'than original array.', /Continue
         Message, 'Consider using /EDGE_TRUNCATE.'
      EndIf
      return, (shift(A, -y, -x))[0:height-1, 0:width-1]
   endif

   If Keyword_Set(EDGE_TRUNCATE) then begin
      res = make_array(height>sa[1], width>sa[2], value=TRUNC_VALUE)
      res[0:(sa[1]-1), 0:(sa[2]-1)] = A
      
      return, (norot_shift(temporary(res), -y, -x, Weight=TRUNC_VALUE))[0:height-1, 0:width-1]
   endif

   If (x lt 0) or (y lt 0) or ((x+width) gt sa(2)) or ((y+height) gt sa(1)) then Begin
      Message, 'Area specified lies partly outside the array boundaries. ', /Continue
      Message, 'Perhaps you meant to set /EDGE_WRAP or /EDGE_TRUNCATE?'
   EndIf

   RETURN, A(y:y+height-1,x:x+width-1) 

END
