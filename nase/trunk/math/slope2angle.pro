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
;  Computation is performed (and result is returned) in single
;  precision, if the argument is of integer type or float. Computation
;  is performed in double precision, if the argument is of type
;  double.
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
;        Revision 2.3  2000/06/14 14:17:49  kupper
;        Added one space to turn on the CVS watch.
;
;        Revision 2.2  2000/06/14 12:59:36  kupper
;        Changed policy of floating / double computation.
;
;        Revision 2.1  2000/06/13 14:29:01  kupper
;        New, simple, but convenient.
;
;-

Function Slope2Angle, s

   If size(s, /Tname) eq "DOUBLE" then pi = !DPI else pi = !PI
   return, atan(s)*180/pi

End
