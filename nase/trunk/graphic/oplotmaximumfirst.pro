;+
; NAME: OPlotMaximumFirst
;
; PURPOSE: Darstellung mehrerer Plots im gleichen Koordinatensystem,
;          die y-Achse wird dabei so gew�hlt, da� der gr��te darzustellende
;          Wert auch wirklich zu sehen ist.
;
; CATEGORY: GRAPHICS
;
; CALLING SEQUENCE: OPlotMaximumFirst, [xarray,] yarray, _EXTRA=_extra
;
; INPUTS: yarray: Sollen n Arrays mit jeweils x Eintr�gen �bereinander 
;                  geplottet werden, so mu� yarray ein Array der Dimension
;                  (x,n) sein.
;                  Das erste der n Arrays wird dann mit LINESTYLE=0 geplottet,
;                  die �brigen mit jeweils ansteigendem LINESTYLE-Wert. �ber
;                  die Reihenfolge der n Unterarrays im yarray kann also
;                  deren LINESTYLE festgelegt werden.
;
; OPTIONAL INPUTS: xarray: Die zu den y-Werten geh�renden x-Werte, das
;                           Ergebnis entspriocht der normalen IDL-Plot-
;                           Ausgabe.
;                  _EXTRA=_extra: Alle �brigen Schl�sselworte werden an
;                                  die Plot-Prozedur weitergereicht.
;
; OUTPUTS: Ein zweidimensionaler Plot der �bergebenen Arrays im selben
;           Koordinatensystem.
;
; PROCEDURE: 1. Ermittlung des Maximums im �bergebenen Array.
;            2. Plot des Unterarrays, das das Maximum enth�lt.
;            3. OPlot aller �brigen Unterarrays
;
; EXAMPLE: a = randomn(50,50) > 0
;          b = randomu(50,50) > 0
;          oplotmaximumfirst, [[a],[b]]
;
; SEE ALSO: IDL-Prozeduren PLOT und OPLOT
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/04/28 12:52:37  thiel
;            Neu!
;
;-

PRO OPlotMaximumFirst, z, zz, _EXTRA=_extra

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

   Plot, x, y(*,index), LINESTYLE=index, _EXTRA=_extra

   FOR n=1,plotnr-1 DO $
    Oplot, x, y(*,(index+n) MOD plotnr), LINESTYLE=(index+n) MOD plotnr 

END



   

   
