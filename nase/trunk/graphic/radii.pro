;+
; NAME:
;  Radii
;
; VERSION:
;  $Id$
;
; AIM:
;  plots specified radii
;
; PURPOSE:
;  Plot specified radii emerging from a specified point in the 
;  coordinate system.
;  This routine was originally written by R. Sterner,
;  Johns Hopkins University Applied Physics Laboratory.
;
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* Radii, r1, r2, a [,x0] [,yy] [,COLOR=...] [,LINESTYLE=...]
;         [,/{DEVICE|DATA|NORM}]
;
; INPUTS:
;  r1 :: start radius of radius to draw (data units)
;  r2 :: end radius of radius to draw (data units)
;  a  :: angle of arc (deg CCW from X axis)
;
; OPTIONAL INPUTS:
;  x0,y0 :: optional arc center (default: 0,0)
;
; INPUT KEYWORDS:
;  DEVICE::    means use device coordinates .
;  DATA::      means use data coordinates (default).
;  NORM::      means use normalized coordinates.
;  COLOR::     plot color (scalar or array)
;  LINESTYLE:: linestyle (scalar or array)
;
;-

	pro radii, r1, r2, a, xx, yy,$
	  color=clr, linestyle=lstyl, $
          device=device, data=data, norm=norm
 
 
 	np = n_params(0)
 
        ;------  Determine coordinate system  -----
        if n_elements(device) eq 0 then device = 0    ; Define flags.
        if n_elements(data)   eq 0 then data   = 0
        if n_elements(norm)   eq 0 then norm   = 0
        if device+data+norm eq 0 then data = 1        ; Default to data.
 
	if n_elements(clr) eq 0 then clr = !p.color
	if n_elements(lstyl) eq 0 then lstyl = !p.linestyle
 
	if np lt 4 then xx = 0.
	if np lt 5 then yy = 0.
 
	nr1 = n_elements(r1)-1		; Array sizes.
	nr2 = n_elements(r2)-1
	na  = n_elements(a)-1
	nxx = n_elements(xx)-1
	nyy = n_elements(yy)-1
        nclr = n_elements(clr)-1
        nlstyl = n_elements(lstyl)-1
	n = nr1>nr2>na>nxx>nyy		; Overall max.
 
	for i = 0, n do begin   	; loop thru arcs.
	  r1i  = r1(i<nr1)		; Get R1, R2, A.
	  r2i  = r2(i<nr2)
	  ai = a(i<na)
	  xxi = xx(i<nxx)
	  yyi = yy(i<nyy)
          clri = clr(i<nclr)
          lstyli = lstyl(i<nlstyl)
	  polrec, [r1i, r2i], [ai, ai]/!radeg, x, y
	  plots, x + xxi, y + yyi, color=clri, linestyle=lstyli, $
            data=data, device=device, norm=norm
	endfor
 
	return
 
	end
