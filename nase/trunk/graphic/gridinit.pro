;+
; NAME:
;  GridInit()
;
; VERSION:
;  $Id$
;
; AIM:
;  a more flexible geometry manager than !p.multi
;
; PURPOSE:
;  is inted to be a more flexible geometry manager than !p.multi
;  a defined region (given in normal coordinates) is seen as a grid
;  with gx,gy cells in each direction. in units of these grid cells
;  one may specifiy plotting regions...
;
;
;*  ------------------------------------------------------ Window
;*  -                                                    -
;*  -                                                    -
;*  -                                                    -
;*  -                                                    -
;*  ------------------------------------  Region         -
;*  - Win2                   -         -  is (4x3 Grid)  -
;*  -                        -  Win3   -                 -
;*  --------------------------         -                 -
;*  - Win1                   -         -                 -
;*  -                        -         -                 -
;*  ------------------------------------                 -
;*  - Win0                             -                 -
;*  -                                  -                 -
;*  ------------------------------------------------------
;*
;*  Region = [0.0,0.0,0.6,0.6]
;*  Grid = [4,3]
;*  Win0 = [0,0,4,1]
;*  Win1 = [0,1,3,2]
;*  Win2 = [0,2,3,3]
;*  Win3 = [3,1,4,3]
;
;  
;
; CATEGORY:
;  Algebra
;  Graphic
;  NASE
;  Widgets
;  Windows
;
; CALLING SEQUENCE:
;*mygrid = GridInit(REGION=region, GRID=grid, WINS=wins)
;
; INPUTS:
; 
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  REGION:: specifying plotting region (Default [0.,0.,1.,1.])
;  GRID:: 2dim array, specifying grid dimensions
;  WINS:: Array, specifying all window positions (see above)
;
; OUTPUTS:
;  mygrid:: grid structure. can be applied to gridsetwindow
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  to cause IDL not to clear one window, when plotting on another, you
;  have to apply to all plotting-procedures the /NOERASE keyword
;
; PROCEDURE:
;  wrapper for !p.region
;
; EXAMPLE:
;*mygrid = gridinit(region=[0.,0.,0.6,0.6],grid=[5,5],wins=[[0,0,3,1],[0,1,3,2],[0,2,3,3],[3,0,4,3]])
;*window,0
;*gridsetwindow,mygrid,0
;*plot, indgen(10),/NOERASE
;*gridsetwindow,mygrid,2
;*plot,indgen(20),/NOERASE
;*gridsetwindow,mygrid,0,/CLEAR
;*plot,indgen(20),/NOERASE
;
; SEE ALSO:
;  <A>gridsetwindow</A>
;-


function gridinit, REGION=_region, GRID=_grid, WINS=wins

default, _region, [0., 0., 0.6, 0.6]

if not set(_grid) then console, /FATAL, "Please specify grid dimensions!"
if not set(wins) then console, /FATAL, "There's no sense in defining a grid without inner windows!"

;
; returned structure is an array, containing the
; absolute window locations...
; 

xregmax = _region(2)-_region(0)
yregmax = _region(3)-_region(1)
xregoff = _region(0)
yregoff = _region(1)
xgrid = _grid(0)
ygrid = _grid(1)
newwins = wins*0.
for i=0, (n_elements(wins)-1)/2 do begin
   newwins(i*2) = xregoff+xregmax*wins(i*2)/xgrid
   newwins(i*2+1) = yregoff+yregmax*wins(i*2+1)/ygrid
endfor 

return, newwins
end
