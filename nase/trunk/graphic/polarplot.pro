;+
; NAME: PolarPlot
;
; PURPOSE: Zeichnen eines Polardiagramms
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: PolarPlot, radiusarray, winkelarray [,sdev]
;                              [,TITLE=title] [,CHARSIZE=charsize]
;                              [,XRANGE=xrange] [,YRANGE=yrange]
;                              [,XSTYLE=xstyle] [,YSTYLE=ystyle]
;                              [,MINORANGLETICKS=minorangleticks]
;                              [,THICK=thick],[CLOSE=CLOSE],
;                              [SDCOLOR=sdcolor],[MCOLOR=mcolor],[DELTA=DELTA],
;                              [ORIGPT=ORIGPT]
;
; INPUTS: radiusarray: Die in diesem Array enthaltenen Werte werden als Abstaende
;                      gemessen vom Ursprung dargestellt.
;         winkelarray: Die zugehoerigen Winkel in Rad.
;
; OPTIONAL INPUTS: 
;                  sdev       : Array, das die Standardabweichung enthaelt 
;                  title: Ein String, der nachher ueber dem Plot steht.
;                  charsize: Groesse der Beschriftung bezogen auf die Normalgroesse
;                            von 1.0.
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
;                  close: Endpunkt wird mit Anfangspunkt verbunden: 
;                         Darstellung als geschlossene Kurve (default: 0)
;                  DELTA: Interpoliert zwischen den Stuetzpunkten (radius,winkel) mit sin(x)/x um 
;                         den Faktor Delta (default: 1). Setzt Keyword CLOSE auf 1 wenn es gesetzt ist,
;                         da eine Interpolation nur fuer geschlossene  Kurven sinnvoll ist.  
;                  MCOLOR  : Farbindex fuer den Mittelwert         (Default: weiss)
;                  SDCOLOR : Farbindex fuer die Standardabweichung (Default: dunkelblau) 
;                  ORIGPT:   Original Stuetzstellen werden als Kreise
;                            mit dem Radius ORIGPT  eingezeichnet
;                            (default: 0) 
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
;        Revision 2.15  2000/07/05 16:20:20  gabriel
;             BUGFIX Origpt
;
;        Revision 2.14  2000/07/05 13:36:36  gabriel
;             Keyword ORIGPT new
;
;        Revision 2.13  2000/07/05 10:19:14  saam
;              little bug in doc header
;
;        Revision 2.12  2000/06/23 10:22:12  gabriel
;             !P.MULTI bug fixed
;
;        Revision 2.11  2000/06/08 10:11:34  gabriel
;               BGCOLOR BUG fixed
;
;        Revision 2.10  2000/05/23 08:21:36  gabriel
;             COLOR problem fixed
;
;        Revision 2.9  2000/03/01 16:20:30  gabriel
;                 there was a cut and paste bug
;
;        Revision 2.8  2000/02/24 15:51:49  gabriel
;                ------
;
;        Revision 2.7  2000/02/24 15:49:22  gabriel
;              Bugfix: Axis weren't printed properly
;
;        Revision 2.6  1999/04/29 09:17:26  gabriel
;             Interpolation der Winkel war falsch
;
;        Revision 2.5  1999/04/28 17:10:41  gabriel
;             Keyword DELTA neu
;
;        Revision 2.4  1999/02/12 14:48:50  gabriel
;             Keyword CLOSE und Input SDEV neu
;
;        Revision 2.3  1998/02/18 14:07:55  thiel
;               CHARSIZE-Keyword hinzugefuegt.
;
;        Revision 2.2  1998/01/22 14:11:02  thiel
;               Jetzt mit variabler Liniendicke, Keyword THICK.
;
;        Revision 2.1  1998/01/22 13:46:52  thiel
;               Die erste Version ist fertig.
;
;-


PRO PolarPlot, radiusarray, winkelarray,sdev,SDCOLOR=sdcolor,MCOLOR=mcolor,DELTA=DELTA,$
               TITLE=title, $
               CHARSIZE=charsize, $
               XRANGE=xrange, YRANGE=yrange, $
               XSTYLE=xstyle, YSTYLE=ystyle, $
               MINORANGLETICKS=minorangleticks, $
               THICK=thick , CLOSE=CLOSE,radiusinterpol=radiusinterpol,$
               winkelinterpol=winkelinterpol, ORIGPT=ORIGPT,_EXTRA=e


   On_Error, 2
_radiusarray = radiusarray
_winkelarray = winkelarray

IF set(SDEV) THEN _sdev = sdev
BGCOLOR = GetBgColor()
BGCOLOR = RGB(BGCOLOR(0), BGCOLOR(1), BGCOLOR(2),/NOALLOC)
Default, MCOLOR , !P.COLOR
Default, SDCOLOR, RGB(150,150,200,/NOALLOC)
IF set(DELTA) THEN DEFAULT,CLOSE ,1

DEFAULT,CLOSE ,0
Default, xstyle, 4
Default, ystyle, 4
Default, xrange, [-Max(_RadiusArray),Max(_RadiusArray)]
Default, yrange, [-Max(_RadiusArray),Max(_RadiusArray)]
Default, title, ''
Default, charsize, 1.0
Default, thick, 3.0
default,delta,1
default, origpt, 0


