;+
; NAME:               InitPlotscilloscope
;
; PURPOSE:            Initialisiert ein Plotscilloscope
;                     (siehe <A HREF="#PLOTCILLOSCOPE">Plotcilloscope</A>)
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   PS = InitPlotcilloscope([TIME=time] $
;                            [,YMIN=ymin] [,YMAX=ymax] $
;                            [,/NOSCALEALL] [,/NOSCALEYMIN] $
;                            [,/NOSCALEYMAX] $
;                            [-other-Plot-Keywords-] $
;                            [,OVERSAMPLING=oversampling]
;                            [,/INSTANTREFRESH])
;
; KEYWORD PARAMETERS:  TIME       : die Laenge der dargestellten Zeitachse (Def.:100)
;                      RAYS       : die Anzahl der benutzten Strahlen
;                      YMIN/YMAX  : anfaengliche Skalierung der Ordinate (Def.:0.0/1.0)
;                      NOSCALEYMIN/
;                      NOSCALEYMAX/
;                      NOSCALEALL : verhindert eine dyn. Anpassung des oberen/
;                                   unteren/beider Ordinatenwerte  
;                   INSTANTREFRESH: bewirkt, da� die Achsen gleich
;                                   beim ersten geplotteten Wert neu
;                                   skaliert werden.
;                     OVERSAMPLING: korrekte Umrechnung von BIN in ms bei
;                                   ueberabtastenden Neuronen
;
;                   Au�erdem sind alle Schl�sselworte erlaubt, die
;                   auch PLOT nimmt. Der Default f�r XTITLE ist "t / ms".
;
; OUTPUTS:             PS : ein Struktur zum Benutzen mit Plotcilloscope
;
; EXAMPLE:
;            PS = InitPlotcilloscope(TIME=100)
;            ;PS = InitPlotcilloscope(TIME=50, YMIN=-40, YMAX=150, /NOSCALEALL)
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
; SEE ALSO:  <A HREF="#PLOTCILLOSCOPE">Plotcilloscope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.9  1998/05/14 09:03:45  saam
;           keyword oversampling now in doc-header
;
;     Revision 2.8  1998/03/25 10:40:05  kupper
;            Whatever might be might be...
;
;     Revision 2.7  1998/03/19 11:04:22  kupper
;            Inkompatibilit�t zu IDL4 entfernt... (_extra-Verarbeitung)
;
;     Revision 2.6  1998/03/18 12:43:34  kupper
;            INSTANTREFRESH und _EXTRA implementiert.
;
;     Revision 2.5  1998/01/28 09:57:54  saam
;           now handles oversampling with new keyword OVERSAMP
;
;     Revision 2.4  1998/01/21 21:56:37  saam
;           BUG: Abbruch bei t > MAX(Int) ... korrigiert
;
;     Revision 2.3  1998/01/08 16:59:05  saam
;           mehere Strahlen sind nun moeglich
;
;     Revision 2.2  1998/01/07 17:52:30  saam
;           na was?? n Bug in der Docu
;
;     Revision 2.1  1998/01/07 17:49:01  saam
;           es ist geschafft
;
;
;-
FUNCTION InitPlotcilloscope, TIME=time, YMIN=ymin, YMAX=ymax, $
                             RAYS=rays,$
                             NOSCALEALL=noscaleall, NOSCALEYMIN=noscaleymin, NOSCALEYMAX=noscaleymax,$
                             OVERSAMPLING=oversampling, $
                             INSTANTREFRESH=instantrefresh, $
                             XTITLE=xtitle, _EXTRA=_extra

   Default, OVERSAMPLING, 1
   Default, TIME, 100l
   Default, YMIN, 0.0
   Default, YMAX, 1.0
   Default, Rays, 1
   Default, XTITLE, 't / ms'
   If not keyword_set(_EXTRA) then _extra = {XTITLE: xtitle} else begin
      If not extraset(_extra, "xtitle") then _extra = create_struct(_extra, "xtitle", xtitle)
   EndElse
   time =  time*OVERSAMPLING
   maxSc = 1
   minSc = 1
   If Keyword_Set(INSTANTREFRESH) then startvalue = 0. else startvalue = ((ymax-ymin)/2.+ymin)
   
   IF Keyword_Set(NOSCALEYMIN) THEN minSc = 0
   IF Keyword_Set(NOSCALEYMAX) THEN maxSc = 0
   IF Keyword_Set(NOSCALEALL)  THEN BEGIN
      maxSc = 0
      minSc = 0 
   END

   PS = { info  : 'T_PLOT'      ,$
          minAx : ymin          ,$
          maxAx : ymax          ,$
          y     : Make_Array(rays, time, /FLOAT, VALUE=startvalue), $
          rays  : rays          ,$
          t     : 0l            ,$
          time  : LONG(time)    ,$
          maxSc : maxSc         ,$
          minSc : minSc         ,$
          os    : oversampling  ,$
          _extra: _extra}
   
   plot, PS.y, /NODATA, YRANGE=[PS.minAx, PS.maxAx], XRANGE=[0,PS.time/PS.os], XSTYLE=1, _EXTRA=_extra

   RETURN, PS
END
