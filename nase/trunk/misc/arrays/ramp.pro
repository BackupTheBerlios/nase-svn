;+
; NAME:
;  Ramp()
;
; AIM: Return array filled with a linear ramp
;  
; PURPOSE:
;  Ramp() is a generalization of the IDL INDGEN() function. It returns
;  a one-dimensional array filled with values according to a linear
;  ramp. The ramp may be specified by suitable combinations of the
;  following values: leftmost, rightmost, minimal, maximal or mean
;  value, and the slope or angle to the positive X-axis.
;  
; CATEGORY:
;  ARRAY
;  
; CALLING SEQUENCE:
;  result = Ramp( len,
;              { (LEFT=l, RIGHT=r)
;               |(LEFT=l,  {SLOPE=s|ANGLE=a})
;               |(RIGHT=r, {SLOPE=s|ANGLE=a})
;               |(MIN=min, {SLOPE=s|ANGLE=a})
;               |(MAX=max, {SLOPE=s|ANGLE=a})
;               |(MEAN=mn, {SLOPE=s|ANGLE=a})
;              }
; 
; INPUTS:
;  len: The length of the array to fill
;  
; OPTIONAL INPUTS:
;  LEFT:     value of the leftmost element (index 0)
;  RIGHT:    value of the rightmost element (index len-1)
;  MIN:      minimal value array shall contain
;  MAX:      maximal value array shall contain
;  MEAN:     mean value array shall contain
;
;  SLOPE:    slope of the ramp (dy/dx)
;  ANGLE:    angle between ramp and the positive X-axis
;  
; OUTPUTS:
;  result: Array filled with a linear ramp. The values are floats by default.
;          If one of the supplied values was a double, the result is double.
;  
; OPTIONAL OUTPUTS:
;  -please remove any sections that do not apply-
;  
; COMMON BLOCKS:
;  -please remove any sections that do not apply-
;  
; SIDE EFFECTS:
;  -please remove any sections that do not apply-
;  
; RESTRICTIONS:
;  Only the documented combinations of keywords are supported. For
;  other combinations (even though possibly propperly defining a
;  ramp), the result is undefined.
;  
; PROCEDURE:
;  Compute left and right value, then modify an INDGEN() accordingly.
;  
; EXAMPLE:
;  -please specify-
;  
; SEE ALSO:
;  INDGEN(), Angle2Slope()
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/06/14 19:20:10  kupper
;        Now handling special case of len=1.
;
;        Revision 1.2  2000/06/14 18:55:28  kupper
;        Oops! +/-1 error!
;
;        Revision 1.1  2000/06/14 14:07:42  kupper
;        First version.
;
;-

Function Ramp, len, LEFT=left, RIGHT=right, MIN=min, MAX=max, $
               MEAN=mean, SLOPE=slope, ANGLE=angle

   ;; Angle was given, not slope:
   If Set(ANGLE) then slope = Angle2Slope(angle)

   ;; Mean was given, not Min/Max:
   If Set(MEAN) then begin
      min = mean-((len-1)/2.0)*abs(slope)
   EndIf

   ;; Min/Slope was given:
   If Set(MIN) and Set(SLOPE) then begin
      If slope gt 0 then begin
         left = min
         right = min + (len-1)*abs(slope)
      Endif Else begin
         left = min + (len-1)*abs(slope)
         right = min
      Endelse
   EndIf
   
   ;; Max/Slope was given:
   If Set(MAX) and Set(SLOPE) then begin
      If slope gt 0 then begin
         right = max
         left  = max - (len-1)*abs(slope)
      Endif Else begin
         right = max - (len-1)*abs(slope)
         left = max
      Endelse
   EndIf

   ;; Left/Slope was given:
   If Set(LEFT) and Set (SLOPE) then begin
      right = left + (len-1)*slope
   EndIf
   
   ;; Right/Slope was given:
   If Set(RIGHT) and Set (SLOPE) then begin
      left = right - (len-1)*slope
   EndIf
   
   ;; At this point, left & right are defined.

   ;; handle special case:
   if len eq 1 then return, float(left)

   return, left + indgen(len)/(len-1.0) * (right-left)

End
