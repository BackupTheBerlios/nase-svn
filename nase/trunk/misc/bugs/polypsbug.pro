;+
; NAME:
;  PolyPSBug
;
; VERSION:
;  $Id$
;
; AIM:
;  Show size explosion of IDL's <C>Polyfill</C> PS-Output.
;
; PURPOSE:
;  Show size explosion of IDL's <C>Polyfill</C> PS-Output.
;
; CATEGORY:
;  Demonstration
;  Graphic
;
; CALLING SEQUENCE:
;*  PolyPSBug
;
; OUTPUTS:
;  Four encapsulated postcript files of different size.  
;
; PROCEDURE:
;  Define polygons and plots with small and large number of vertices
;  and plot them into PS-Sheets.
;
; SEE ALSO:
;  <C>PolyFill</C>
;-

PRO PolyPSBug

sh1 = DefineSheet(/PS, FILE='polytest_oplotshort', /ENCAPS)
sh2 = DefineSheet(/PS, FILE='polytest_polyshort', /ENCAPS)
sh3 = DefineSheet(/PS, FILE='polytest_oplotlarge', /ENCAPS)
sh4 = DefineSheet(/PS, FILE='polytest_polylarge', /ENCAPS)

n = 250
x1 = FIndgen(n)/2./n+0.25
y1 = 0.05*RandomN(23, n)+0.25
y2 = 0.05*RandomN(24, n)+0.75

opensheet, sh1
Plot, indgen(2), /NODATA
OPlot, x1, y1, COL=RGB('red')
OPlot, Reverse(x1), Reverse(y2), COL=RGB('red')
closesheet,sh1

opensheet, sh2
Plot, indgen(2), /NODATA
PolyFill, [x1, Reverse(x1), x1[0]], [y1, y2, y1[0]], COL=RGB('red')
closesheet,sh2



n = 8000
x1 = FIndgen(n)/2./n+0.25
y1 = 0.05*RandomN(23, n)+0.25
y2 = 0.05*RandomN(24, n)+0.75

opensheet, sh3
Plot, indgen(2), /NODATA
OPlot, x1, y1, COL=RGB('red')
OPlot, Reverse(x1), Reverse(y2), COL=RGB('red')
closesheet,sh3

opensheet, sh4
Plot, indgen(2), /NODATA
PolyFill, [x1, Reverse(x1), x1[0]], [y1, y2, y1[0]], COL=RGB('red')
closesheet,sh4



END
