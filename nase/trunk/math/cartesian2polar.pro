;+
; NAME:
;  Cartesian2Polar()
;
; VERSION:
;  $Id$
;
; AIM:
;  convert 2d cartesian to 2d polar coordinates
;
; PURPOSE:
;  The function converts 2d cartesian {x,y} to 2d polar {r,phi}
;  coordinates. Input can be a single coordinate or an array.
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;*result = function Cartesian2Polar (c)
;
; INPUTS:
;  c:: cartesian coordinates.
;      Named structure of form {cartesian2, x:x, y:y},
;      or an array of these structures.
;
; OUTPUTS:
;  result:: polar coordinates.
;           Named structure of form {polar2, r:r, phi:phi},
;           or an array of these structures.
;
; PROCEDURE:
;  most simple math
;
; EXAMPLE:
;* c={cartesian2, 1, 1}
;* help, Cartesian2Polar(c), /struct
;*>
;
; SEE ALSO:
;  <A>Polar2Cartesian</A>
;-



function Cartesian2Polar, c  ; c has format: {cartesian2, x: x, y: y}
   ; result: {polar2, r: r, phi: phi}
   ;         phi is in degrees.

   assert, tag_names(/structure_name, c) eq "CARTESIAN2", "Parameter must be of structure type CARTESIAN2."

   r       = sqrt(c.x*c.x + c.y*c.y)
   phi_rad = atan(c.y, c.x)

   phi = Deg(phi_rad)
  
   result = replicate({polar2}, n_elements(c))
   result.r = r
   result.phi = phi

   return, result
end
