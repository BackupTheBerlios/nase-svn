;+
; NAME: PlotTVScl
;
;
; PURPOSE: TVScl-Darstellung eines Arrays zusammen mit einem
;          Koordinatensystem, Achsenbeschriftung und Legende
;
; CATEGORY: GRAPHICS / GENERAL
;
; CALLING SEQUENCE: PlotTvScl, Array 
;                             [, XNorm] [, YNorm]
;                             [, XTITLE=Abszissentext] [,YTITLE=Ordinatentext]
;                             [, CHARSIZE=Schriftgroesse]
;                             [, /FULLSHEET]
;                             [, /NOSCALE]
;                             [, /LEGEND]
;                             [, /ORDER]
;                             [, /NASE]
;
; INPUTS: Array : klar!
;
; OPTIONAL INPUTS: XNorm, YNorm : Position der unteren linken Ecke der Plotregion
;                                 in Normalkoordinaten.
;                                 (Plotregion =  Bildbereich plus Rand fuer die Beschriftung)
;                  Abszissen-, Ordinatentext : klar!
;                  Schriftgroesse: Faktor, der die Schriftgroesse in Bezug auf die
;                                  Standardschriftgroesse (1.0) angibt
;
; KEYWORD PARAMETERS: FULLSHEET: Nutzt fuer die Darstellung den ganzen zur Verfuegung stehenden 
;                                Platz aus, TVScl-Pixel sind deshalb in dieser Darstellung in 
;                                der Regel nicht quadratisch.
;                     NOSCALE: Schaltet die Intensitaetsskalierung ab. Der Effekt ist identisch
;                              mit dem Aufruf von <A HREF="#PLOTTV">PlotTV</A>
;                              Siehe dazu auch den Unterschied zwischen den Original-IDL-Routinen 
;                              TVSCL und TV.
;                     LEGEND: Zeigt zusaetzlich eine <A HREF="#TVSCLLEGEND">Legende</A> rechts neben der TVScl-Graphik
;                             an. 
;                     ORDER: der gleiche Effekt wie bei Original-TVScl
;                     NASE: Bewirkt die richtig gedrehte Darstellung von Layerdaten 
;                           (Inputs, Outputs, Potentiale, Gewichte...).
;                           D.h. z.B. werden Gewichtsmatrizen in der gleichen
;                           Orientierung dargestellt, wie auch ShowWeights sie ausgibt.
;
; PROCEDURE: 1. Ermitteln des fuer die Darstellung zur Verfuegung stehenden Raums.
;            2. Zeichnen der Achsen an der ermittelten Position.
;            3. Ausfuellen mit einer entsprechend grossen UTVScl-Graphik
;            4. Legende hinzufuegen 
;
; EXAMPLE: width = 25
;          height = 50
;          W = gauss_2d(width, height)+0.01*randomn(seed,width, height)
;          window, xsize=500, ysize=600
;          PlotTvScl, W, 0.0, 0.1, XTITLE='X-AXEN-Beschriftungstext', /LEGEND, CHARSIZE=2.0
;
; SEE ALSO: <A HREF="#PLOTTV">PlotTV</A><A HREF="#UTVSCL">UTVScl</A>, <A HREF="#TVSCLLEGEND">TVSclLegend</A>, <A HREF="file:/usr/ax1303/neuroadm/nase/graphic/index.html#NASETVSCL">NaseTVScl</A>, 
;      
; MODIFICATION HISTORY:
;     
;     $Log$
;     Revision 2.11  1997/12/17 14:45:19  thiel
;            Jetzt neu: NOSCALE-Schluesselwort
;
;     Revision 2.10  1997/12/10 15:24:28  thiel
;            Hilfsfunktion
;              'KeineNegativenUndGebrochenenTicks'
;            ausgelagert.
;
;     Revision 2.9  1997/12/08 16:24:13  thiel
;            Fehler im Hyperdings korrigiert.
;
;     Revision 2.8  1997/12/08 15:02:18  thiel
;            Jetzt auf vielfachen Wunsch mit Hyperdings.
;
;     Revision 2.7  1997/12/02 11:27:30  saam
;           auch [XY]Minor und [XY]TickLen werden nun gesichert
;
;     Revision 2.6  1997/12/02 11:03:22  saam
;           BUG: !P.Region wurde umdefiniert, damit veraendern
;                sich alle nachfolgenden Plots...
;           Daher wird jetzt die Region gesichert und am Ende
;            wieder restauriert
;
;     Revision 2.5  1997/11/30 17:56:50  thiel
;            Ich dacht, da waer ein Fehler drin, war aber nich...
;
;     Revision 2.4  1997/11/28 12:56:15  thiel
;           Eine sinnlose Aenderung, damit das CVS-WATCH funktioniert.
;
;     Revision 2.3  1997/11/28 12:50:10  thiel
;            Die erste scheinbar fertige Version.
;
;
;-


