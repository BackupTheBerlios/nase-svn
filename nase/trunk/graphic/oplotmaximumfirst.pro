;+
; NAME: OPlotMaximumFirst
;
; PURPOSE: Darstellung mehrerer Plots im gleichen Koordinatensystem,
;          die y-Achse wird dabei so gewählt, daß der größte und der 
;          kleinste darzustellende Wert auch wirklich zu sehen sind.
;
; CATEGORY: GRAPHICS
;
; CALLING SEQUENCE: OPlotMaximumFirst, [xarray,] yarray, _EXTRA=_extra
;
; INPUTS: yarray: Sollen n Arrays mit jeweils x Einträgen übereinander 
;                  geplottet werden, so muß yarray ein Array der 
;                  Dimension (x,n) sein.
;                  Das erste der n Arrays wird dann mit LINESTYLE=0 geplottet,
;                  die übrigen mit jeweils ansteigendem LINESTYLE-Wert. Über
;                  die Reihenfolge der n Unterarrays im yarray kann also
;                  deren LINESTYLE festgelegt werden.
;
; OPTIONAL INPUTS: xarray: Die zu den y-Werten gehörenden x-Werte, das
;                           Ergebnis entspricht der normalen IDL-Plot-
;                           Ausgabe.
;                  _EXTRA=_extra: Alle übrigen Schlüsselworte werden an
;                                  die Plot-Prozedur weitergereicht.
;
; OUTPUTS: Ein zweidimensionaler Plot der übergebenen Arrays im selben
;           Koordinatensystem.
;
; PROCEDURE: 1. Ermittlung des Maximums und Minimums im übergebenen Array.
;            2. Plot, /NODATA eines Arrays, das Minimum und Maximum
;                enhält und so die Wahl der y-Achse bestimmt.
;            3. OPlot aller übrigen Arrays.
;
; EXAMPLE: a = randomn(seed,50)
;          b = randomn(seed,50)
;          oplotmaximumfirst, [[a],[b]]
;
; SEE ALSO: IDL-Prozeduren PLOT und OPLOT
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/04/29 09:49:48  thiel
;            Jetzt wird auch das Minimum beachtet.
;
;        Revision 1.1  1999/04/28 12:52:37  thiel
;            Neu!
;
;-

PRO OPlotMaximumFirst, z, zz, _EXTRA=_extra

   maxlinestyle = 6

   IF N_Params() LT 1 THEN Message, 'wrong number of arguments'
   n = (Size(z))(1)
   IF N_Params() EQ 2 THEN BEGIN
      x = z
      y = zz
   END ELSE BEGIN
      x = LindGen(n)
      y = z
   END
 
   plotnr = (Size(y))(2)

   maxvalue = Max(IMax(y,1), index)
   minvalue = Min(IMin(y,1), index)

   nodata = y
   IF maxvalue EQ minvalue THEN nodata(0) = maxvalue $
    ELSE nodata(0:1) = [minvalue,maxvalue]

   Plot, x, nodata, /NODATA, _EXTRA=_extra

   FOR n=0,plotnr-1 DO $
    Oplot, x, y(*,n), LINESTYLE=(n MOD maxlinestyle) 

END



   

   
