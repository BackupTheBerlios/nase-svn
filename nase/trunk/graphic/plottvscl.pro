;+
; NAME:
;  PlotTVScl
;
; VERSION:
;  $Id$
;
; AIM:
;  Color coded display of a two-dimensional array in a coordinate
;  system.
;
; PURPOSE:
;  TVScl-Darstellung eines Arrays zusammen mit einem
;          Koordinatensystem, Achsenbeschriftung und Legende
;
; CATEGORY: 
;  Graphic
;
; CALLING SEQUENCE: 
;*PlotTvScl, Array 
;*           [, XNorm] [, YNorm]
;*           [, CHARSIZE=Schriftgroesse]
;*           [, /FULLSHEET]
;*           [, /NOSCALE]
;*           [, /LEGEND]
;*           [, /ORDER]
;*           { {[,/NORDER] [,/NSCALE]} | [,/NASE] }
;*           [, XRANGE=...] [, YRANGE=...]
;*           [, GET_POSITION=...]
;*           [, GET_COLOR=...]
;*           [, GET_XTICKS=...] [, GET_YTICKS=...]
;*           [, GET_PIXELSIZE=...]
;*           [, GET_INFO=...]
;*           [, LAGMARGIN=...]
;*           [, /NEUTRAL]
;*           [, /POLYGON]
;*           [, CUBIC=...] [, /INTERP] [, /MINUS_ONE]
;*           [, LEG_MAX=...] [, LEG_MIN=...]
;*           [, COLORMODE=+/-1] [, SETCOL=0]
;*           [, TOP=...]
;*           [, RANGE_IN=[a,b] ]
;*           [, UPDATE_INFO=... [, /INIT ] ]
;*
;*           - all other Keywords are passed to the PLOT -
;*           - command, using the _REF_EXTRA mechanism,  -
;*           - for example: [X|Y]TITLE, SUBTITLE, ...    -
;
; INPUTS: 
;           Array:: klar!
;
; OPTIONAL INPUTS: 
;                  XNorm, YNorm:: Position der unteren linken Ecke des Plotkastens
;                                 in Normalkoordinaten.
;                                 Werden diese Werte angegeben, so hat der Anwender
;                                 selbst fuer ausreichenden Rand fuer Beschriftungen 
;                                 zu sorgen. Ohne Angabe von XNorm und YNorm wird
;                                 der Rand um den Plotkasten analog zur IDL-Plot-Routine
;                                 ermittelt.  
;                  Abszissen-, Ordinatentext:: klar!
;                  Schriftgroesse:: Faktor, der die Schriftgroesse in Bezug auf die
;                                   Standardschriftgroesse (1.0) angibt
;
; INPUT KEYWORDS: 
;     FULLSHEET::Nutzt fuer die Darstellung den ganzen zur Verfuegung stehenden 
;                Platz aus, TVScl-Pixel sind deshalb in dieser Darstellung in 
;                der Regel nicht quadratisch.
;     NOSCALE::  Schaltet die Intensitaetsskalierung ab. Der Effekt ist identisch
;                mit dem Aufruf von <A>PlotTV</A>
;                Siehe dazu auch den Unterschied zwischen den Original-IDL-Routinen 
;                TVSCL und TV.
;     LEGEND::   Zeigt zusaetzlich eine <A NREF="TVSCLLEGEND">Legende</A> rechts neben der TVScl-Graphik
;                an. 
;     ORDER::    der gleiche Effekt wie bei Original-TVScl
;     NASE::     Setting this keyword is equivalent to setting
;                <C>NORDER</C> and <C>NSCALE</C> (see below). It is
;                maintained for backwards compatibility.<BR>
;                <I>Note: In general, newer applications sould use the
;                         <C>NORDER</C> and <C>NSCALE</C> keywords to
;                         indicate array ordering and color scaling
;                         according to NASE conventions.</I>
;     NORDER::   Indicate that array ordering conforms to the NASE
;                convention: The indexing order is <*>[row,column]</*>, and
;                the origin will be displayed on the upper left corner
;                (unless <C>ORDER</C> is set, cf. IDL help on
;                <C>TvScl</C>).
;       NSCALE:: Request that colorscaling shall be done according to
;                NASE conventions: Before display, the array contents
;                will be scaled for display with the NASE colortables
;                (b/w linear or red/green linear by default). The
;                value <*>0</*> will always be mapped to black. In
;                addition, the appropriate NASE color table will be
;                loaded, unless <C>SETCOL</C><*>=0</*> is passed. (For
;                further information cf. <A>Showweights_Scale</A>.)<BR>
;                This keyword has no effect, if <C>/NOSCALE</C> is set.
;     [XY]RANGE:: zwei-elementiges Array zur alternative [XY]-Achsenbeschriftung:
;                das erste Element gibt das Minimum,
;                das zweite das Maximum der Achse an 
;     LEGMARGIN:: Raum fuer die Legende in Prozent des gesamten Plotbereichs (default: 0.25) 
;     leg_(max|min):: alternative Beschriftung der Legende 
;     NEUTRAL::   bewirkt die Darstellung mit NASE-Farbtabellen inclusive Extrabehandlung von
;                !NONE, ohne den ganzen anderen NASE-Schnickschnack
;     POLYGON:: Statt Pixel werden Polygone gezeichnet (gut fuer Postscript)
;                 /POLYGON setzt /CUBIC, /INTERP
;                 und /MINUS_ONE außer Kraft.
;     TOP::       Benutzt nur die Farbeintraege
;                 von 0..TOP (siehe IDL5-Hilfe von TvSCL)
;                 Dieses Schlüsselwort hat nur
;                 Bedeutung, wenn nicht eines
;                 der Schlüsselworte NASE,
;                 NEUTRAL oder NOSCALE gesetzt ist.
;     CUBIC, INTERP, MINUS_ONE:: 
;                 werden an ConGrid weitergereicht (s. IDL-Hilfe)
;     COLORMODE:: Wird an Showweights_scale
;                 weitergereicht. Mit diesem Schlüsselwort kann unabhängig 
;                 von den Werten im Array die
;                 schwarz/weiss-Darstellung (COLORMODE=+1) 
;                 oder die rot/grün-Darstellung
;                 (COLORMODE=-1) erzwungen werden.
;     SETCOL::    Default:1 Wird an ShowWeights_Scale weitergereicht, beeinflusst also, ob
;                 die Farbtabelle passend fuer den ArrayInhalt gesetzt wird, oder nicht.
;     RANGE_IN::  When passed, the two-element array is taken as the range to
;                 scale to the plotting colors. (I.e. the first element is scaled to
;                 color index 0, the scond is scaled to the highest available
;                 index (or to TOP in the no-NASE, no-NEUTRAL, no-NOSCALE 
;                 case)).
;                 Note that when NASE or NEUTRAL is specified, only the highest
;                 absolute value of the passed array is used, as according to NASE 
;                 conventions, the value 0 is always mapped to
;                 color index 0 (black).
;                 If used in conjunction with UPDATE_INFO, this
;                 keyword overrides the values regarding color
;                 scaling that are part of the PLOTTVSCL_INFO
;                 struct. However, the new scaling is valid for
;                 this call only, and is not stored in the
;                 struct, unless you also specify /INIT.
;   UPDATE_INFO:: When omitted, undefined, or passend an empty
;                 PLOTTVSCL_INFO structure, the call acts like
;                 a normal PlotTvScl call. Axes as well as the
;                 array are plotted.
;                   This keyword acts as an optional output
;                 also. A <A>PLOTTVSCL_INFO</A> struct is returned,
;                 containing information on keywords, plot
;                 positions and color scaling. When this strict
;                 is passed with the next call to PlotTvScl,
;                 only the array is re-plotted, and the new
;                 array is scaled in the ranges of the original
;                 array. (I.e. the colors of the two plots are
;                 directly comparable. See also keywords
;                 RANGE_IN and INIT.)
;                   When UPDATE_INFO is set, all keywords execept
;                 RANGE_IN and INIT are silently overriden by
;                 the values contained in the PLOTTVSCL_INFO
;                 struct.
;                   Note that calling PlotTvScl with keyword
;                 UPDATE_INFO set to a defined structure is
;                 equivalent to calling PlotTvScl_Update on this 
;                 structure. The UPDATE_INFO keyword is supplied 
;                 for convenience.
;                   If you intend to store UPDATE_INFO
;                 structures in an array or another structure,
;                 use the zeroed structure '{PLOTTVSCL_INFO}' as
;                 initial value. This value will be treated as
;                 if an undefined variable was passed to
;                 UPDATE_INFO. When storing in another
;                 structure, note also that structure tags are
;                 passed by value in IDL. You need to use a
;                 temporary variable. (See IDL Reference Manual,
;                 chapter "Parameter Passing with Structures", sic!)
;          INIT:: When passing a structure in UPDATE_INFO, array 
;                 values are scaled according to the values
;                 contained in the PLOTTVSCL_INFO struct. /INIT
;                 forces the color scaling to be re-initialized, 
;                 i.e., the array (or any interval specified in
;                 RANGE_IN, respectively) is individually scaled
;                 to span all availabe color indices.
;                 The new scling is stored in the PLOTTVSCL_INFO 
;                 struct for subsequent calls.
;  /ALLOWCOLORS:: Passed to <A>UTvScl</A>, see there.
;
; OPTIONAL OUTPUTS:
;                 
;                   GET_POSITION::  Ein vierelementiges Array [x0,y0,x1,y1], das die untere linke (x0,y0)
;                                   und die obere rechte Ecke (x1,y1) des Bildbereichs in Normalkoordinaten
;                                   zurueckgibt.
;                   GET_COLOR::     Gibt den Farbindex, der beim Zeichnen der Achsen verwendet wurde, zurueck.
;                   GET_[XY]Ticks:: Ein Array, das die Zahlen enthaelt, mit denen die jeweilige Achse
;                                   ohne die Anwendung der 'KeineNegativenUndGebrochenenTicks'-Funktion
;                                   beschriftet worden waere. 
;                   GET_PIXELSIZE:: Ein zweielementiges Array [XSize, YSize], das die Groesse der
;                                   TV-Pixel in Normalkoordinaten
;                                   zurueckliefert.
;                   GET_INFO::      Kept for compatibility reasons. This keyword
;                                   is obsolete. The value returned is the same as 
;                                   returned by the UPDATE_INFO keyword. Use
;                                   UPDATE_INFO instead.
;
;
; PROCEDURE: 
;* 1. Ermitteln des fuer die Darstellung zur Verfuegung stehenden Raums.
;* 2. Zeichnen der Achsen an der ermittelten Position.
;* 3. Ausfuellen mit einer entsprechend grossen UTVScl-Graphik
;* 4. Legende hinzufuegen 
;
; SIDE EFFECTS:
;  If <C>/NASE</C> or <C>/NSCALE</C> is set, and unless <C>SETCOL</C><*>=0</*> is passed, the
;  appropriate NASE color table is loaded.
;
; EXAMPLE: 
;*          width = 25
;*          height = 50
;*          W = gauss_2d(width, height)+0.01*randomn(seed,width, height)
;*          window, xsize=500, ysize=600
;*          PlotTvScl, W, 0.0, 0.1, XTITLE='X-ACHSEN-Beschriftungstext', /LEGEND, CHARSIZE=2.0
;
;
; SEE ALSO: <A>PlotTV</A>, <A>UTVScl</A>, <A>TVSclLegend</A>,
;           <A>PlotTVScl_update</A>            
;-

function __isfloat, value
   COMPILE_OPT HIDDEN
   type =  last(size(value),pos=-1)
   return, (type eq 4) or (type eq 5)     
end 

PRO PlotTvscl, _W, XPos, YPos, FULLSHEET=FullSheet, CHARSIZE=Charsize, $
               LEGEND=Legend, ORDER=Order, NASE=Nase, NOSCALE=NoScale, $
               NORDER=norder, NSCALE=nscale, $
               XRANGE=_xrange, YRANGE=_yrange, $
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
               RANGE_IN=range_in, $
               UPDATE_INFO=update_info, $
               INIT=init, $
               ALLOWCOLORS=allowcolors, $
               _REF_EXTRA=_extra

;;   On_Error, 2
   IF NOT Set(_W) THEN Message, 'Argument undefined'
   IF !D.Name EQ 'NULL' THEN RETURN
   
   
   Default, UPDATE_INFO, {PLOTTVSCL_INFO}

   If UPDATE_INFO.defined eq 0 then begin
      ;; UPDATE_INFO either was not specified, or it was passed an empty
      ;; PLOTTVSCL_INFO struct. ("defined" is never 0 in a properly initialized 
      ;; PLOTTVSCL_INFO struct.)
      ;;This is a normal PlotTvScl-Call

      INIT = 1                  ; we want the color scaling to be initialized

      ;;-----Sichern der urspruenglichen Device-Parameter
      oldRegion   = !P.Region
      oldXTicklen = !X.TickLen 
      oldYTicklen = !Y.TickLen 
      oldXMinor   = !X.Minor
      oldYMinor   = !Y.Minor
      

      Get_Color = !P.COLOR ;;kept for compatibility
      

      ;;NASE implies NORDER and NSCALE:
      Default, NASE, 0
      Default, NORDER, NASE
      Default, NSCALE, NASE

      Default, SETCOL, 1
      Default, Charsize, 1.0
      Default, NOSCALE, 0
      Default, ORDER, 0
      Default, LEGEND, 0
      Default, legmargin,0.25
      Default, Polygon,0
      DEFAULT, top, !TOPCOLOR

      ;; Added for passing to PlotTvScl_update, R Kupper, Sep 22 1999
      default, CUBIC, 0
      default, INTERP, 0
      default, MINUS_ONE, 0
      default, COLORMODE, 0
      default, NEUTRAL, 0
      default, ALLOWCOLORS, 0

      ;; copying of _W is no longer necessary (it is done by
      ;; PlotTvScl_update), R Kupper, Sep 22 1999
      ;;   W = _W 
      IF (Keyword_Set(NSCALE) OR Keyword_Set(NEUTRAL)) THEN BEGIN
         maxW = Max(_W)
         minW = Min(NoNone_Func(_W))
      END

      IF Keyword_Set(NORDER) THEN BEGIN
         ArrayHeight = (size(_w))(1)
         ArrayWidth  = (size(_w))(2)
      END ELSE BEGIN
         ArrayHeight = (size(_w))(2)
         ArrayWidth  = (size(_w))(1)
      END
      
      
      charcor = 1.
      IF !P.MULTI(1) GT 0  AND !P.MULTI(2) GT 0 THEN charcor =sqrt(1./FLOAT(!P.MULTI(1)))
      ;;print,charcor
      xcoord = lindgen(ArrayWidth)
      ycoord = lindgen(ArrayHeight)
      PLOT,xcoord,ycoord,/XSTYLE,/YSTYLE,/NODATA,COLOR=GetBackground(), Charsize=Charsize*charcor,_EXTRA=_extra

      plotregion_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
      ;;only whole pixel or points exist
      plotregion_device = (convert_coord(plotregion_norm,/NORM,/TO_DEVICE))
      plotregion_norm = uconvert_coord(plotregion_device,/TO_NORM,/DEVICE)

      VisualWidth = !D.X_VSIZE
      VisualHeight = !D.Y_VSIZE
      IF !P.MULTI(1) GT 0 AND !P.MULTI(2) GT 0 THEN BEGIN
         VisualWidth = !D.X_VSIZE/FLOAT(!P.MULTI(1))
         VisualHeight = !D.Y_VSIZE/FLOAT(!P.MULTI(2))
      ENDIF

      Default, _XRANGE, [0, ArrayWidth-1]
      Default, _YRANGE, [0, ArrayHeight-1]
      xrange = _XRANGE
      yrange = _YRANGE

      IF N_Elements(XRANGE) NE 2 THEN Message, 'wrong XRANGE argument'
      IF N_Elements(YRANGE) NE 2 THEN Message, 'wrong YRANGE argument'

      ;;for fractional xrange or yrange we need another labeling 

      if __isfloat(XRANGE) then x_corr = abs(XRANGE(0)-XRANGE(1))/FLOAT(ArrayWidth-1) else x_corr = 1l
      if __isfloat(YRANGE) then y_corr = abs(YRANGE(0)-YRANGE(1))/FLOAT(ArrayHeight-1) else   y_corr = 1l

      XRANGE(0) = XRANGE(0)-1*x_corr+2*x_corr*(XRANGE(0) GT XRANGE(1))
      XRANGE(1) = XRANGE(1)-1*x_corr+2*x_corr*(XRANGE(0) LE XRANGE(1))
      YRANGE(0) = YRANGE(0)-1*y_corr+2*y_corr*(YRANGE(0) GT YRANGE(1))
      YRANGE(1) = YRANGE(1)-1*y_corr+2*y_corr*(YRANGE(0) LE YRANGE(1))   
      ;;-----Behandlung der NASE und ORDER-Keywords:
      XBeschriftung = XRANGE
      IF keyword_set(ORDER) THEN BEGIN
         UpSideDown = 1
         YBeschriftung = REVERSE(YRANGE)
      ENDIF ELSE BEGIN
         UpSideDown = 0
         YBeschriftung = YRANGE
      ENDELSE
      IF (Keyword_Set(NORDER)) AND (Keyword_Set(ORDER)) THEN BEGIN
         UpsideDown = 0 
         YBeschriftung = YRANGE
      ENDIF
      IF (Keyword_Set(NORDER)) AND (NOT(Keyword_Set(ORDER)))THEN BEGIN
         YBeschriftung = REVERSE(YRANGE)
         UpSideDown = 1 
      ENDIF 
      

      ;;-----Laenge und Anzahl der Ticks:
      !Y.TickLen = Max([1.0/(ArrayWidth+1)/2.0,0.01])
      !X.TickLen = Max([1.0/(ArrayHeight+1)/2.0,0.01])
      
      IF ArrayHeight GE 15 THEN !Y.Minor = 0 ELSE $
       IF ArrayHeight GE 7 THEN !Y.Minor = 2 ELSE !Y.Minor=-1
      
      IF ArrayWidth GE 15 THEN !X.Minor = 0 ELSE $
       IF ArrayWidth GE 7 THEN !X.Minor = 2 ELSE !X.Minor=-1
      

      ;;-----Raender und Koordinaten des Ursprungs:
      IF Keyword_Set(LEGEND) THEN LegendRandDevice = LEGMARGIN*VisualWidth ELSE LegendRandDevice = 0.0
      
          
      IF N_Params() EQ 3 THEN OriginDevice = (uConvert_Coord([XPos,YPos], /Normal, /To_Device)) $
      ELSE OriginDevice = [plotregion_device(0,0),plotregion_device(1,0)]
   
     
      UpRightDevice = ([VISUALWIDTH -(plotregion_device(0,1)- plotregion_device(0,0)), $
                        VISUALHEIGHT-(plotregion_device(1,1)-plotregion_device(1,0))]+[LegendRandDevice,0])
       
      LegendRandNorm = uConvert_Coord([LegendRandDevice,0], /Device, /To_Normal)
      OriginNormal = uConvert_Coord(OriginDevice, /Device, /To_Normal)
      UpRightNormal = uConvert_Coord(UpRightDevice, /Device, /To_Normal)
      
      RandNormal = OriginNormal + UpRightNormal
      
      PlotPositionDevice = FltArr(4)
      PlotPositionDevice(0) = OriginDevice(0)
      PlotPositionDevice(1) = OriginDevice(1)
      
     
      PixelSizeNormal = [(plotregion_norm(0,1)-OriginNormal(0)-LegendRandNorm(0,0))/float(ArrayWidth+1),$
                         (plotregion_norm(1,1)-OriginNormal(1))/float(ArrayHeight+1)]
      
      PixelSizeDevice = (uconvert_coord(PixelSizeNormal, /normal, /to_device))
    

      ;;-----Plotten des Koodinatensystems:
      IF Min(XRANGE) LT -1 THEN xtf = 'KeineGebrochenenTicks' ELSE xtf = 'KeineNegativenUndGebrochenenTicks'
      IF Min(YRANGE) LT -1 THEN ytf = 'KeineGebrochenenTicks' ELSE ytf = 'KeineNegativenUndGebrochenenTicks'
      if __isfloat(XRANGE) then xtf = ''
      if __isfloat(YRANGE) then ytf = ''

      PTMP = !P.MULTI
      !P.MULTI(0) = 1
      IF NOT Keyword_Set(FullSheet) THEN BEGIN 
         MinPixelSizeDevice = min(PixelSizeDevice(0:1)) ;;PixelSizeDevice contains Z-Value=0
         PlotPositionDevice(2) = MinPixelSizeDevice*(ArrayWidth+1)+OriginDevice(0)
         PlotPositionDevice(3) = MinPixelSizeDevice*(ArrayHeight+1)+OriginDevice(1)
        
         Plot, indgen(2), /NODATA, Position=PlotPositionDevice, /Device, $;Color=sc, $
          xrange=XBeschriftung, /xstyle, xtickformat=xtf, $
          yrange=YBeschriftung, /ystyle, ytickformat=ytf, $
          XTICK_Get=Get_XTicks, YTICK_GET=Get_YTicks, charsize=charsize*charcor,_EXTRA=_extra
      ENDIF ELSE BEGIN
         
         Plot, indgen(2), /NODATA, $;Color=sc, $
          Position=[OriginNormal(0),OriginNormal(1),plotregion_norm(0,1)-LegendRandNorm(0),plotregion_norm(1,1)], $
          xrange=XBeschriftung, /xstyle, xtickformat=xtf, $
          yrange=YBeschriftung, /ystyle, ytickformat=ytf, $
          XTICK_Get=Get_XTicks, YTICK_GET=Get_YTicks, charsize=charsize*charcor,_EXTRA=_extra
      ENDELSE
      !P.MULTI = PTMP
      Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]
      
      TotalPlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
      TotalPlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)
 
      PlotWidthNormal = TotalPlotWidthNormal - TotalPlotWidthNormal*2*!Y.Ticklen
      PlotHeightNormal = TotalPlotHeightNormal - TotalPlotHeightNormal*2*!X.Ticklen
      
      PlotAreaDevice = (uConvert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device))

      
      ;; it seems that Ticklen is measured without the border line
      ;; so we have to add one pixel (point) for the right positioning
      borderthick_norm = uConvert_Coord([1., 1.], /DEVICE, /to_normal)


      ;;------------------> Optional Outputs
      Get_PixelSize = [2.0*TotalPlotWidthNormal*!Y.Ticklen, 2.0*TotalPlotHeightNormal*!X.Ticklen]

      UPDATE_INFO = {PLOTTVSCL_INFO, $
                     defined : 1b               ,$
                     x1      : long(PlotAreaDevice(0)),$
                     y1      : long(PlotAreaDevice(1)),$
                     $;;
                     $;; R Kupper, Sep 21 1999:
                     $;;   Found something looking like copy&paste-error.
                     $;;   Don't know if it was meant to be so.
                     $;;   It looked like this:
                     $;;              x00     : long((OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen)*!D.X_SIZE),$
                     $;;              y00     : long((OriginNormal(1)+TotalPlotWidthNormal*!Y.Ticklen)*!D.Y_SIZE),$ 
                     $;;   Changed it to:                   
                     $;;
                     x00     : long((OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen)*!D.X_SIZE),$
                     y00     : long((OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen)*!D.Y_SIZE),$ 
                     x00_norm:  OriginNormal(0)+TotalPlotWidthNormal*!Y.Ticklen+borderthick_norm(0),$
                     y00_norm:  OriginNormal(1)+TotalPlotHeightNormal*!X.Ticklen+borderthick_norm(1),$ 
                     tvxsize : long(PlotAreaDevice(0)),$
                     tvysize : long(PlotAreaDevice(1)),$
                     subxsize: long(2.0*TotalPlotWidthNormal*!Y.Ticklen*!D.X_SIZE),$
                     subysize: long(2.0*TotalPlotHeightNormal*!X.Ticklen*!D.Y_SIZE), $
                     $;;
                     $;; Keywords to be passed to PlotTvScl_update:
                     order   : ORDER, $
                     nase    : NASE, $
                     norder  : NORDER, $
                     nscale  : NSCALE, $
                     neutral : NEUTRAL, $
                     noscale : NOSCALE, $
                     polygon : POLYGON, $
                     top     : TOP, $
                     cubic   : float(CUBIC), $
                     interp  : INTERP, $
                     minus_one: MINUS_ONE, $
                     colormode: COLORMODE, $
                     setcol  : SETCOL, $
                     allowcolors : ALLOWCOLORS, $
                     $;;
                     $;; Scaling Information to be stored by PlotTvScl_update:
                     range_in: [-1.0d, -1.0d], $
                       $;;
                       $;;Data needed to (re)produce the legend:
                       leg_x: OriginNormal[0]+TotalPlotWidthNormal*1.15, $
                       leg_y: OriginNormal[1]+TotalPlotHeightNormal/2.0, $
                       leg_hstretch: TotalPlotWidthNormal/15.0*VisualWidth/(0.5*!D.X_PX_CM), $
                       leg_vstretch: TotalPlotHeightNormal/4.0*VisualHeight/(2.5*!D.Y_PX_CM)*(1+!P.MULTI(2)), $
                       charsize: CHARSIZE, $
                       legend: LEGEND $
                       }

      Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]
      ;;-------------------------------- End Optional Outputs

      
      ;;-----Restauration der urspruenglichen Device-Parameter
      !P.Region  = oldRegion 
      !X.TickLen = oldXTicklen 
      !Y.TickLen = oldYTicklen 
      !X.Minor   = oldXMinor  
      !Y.Minor   = oldYMinor   


   Endif;; keyword_set(UPDATE_INFO.defined)



   ;;-----Legende, falls erwuenscht und nötig:
   IF Keyword_Set(INIT) and Keyword_Set(UPDATE_INFO.legend) THEN BEGIN
      
      ;; first opaque area for legend value plotting, in case this is an
      ;; update (all in normal):
      fill_left = UPDATE_INFO.leg_x
      fill_right = 1.0
      fill_bottom = 0.0
      fill_top = 1.0
      PolyFill, [fill_left, fill_right, fill_right, fill_left], $
                [fill_bottom, fill_bottom, fill_top, fill_top], $
                /Normal, $
                color=GetBackground()
      
      IF Keyword_Set(NSCALE) THEN BEGIN
         IF (MaxW LT 0) OR (MinW LT 0) THEN BEGIN
            Default, LEG_MAX,  MAX([ABS(MaxW), ABS(MinW)])
            Default, LEG_MIN, -MAX([ABS(MaxW), ABS(MinW)])
            If LEG_MIN eq -LEG_MAX then Mid = '0'
            TVSclLegend, UPDATE_INFO.leg_x, $
                         UPDATE_INFO.leg_y, $
                         H_Stretch=UPDATE_INFO.leg_hstretch, $
                         V_Stretch=UPDATE_INFO.leg_vstretch, $
                         Max=LEG_MAX, Min=LEG_MIN, Mid=Mid, $
                         CHARSIZE=Charsize, $
                         $;;NOSCALE=NoScale, $
                         /Vertical, /Center
         END ELSE BEGIN
            Default, LEG_MAX, MaxW
            Default, LEG_MIN, 0
            If LEG_MIN eq -LEG_MAX then Mid = '0'
            TVSclLegend, UPDATE_INFO.leg_x, $
                         UPDATE_INFO.leg_y, $
                         H_Stretch=UPDATE_INFO.leg_hstretch, $
                         V_Stretch=UPDATE_INFO.leg_vstretch, $
                         Max=LEG_MAX, Min=LEG_MIN, MID=Mid, $
                         CHARSIZE=Charsize, $
                         $;;NOSCALE=NoScale, $
                         /Vertical, /Center
         ENDELSE
      ENDIF  ELSE BEGIN;; No-NASE
         Default, LEG_MAX, MAX(_w)
         Default, LEG_MIN, MIN(_w)
         IF Keyword_Set(NEUTRAL) THEN BEGIN
            IF (MaxW LT 0) OR (MinW LT 0) THEN BEGIN
               LEG_MAX = MAX([ABS(MaxW), ABS(MinW)])
               LEG_MIN = -LEG_MAX
            END ELSE LEG_MIN = 0
         END
         
         
         TVSclLegend, UPDATE_INFO.leg_x, $
                      UPDATE_INFO.leg_y, $
                      H_Stretch=UPDATE_INFO.leg_hstretch, $
                      V_Stretch=UPDATE_INFO.leg_vstretch, $
                      Max=LEG_MAX, Min=LEG_MIN, $
                      CHARSIZE=Charsize, $
                      /Vertical, /Center, TOP=top
      ENDELSE
   ENDIF
   
   
   


   ;;-----Plotten der UTVScl-Graphik:
   PlotTvScl_update, INIT=init, _W, UPDATE_INFO, RANGE_IN=range_in
   GET_INFO = UPDATE_INFO       ;Kept for compatibility


END