PRO PlotTvscl, _W, XPos, YPos, FULLSHEET=FullSheet, CHARSIZE=Charsize, $
                  LEGEND=Legend, ORDER=Order, NASE=Nase, NOSCALE=NoScale, _EXTRA=_extra


;-----Sichern der urspruenglichen Device-Parameter
oldRegion   = !P.Region
oldXTicklen = !X.TickLen 
oldYTicklen = !Y.TickLen 
oldXMinor   = !X.Minor
oldYMinor   = !Y.Minor


;-----Optimale Farbe fuer die Achsen ermitteln:
bg = GetBGColor()
; if device is PS and REVERTPS is on 
save_rpsc = !REVERTPSCOLORS
!REVERTPSCOLORS = 0
sc =  RGB(255-bg(0), 255-bg(1), 255-bg(2), /NOALLOC)
!REVERTPSCOLORS = save_rpsc


Default, Charsize, 1.0
Default, NOSCALE, 0
Default, ORDER, 0

W = _W
IF (Keyword_Set(NASE)) THEN W = Transpose(W)


ArrayHeight = (size(w))(2)
ArrayWidth  = (size(w))(1)

VisualWidth = !D.X_VSIZE
VisualHeight = !D.Y_VSIZE


;-----Behandlung der NASE und ORDER-Keywords:
XBeschriftung = [-1, ArrayWidth]
IF keyword_set(ORDER) THEN BEGIN
   UpSideDown = 1
   YBeschriftung = [ArrayHeight,-1] 
   ENDIF ELSE BEGIN
      UpSideDown = 0
      YBeschriftung = [-1, ArrayHeight]
      ENDELSE
IF (Keyword_Set(NASE)) AND (Keyword_Set(ORDER)) THEN BEGIN
      UpsideDown = 0 
      YBeschriftung = [-1,Arrayheight]
ENDIF
IF (Keyword_Set(NASE)) AND (NOT(Keyword_Set(ORDER)))THEN BEGIN
   YBeschriftung = [Arrayheight, -1]
   UpSideDown = 1 
ENDIF 


;-----Laenge und Anzahl der Ticks:
!Y.TickLen = Max([1.0/(ArrayWidth+1)/2.0,0.01])
!X.TickLen = Max([1.0/(ArrayHeight+1)/2.0,0.01])

IF ArrayHeight GE 15 THEN !Y.Minor = 0 ELSE $
 IF ArrayHeight GE 7 THEN !Y.Minor = 2 ELSE !Y.Minor=-1

IF ArrayWidth GE 15 THEN !X.Minor = 0 ELSE $
 IF ArrayWidth GE 7 THEN !X.Minor = 2 ELSE !X.Minor=-1


;-----Raender und Koordinaten des Ursprungs:
Default, XPos, 0.0
Default, YPos, 0.0

IF Keyword_Set(LEGEND) THEN LegendRandDevice = 0.25*VisualWidth ELSE LegendRandDevice = 0.0

PosDevice = Convert_Coord([XPos,YPos], /Normal, /To_Device)

