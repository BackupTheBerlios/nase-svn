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
;  Johns Hopkins University Applied Physics Laboratory. A lot of
;  improvements have been added since.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*  arcs, r [,a1] [,a2] [,x0] [,y0]
;*        [,/FILL] [,N_EDGES=...]
;*        [,/DEVICE | ,/DATA | ,/NORM] [,COLOR=...] [,LINESTYLE=...] [,THICK=...]
;
; INPUTS:
;   r      :: radii of arcs to draw (data units). This can be an array
;             or a scalar. If an array is given, several arcs are drawn.
;
; OPTIONAL INPUTS:
;   a1     :: start angle(s) of arc(s) (deg counter clockwise from X axis, def=0)
;   a2     :: end angle(s) of arc(s) (deg counter clockwise from X axis, def=360)
;   x0,y0  :: optional arc center(s) (default is 0,0)
;
; INPUT KEYWORDS:
;   DEVICE    :: use device coordinates
;   DATA      :: use data coordinates (default)
;   NORM      :: use normalized coordinates
;   COLOR     :: plot color (scalar or array)
;   LINESTYLE :: linestyle (scalar or array)
;   THICK     :: line thickness (scalar or array)
;   FILL      :: a filled polygon will be drawn. The center point of
;                the polygon will be added in this case, so that the
;                overall shape is a sector.
;   N_EDGES   :: the polygon will be an N-angle. This refers to the
;                complete 360 degrees, so the actual numer of edges
;                you will see depends on a1 and a2. This keyword
;                defaults to 1440, meaning steps of 0.25°, which will
;                in all usual cases look like a perfect circle. Please
;                note, that for smaller numbers of N_EDGES, the final
;                point drawn may not correspond perfectly with a2,
;                i.e., only full edges will be drawn, so that the
;                final angle may not be reached. (This could of course
;                be implemented, go ahead!).
;
; RESTRICTIONS:: Please note, that for smaller numbers of N_EDGES, the
;                final point drawn may not correspond perfectly with
;                a2, i.e., only full edges will be drawn, so that the
;                final angle may not be reached. (This could of course
;                be implemented, go ahead!).
;
; EXAMPLE:
;* plot, indgen(20)-10,indgen(20)-10
;* arcs, [2,3,4], 45, 135
;
;-

 

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
          color=clr, linestyle=lstyl, thick=thick, $
          device=device, data=data, norm=norm, $
          fill=fill, n_edges=n_edges

  np = n_params(0)
  default, n_edges, 1440;; defaults to sectors of 0.25 degrees
  
  ;------  Determine coordinate system  -----
  if n_elements(device) eq 0 then device = 0 ; Define flags.
  if n_elements(data)   eq 0 then data   = 0
  if n_elements(norm)   eq 0 then norm   = 0
  if device+data+norm eq 0 then data = 1 ; Default to data.
  
  if n_elements(clr) eq 0 then clr = !p.color
  if n_elements(lstyl) eq 0 then lstyl = !p.linestyle
  if n_elements(thick) eq 0 then thick = !p.thick
  
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
  nthick = n_elements(thick)-1
  n = nr>na1>na2>nxx>nyy        ; Overall max.
  
  for i = 0, n do begin   	; loop thru arcs.
      ri  = r(i<nr)             ; Get r, a1, a2.
      a1i = a1(i<na1)
      a2i = a2(i<na2)
      xxi = xx(i<nxx)
      yyi = yy(i<nyy)
      clri = clr(i<nclr)
      lstyli = lstyl(i<nlstyl)
      thicki = thick(i<nthick)
      a = makex(a1i, a2i, 360.0/n_edges*signum(a2i-a1i))/!radeg
      polrec, ri, a, x, y
      if keyword_set(fill) then begin
         polyfill, [0, x] + xxi, [0, y] + yyi, color=clri, linestyle=lstyli, thick=thicki, $
                   data=data, device=device, norm=norm
      endif else begin
         plots, x + xxi, y + yyi, color=clri, linestyle=lstyli, thick=thicki, $
                data=data, device=device, norm=norm
      endelse
  endfor
  
end
