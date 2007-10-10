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
;*           [, LEGMARGIN=...]
;*           [, /NEUTRAL]
;*           [, /POLYGON]
;*           [, CUBIC=...] [, /INTERP] [, /MINUS_ONE]
;*           [, LEG_MAX=...] [, LEG_MIN=...]
;*           [, COLORMODE=+/-1] [, SETCOL=0]
;*           [, TOP=...]
;*           [, RANGE_IN=[a,b] ]
;*           [, UPDATE_INFO=... [, /INIT ] [, /REDRAW_LEGEND] ]
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
;   (FULLSHEET)::DEPRICATED. Equivalent to (1-ISOPOTROPIC). Use
;                ISOTROPIC instead.
;     ISOTROPIC::Plot will have square pixels. Note that ISOTROPIC=1
;                is default for backwards compatibility. Use
;                ISOTROPIC=0 to explicitely turn off. See also IDL docu of ISOTROPIC.
;     NOSCALE::  Schaltet die Intensitaetsskalierung ab. Der Effekt ist identisch
;                mit dem Aufruf von <A>PlotTV</A>
;                Siehe dazu auch den Unterschied zwischen den Original-IDL-Routinen 
;                TVSCL und TV.
;     LEGEND::   Zeigt zusaetzlich eine <A NREF="TVSCLLEGEND">Legende</A> rechts neben der TVScl-Graphik
;                an. 
;     ORDER::    der gleiche Effekt wie bei Original-TVScl
;     NASE::     Setting this keyword is equivalent to setting
;                <C>/NORDER</C> and <C>/NSCALE</C> (see below). It is
;                maintained for backwards compatibility.<BR>
;                <I>Note: In general, newer applications sould use the
;                         <C>NORDER</C> and <C>NSCALE</C> keywords to
;                         indicate array ordering and color scaling
;                         according to NASE conventions.</I>
;     NEUTRAL::  Setting this keyword is equivalent to setting
;                <C>NORDER=0</C> and <C>/NSCALE</C> (see below). It is
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
;     LEGMARGIN:: Zusätzlicher rechter rand fuer die Legende. Wird auf
;                 !X.MARGIN[1] aufaddiert. Einheit ist die
;                 Schriftgröße, s. IDL-Doku von !X.MARGIN
;     leg_(max|min):: alternative Beschriftung der Legende 
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
;                 color index 0 (black).<BR>
;                 Note: Any value stored inside an initialized
;                 UPDATE_INFO-structure overrides this value, unless 
;                 you also specify /INIT.
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
;         /INIT:: When passing a structure in UPDATE_INFO, array 
;                 values are scaled according to the values
;                 contained in the PLOTTVSCL_INFO struct. /INIT
;                 forces the color scaling to be re-initialized, 
;                 i.e., the array (or any interval specified in
;                 RANGE_IN, respectively) is individually scaled
;                 to span all availabe color indices.
;                 The new scling is stored in the PLOTTVSCL_INFO 
;                 struct for subsequent calls.
; /REDRAW_LEGEND::When passing a structure in UPDATE_INFO, only the
;                 contents of the plot window are updated. In some
;                 cases, it might also be required to redraw
;                 the legend, (if plotting of a legend was originally
;                 requested). A common reason is, that the palette has
;                 been changed, so that the contents of the plot
;                 window will change colors. Setting this keyword
;                 initiates redrawing of the legend.
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

PRO PlotTvscl, _W, XPos, YPos, FULLSHEET=FullSheet, $
               ISOTROPIC=isotropic, CHARSIZE=Charsize, $
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
               REDRAW_LEGEND = redraw_legend, $
               ALLOWCOLORS=allowcolors, $
               _REF_EXTRA=_extra

   Common UTVScl_clipping, CLIPPEDABOVE, CLIPPEDBELOW

