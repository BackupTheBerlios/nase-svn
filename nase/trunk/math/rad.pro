;+
; NAME:
;  Rad()
;
; AIM: Change angle from degrees to rad.
;  
; PURPOSE:
;  Rad() takes an angle measured in degrees, and returns it's
;  radian equivalent.
;  Output values will always be in the interval [0,2pi) ([-pi,pi) if
;  SYMMETRIC is set), input values are unrestricted.  
;  
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  result = Rad(angle [,/SYMMETRIC])
;  
; INPUTS:
;  angle: angle, measured in degrees. Interval: (-oo, oo)
;  
; OUTPUTS:
;  result: angle measured in radians. Interval: [0,2pi), [-pi,pi) if
;          SYMMETRIC is set.
;          The return type is always of double precision.
;
; KEYWORDS:
;  SYMMETRIC: If set, the result is in interval [-pi,pi), not in
;             [0,2pi).
;  
; PROCEDURE:
;  just a call to cyclic_value() and Scl().
;  
; EXAMPLE:
;  print, Rad(-3600)
;  print, Rad(Deg(0.23)) ; better use cyclic_value() for same effect!
;  
; SEE ALSO:
;  Deg(), cyclic_value()
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  2000/08/09 17:23:02  kupper
;        Some useful routines...
;
;

Function Rad, deg, SYMMETRIC=symmetric
   If Keyword_Set(SYMMETRIC) then $
    return, Scl(cyclic_value(deg, [-180, 180]), [-!DPI, !DPI], [-180, 180]) $
   else $
    return, Scl(cyclic_value(deg, [0, 360]), [0, 2*!DPI], [0, 360])
End