IF DELTA GT 1 THEN BEGIN
   index = 0
   WHILE N_ELEMENTS(_radiusarray) LT 30 DO BEGIN 
      index = N_ELEMENTS(_radiusarray) + index
      _radiusarray = [_radiusarray,_radiusarray,_radiusarray]
      IF set(_SDEV) THEN  _sdev=[_sdev,_sdev,_sdev]
   ENDWHILE

   IF set(_SDEV) THEN   _sdev =   Sincerpolate(_sdev ,delta)

   _radiusarray = Sincerpolate(_radiusarray,delta)
   _radiusarray = _radiusarray(index*delta : (index+ N_ELEMENTS(radiusarray))*delta-1+close)

   IF set(_SDEV) THEN BEGIN 
      _sdev = _sdev(index*delta : (index+ N_ELEMENTS(radiusarray))*delta-1+close)
      ;_sdev = _sdev - _radiusarray
   ENDIF

   _winkelarray = (signum(last(_winkelarray))*(abs(last(_winkelarray))+close*abs(_winkelarray(1)-_winkelarray(0)))-_winkelarray(0))*findgen(delta*(N_ELEMENTS(_winkelarray))+close)/FLOAT(N_ELEMENTS(_winkelarray)*DELTA+close-1)+_winkelarray(0)
;print, _winkelarray
END ELSE BEGIN

   IF CLOSE EQ 1 THEN BEGIN
      _radiusarray = [_radiusarray,_radiusarray(0)]
      _winkelarray = [_winkelarray,last(_winkelarray)+_winkelarray(1)-_winkelarray(0)]
      IF set(SDEV) THEN _sdev = [_sdev,_sdev(0)]
   ENDIF

ENDELSE



plot,_radiusarray , _winkelarray,/POLAR, /NODATA, $
 XSTYLE=xstyle, YSTYLE=ystyle, $
 XRANGE=xrange, YRANGE=yrange, $
 TITLE=title,COLOR=BGCOLOR,_EXTRA=e

PTMP = !P.MULTI
!P.MULTI(0) = 1

plotregion_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
plotregion_norm_center = [0.5,0.5]
plotregion_device = convert_coord(plotregion_norm,/NORM,/TO_DEVICE)
plotregion_device_center = convert_coord(plotregion_norm_center,/NORM,/TO_DEVICE)



plotregion_device = plotregion_device(0:1,*)

plotregion_device_center(0) = plotregion_device_center(0)


xsize_device = plotregion_device(0,1)-plotregion_device(0,0)
ysize_device = plotregion_device(1,1)-plotregion_device(1,0)
org_plotregion_device = [ plotregion_device(0,0) + xsize_device/2.,$
                          plotregion_device(1,0) + ysize_device/2. ]
shift_plotregion_device = org_plotregion_device-plotregion_device_center

if !P.MULTI(1) eq 0 OR !P.MULTI(2) eq 0 then begin 
   shift_plotregion_device(1) = 0.0
end else begin
   shift_plotregion_device(*) = 0.0
endelse

xy_dim = [xsize_device,ysize_device]
corr_fac = min(xy_dim,min_size_ind)/ FLOAT( max(xy_dim,max_size_ind))
corr_fac = [corr_fac,corr_fac]
corr_fac(min_size_ind) = 1.0
plotregion_device_new = [[plotregion_device(*,0)]-shift_plotregion_device,$
                         [plotregion_device(*,0)+xy_dim*corr_fac]-shift_plotregion_device]


plot,_radiusarray , _winkelarray,/POLAR, $
 XSTYLE=xstyle, YSTYLE=ystyle, $
 XRANGE=xrange, YRANGE=yrange, $
 TITLE=title ,POSITION=plotregion_device_new,/DEVICE,_EXTRA=e


IF set(_SDEV) THEN BEGIN
   x1 = (_radiusarray(*)-_sdev(*))*cos(_winkelarray(*))
   m1 = (_radiusarray(*)-_sdev(*))*sin(_winkelarray(*))
   x2 = (_radiusarray(*)+_sdev(*))*cos(_winkelarray(*))
   m2 = (_radiusarray(*)+_sdev(*))*sin(_winkelarray(*))
   polyfill, [x1,last(x1),REVERSE(x2),x2(0)], [m1,last(m1), REVERSE(m2),m2(0)], COLOR=sdcolor
   
ENDIF

oplot, _radiusarray, _winkelarray, /polar, THICK=thick,COLOR=mcolor
if ORIGPT GT 0 then begin
 
 
   r = ORIGPT
   PHI=findgen(40+1)*2*!PI/40. 
   y=r*sin(PHI) & x=r*cos(PHI) 
   usersym,x,y,/fill

   oplot,radiusarray, winkelarray,/polar,PSYM=8

endif
Axis, 0,0, xax=0, /data, XTICKFORMAT=('AbsoluteTicks'), $
    XRANGE=xrange, XTICK_GET=TickArray, CHARSIZE=charsize
Axis, 0,0, yax=0, /data, YTICKFORMAT=('AbsoluteTicks'), $
  YRANGE=yrange, CHARSIZE=charsize

Arcs, TickArray, LINESTYLE=1




IF (Set(minorangleticks)) THEN BEGIN
 IF minorangleticks NE 0 THEN BEGIN
    rayarray = 90.0/(minorangleticks+1)*(1.0+findgen(4*(minorangleticks+1)))
    Radii, 0.0, max(tickarray), rayarray, LINESTYLE=1, /DATA
 ENDIF
ENDIF 
!P.MULTI = PTMP

radiusinterpol = _radiusarray
winkelinterpol = _winkelarray
END 
