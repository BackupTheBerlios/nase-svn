;+
; NAME:
;  CutTorus()                
;
; VERSION:
;  $Id$
;
; AIM:
;  sets all array elements outside a specfied torus to a constant value 
;
; PURPOSE:
;  Sets all array elements outside a specfied torus to a constant value.
;  The center of the torus is placed in the center of the array.
;
; CATEGORY:
;  Array
;  Image
;
; CALLING SEQUENCE:
;* torus = CutTorus(array, outer_radius [,inner_radius]
;*                  [X_CENTER=...] [,Y_CENTER=...] [,/TRUNCATE] [,CUT_VALUE=...]
;*                  [,/WHERE] [,COUNT=count])
;                         
; INPUTS:
;  array       :: two-dimmensional array
;  outer_radius:: elements with a distance > outer_radius from the
;                 center will be set to zero or the value specified by
;                 <*>CUT_VALUE</*>. 
;
; OPTIONAL INPUTS:
;  inner_radius:: elements with a distance <= inner_radius from the
;                 center will be set to zero or the value specified by
;                 <*>CUT_VALUE</*>.
;
; INPUT KEYWORD:
;  X_CENTER/
;  Y_CENTER :: Shift of the torus' center relative to the center of the array.
;              Toroidal boundary conditions apply unless
;              <*>/TRUNCATE</*> is set.
;  TRUNCATE :: Non-toroidal boundary conditions will be used, i.e. the
;              torus will be cut, if it doesn't fit.
;  CUT_VALUE:: Each element outside the torus will be set to this
;              value. Default is zero.
;  WHERE    :: If set, the indices specifying the elements of the
;              torus will be returned. If none matches, <*>!NONE</*>
;              will be returned, see also <*>COUNT</*>; 
;                               
; OUTPUTS:
;  torus:: the modified <*>array</*>, with the original values inside
;          the torus OR the indices of the array elements belonging to
;          the torus (see <*>/WHERE</*>).
;
; OPTIONAL OUTPUTS:
;  COUNT    :: will contain the count of the torus elements, if
;              <*>/WHERE</*> was set
;
; EXAMPLE:            
;*a = IntArr(100,100)
;*a = a+150
;*ptvs, cuttorus(a, 40, 30)
;*for i=-100,100 DO tv, cuttorus(a, 40, 30, Y_CENTER=i, X_CENTER=i)  
;*for i=-100,100 DO tv, cuttorus(a, 40, 30, Y_CENTER=i, /TRUNCATE)  
;*for i=-100,100 DO tv, cuttorus(a, 40, 30, Y_CENTER=i, X_CENTER=i, /TRUNCATE, CUT_VALUE=50)      
;
;-
FUNCTION CutTorus, data, outer_radius, inner_radius, X_CENTER=x_center, Y_CENTER=y_center, TRUNCATE=truncate, CUT_VALUE=cut_value, COUNT=count, WHERE=where

   dataDims = SIZE(data) 

   IF dataDims(0) NE 2 THEN Message, 'first argument has to be an 2d array'
   IF N_Params()  LT 2 THEN Message, 'at least two arguments expected' 
   Default, x_center, 0
   Default, y_center, 0
   Default, cut_value, 0
   

   distArr = ROUND(SHIFT( DIST(dataDims(1), dataDims(2)), dataDims(1)/2, dataDims(2)/2 ))
   IF Keyword_Set(TRUNCATE) THEN BEGIN
      distArr = NOROT_SHIFT(distArr, x_center, y_center)
   END ELSE BEGIN
      distArr = SHIFT(distArr, x_center, y_center)
   END

   outerRadius = WHERE (distArr GT outer_radius, count)
   IF count NE 0 THEN distArr(outerRadius) = -1

   IF N_Params() GE 3 THEN BEGIN
      innerRadius = WHERE (distArr LE inner_radius, count)
      IF count NE 0 THEN distArr(innerRadius) = -1
   END

   cut_elements = WHERE(distArr EQ -1, count)
   IF Keyword_Set(WHERE) THEN BEGIN
      ; GET THE INVERSE SET OF INDICES AND SET COUNT
      IF count NE 0 THEN BEGIN
         resArr = DiffSet( LIndgen(dataDims(1)*dataDims(2)), cut_elements)
      END ELSE BEGIN
         resArr = LIndgen(dataDims(1)*dataDims(2))
      END
      IF resArr(0) EQ !NONE THEN count = 0 ELSE count = N_Elements(resArr)
      RETURN, resArr
   END ELSE BEGIN
      resArr = data
      IF count NE 0 THEN resArr(cut_elements) = cut_value
      RETURN, resArr
   END

END
