;+
; NAME:
;  Elliptic_r()
;
; AIM: In an ellipse, return radius as function of angle: r(phi).
;  
; PURPOSE:
;  Elliptic_r() implements the parametric representation of an
;  ellipse in cylindric corrdinates. Given the length of the main axes
;  and an angle phi, it returns the radius r(phi), measured from the
;  center (crossing of main axes).
;  
; CATEGORY:
;  MATH
;  
; CALLING SEQUENCE:
;  r = elliptic_r( a, b, phi )
;  
; INPUTS: 
;  a, b: Length of the ellpse's main axes.
;  phi: angle in the cyclindric coordinate system. Phi must be
;       specified in degrees (use Deg() to convert from radians), and
;       is measured in mathematical sense, i.e., anticlockwise from
;       the positive part of the a axis.
;  
; OUTPUTS:
;  The radius r(phi).
;  
; RESTRICTIONS: 
;  Please note that some IDL procedures measure angles clockwise, not
;  conforming to the usual mathematic conventions (i.e. ROT()).
;  
; PROCEDURE:
;  Straightforward from the mathematicsl definition of an elllipse.
;  
; EXAMPLE:
;  angle = Scl(Indgen(1000),[0,360])
;  PolarPlot, elliptic_r(4, 2, angle), Rad(angle)
;  
; SEE ALSO:
;  Deg(), PolarPlot
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

Function Elliptic_R, a, b, phi
   p = Rad(phi)
   return, sqrt( a^2*b^2 / ((a*sin(p))^2+(b*cos(p))^2) )
End
