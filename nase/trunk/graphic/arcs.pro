;+
; NAME:
;  Arcs
;
; VERSION:
;  $Id$
;
; AIM:
;  plots specified arcs or circles on the current plot device
;
; PURPOSE:
;  Plots specified arcs or circles on the current plot device.
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*  arcs, r [,a1] [,a2] [,x0] [,y0] 
;*        [/DEVICE | /DATA | /NORM] [COLOR=...] [LINESTYLE=...]
;
; INPUTS:
;   r      :: radii of arcs to draw (data units).
;
; OPTIONAL INPUTS:
;   a1     :: start angle of arc (deg counter clockwise from X axis, def=0)
;   a2     :: end angle of arc (deg counter clockwise from X axis, def=360)
;   x0,y0  :: optional arc center (default is 0,0)
;
; INPUT KEYWORDS:
;   DEVICE    :: use device coordinates
;   DATA      :: use data coordinates (default)
;   NORM      :: use normalized coordinates
;   COLOR     :: plot color (scalar or array)
;   LINESTYLE :: linestyle (scalar or array)
;
; EXAMPLE:
;* plot, indgen(20)-10,indgen(20)-10
;* arcs, [2,3,4], 45, 135
;
;-

;;; look in ../doc/header.pro for explanations and syntax,
;;; or view the NASE Standards Document
;-------------------------------------------------------------
;+
; NAME:
;       ARCS
; PURPOSE:
;       Plot specified arcs or circles on the current plot device.
; CATEGORY:
; CALLING SEQUENCE:
;       arcs, r, a1, a2, [x0, y0]
; INPUTS:
;       r = radii of arcs to draw (data units).                  in
;       [a1] = Start angle of arc (deg CCW from X axis, def=0).  in
;       [a2] = End angle of arc (deg CCW from X axis, def=360).  in
;       [x0, y0] = optional arc center (def=0,0).                in
; KEYWORD PARAMETERS:
;       Keywords:
;         /DEVICE means use device coordinates .
;         /DATA means use data coordinates (default).
;         /NORM means use normalized coordinates.
;         COLOR=c  plot color (scalar or array).
;         LINESTYLE=l  linestyle (scalar or array).
; OUTPUTS:
; COMMON BLOCKS:
; NOTES:
;       Note: all parameters may be scalars or arrays.
; MODIFICATION HISTORY:
;       Written by R. Sterner, 12 July, 1988.
;       Johns Hopkins University Applied Physics Laboratory.
;       RES 15 Sep, 1989 --- converted to SUN.
;       R. Sterner, 17 Jun, 1992 --- added coordinate systems, cleaned up.
;
; Copyright (C) 1988, Johns Hopkins University/Applied Physics Laboratory
; This software may be used, copied, or redistributed as long as it is not
; sold and this copyright notice is reproduced on each copy made.  This
; routine is provided as is without any express or implied warranties
; whatsoever.  Other limitations apply as described in the file disclaimer.txt.
;-
;-------------------------------------------------------------
 

; NAME:
;       MAKEX
; PURPOSE:
;       Make an array with specified start, end and step values.
; CALLING SEQUENCE:
;       x = makex(first, last, step)
; INPUTS:
;       first, last = array start and end values.     
;       step = step size between values.              
; OUTPUTS:
;       x = resulting array.                          
FUNCTION makex,xlo,xhi,xst
  RETURN, xlo+xst*findgen(1+ long( (xhi-xlo)/xst) )
END


; NAME:
;       POLREC
; PURPOSE:
;       Convert 2-d polar coordinates to rectangular coordinates.
; CATEGORY:
; CALLING SEQUENCE:
;       polrec, r, a, x, y
; INPUTS:
;       r, a = vector in polar form: radius, angle (radians).
; KEYWORD PARAMETERS:
;       Keywords:
;         /DEGREES means angle is in degrees, else radians.
; OUTPUTS:
;       x, y = vector in rectangular form.                     
 
PRO POLREC, R, A, X, Y, degrees=degrees
 
   cf = 1.
   if keyword_set(degrees) then cf = !radeg
   
   X = R*COS(A/cf)
   Y = R*SIN(A/cf)	
   RETURN
END




PRO arcs, r, a1, a2, xx, yy,$
          color=clr, linestyle=lstyl, $
          device=device, data=data, norm=norm

  np = n_params(0)

  ;------  Determine coordinate system  -----
  if n_elements(device) eq 0 then device = 0 ; Define flags.
  if n_elements(data)   eq 0 then data   = 0
  if n_elements(norm)   eq 0 then norm   = 0
  if device+data+norm eq 0 then data = 1 ; Default to data.
  
  
  if n_elements(clr) eq 0 then clr = !p.color
  if n_elements(lstyl) eq 0 then lstyl = !p.linestyle
  
  if np lt 2 then a1 = 0.
  if np lt 3 then a2 = 360.
  if np lt 4 then xx = 0.
  if np lt 5 then yy = 0.
  
  nr = n_elements(r)-1		; Array sizes.
  na1 = n_elements(a1)-1
  na2 = n_elements(a2)-1
  nxx = n_elements(xx)-1
  nyy = n_elements(yy)-1
  nclr = n_elements(clr)-1
  nlstyl = n_elements(lstyl)-1
  n = nr>na1>na2>nxx>nyy        ; Overall max.
  
  for i = 0, n do begin   	; loop thru arcs.
      ri  = r(i<nr)             ; Get r, a1, a2.
      a1i = a1(i<na1)
      a2i = a2(i<na2)
      xxi = xx(i<nxx)
      yyi = yy(i<nyy)
      clri = clr(i<nclr)
      lstyli = lstyl(i<nlstyl)
      a = makex(a1i, a2i, 0.25*signum(a2i-a1i))/!radeg
      polrec, ri, a, x, y
      plots, x + xxi, y + yyi, color=clri, linestyle=lstyli, $
        data=data, device=device, norm=norm
  endfor
  
end