;;   On_Error, 2
   IF NOT Set(_W) THEN Message, 'Argument undefined'
   IF !D.Name EQ 'NULL' THEN RETURN
   
   
   Default, UPDATE_INFO, {PLOTTVSCL_INFO}


   ;; if struct is initialized, but colorscaling could not be
   ;; initialized yet, the legend must be redrawn:
   If (UPDATE_INFO.defined eq 1) and $
     a_eq(UPDATE_INFO.range_in, [-1d, -1d]) then $
     REDRAW_LEGEND = 1


   ;; we want some special things (not) to be done at the very first
   ;; call, so we define this:
   VERY_FIRST_CALL = (UPDATE_INFO.defined eq 0)


   If VERY_FIRST_CALL then begin
      ;; UPDATE_INFO either was not specified, or it was passed an empty
      ;; PLOTTVSCL_INFO struct. ("defined" is never 0 in a properly initialized 
      ;; PLOTTVSCL_INFO struct.)
      ;;This is a normal PlotTvScl-Call

      INIT = 1                  ; we want everything to be done: the
                                ; color scaling to be initialized
                                ; and the legend to be drawn, (if requested)

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

      ;;NEUTRAL is identical to /NSCALE, NORDER=0
      If keyword_Set(NEUTRAL) then begin
         NSCALE = 1
         NORDER = 0
      EndIf

      Default, SETCOL, 1
      Default, Charsize, 1.0
      Default, NOSCALE, 0
      Default, ORDER, 0
      Default, LEGEND, 0
      Default, legmargin, 5
      Default, Polygon,0
      DEFAULT, top, !TOPCOLOR
      Default, ISOTROPIC, 1-Keyword_Set(FULLSHEET)


      ;; Added for passing to PlotTvScl_update, R Kupper, Sep 22 1999
      default, CUBIC, 0
      default, INTERP, 0
      default, MINUS_ONE, 0
      default, COLORMODE, 0
      default, ALLOWCOLORS, 0

      ;; copying of _W is no longer necessary (it is done by
      ;; PlotTvScl_update), R Kupper, Sep 22 1999
      ;;   W = _W 

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
      ;;-----Behandlung der ORDER-Keywords:
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
      



      ;;-----Plotten des Koodinatensystems:
      IF Min(XRANGE) LT -1 THEN xtf = 'KeineGebrochenenTicks' ELSE xtf = 'KeineNegativenUndGebrochenenTicks'
      IF Min(YRANGE) LT -1 THEN ytf = 'KeineGebrochenenTicks' ELSE ytf = 'KeineNegativenUndGebrochenenTicks'
      if __isfloat(XRANGE) then xtf = ''
      if __isfloat(YRANGE) then ytf = ''

;;;;;;      PTMP = !P.MULTI
;;;;;;      !P.MULTI(0) = 1

      ;;-----zusätzlicher xmargin für die legende:
      XTMP = !X.MARGIN

      IF keyword_set(LEGEND) then !X.MARGIN[1] = !X.MARGIN[1]+LEGMARGIN

      Plot, indgen(2), /NODATA, $ ;Position=PlotPositionDevice,;/Device, $;Color=sc, $
            Isotropic=ISOTROPIC, $
            xrange=XBeschriftung, /xstyle, xtickformat=xtf, $
            yrange=YBeschriftung, /ystyle, ytickformat=ytf, $
            XTICK_Get=Get_XTicks, YTICK_GET=Get_YTicks, charsize=charsize*charcor,_EXTRA=_extra

