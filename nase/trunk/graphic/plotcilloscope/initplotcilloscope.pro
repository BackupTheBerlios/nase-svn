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
;                            [,/NOSCALEYMAX]
;
; KEYWORD PARAMETERS:  TIME       : die Laenge der dargestellten Zeitachse (Def.:100)
;                      YMIN/YMAX  : anfaengliche Skalierung der Ordinate (Def.:0.0/1.0)
;                      NOSCALEYMIN/
;                      NOSCALEYMAX/
;                      NOSCALEALL : verhindert eine dyn. Anpassung des oberen/
;                                   unteren/beider Ordinatenwerte  
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
;     Revision 2.2  1998/01/07 17:52:30  saam
;           na was?? n Bug in der Docu
;
;     Revision 2.1  1998/01/07 17:49:01  saam
;           es ist geschafft
;
;
;-
FUNCTION InitPlotcilloscope, TIME=time, YMIN=ymin, YMAX=ymax, $
                             NOSCALEALL=noscaleall, NOSCALEYMIN=yminnoscale, NOSCALEYMAX=ymaxnoscale

   Default, TIME, 100
   Default, YMIN, 0.0
   Default, YMAX, 1.0
   maxSc = 1
   minSc = 1
   
   IF Keyword_Set(NOSCALEYMIN) THEN minSc = 0
   IF Keyword_Set(NOSCALEYMAX) THEN maxSc = 0
   IF Keyword_Set(NOSCALEALL)  THEN BEGIN
      maxSc = 0
      minSc = 0 
   END

   PS = { info : 'T_PLOT'      ,$
          minAx: ymin          ,$
          maxAx: ymax          ,$
          y    : Make_Array(time, /FLOAT, VALUE=((ymax-ymin)/2.+ymin)),$
          t    : 0             ,$
          time : time          ,$
          maxSc: maxSc         ,$
          minSc: minSc         }
   
   plot, PS.y, /NODATA, YRANGE=[PS.minAx, PS.maxAx], XRANGE=[0,PS.time]

   RETURN, PS
END
