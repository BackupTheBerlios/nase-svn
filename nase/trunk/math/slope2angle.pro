;+
; NAME:
;  Slope2Angle()
;
; AIM: Compute slope of a straight line from its angle
;  
; PURPOSE:
;  Given the angle (in degrees) a line forms with the positive X-axis,
;  the function computes the slope of this line.
;  
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  angle = Slope2Angle(slope)
;  
; INPUTS:
;  slope: Slope of the line (dy/dx), a value in (-oo, +oo)
;  
; OUTPUTS:
;  angle: Angle the line forms with the positive X-axis, a value in
;         (-90°, +90°)
;  
; RESTRICTIONS:
;  Computation is performed in double precision.
;  
; PROCEDURE:
;  Straightforward ATAN().
;  
; EXAMPLE:
;  print, Slope2Angle(-1)
;  
; SEE ALSO:
;  Angle2Slope()
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  2000/06/13 14:29:01  kupper
;        New, simple, but convenient.
;
;-

Function Slope2Angle, s

   return, atan(s)/!DPI*180d

End
