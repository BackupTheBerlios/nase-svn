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
;                             [, XRANGE=xrange] [, YRANGE=yrange]
;                             [, GET_POSITION=PlotPosition]
;                             [, GET_COLOR=Farbe]
;                             [, GET_XTICKS=XTicks]
;                             [, GET_YTICKS=YTicks]
;                             [, GET_PIXELSIZE=Pixelgroesse]
;                             [, LAGMARGIN=LEGMARGIN]
;                             [, /NEUTRAL]
;                             [, /POLYGON]
;                             [, CUBIC=cubic] [, /INTERP] [, /MINUS_ONE]
;                             [, LEG_MAX=leg_max] [, LEG_MIN=leg_min]
;                             [, COLORMODE=+/-1] [, SETCOL=0] [, PLOTCOL=PlotColor]
;
; INPUTS: Array : klar!
;
; OPTIONAL INPUTS: XNorm, YNorm : Position der unteren linken Ecke des Plotkastens
;                                 in Normalkoordinaten.
;                                 Werden diese Werte angegeben, so hat der Anwender
;                                 selbst fuer ausreichenden Rand fuer Beschriftungen 
;                                 zu sorgen. Ohne Angabe von XNorm und YNorm wird
;                                 der Rand um den Plotkasten analog zur IDL-Plot-Routine
;                                 ermittelt.  
;                  Abszissen-, Ordinatentext : klar!
;                  Schriftgroesse: Faktor, der die Schriftgroesse in Bezug auf die
;                                  Standardschriftgroesse (1.0) angibt
;
; KEYWORD PARAMETERS: FULLSHEET: Nutzt fuer die Darstellung den ganzen zur Verfuegung stehenden 
;                                Platz aus, TVScl-Pixel sind deshalb in dieser Darstellung in 
;                                der Regel nicht quadratisch.
;                     NOSCALE:   Schaltet die Intensitaetsskalierung ab. Der Effekt ist identisch
;                                mit dem Aufruf von <A HREF="#PLOTTV">PlotTV</A>
;                                Siehe dazu auch den Unterschied zwischen den Original-IDL-Routinen 
;                                TVSCL und TV.
;                     LEGEND:    Zeigt zusaetzlich eine <A HREF="#TVSCLLEGEND">Legende</A> rechts neben der TVScl-Graphik
;                                an. 
;                     ORDER:     der gleiche Effekt wie bei Original-TVScl
;                     NASE:      Bewirkt die richtig gedrehte Darstellung von Layerdaten 
;                                (Inputs, Outputs, Potentiale, Gewichte...).
;                                D.h. z.B. werden Gewichtsmatrizen in der gleichen
;                                Orientierung dargestellt, wie auch ShowWeights sie ausgibt.
;                     [XY]RANGE: zwei-elementiges Array zur alternative [XY]-Achsenbeschriftung;
;                                das erste Element gibt das Minimum, das zweite das Maximum der Achse an                      
;                     LEGMARGIN: Raum fuer die Legende in Prozent des gesamten Plotbereichs (default: 0.25) 
;                     leg_(max|min): alternative Beschriftung der Legende 
;                     NEUTRAL:   bewirkt die Darstellung mit NASE-Farbtabellen inclusive Extrabehandlung von
;                                !NONE, ohne den ganzen anderen NASE-Schnickschnack
;                     POLYGON   : Statt Pixel werden Polygone gezeichnet (gut fuer Postscript)
;                     TOP       : Benutzt nur die Farbeintraege von 0..TOP-1 (siehe IDL5-Hilfe von TvSCL)
;                     CUBIC,
;                     INTERP,
;                     MINUS_ONE : werden an ConGrid weitergereicht (s. IDL-Hilfe)
;                     COLORMODE : Wird an Showweights_scale
;                                 weitergereicht. Mit diesem Schlüsselwort kann unabhängig 
;                                 von den Werten im Array die
;                                 schwarz/weiss-Darstellung (COLORMODE=+1) 
;                                 oder die rot/grün-Darstellung
;                                 (COLORMODE=-1) erzwungen werden.
;                     SETCOL    : Default:1 Wird an ShowWeights_Scale weitergereicht, beeinflusst also, ob
;                                 die Farbtabelle passend fuer den ArrayInhalt gesetzt wird, oder nicht.
;                     PLOTCOL   : Farbe, mit der der Plot-Rahmen gezeichnet wird. Wenn nicht angegeben,
;                                 wird versucht, eine passende Farbe zu raten.
;
; OPTIONAL OUTPUTS: PlotPosition: Ein vierelementiges Array [x0,y0,x1,y1], das die untere linke (x0,y0)
;                                 und die obere rechte Ecke (x1,y1) des Bildbereichs in Normalkoordinaten
;                                 zurueckgibt.
;                   Farbe       : Gibt den Farbindex, der beim Zeichnen der Achsen verwendet wurde, zurueck.
;                   [XY]Ticks   : Ein Array, das die Zahlen enthaelt, mit denen die jeweilige Achse
;                                 ohne die Anwendung der 'KeineNegativenUndGebrochenenTicks'-Funktion
;                                 beschriftet worden waere. 
;                   Pixelgroesse: Ein zweielementiges Array [XSize, YSize], das die Groesse der
;                                 TV-Pixel in Normalkoordinaten zurueckliefert.
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
; SEE ALSO: <A HREF="#PLOTTV">PlotTV</A>, <A HREF="#UTVSCL">UTVScl</A>, <A HREF="#TVSCLLEGEND">TVSclLegend</A>, <A HREF="../#NASETVSCL">NaseTVScl</A> 
;      
; MODIFICATION HISTORY:
;     
;     $Log$
;     Revision 2.44  1999/06/18 14:45:47  kupper
;     LEG_MIN and LEG_MAX did not work with /NASE. Fixed.
;     (What about /NEUTRAL? - Mirko?)
;
;     Revision 2.43  1999/06/07 14:40:44  kupper
;     Added CUBIC,INTERP,MINUS_ONE-Keywords for ConGrid.
;
;     Revision 2.42  1999/06/07 14:03:09  kupper
;     Added COLORMODE Keyword.
;
;     Revision 2.41  1999/06/06 14:52:54  kupper
;     Added PLOTCOL-Keyword.
;
;     Revision 2.40  1999/06/06 14:24:48  kupper
;     Added SETCOL KeyWord.
;
;     Revision 2.39  1999/03/17 16:37:16  saam
;           TOP keyword implemented
;
;     Revision 2.38  1999/02/12 15:26:04  saam
;           tests for an unset argument
;
;     Revision 2.37  1998/10/28 13:50:38  gabriel
;          !P.Multi fuer Postscript verbessert
;
;     Revision 2.36  1998/08/10 08:38:04  gabriel
;           Keyword POLYGON neu
;
;     Revision 2.35  1998/08/04 16:14:11  gabriel
;          Charsizes !P.MULTI angepasst
;
;     Revision 2.34  1998/08/04 15:02:42  gabriel
;          Print kommandos auskommentiert
;
;     Revision 2.33  1998/08/04 14:57:06  gabriel
;          LEGMARGIN KEYWORD eingefuehrt
;
;     Revision 2.32  1998/08/04 14:28:38  gabriel
;          Bug bei Convert_Coord nochmals verbessert/korrigiert
;
;     Revision 2.31  1998/08/04 13:23:32  gabriel
;          Jetzt mit !P.MULTI Funktionalitaet. (Convert_Coord korrigiert, kann
;          bei hoeheren (>4.0)  IDL Versionen wieder falsch sein)
;
;     Revision 2.30  1998/07/21 15:37:33  saam
;           modifications of last revision made changes in rev. 2.27
;           wrong and these lines are therfore kicked off again
;
;     Revision 2.29  1998/07/21 15:31:25  saam
;           bug with /NASE , without /FULLSHEET and rectangular arrays
;
;     Revision 2.28  1998/07/11 20:21:25  saam
;           added NEUTRAL keyword
;
;     Revision 2.27  1998/07/09 12:42:52  saam
;           the axis labelling for keyword nase was swapped (X/Y)
;
;     Revision 2.26  1998/05/26 13:16:08  kupper
;            Noch nicht alle Routinen kannten das !PSGREY. Daher mal wieder
;               Änderungen an der Postcript-Sheet-Verarbeitung.
;               Hoffentlich funktioniert alles (war recht kompliziert, wie immer.)
;
;     Revision 2.25  1998/05/18 19:43:30  saam
;           alternative legend by new keywords LEG_(MIN|MAX)
;           new get_position keyword for procedure plot2plus1 (internal)
;
;     Revision 2.24  1998/05/13 15:03:35  kupper
;            Farbskalierungs-Bug behoben.
;
;     Revision 2.23  1998/05/04 18:33:02  saam
;           nase-matrices were handled correctly now
;           (include legend)
;
;     Revision 2.22  1998/03/16 14:33:16  saam
;           PS-Output always had a legend even if
;           unwanted
;           there is still a bug with COLOR-PS because
;           of a bug in IDLs TV with the centimeter option
;
;     Revision 2.21  1998/03/13 15:59:48  thiel
;            Bugfix: Beschriftung der Achsen funktioniert jetzt
;            auch, wenn XRANGE=[A,B] und A > B ist.
;
;     Revision 2.20  1998/02/19 13:31:34  thiel
;            Dritter Versuch.
;
;     Revision 2.19  1998/02/19 13:25:24  thiel
;            anderer Hyperlink
;
;     Revision 2.18  1998/02/19 13:12:27  thiel
;            Neuer Hyperlink.
;
;     Revision 2.17  1998/01/29 16:13:52  saam
;           new keywords [XY]Range for variable
;           axis-labelling
;
;     Revision 2.16  1998/01/29 15:55:18  saam
;           *** empty log message ***
;
;     Revision 2.15  1997/12/31 11:49:58  thiel
;            Kombination von XNorm/YNorm-Parametern und
;            /FULLSHEET-Schluesselwort von Bugs befreit.
;
;     Revision 2.14  1997/12/19 15:58:08  thiel
;            XNorm-, YNorm-Parameter beziehen sich jetzt auf
;            auf die linke untere Ecke des Plotkastens.
;
;     Revision 2.13  1997/12/18 18:39:37  thiel
;            Liefert jetzt auf Wunsch Informationen ueber PlotPosition,
;            verwendete Farbe usw.
;
;     Revision 2.12  1997/12/17 15:43:55  thiel
;            Weitere Verbesserung der /NOSCALE-Behandlung.
;
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
               LEGEND=Legend, ORDER=Order, NASE=Nase, NOSCALE=NoScale, $
               XRANGE=xrange, YRANGE=yrange, $
               GET_Position=Get_Position, $
               GET_COLOR=Get_Color, $
               GET_XTICKS=Get_XTicks, $
               GET_YTICKS=Get_YTicks, $
               GET_INFO=get_info,$
               GET_PIXELSIZE=Get_PixelSize, $
               LEG_MAX=leg_MAX,$
               LEG_MIN=leg_MIN,$
               NEUTRAL=neutral,$
               POLYGON=POLYGON,$
               LEGMARGIN=LEGMARGIN,$
               TOP=top,$
               CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
               COLORMODE=colormode, SETCOL=setcol, $
               PLOTCOL=plotcol, $
               _EXTRA=_extra


   On_Error, 2
   IF NOT Set(_W) THEN Message, 'Argument undefined'
   IF !D.Name EQ 'NULL' THEN RETURN

   ;-----Sichern der urspruenglichen Device-Parameter
   oldRegion   = !P.Region
   oldXTicklen = !X.TickLen 
   oldYTicklen = !Y.TickLen 
   oldXMinor   = !X.Minor
   oldYMinor   = !Y.Minor
   

   If set(PLOTCOL) then sc = plotcol else begin
      ;-----Optimale Farbe fuer die Achsen ermitteln:
      bg = GetBGColor()
      ; if device is !PSGREY and !REVERTPS is on 
      If !PSGREY then begin
         save_rpsc = !REVERTPSCOLORS
         !REVERTPSCOLORS = 0
      EndIf
      sc =  RGB(255-bg(0), 255-bg(1), 255-bg(2), /NOALLOC)
      If !PSGREY then !REVERTPSCOLORS = save_rpsc
   EndElse
   Get_Color = sc
   
   Default, SETCOL, 1
   Default, Charsize, 1.0
   Default, NOSCALE, 0
   Default, ORDER, 0
   Default, LEGEND, 0
   Default,legmargin,0.25
   Default,Polygon,0
   DEFAULT, top, !D.TABLE_SIZE

   W = _W
   IF (Keyword_Set(NASE) OR Keyword_Set(NEUTRAL)) THEN BEGIN
      maxW = Max(W)
      minW = Min(NoNone(W))
   END

   IF Keyword_Set(NASE) THEN BEGIN
      ArrayHeight = (size(w))(1)
      ArrayWidth  = (size(w))(2)
   END ELSE BEGIN
      ArrayHeight = (size(w))(2)
      ArrayWidth  = (size(w))(1)
   END
   
   
   charcor = 1.
   IF !P.MULTI(1) GT 0  AND !P.MULTI(2) GT 0 THEN charcor =sqrt(1./FLOAT(!P.MULTI(1)))
   ;print,charcor
   xcoord = lindgen(ArrayWidth)
   ycoord = lindgen(ArrayHeight)
   PLOT,xcoord,ycoord,/XSTYLE,/YSTYLE,/NODATA,COLOR=!P.BACKGROUND, Charsize=Charsize*charcor,_EXTRA=e
   

   plotregion_norm = convert_coord([ [xcoord(0),ycoord(0)],[xcoord(N_ELEMENTS(xcoord)-1),ycoord(N_ELEMENTS(ycoord)-1)]],/DATA,/TO_NORMAL)
   plotregion_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
   ;; convert_coord macht bei !P.MULTI Fehler Y Koordinate muss korregiert werden
