;+
; NAME:               InitPlotcilloscope
;
; AIM:
;  Initialize a structure for use with the Plotcilloscope routine.
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
;                            [,/INSTANTREFRESH]
;                            [,SCALE=scale] )
;                            
; KEYWORD PARAMETERS:  TIME       : die Laenge der dargestellten Zeitachse (Def.:100)
;                      RAYS       : die Anzahl der benutzten Strahlen
;                      YMIN/YMAX  : anfaengliche Skalierung der Ordinate (Def.:0.0/1.0)
;                      NOSCALEYMIN/
;                      NOSCALEYMAX/
;                      NOSCALEALL : verhindert eine dyn. Anpassung des oberen/
;                                   unteren/beider Ordinatenwerte  
;                   INSTANTREFRESH: bewirkt, daß die Achsen gleich
;                                   beim ersten geplotteten Wert neu
;                                   skaliert werden.
;                     OVERSAMPLING: korrekte Umrechnung von BIN in ms bei
;                                   ueberabtastenden Neuronen
;                     SCALE       : Array[upperscl,lowerscl]
;                                   Umskalierung, wenn sich Graph um mehr als 
;                                   upperscl*(Abstand oberer/unterer Ordinatenwert) einem dieser Werte 
;                                   naehert, bzw. wenn er sich um mehr als lowerscl*(...) 
;                                   davon entfernt. (Def.:[0.1,0.65])
;       
;                   Außerdem sind alle Schlüsselworte erlaubt, die
;                   auch PLOT nimmt. Der Default für XTITLE ist "t / ms".
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
;            FreePlotcilloscope, PS
;
; SEE ALSO:  <A HREF="#PLOTCILLOSCOPE">Plotcilloscope</A>, <A HREF="#FREEPLOTCILLOSCOPE">FreePlotcilloscope</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.16  2000/10/25 14:10:30  kupper
;     Typo in NAME: entry!!
;
;     Revision 2.15  2000/10/01 14:51:23  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.14  2000/09/27 15:59:15  saam
;     service commit fixing several doc header violations
;
;     Revision 2.13  1999/10/07 09:42:17  alshaikh
;           added Keyword SCALE
;
;     Revision 2.12  1998/11/08 14:30:41  saam
;           + hyperlink updates
;           + the plotcilloscope structure is now
;              a handle and has to freed via FreePlotcilloscope
;
;     Revision 2.11  1998/05/18 19:39:09  saam
;           added Keyword OVERSAMPLING
;
;     Revision 2.10  1998/05/16 16:28:42  kupper
;            Stürzt nun nicht mehr ab bei TIME=1
;
;     Revision 2.9  1998/05/14 09:03:45  saam
;           keyword oversampling now in doc-header
;
;     Revision 2.8  1998/03/25 10:40:05  kupper
;            Whatever might be might be...
;
;     Revision 2.7  1998/03/19 11:04:22  kupper
;            Inkompatibilität zu IDL4 entfernt... (_extra-Verarbeitung)
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
                             XTITLE=xtitle, SCALE=scale, $  
                             _EXTRA=_extra
                             
   On_Error, 2

   Default, OVERSAMPLING, 1
   Default, TIME, 100l
   time = time / OVERSAMPLING
   Default, YMIN, 0.0
   Default, YMAX, 0.0
   Default, Rays, 1
   Default, XTITLE, 't / ms'
   Default, scale, [0.1,0.65]
   

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

   PS = { info     : 'T_PLOT'      ,$
          minAx    : ymin          ,$
          maxAx    : ymax          ,$
          y        : Make_Array(rays, time, /FLOAT, VALUE=startvalue), $
          rays     : rays          ,$
          t        : 0l            ,$
          time     : LONG(time)    ,$
          maxSc    : maxSc         ,$
          minSc    : minSc         ,$
          os       : oversampling  ,$
          scale    : scale         ,$
          _extra   : _extra}    
   
   plot, [PS.y], /NODATA, YRANGE=[PS.minAx, PS.maxAx], XRANGE=[0,PS.time/PS.os], XSTYLE=1, _EXTRA=_extra


   RETURN, HANDLE_CREATE(!MH, VALUE=ps, /NO_COPY)
END
