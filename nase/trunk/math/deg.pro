;+
; NAME:
;  Deg()
;
; AIM: Change angle from rad to degrees.
;  
; PURPOSE:
;  Deg() takes an angle measured in radians, and returns it's
;  degree equivalent.
;  Output values will always be in the interval [0,360) ([-180,180) if
;  SYMMETRIC is set), input values are unrestricted.  
;  
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  result = Deg(angle [,/SYMMETRIC])
;  
; INPUTS:
;  angle: angle, measured in radians. Interval: (-oo, oo)
;  
; OUTPUTS:
;  result: angle measured in degrees. Interval: [0,360), [-180,180) if
;          SYMMETRIC is set.
;          The return type is always of double precision.
;  
; KEYWORDS:
;  SYMMETRIC: If set, the result is in interval [-180,180), not in
;             [0,360).
;  
; PROCEDURE:
;  just a call to cyclic_value() and Scl().
;  
; EXAMPLE:
;  print, Deg(-4*!DPI)
;  print, Deg(Rad(23)) ; better use cyclic_value() for same effect!
;  
; SEE ALSO:
;  Rad(), cyclic_value()
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

Function Deg, deg, SYMMETRIC=symmetric
   If Keyword_Set(SYMMETRIC) then $
    return, Scl(cyclic_value(deg, [-!DPI, !DPI]), [-180, 180], [-!DPI, !DPI]) $
   else $
    return, Scl(cyclic_value(deg, [0, 2*!DPI]), [0, 360], [0, 2*!DPI])
End
