;+
; NAME: PolarPlot
;
; PURPOSE: Zeichnen eines Polardiagramms
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: PolarPlot, radiusarray, winkelarray
;                              [,TITLE=title] 
;                              [,XRANGE=xrange] [,YRANGE=yrange]
;                              [,XSTYLE=xstyle] [,YSTYLE=ystyle]
;                              [,MINORANGLETICKS=minorangleticks]
;                              [,THICK=thick]
;
; INPUTS: radiusarray: Die in diesem Array enthaltenen Werte werden als Abstaende
;                      gemessen vom Ursprung dargestellt.
;         winkelarray: Die zugehoerigen Winkel in Rad.
;
; OPTIONAL INPUTS: title: Ein String, der nachher ueber dem Plot steht.
;                  xrange, yrange: Plotbereiche.
;                                  Default: [-Max(radiusarray),+Max(radiusarray)]
;                  xstyle, ystyle: Beeinflusst die Darstellung der Achsen.
;                                  Default: 4, d.h. kein Kasten um den Plot herum.
;                                  Falls exakte Achsenbereiche gewuenscht werden, 
;                                  sollte xystyle=5 gewaehlt werden.
;                  minorangleticks: Zusaetzlich zu den Achsen koennen 
;                                   Zwischenwinkel eingezeichnet werden.
;                                   minorangleticks=n malt in jedem Quadranten
;                                   n Zwischenwinkelmarkierungen, z.B. liefert
;                                   n=1 Markierungen bei 45, 135, 225 und 315 Grad. 
;                  thick: Die Liniendicke, Normal: 1.0, Default: 3.0
;
; OUTPUTS: Polardarstellung der Daten auf dem aktuellen Plot-Device.
;
; PROCEDURE: 1. Plot mit /Polar-Schluesselwort ohne Achsen.
;            2. Achsen malen.
;            3. So viele Kreise wie Tickmarks malen. (Benutzt importierte ARCS-Prozedur.)
;            4. Auf Wunsch Zwischenwinkel malen. (Benutzt importierte RADII-Prozedur.)  
;
; EXAMPLE: radius = findgen(33)
;          winkel = findgen(33)*2.0*!PI/32.0
;          PolarPlot, radius, winkel, MINORANGLETICKS=4, TITLE='Spiralplot'
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  1998/01/22 14:11:02  thiel
;               Jetzt mit variabler Liniendicke, Keyword THICK.
;
;        Revision 2.1  1998/01/22 13:46:52  thiel
;               Die erste Version ist fertig.
;
;-


PRO PolarPlot, radiusarray, winkelarray, $
               TITLE=title, $
               XRANGE=xrange, YRANGE=yrange, $
               XSTYLE=xstyle, YSTYLE=ystyle, $
               MINORANGLETICKS=minorangleticks, $
               THICK=thick

Default, xstyle, 4
Default, ystyle, 4

Default, xrange, [-Max(RadiusArray),Max(RadiusArray)]
Default, yrange, [-Max(RadiusArray),Max(RadiusArray)]

Default, title, ''

Default, thick, 3.0

Plot, radiusarray, winkelarray, /polar, THICK=thick, $
 XSTYLE=xstyle, YSTYLE=ystyle, $
 XRANGE=xrange, YRANGE=yrange, $
 TITLE=title
Axis, 0,0, xax=0, /data, XTICKFORMAT=('AbsoluteTicks'), $
 XSTYLE=xstyle, XRANGE=xrange, XTICK_GET=TickArray
Axis, 0,0,0, yax=0, /data, YTICKFORMAT=('AbsoluteTicks'), $
 YSTYLE=ystyle, YRANGE=yrange

Arcs, TickArray, LINESTYLE=1

IF (Set(minorangleticks) AND minorangleticks NE 0) THEN BEGIN
   rayarray = 90.0/(minorangleticks+1)*(1.0+findgen(4*(minorangleticks+1)))
   Radii, 0.0, max(tickarray), rayarray, LINESTYLE=1, /DATA
ENDIF 


END 
