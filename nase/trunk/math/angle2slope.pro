;+
; NAME:
;  Angle2Slope()
;
; AIM: Compute angle of a straight line from its slope
;  
; PURPOSE:
;  Given the slope of a straight line, the function computes the angle
;  (in degrees) this line forms with the positive X-axis.
;  
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  slope = Angle2Slope(angle)
;  
; INPUTS:
;  angle: Angle the line forms with the positive X-axis, a value in
;         (-90°, +90°)
;  
; OUTPUTS:
;  slope: Slope of the line (dy/dx), a value in (-oo, +oo)
;  
; RESTRICTIONS:
;  Computation is performed in double precision.
;  
; PROCEDURE:
;  Straightforward TAN().
;  
; EXAMPLE:
;  print, Angle2Slope(-45)
;  
; SEE ALSO:
;  Slope2Angle()
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  2000/06/13 14:29:01  kupper
;        New, simple, but convenient.
;
;-

Function Angle2Slope, s

   return, tan(s/180d*!DPI)

End
