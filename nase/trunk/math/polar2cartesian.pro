;+
; NAME:
;  Polar2Cartesian()
;
; VERSION:
;  $Id$
;
; AIM:
;  convert 2d polar to 2d cartesian coordinates
;
; PURPOSE:
;  The function converts 2d polar {r,phi} to 2d cartesian {x,y} 
;  coordinates. Input can be a single coordinate or an array.
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;*result = function Polar2Cartesian (p)
;
; INPUTS:
;  p:: polar coordinates.
;           Named structure of form {polar2, r:r, phi:phi},
;           or an array of these structures.
;
; OUTPUTS:
;  result:: cartesian coordinates.
;      Named structure of form {cartesian2, x:x, y:y},
;      or an array of these structures.
;
; PROCEDURE:
;  most simple math
;
; EXAMPLE:
;* p={polar2, 1.4142, 45}
;* help, Polar2Cartesian(p), /struct
;*>
;
; SEE ALSO:
;  <A>Cartesian2Polar</A>
;-

function Polar2Cartesian, p  ; p has format:  {polar2, r: r, phi: phi}
   ; phi is in degrees
   ; result: {cartesian2, x: x, y: y}

   assert, tag_names(/structure_name, p) eq "POLAR2", "Parameter must be of structure type POLAR2."

   phi_rad = Rad(p.phi)

   x = p.r * cos(phi_rad)
   y = p.r * sin(phi_rad)
   
   result = replicate({cartesian2}, n_elements(p))
   result.x = x
   result.y = y

   return, result
end
