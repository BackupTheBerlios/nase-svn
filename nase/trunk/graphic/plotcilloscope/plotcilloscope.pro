;+
; NAME:                Plotcilloscope
; 
; PURPOSE:             Diese Routine soll eine Art Oscillograph
;                      d.h. einen Y-t-Plot realisieren. Jeder
;                      Aufruf aktualisiert die Ausgabe um den
;                      momentanen Zeitschritt. Die Y-Achse wird
;                      automatisch skaliert.
;
; CATEGORY:            GRAPHIC
;
; CALLING SEQUENCE:    Plotcilloscope, PS, y
;
; INPUTS:              PS: eine mit InitPlotcilloscope initialisierte
;                          Struktur
;                       y: der aktuelle aufzuzeichnende/darzustellende
;                          Wert
;
; EXAMPLE:
;            PS = InitPlotcilloscope(TIME=100)
;            FOR i=0,199 DO BEGIN
;               y = 100-i+15.*RandomU(seed,1)
;               Plotcilloscope, PS, y
;               wait, 0.06
;            END
;            FOR i=0,199 DO BEGIN
;               y = -100+i+15.*RandomU(seed,1)
;               Plotcilloscope, PS, y
;               wait, 0.06
;            END
;
; SEE ALSO:  <A HREF="#INITPLOTCILLOSCOPE">InitPlotcilloscope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/01/07 17:49:00  saam
;           es ist geschafft
;
;
;-
PRO Plotcilloscope, PS, value 

   xpos = PS.t MOD PS.time

   IF xpos GT 0 THEN BEGIN
      IF xpos LT PS.time-1 THEN PlotS, [xpos,xpos+1], [PS.y(xpos),PS.y(xpos+1)], COLOR=!P.Background, NOCLIP=0
      PlotS, [xpos-1,xpos], [PS.y(xpos-1),value], NOCLIP=0
   END
   PS.y(xpos) = value
   PS.t       = PS.t + 1  

   newPlot = 0
   maxy = MAX(PS.y)
   miny = MIN(PS.y)
   IF PS.maxSc AND ((maxy GT 0.95*(PS.maxAx-PS.minAx)+PS.minAx) OR (maxy LT 0.35*(PS.maxAx-PS.minAx)+PS.minAx)) THEN BEGIN
      PS.maxAX = maxy + 0.4*(maxy-miny)
      newPlot=1
   END

   IF PS.minSc AND ((miny LT 0.05*(PS.maxAx-PS.minAx)+PS.minAx) OR (miny GT 0.65*(PS.maxAx-PS.minAx)+PS.minAx)) THEN BEGIN
      PS.minAx = miny-0.4*(maxy-miny)
      newPLot=1
   END

   IF newPlot OR xpos EQ 0 THEN BEGIN
      ticks = STRCOMPRESS(String(PS.t - (PS.t MOD PS.time)), /REMOVE_ALL)
      FOR i=1,5 DO ticks = [ticks, STRCOMPRESS(STRING(PS.t - (PS.t MOD PS.time) +i*PS.time/5), /REMOVE_ALL) ]

      plot, PS.y, YRANGE=[PS.minAx, PS.maxAx], XRANGE=[0,PS.time], XTICKS=5, XTICKNAME=ticks, /NODATA
      IF xpos GT 0 THEN oplot, PS.y(0:xpos)
      IF xpos LT PS.time-3 AND PS.t GE PS.time THEN oplot, Indgen(PS.time-xpos-3)+xpos+3, PS.y(xpos+3:*)
   END
END