OriginDevice = [!X.Margin(0)*!D.X_CH_Size*Charsize,!Y.Margin(0)*!D.Y_CH_Size*Charsize]+PosDevice
UpRightDevice = [!X.Margin(1)*!D.X_CH_Size*Charsize,!Y.Margin(1)*!D.Y_CH_Size*Charsize]+[LegendRandDevice,0]

OriginNormal = Convert_Coord(OriginDevice, /Device, /To_Normal)
UpRightNormal = Convert_Coord(UpRightDevice, /Device, /To_Normal)

RandNormal = OriginNormal + UpRightNormal

PlotPositionDevice = FltArr(4)
PlotPositionDevice(0) = OriginDevice(0)
PlotPositionDevice(1) = OriginDevice(1)

PixelSizeNormal = [(1.0-RandNormal(0))/float(ArrayWidth+1),(1.0-RandNormal(1))/float(ArrayHeight+1)]
PixelSizeDevice = convert_coord(PixelSizeNormal, /normal, /to_device)


;-----Plotten des Koodinatensystems:
IF NOT Set(FullSheet) THEN BEGIN 
 IF PixelSizeDevice(1)*(ArrayWidth+1)+OriginDevice(0)+UpRightDevice(0) LT VisualWidth THEN BEGIN
       PlotPositionDevice(2) = PixelSizeDevice(1)*(ArrayWidth+1)+OriginDevice(0)
       PlotPositionDevice(3) = VisualHeight - UpRightDevice(1)
   ENDIF ELSE BEGIN
       PlotPositionDevice(3) = PixelSizeDevice(0)*(ArrayHeight+1)+OriginDevice(1)
       PlotPositionDevice(2) = VisualWidth - UpRightDevice(0)
     ENDELSE 
     Plot, indgen(2), /NODATA, Position=PlotPositionDevice, /Device, Color=sc, $
      xrange=XBeschriftung, /xstyle, xtickformat='KeineNegativenUndGebrochenenTicks', $
      yrange=YBeschriftung, /ystyle, ytickformat='KeineNegativenUndGebrochenenTicks', charsize=charsize,_EXTRA=_extra
ENDIF ELSE BEGIN
   !P.Region = [XPos,YPos,0.75,1.0]
   Plot, indgen(2), /NODATA, Color=sc, $
      xrange=XBeschriftung, /xstyle, xtickformat='KeineNegativenUndGebrochenenTicks', $
      yrange=YBeschriftung, /ystyle, ytickformat='KeineNegativenUndGebrochenenTicks', charsize=charsize,_EXTRA=_extra
ENDELSE


TotalPlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
TotalPlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)

PlotWidthNormal = TotalPlotWidthNormal - TotalPlotWidthNormal*2*!Y.Ticklen
PlotHeightNormal = TotalPlotHeightNormal - TotalPlotHeightNormal*2*!X.Ticklen

PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device)

;-----Plotten der UTVScl-Graphik:
UTVScl, W, OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen, OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen, X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM, Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM, ORDER=UpSideDown, NOSCALE=NoScale

;-----Legende, falls erwuenscht:
IF Set(LEGEND) THEN TVSclLegend, OriginNormal(0)+TotalPlotWidthNormal*1.15,OriginNormal(1)+TotalPlotHeightNormal/2.0, $
 H_Stretch=TotalPlotWidthNormal/15.0*VisualWidth/(0.5*!D.X_PX_CM), $
 V_Stretch=TotalPlotHeightNormal/4.0*VisualHeight/(2.5*!D.Y_PX_CM), $
 Max=Max(W), Min=Min(W), $
 CHARSIZE=Charsize, $
 /Vertical, /Center 


;-----Restauration der urspruenglichen Device-Parameter
!P.Region  = oldRegion 
!X.TickLen = oldXTicklen 
!Y.TickLen = oldYTicklen 
!X.Minor   = oldXMinor  
!Y.Minor   = oldYMinor   


;-----ENDE:
END
