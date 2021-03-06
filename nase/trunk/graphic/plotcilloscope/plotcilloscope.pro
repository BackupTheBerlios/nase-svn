;+
; NAME:                Plotcilloscope
; 
; AIM:
;  Gradually plot oscilloscope-like graph(s) (y-t-plot).
;
; PURPOSE:             Diese Routine soll eine Art Oscillograph
;                      d.h. einen Y-t-Plot realisieren. Jeder
;                      Aufruf aktualisiert die Ausgabe um den
;                      momentanen Zeitschritt. Die Y-Achse wird
;                      automatisch skaliert. Es werden auch 
;                      mehrere Strahlen unterstuetzt.
;
; CATEGORY:            GRAPHIC PLOTCILLOSCOPE
;
; CALLING SEQUENCE:    Plotcilloscope, PS, y
;
; INPUTS:              PS: eine mit <A HREF="#INITPLOTCILLOSCOPE>InitPlotcilloscope</A> initialisierte
;                          Struktur
;                       y: ein Array der aktuell aufzuzeichnende/
;                          darzustellenden Werte
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
;            FreePlotcilloscope, PS
;
; SEE ALSO:  <A HREF="#INITPLOTCILLOSCOPE">InitPlotcilloscope</A>, <A HREF="#FREEPLOTCILLOSCOPE">FreePlotcilloscope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.15  2000/10/30 09:34:13  kupper
;     Removed NOALLOC keywords from RGB call, is tended to yield weird
;     colors.
;
;     Revision 2.14  2000/10/01 14:51:23  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.13  2000/09/06 16:36:56  kupper
;     Replaced old () array indexing by new [], as we encountered problems
;     with function/array "value".
;
;     Revision 2.12  1999/10/07 09:42:18  alshaikh
;           added Keyword SCALE
;
;     Revision 2.11  1998/11/08 14:30:41  saam
;           + hyperlink updates
;           + the plotcilloscope structure is now
;              a handle and has to freed via FreePlotcilloscope
;
;     Revision 2.10  1998/10/29 12:16:18  saam
;           now checks passed arguements
;
;     Revision 2.9  1998/05/16 16:28:42  kupper
;            Stürzt nun nicht mehr ab bei TIME=1
;
;     Revision 2.8  1998/03/19 11:04:23  kupper
;            Inkompatibilität zu IDL4 entfernt... (_extra-Verarbeitung)
;
;     Revision 2.7  1998/03/18 12:43:34  kupper
;            INSTANTREFRESH und _EXTRA implementiert.
;
;     Revision 2.6  1998/02/19 14:16:29  saam
;          wieder zurueck
;
;     Revision 2.5  1998/02/19 14:02:56  saam
;           Aenderung an der Farbpalette
;
;     Revision 2.4  1998/01/28 09:57:54  saam
;           now handles oversampling with new keyword OVERSAMP
;
;     Revision 2.3  1998/01/21 21:56:38  saam
;           BUG: Abbruch bei t > MAX(Int) ... korrigiert
;
;     Revision 2.2  1998/01/08 16:59:06  saam
;           mehere Strahlen sind nun moeglich
;
;     Revision 2.1  1998/01/07 17:49:00  saam
;           es ist geschafft
;
;
;-
PRO Plotcilloscope, _PS, value

   On_Error, 2

   TestInfo, _PS, 'T_PLOT'
   Handle_Value, _PS, PS, /NO_COPY

   rayRed   = [  0, 200,   0, 200, 200, 200,   0]
   rayGreen = [200,   0,   0, 200, 200,   0, 200]
   rayBlue  = [  0,   0, 200, 200,   0, 200, 200]

   xpos = PS.t MOD PS.time

   IF xpos GT 0 THEN BEGIN
      FOR ray=0,PS.rays-1 DO BEGIN
         IF xpos LT PS.time-1 THEN PlotS, [xpos/Float(PS.os),(xpos+1)/Float(PS.os)], [PS.y[ray,xpos],PS.y[ray,xpos+1]], COLOR=!P.Background, NOCLIP=0
         PlotS, [(xpos-1)/Float(PS.os),xpos/Float(PS.os)], [PS.y[ray,xpos-1],value[ray]], NOCLIP=0, COLOR=RGB(rayRed[ray],rayGreen[ray],rayBlue[ray])
      END
   END
   PS.y[*,xpos] = value
   PS.t = PS.t + 1  

   
   newPlot = 0
   maxy = MAX(PS.y)
   miny = MIN(PS.y)


   IF PS.maxSc AND ((maxy GT (1-PS.scale[0])*(PS.maxAx-PS.minAx)+PS.minAx) OR (maxy LT (1-PS.scale[1])*(PS.maxAx-PS.minAx)+PS.minAx)) THEN BEGIN
      PS.maxAX = maxy + 0.2*(maxy-PS.minAx)
      newPlot=1
   END

   IF PS.minSc AND ((miny LT PS.scale[0]*(PS.maxAx-PS.minAx)+PS.minAx) OR (miny GT PS.scale[1]*(PS.maxAx-PS.minAx)+PS.minAx)) THEN BEGIN
      PS.minAx = miny-0.2*(PS.maxAx-miny)
      newPLot=1
   END



   IF newPlot OR xpos EQ 0 THEN BEGIN
      ticks = STRCOMPRESS(String((PS.t - (PS.t MOD PS.time))/PS.os), /REMOVE_ALL)
      FOR i=1,5 DO ticks = [ticks, STRCOMPRESS(STRING((PS.t - (PS.t MOD PS.time) +i*PS.time/5)/PS.os), /REMOVE_ALL) ]

      plot, [PS.y[0,*]], YRANGE=[PS.minAx, PS.maxAx], XRANGE=[0,PS.time/PS.os], XTICKS=5, XTICKNAME=ticks, /NODATA, XSTYLE=1, _EXTRA=PS._extra
      FOR ray=0,PS.rays-1 DO BEGIN
         IF xpos GT 0 THEN oplot, FIndGen(xpos+1)/PS.os, PS.y[ray,0:xpos], COLOR=RGB(rayRed[ray],rayGreen[ray],rayBlue[ray])
         IF xpos LT PS.time-4 AND PS.t GE PS.time THEN oplot, (Indgen(PS.time-xpos-3)+xpos+3)/Float(PS.OS), PS.y[ray,xpos+3:*], COLOR=RGB(rayRed[ray],rayGreen[ray],rayBlue[ray])
      END
   END

   Handle_Value, _PS, PS, /NO_COPY, /SET
END
