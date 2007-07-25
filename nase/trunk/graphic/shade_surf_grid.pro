;+
; NAME:
;  Shade_Surf_Grid
;
; VERSION:
;  $Id$
;
; AIM: Adds a grid to SHADE_SURF.
;  
;
; PURPOSE:
;  This routine superimposes a grid (produced by <C>SURFACE</C>)
;  on a surface (produced by <C>SHADE_SURF</C>).
;  This routine is also be used by <A>Surfit</A> when it is called
;  with the <*>/OVERLAYGRID</*> keyword.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*Shade_Surf_Grid, z [,x ,y] [,GRIDCOLOR=...]
;
; INPUTS:
;  z:: see <C>SHADE_SURF</C> or <C>SURFACE</C>.
;  
; OPTIONAL INPUTS:
;  x, y:: see <C>SHADE_SURF</C> or <C>SURFACE</C>.
;  
; INPUT KEYWORDS: 
;  (all keywords that <C>SHADE_SURF</C> or <C>SURFACE</C> take)
;  GRIDCOLOR:: the color of the grid can be adjusted independent
;              from the color of the plot. Defaults to COLOR.
;
; SIDE EFFECTS:
;  Changes the 3d-transformation matrix stored in !P.t3d.
;
; PROCEDURE:
;  call <C>SHADE_SURF</C>, store transformation matrix, call
;  <C>SURFACE</C>. Redirect some keywords.
;
; EXAMPLE:
;*
;*> Shade_Surf_Grid, gauss_2d(10,10)
;*> Surfit, /OVERLAYGRID, gauss_2d(10,10)
;
; SEE ALSO:
; <C>SHADE_SURF</C>, <C>SURFACE</C>, <A>SurfIt</A>
;-

Pro Shade_Surf_Grid, z, x, y, title=title, color=color, $
                     gridcolor=gridcolor, shades=shades, _extra=_e

   default, gridcolor, color

   case n_params() of
      1: shade_surf, z,       xstyle=1, ystyle=1, zstyle=1, title=title, color=color, shades=shades, _extra=_e, /save
      2: shade_surf, z, x,    xstyle=1, ystyle=1, zstyle=1, title=title, color=color, shades=shades, _extra=_e, /save
      3: shade_surf, z, x, y, xstyle=1, ystyle=1, zstyle=1, title=title, color=color, shades=shades, _extra=_e, /save
   endcase

   case n_params() of
      1: surface, z,       xstyle=4, ystyle=4, zstyle=4, color=gridcolor, _extra=_e, /noerase, /t3d
      2: surface, z, x,    xstyle=4, ystyle=4, zstyle=4, color=gridcolor, _extra=_e, /noerase, /t3d
      3: surface, z, x, y, xstyle=4, ystyle=4, zstyle=4, color=gridcolor, _extra=_e, /noerase, /t3d
   endcase
End