;;;;;;;      !P.MULTI = PTMP

      !X.MARGIN = XTMP


      Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]
      

      OriginNormal = [(!X.Window)[0], (!Y.Window)[0]]



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
                     defined : 1b,$
                     $
                     OriginNormalX:        OriginNormal[0], $
                     OriginNormalY:        OriginNormal[1], $
                     $
                     TotalPlotWidthNormal: TotalPlotWidthNormal, $
                     TotalPlotHeightNormal:TotalPlotHeightNormal, $
                     $
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
                     norder  : NORDER, $
                     nscale  : NSCALE, $
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
                       range_in: [-1d, -1d], $ ; indicates uninitialized color scaling
                       $;;
                       $;;Data needed to (re)produce the legend:
                       charsize: CHARSIZE, $
                       legend: LEGEND, $
                       leg_min: 0.0, $ ;will be set below, see there!
                       leg_mid_str: '', $ ;will be set below, see there!
                       leg_max: 0.0, $ ;will be set below, see there!
                     $
                     clippedabove: -1, $
                     clippedbelow: -1 $
                       }

      GET_INFO = UPDATE_INFO    ;Kept for compatibility

      Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]
      ;;-------------------------------- End Optional Outputs

      
      ;;-----Restauration der urspruenglichen Device-Parameter
      !P.Region  = oldRegion 
      !X.TickLen = oldXTicklen 
      !Y.TickLen = oldYTicklen 
      !X.Minor   = oldXMinor  
      !Y.Minor   = oldYMinor   


   Endif;; keyword_set(UPDATE_INFO.defined)


   ;;-----Plotten der UTVScl-Graphik:
   PlotTvScl_update, INIT=init, _W, UPDATE_INFO, RANGE_IN=range_in

   clipping_changed = (CLIPPEDABOVE ne UPDATE_INFO.clippedabove) || (CLIPPEDBELOW ne UPDATE_INFO.clippedbelow)  
   UPDATE_INFO.clippedabove = CLIPPEDABOVE
   UPDATE_INFO.clippedbelow = CLIPPEDBELOW


   ;;------------ Handling of legend: ----------------------------

   ;; determine min, mid and max values for (an eventual) legend
   ;; draw. This must only be done, when /INIT or /REDRAW_LEGEND is set!
   If keyword_set(INIT) or keyword_set(REDRAW_LEGEND) then begin
      ;; if nothing was explicitely specified, we lable the legend
      ;; according to the range our array has been scaled to.
      ;; UPDATE_INFO.range_in has been updated accordingly by the
      ;; above PlotTvScl_update call:
      Default, LEG_MIN, UPDATE_INFO.range_in[0]
      Default, LEG_MAX, UPDATE_INFO.range_in[1]
      If LEG_MIN eq -LEG_MAX then leg_mid_str = '0' else $
        leg_mid_str = ''


      ;; store these values in the UPDATE_INFO struct:
      UPDATE_INFO.leg_min = LEG_MIN
      UPDATE_INFO.leg_max = LEG_MAX
      UPDATE_INFO.leg_mid_str = leg_mid_str

   EndIf

   ;;-----Legende plotten, falls erwuenscht und nötig:
   ;; Legende erwünscht?
   If Keyword_Set(UPDATE_INFO.legend) then begin
      ;; die Legende muß gezeichnet werden bei /REDRAW_LEGEND und auch
      ;; bei /INIT, oder wenn sich das clipping geändert hat:
      IF Keyword_Set(INIT) or Keyword_Set(REDRAW_LEGEND) or clipping_changed THEN BEGIN
         ;; Ist es ein RE-draw? Dann können sich die Legendenwerte
         ;; geändert haben, und wir müssen die alten auslöschen. wir
         ;; wollen das nicht beim allerersten Aufruf tun
         ;; (VERY_FIRST_CALL=1), da es dort überflüssig ist und in
         ;; PS-Files nicht die lästigen Farbkästen auftauchen.
         IF not VERY_FIRST_CALL THEN BEGIN
            ;; first opaque area for legend value plotting, in case this is an
            ;; update (all in normal):
            fill_left = UPDATE_INFO.OriginNormalX+UPDATE_INFO.TotalPlotWidthNormal*1.15
            fill_right = 1.0
            fill_bottom = UPDATE_INFO.OriginNormalY
            fill_top = 1.0
            PolyFill, [fill_left, fill_right, fill_right, fill_left], $
                      [fill_bottom, fill_bottom, fill_top, fill_top], $
                      /Normal, $
                      color=GetBackground()
         endif
         ;; now draw the legend:
         TVSclLegend, /Vertical, TOP=top, /YCenter, $
                      UPDATE_INFO.OriginNormalX+UPDATE_INFO.TotalPlotWidthNormal*1.15, $
                      UPDATE_INFO.OriginNormalY+UPDATE_INFO.TotalPlotHeightNormal/2.0, $
                      Norm_Y_Size=0.8*UPDATE_INFO.TotalPlotHeightNormal, $
                      Norm_X_Size=0.1*UPDATE_INFO.TotalPlotHeightNormal, $
                      Max=UPDATE_INFO.leg_max, $
                      Min=UPDATE_INFO.leg_min, $
                      Mid=UPDATE_INFO.leg_mid_str, $
                      CHARSIZE=Charsize, $
                      Clippedabove=UPDATE_INFO.clippedabove, $
                      Clippedbelow=UPDATE_INFO.clippedbelow
      ENDIF
   endif
   ;;----- end handling of legend -------------------------
   




END
