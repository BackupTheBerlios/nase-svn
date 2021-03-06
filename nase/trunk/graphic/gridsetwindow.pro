;+
; NAME:
;  GridSetWindow
;
; VERSION:
;  $Id$
;
; AIM:
;  a more flexible geometry manager than !p.multi 
;
; PURPOSE:
;  part of the grid geometry-manager.
;
; CATEGORY:
;  Graphic
;  NASE
;  Widgets
;  Windows
;
; CALLING SEQUENCE:
;*GridSetWindow, mygridstruct, winnr, CLEAR=clear
;
; INPUTS:
;  mygridstruct:: gridstruct, generated by gridinit
;  winnr:: window to access (0 -- (N-1))
;
; INPUT KEYWORDS:
;  CLEAR:: if set, region is cleared
;
; SIDE EFFECTS:
;  Affects IDL's plotting region. To restore a window's normal
;  behaviour after usage of the grid, reset the plotting region by
;  <*>!P.REGION=0</*>.
;
; RESTRICTIONS:
;  DO NOT SET CLEAR IF YOU ARE PLOTTING TO A POSTSCRIPT DEVICE!
;  the region is cleared by overplotting a rectangle with background
;  color.
;
; PROCEDURE:
;  sets !p.region...
;
; EXAMPLE:
;*mygrid = gridinit(region=[0.,0.,0.6,0.6] $
;*                  ,grid=[5,5] $
;*                  ,wins=[[0,0,3,1],[0,1,3,2],[0,2,3,3],[3,0,4,3]])
;*window,0
;*gridsetwindow,mygrid,0
;*plot,indgen(10), /NOERASE
;*gridsetwindow,mygrid,1
;*...
;
; SEE ALSO:
;  <A>GridInit</A>
;-

pro gridsetwindow, gridstruct, number, CLEAR=clear
if ((n_elements(gridstruct)/4-1) lt  number) then console, /FATAL, "illegal window number!" $
else begin
   regarr = gridstruct(*, number)
   !p.region = regarr
   if set(clear) then begin
      plot,[1],/NODATA,xmargin=[0.,0.],ymargin=[0.,0.],xtickformat="noticks",ytickformat="noticks",xminor=1,xticks=1.,yminor=1,yticks=1, /NOERASE, xstyle=4, ystyle=4
      polyfill,[0.,0.,1.,1.,0.],[0.,1.,1.,0.,0.],color=!p.background
   end
end

end