;   IF FLOAT(!P.MULTI(2)) GT 0 AND (ArrayHeight GT ArrayWidth) THEN BEGIN
;      plotregion_norm(1,1) = !Y.S(0)+ !Y.S(1)*ycoord(N_ELEMENTS(ycoord)-1)*  ArrayWidth/FLOAT(ArrayHeight)
      ;print,"hallo",plotregion_norm(1,1)
;   ENDIF
   plotregion_device = convert_coord(plotregion_norm,/NORM,/TO_DEVICE)
 

   VisualWidth = !D.X_VSIZE
   VisualHeight = !D.Y_VSIZE
   IF !P.MULTI(1) GT 0 AND !P.MULTI(2) GT 0 THEN BEGIN
      VisualWidth = !D.X_VSIZE/FLOAT(!P.MULTI(1))
      VisualHeight = !D.Y_VSIZE/FLOAT(!P.MULTI(2))
   ENDIF

   Default, XRANGE, [0, ArrayWidth-1]
   Default, YRANGE, [0, ArrayHeight-1]

   IF N_Elements(XRANGE) NE 2 THEN Message, 'wrong XRANGE argument'
   IF N_Elements(YRANGE) NE 2 THEN Message, 'wrong YRANGE argument'
   
   XRANGE(0) = XRANGE(0)-1+2*(XRANGE(0) GT XRANGE(1))
   XRANGE(1) = XRANGE(1)-1+2*(XRANGE(0) LE XRANGE(1))
   YRANGE(0) = YRANGE(0)-1+2*(YRANGE(0) GT YRANGE(1))
   YRANGE(1) = YRANGE(1)-1+2*(YRANGE(0) LE YRANGE(1))
   
   ;-----Behandlung der NASE und ORDER-Keywords:
   XBeschriftung = XRANGE
   IF keyword_set(ORDER) THEN BEGIN
      UpSideDown = 1
      YBeschriftung = REVERSE(YRANGE)
   ENDIF ELSE BEGIN
      UpSideDown = 0
      YBeschriftung = YRANGE
   ENDELSE
   IF (Keyword_Set(NASE)) AND (Keyword_Set(ORDER)) THEN BEGIN
      UpsideDown = 0 
      YBeschriftung = YRANGE
   ENDIF
   IF (Keyword_Set(NASE)) AND (NOT(Keyword_Set(ORDER)))THEN BEGIN
      YBeschriftung = REVERSE(YRANGE)
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
   IF Keyword_Set(LEGEND) THEN LegendRandDevice = LEGMARGIN*VisualWidth ELSE LegendRandDevice = 0.0
   
   ;print,LegendRandDevice
   ;IF N_Params() EQ 3 THEN OriginDevice = Convert_Coord([XPos,YPos], /Normal, /To_Device) $
   ;ELSE OriginDevice = [!X.Margin(0)*!D.X_CH_Size*Charsize,!Y.Margin(0)*!D.Y_CH_Size*Charsize]
   
   IF N_Params() EQ 3 THEN OriginDevice = Convert_Coord([plotregion_norm(0,0)+XPos,plotregion_norm(1,0)+YPos], /Normal, /To_Device) $
   ELSE OriginDevice = [plotregion_device(0,0),plotregion_device(1,0)]
   
   ;;UpRightDevice = [!X.Margin(1)*!D.X_CH_Size*Charsize,!Y.Margin(1)*!D.Y_CH_Size*Charsize]+[LegendRandDevice,0]
   UpRightDevice = [VISUALWIDTH -(plotregion_device(0,1)- plotregion_device(0,0)), VISUALHEIGHT-(plotregion_device(1,1)-plotregion_device(1,0))]+[LegendRandDevice,0]
   
   LegendRandNorm = Convert_Coord([LegendRandDevice,0], /Device, /To_Normal)
   OriginNormal = Convert_Coord(OriginDevice, /Device, /To_Normal)
   UpRightNormal = Convert_Coord(UpRightDevice, /Device, /To_Normal)
   
   RandNormal = OriginNormal + UpRightNormal
   
   PlotPositionDevice = FltArr(4)
   PlotPositionDevice(0) = OriginDevice(0)
   PlotPositionDevice(1) = OriginDevice(1)
   
   ;PixelSizeNormal = [(plotregion_norm(0,1))/float(ArrayWidth+1),(plotregion_norm(1,1))/float(ArrayHeight+1)]
   PixelSizeNormal = [(plotregion_norm(0,1)-plotregion_norm(0,0)-LegendRandNorm(0,0))/float(ArrayWidth+1),(plotregion_norm(1,1)-plotregion_norm(1,0))/float(ArrayHeight+1)]
   ;print,PixelSizeNormal,plotregion_device
   PixelSizeDevice = convert_coord(PixelSizeNormal, /normal, /to_device)
  

   ;-----Plotten des Koodinatensystems:
   IF Min(XRANGE) LT -1 THEN xtf = 'KeineGebrochenenTicks' ELSE xtf = 'KeineNegativenUndGebrochenenTicks'
   IF Min(YRANGE) LT -1 THEN ytf = 'KeineGebrochenenTicks' ELSE ytf = 'KeineNegativenUndGebrochenenTicks'
   PTMP = !P.MULTI
   !P.MULTI(0) = 1
   IF NOT Keyword_Set(FullSheet) THEN BEGIN 
      IF PixelSizeDevice(1)*(ArrayWidth+1)+UpRightDevice(0) LT VisualWidth THEN BEGIN
         PlotPositionDevice(2) = PixelSizeDevice(1)*(ArrayWidth+1)+OriginDevice(0)
         ;PlotPositionDevice(3) = VisualHeight - UpRightDevice(1)
         PlotPositionDevice(3) = plotregion_device(1,1)
         ;print, PlotPositionDevice,'hallo1'
      ENDIF ELSE BEGIN
         PlotPositionDevice(3) = PixelSizeDevice(0)*(ArrayHeight+1)+OriginDevice(1)
         ;PlotPositionDevice(2) = VisualWidth - UpRightDevice(0)
         PlotPositionDevice(2) = plotregion_device(0,1) - LegendRandDevice
         ;print,PlotPositionDevice,'hallo2'
      ENDELSE 

      Plot, indgen(2), /NODATA, Position=PlotPositionDevice, /Device, Color=sc, $
       xrange=XBeschriftung, /xstyle, xtickformat=xtf, $
       yrange=YBeschriftung, /ystyle, ytickformat=ytf, $
       XTICK_Get=Get_XTicks, YTICK_GET=Get_YTicks, charsize=charsize*charcor,_EXTRA=_extra
   ENDIF ELSE BEGIN
     ;print,LEGEND*0.2*Charsize,LegendRandNorm(0),"Hallo legende"
      Plot, indgen(2), /NODATA, Color=sc, Position=[OriginNormal(0),OriginNormal(1),plotregion_norm(0,1)-LegendRandNorm(0),plotregion_norm(1,1)], $
       xrange=XBeschriftung, /xstyle, xtickformat=xtf, $
       yrange=YBeschriftung, /ystyle, ytickformat=ytf, $
       XTICK_Get=Get_XTicks, YTICK_GET=Get_YTicks, charsize=charsize*charcor,_EXTRA=_extra
   ENDELSE
   !P.MULTI = PTMP
   Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]
   
   TotalPlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
   TotalPlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)
   ;TotalPlotWidthNormal = (plotregion_norm(0,1)-plotregion_norm(0,0)-LegendRandNorm(0,0))
   ;TotalPlotHeightNormal = (plotregion_norm(1,1)-plotregion_norm(1,0))

   PlotWidthNormal = TotalPlotWidthNormal - TotalPlotWidthNormal*2*!Y.Ticklen
   PlotHeightNormal = TotalPlotHeightNormal - TotalPlotHeightNormal*2*!X.Ticklen
   
   PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device)

   ;-----Plotten der UTVScl-Graphik:
   IF Keyword_Set(NASE) THEN BEGIN
      If Keyword_Set(NOSCALE) then BEGIN 
         UTV, Transpose(W), OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen,$
          X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM, Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM,$
          ORDER=UpSideDown, POLYGON=POLYGON
      END ELSE BEGIN
         UTV, ShowWeights_Scale(Transpose(W),SETCOL=setcol, COLORMODE=colormode), OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen, X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM,$
          Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM, ORDER=UpSideDown , POLYGON=POLYGON
      ENDELSE
   END ELSE BEGIN
      IF Keyword_Set(NEUTRAL) THEN BEGIN
         UTV, ShowWeights_Scale(W, SETCOL=setcol, COLORMODE=colormode), OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen, X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM, $
          Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM, ORDER=UpSideDown , POLYGON=POLYGON
      END ELSE BEGIN
         UTVScl, W, OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen, $
          X_SIZE=PlotAreaDevice(0)/!D.X_PX_CM, Y_SIZE=PlotAreaDevice(1)/!D.Y_PX_CM, $
          ORDER=UpSideDown, NOSCALE=NoScale, POLYGON=POLYGON, TOP=top
      END
   END
   Get_PixelSize = [2.0*TotalPlotWidthNormal*!Y.Ticklen, 2.0*TotalPlotHeightNormal*!X.Ticklen]

   GET_INFO = {x0      : 0                ,$
               y0      : 0                ,$
               x1      : long(PlotAreaDevice(0)),$
               y1      : long(PlotAreaDevice(1)),$
               x00     : long((OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen)*!D.X_SIZE),$
               y00     : long((OriginNormal(1)+TotalPlotWidthNormal*!Y.Ticklen)*!D.Y_SIZE),$ 
               tvxsize : long(PlotAreaDevice(0)),$
               tvysize : long(PlotAreaDevice(1)),$
               subxsize: long(2.0*TotalPlotWidthNormal*!Y.Ticklen*!D.X_SIZE),$
               subysize: long(2.0*TotalPlotHeightNormal*!X.Ticklen*!D.Y_SIZE)}
   Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]
   
   ;-----Legende, falls erwuenscht:
   IF Keyword_Set(LEGEND) THEN BEGIN
      IF Keyword_Set(NASE) THEN BEGIN
         IF (MaxW LT 0) OR (MinW LT 0) THEN BEGIN
            Default, LEG_MAX,  MAX([ABS(MaxW),ABS(MinW)])
            Default, LEG_MIN, -MAX([ABS(MaxW),ABS(MinW)])
            If LEG_MIN eq -LEG_MAX then Mid = '0'
            TVSclLegend, OriginNormal(0)+TotalPlotWidthNormal*1.15,OriginNormal(1)+TotalPlotHeightNormal/2.0, $
             H_Stretch=TotalPlotWidthNormal/15.0*VisualWidth/(0.5*!D.X_PX_CM), $
             V_Stretch=TotalPlotHeightNormal/4.0*VisualHeight/(2.5*!D.Y_PX_CM)*(1+!P.MULTI(2)), $
             Max=LEG_MAX, Min=LEG_MIN, Mid=Mid,$
             CHARSIZE=Charsize, $
             NOSCALE=NoScale, $
             /Vertical, /Center, COLOR=sc
         END ELSE BEGIN
            Default, LEG_MAX, MaxW
            Default, LEG_MIN, 0
            If LEG_MIN eq -LEG_MAX then Mid = '0'
            TVSclLegend, OriginNormal(0)+TotalPlotWidthNormal*1.15,OriginNormal(1)+TotalPlotHeightNormal/2.0, $
             H_Stretch=TotalPlotWidthNormal/15.0*VisualWidth/(0.5*!D.X_PX_CM), $
             V_Stretch=TotalPlotHeightNormal/4.0*VisualHeight/(2.5*!D.Y_PX_CM)*(1+!P.MULTI(2)), $
             Max=LEG_MAX, Min=LEG_MIN, MID=Mid, $
             CHARSIZE=Charsize, $
             NOSCALE=NoScale, $
             /Vertical, /Center, COLOR=sc
         END
      END  ELSE BEGIN; No-NASE
         Default, LEG_MAX, MAX(w)
         Default, LEG_MIN, MIN(w)
         IF Keyword_Set(NEUTRAL) THEN BEGIN
            IF (MaxW LT 0) OR (MinW LT 0) THEN BEGIN
               LEG_MAX = MAX([ABS(MaxW),ABS(MinW)])
               LEG_MIN = -LEG_MAX
            END ELSE LEG_MIN = 0
         END
         
         TVSclLegend, OriginNormal(0)+TotalPlotWidthNormal*1.15,OriginNormal(1)+TotalPlotHeightNormal/2.0, $
          H_Stretch=TotalPlotWidthNormal/15.*VisualWidth/(0.5*!D.X_PX_CM), $
          V_Stretch=TotalPlotHeightNormal/4.*VisualHeight/(2.5*!D.Y_PX_CM)*(1+!P.MULTI(2)), $
          Max=LEG_MAX, Min=LEG_MIN, $
          CHARSIZE=Charsize, $
          /Vertical, /Center, COLOR=sc 
      END
   END

   ;-----Restauration der urspruenglichen Device-Parameter
   !P.Region  = oldRegion 
   !X.TickLen = oldXTicklen 
   !Y.TickLen = oldYTicklen 
   !X.Minor   = oldXMinor  
   !Y.Minor   = oldYMinor   


;-----ENDE:
END
