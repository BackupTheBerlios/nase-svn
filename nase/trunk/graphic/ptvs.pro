;+
; NAME:
;  PTvS
;
; VERSION:
;  $Id$
;
; AIM:
;  Color coded display of a two-dimensional array in a coordinate
;  system (no NASE support, less bugs).
;
; PURPOSE:
;  Color coded display of a two-dimensional array in a coordinate
;  system. This version is similar to <A>PlotTVScl</A> but fixes 
;  several serious design bugs, has a cleaner code, but does not support
;  any NASE options.
;
; CATEGORY: 
;  Graphic
;
; CALLING SEQUENCE: 
;*Ptvs, data 
;*      [,XNorm] [,YNorm]
;*      [,/QUADRATICPIXEL]
;*      [,/FITPLOT]
;*      [,/NOSCALE]
;*      [,/LEGEND] [,LEGMARGIN=...] [,LEG_MIN=...] [, LEG_MAX=...]
;*      [,XRANGE=...] [,YRANGE=...] [,ZRANGE=...]
;*      [,CHARSIZE=...]
;*      [,/ORDER]
;*      [,/POLYGON]
;*      [,CUBIC=...] [, /INTERP] [, /MINUS_ONE]
;*      [,TOP=...]
;*      [,GET_POSITION=...] [,GET_PIXELSIZE=...]
;*
;* all other Keywords are passed to <C>PLOT</C>
;
; INPUTS: 
;  data:: two-dimensional array
;
; OPTIONAL INPUTS: 
;  XNorm, YNorm:: Specify the lower left corner of the plotregion used
;                 by <C>PTvS</C> in normal coordinates. The user
;                 himself has to care for sufficient space for labels.  
;
; INPUT KEYWORDS: 
;  CHARSIZE:: The overall character size for the annotation (default: <*>!P.CHARSIZE</*>)
;  FITPLOT :: The standard behavior of this routine is to plot the
;             coordinate system outside the bitmap, with the tickmarks
;             touching the border of the bitmap. Turning on this
;             option, the bitmap will touch the axes, instead, with
;             the tickmarks plotted above the bitmap.
;  LEGEND   :: displays a legend on the very right of the plot (using <A>TvSclLegend</A>) 
;  LEGMARGIN:: set the space that is used for the legend in normal
;              coordinates of the plot region (<*>/LEGEND</*>
;              has to be set, default: 0.15) 
;  LEGMIN,LEGMAX:: alternative labels for the legend (<*>/LEGEND</*>
;                  has to be set)
;  NOSCALE :: Turns off scaling. Please use <A>PTv</A> instead. 
;  ORDER     :: If specified, ORDER overrides the current setting of
;               the !ORDER system variable for the current image only.
;               If set, the image is drawn from the top down instead
;               of the normal bottom up.
;  POLYGON   :: If producing postscript as output device, <A>UTV</A> and its partners
;               produce bitmap output. With this option, the bitmap is
;               composed of polygon (each pixel a filled
;               polygon). This is advantageous, if you want to edit
;               the pixels with a vector drawing program like
;               COREL. Note, that setting this option disables the
;               function of <*>/CUBIC</*>, <*>/INTERP</*> and <*>/MINUS_ONE</*>.
;  QUADRATIC :: the pixels of the bitmap will be quadratic  
;  TOP       :: uses the colormap entries from 0 up to TOP (default:
;               <*>!TOPCOLOR</*>). This does't do anything, if
;               <*>/NOSCALE</*> is set. 
;  [XY]RANGE :: array containing two elements (minimum, maximum value)
;               for an alternative [XY]-axis labeling. 
;  ZRANGE    :: Minimum and maximum value to scale the
;               <*>data</*>. The minimum will be scaled to color index
;               0, the maximum to <*>TOP</*> or <*>!TOPCOLOR</*>. The
;               passed range has to be larger than the actual scaling
;               of <*>data</*>. 
;  CUBIC, INTERP, MINUS_ONE:: will be passed to IDL routine
;                            <C>ConGrid</C>, to smooth the
;                            bitmap. This only works, if
;                            <*>/POLYGON</*> is not set.   
;
; OPTIONAL OUTPUTS:
;  GET_POSITION:: a four-element array [x0,y0,x1,y1], specifying the
;                 lower left and upper right corner of the plot in
;                 normal coordinates.
;  GET_PIXELSIZE:: an array [XSize, YSize], specifying the size of one
;                  bitmap pixel in normal coordinates
;
; PROCEDURE: 
;  1. compute the plot region<BR>
;  2. set up the coordinate system and plot axes <BR>
;  3. paste bitmap via <A>UTVScl</A><BR>
;  4. add a legend 
;
; EXAMPLE: 
;*x=randomn(seed,300,20)       
;*balancect, x
;*ptvs, x, /legend
;*plots, [0,299], [0,19], COLOR=RGB("white")
;
;
; SEE ALSO: <A>PTV</A>, <A>PlotTV</A>, <A>UTVScl</A>, <A>TVSclLegend</A>,
;           <A>Plottvscl_update</A>            
;-
;;;;
;;;;!!!!!!! PLEASE ALSO UPDATE THE HEADER OF PTV ACCORDINGLY  !!!!!!!!!!
;;;;

PRO PTvS, data, XPos, YPos, $
          QUADRATIC=quadratic, $
          FITPLOT=fitplot, $
          NOSCALE=NoScale, TOP=top, $
          ORDER=Order, $
          Color=color, CHARSIZE=_Charsize, $
          XRANGE=_xrange, YRANGE=_yrange, ZRANGE=_zrange, $
          LEGEND=Legend, LEGMARGIN=LEGMARGIN, LEGMIN=legmin, LEGMAX=legmax, $
          POLYGON=POLYGON, $
          CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, $
          GET_Position=Get_Position, GET_PIXELSIZE=Get_PixelSize, $
          _REF_EXTRA=_extra

   On_Error, 2

   IF !D.Name EQ 'NULL' THEN RETURN

   ;;;   
   ;;; check the passed array
   ;;;
   IF NOT Set(data) THEN Console, 'argument undefined', /FATAL
   hdata = (size(data))(2)
   wdata = (size(data))(1)
   

   ;;;   
   ;;; assure default settings
   ;;;
   Default, _Charsize, !P.CHARSIZE
                                ; lower the passed or default charsize, when there are multiple
                                ; plots per window
   IF (!P.MULTI(1) GT 1  AND !P.MULTI(2) GT 1) THEN Charsize = _Charsize*sqrt(1./FLOAT(!P.MULTI(1))) $
                                               ELSE Charsize = _Charsize



   Default, _XRANGE, [0, wdata-1]
   Default, _YRANGE, [0, hdata-1]

   Default, COLOR, GetForeground()
   Default, LEGMARGIN, 0.15

   DEFAULT, top, !TOPCOLOR

   ;; defaults passed UTV(SCL)
   Default, ORDER, 0
   Default, Polygon,0
   default, CUBIC, 0
   default, INTERP, 0
   default, MINUS_ONE, 0


   ;; save orginal plot parameters for a later restore 
;   oldRegion   = !P.Region
;   oldXTicklen = !X.TickLen 
;   oldYTicklen = !Y.TickLen 
;   oldXMinor   = !X.Minor
;   oldYMinor   = !Y.Minor
   

   ;; set ticks and their lengths
   !X.TickLen = 0.02            ; temporarily set ticklen to a reasonable value, it may contain strange values  
   !Y.TickLen = 0.02            ; this will be changed later


;   IF hdata GE 15 THEN !Y.Minor = 0 ELSE $
;     IF hdata GE 7 THEN !Y.Minor = 2 ELSE !Y.Minor=-1   
;   IF wdata GE 15 THEN !X.Minor = 0 ELSE $
;     IF wdata GE 7 THEN !X.Minor = 2 ELSE !X.Minor=-1
   
   

   ;; need to get plot positions, because they may be unset, when no
   ;; plot has already been done. This is important for an initial
   ;; guesstimation of the width-to-height ratio... 
   ;; ?XSTYLE=5 assures to no coordinate system is actually plotted
   PLOT, [0,1], XRANGE=_xrange, YRANGE=_yrange, XSTYLE=5, YSTYLE=5, /NODATA, CHARSIZE=Charsize 
                                ; i omitted _EXTRA=extra because a
                                ; [xy]title might be plotted, if it
                                ; does't work this way, you have to
                                ; remove all titles from the extra variable  
   
   xyrange_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
   xyrange_dev = (convert_coord(xyrange_norm,/NORM,/TO_DEVICE))
   xyrange_norm = uconvert_coord(xyrange_dev,/TO_NORM,/DEVICE) ;;only whole pixel or points exist
              ;;; NOTE: xyrange_??? = ([x,y,z],[lower_left_corner,upper_right_corner])
   

   ;; Visual is the total place available for the plot (device coordinates)
   Visual = DOUBLE([!D.X_VSIZE, !D.Y_VSIZE])
   IF ((!P.MULTI(1) GT 1) AND (!P.MULTI(2) GT 1)) THEN BEGIN
       Visual(0) = Visual(0)/DOUBLE(!P.MULTI(1))
       Visual(1) = Visual(1)/DOUBLE(!P.MULTI(2))
   ENDIF
   
   
   ;; legwidth: width that is reserved for the legend
   IF Keyword_Set(LEGEND) THEN legwidth_dev = LEGMARGIN*Visual(0) $
                          ELSE legwidth_dev = 0.0
   legwidth_norm = UConvert_Coord([legwidth_dev,0], /Device, /To_Normal)
   

   
   ;; origin : lower left corner of coordinate system 
   IF N_Params() EQ 3 THEN Origin_dev = (uConvert_Coord([XPos,YPos], /Normal, /To_Device)) $
                      ELSE Origin_dev = [xyrange_dev(0,0),xyrange_dev(1,0)]
   Origin_norm = uConvert_Coord(Origin_dev, /Device, /To_Normal)


   
   ;; upright : margin between the upper right corner of the coordinate
   ;;           system and the allowed region 
   UpRight_dev = ([VISUAL(0) -(xyrange_dev(0,1)- xyrange_dev(0,0)), $
                     VISUAL(1)-(xyrange_dev(1,1)-xyrange_dev(1,0))]+[legwidth_dev,0])
   UpRight_norm = uConvert_Coord(UpRight_dev, /Device, /To_Normal)
   
   RandNormal = Origin_norm + UpRight_Norm
   
   
   PlotPositionDevice = FltArr(4)
   PlotPositionDevice(0) = Origin_dev(0)
   PlotPositionDevice(1) = Origin_dev(1)
   
   
   
  
   ;;
   ;; calculate the future size of a pixel
   ;;
   Pixel_Norm = [(xyrange_norm(0,1)-Origin_norm(0)-legwidth_norm(0,0))/double(Wdata+1),$
                      (xyrange_norm(1,1)-Origin_norm(1))/double(Hdata+1)]
   Pixel_Dev  = (uconvert_coord(pixel_norm, /normal, /to_device))
   Pixel_Data = [abs(_XRANGE(0)-_XRANGE(1))/double(wdata-1), abs(_YRANGE(0)-_YRANGE(1))/double(hdata-1)]
                                ; data size of pixel can be exactely
                                ; computed and needn't be converted

   IF Keyword_Set(QUADRATIC) THEN BEGIN
      pixel_ratio = pixel_dev(1)/double(pixel_dev(0))
      pixel_norm(pixel_dev(1) GE pixel_dev(0)) = pixel_norm(pixel_dev(1) LT pixel_dev(0))  
      pixel_dev(pixel_dev(1) GE pixel_dev(0))  = pixel_dev(pixel_dev(1) LT pixel_dev(0))  
      pixel_data(pixel_dev(1) GE pixel_dev(0)) = pixel_data(pixel_dev(1) LT pixel_dev(0))  
   END ELSE pixel_ratio =  1.



   ;; now we can finally set the ticklen, because we now know the
   ;; width-to-height ratio of our device
   ;; this section assures that ordinate ticks have the same length as
   ;; abszissa ticks
   w_dev = Double(xyrange_dev(0,1)-xyrange_dev(0,0)-legwidth_dev)
   h_dev = Double(xyrange_dev(1,1)-xyrange_dev(1,0))
   IF w_dev GT h_dev THEN !Y.Ticklen = !Y.Ticklen*h_dev/w_dev $ 
                     ELSE !X.Ticklen = !X.Ticklen*w_dev/h_dev  

   ticklen_data = uconvert_coord((xyrange_norm(0,1)-xyrange_norm(0,0))*[!Y.Ticklen,2*!Y.ticklen],$
                                 (xyrange_norm(1,1)-xyrange_norm(1,0))*[!X.Ticklen,2*!X.Ticklen],/NORM,/TO_DATA)
   ticklen_data = ABS([(ticklen_data(0,1)-ticklen_data(0,0)),(ticklen_data(1,1)-ticklen_data(1,0))])

   ;;
   ;; calculate the [XY]Ranges
   ;;
   xrange = DOUBLE(_XRANGE)
   yrange = DOUBLE(_YRANGE)
   
   IF N_Elements(XRANGE) NE 2 THEN Console, 'wrong XRANGE argument', /FATAL
   IF N_Elements(YRANGE) NE 2 THEN Console, 'wrong YRANGE argument', /FATAL

   ; correct ranges for pixel extend and tickmarks
   ; with /FITPLOT there is no extra space for the ticklen
   XRANGE(0) = XRANGE(0)-pixel_data(0)/2-ticklen_data(0)*(1-Keyword_Set(FITPLOT))
   XRANGE(1) = XRANGE(1)+pixel_data(0)/2+ticklen_data(0)*(1-Keyword_Set(FITPLOT))
   YRANGE(0) = YRANGE(0)-pixel_data(1)/2-ticklen_data(1)*(1-Keyword_Set(FITPLOT))
   YRANGE(1) = YRANGE(1)+pixel_data(1)/2+ticklen_data(1)*(1-Keyword_Set(FITPLOT))
 

   
   ;; handle the ORDER option and axis labelling
   XBeschriftung = XRANGE
   IF keyword_set(ORDER) THEN BEGIN
       UpSideDown = 1
       YBeschriftung = REVERSE(YRANGE)
   ENDIF ELSE BEGIN
       UpSideDown = 0
       YBeschriftung = YRANGE
   ENDELSE
   

   ;; set axes label style 
   IF Min(XRANGE) LT -1 THEN xtf = 'KeineGebrochenenTicks' ELSE xtf = 'KeineNegativenUndGebrochenenTicks'
   IF Min(YRANGE) LT -1 THEN ytf = 'KeineGebrochenenTicks' ELSE ytf = 'KeineNegativenUndGebrochenenTicks'
   if NOT Ordinal(XRANGE) then xtf = ''
   if NOT Ordinal(YRANGE) then ytf = ''
   

   ;;
   ;; The following lines plot the axes before the bitmap is placed.
   ;; This makes sense for the normal operation. However, when
   ;; /FITPLOT is set, these axes will be overwritten by the bitmap
   ;; anyway but these graphic objects still appear when editing
   ;; the PS in Corel (which is annoying), therefore i will 
   ;; supress plotting of axis, but still the plot region has to be
   ;; set, so i cant completely skip this call with /FITPLOT [MS]
   ;;
   IF Keyword_Set(FITPLOT) THEN mystyle = 5 ELSE mystyle = 1
   PTMP = !P.MULTI
   !P.MULTI(0) = 1
   IF Keyword_Set(QUADRATIC) THEN BEGIN 
      Plot, indgen(2), /NODATA,$
       xrange=XBeschriftung, xstyle=mystyle, xtickformat=xtf,$
       yrange=YBeschriftung, ystyle=mystyle, ytickformat=ytf,$
       charsize=Charsize,$
       Position=[Origin_norm(0),Origin_norm(1),$
                 Origin_norm(0)+(xyrange_norm(0,1)-Origin_norm(0)-legwidth_norm(0))*MIN([pixel_ratio,1.]),$
                 Origin_norm(1)+(xyrange_norm(1,1)-Origin_norm(1))*MIN([1./pixel_ratio,1.])],$
       _EXTRA=_extra
   ENDIF ELSE BEGIN
      Plot, indgen(2), /NODATA, $ 
       Position=[Origin_norm(0),Origin_norm(1),xyrange_norm(0,1)-legwidth_norm(0),xyrange_norm(1,1)], $
       xrange=XBeschriftung, xstyle=mystyle, xtickformat=xtf, $
       yrange=YBeschriftung, ystyle=mystyle, ytickformat=ytf, $
       charsize=Charsize,COLOR=color, _EXTRA=_extra
   END
   !P.MULTI = PTMP
   
   
   ;; it seems that Ticklen is measured without the border line
   ;; so we have to add one pixel (point) for the right positioning
   borderthick_norm = uConvert_Coord([1., 1.], /DEVICE, /to_normal)


   ;; the following section computes the size of the bitmap to be
   ;; placed into the already existing coordinate system 
   IF Keyword_Set(FITPLOT) THEN BEGIN
       wbitmap_Norm = (!X.Window)(1)-(!X.Window)(0)
       hbitmap_Norm = (!Y.Window)(1)-(!Y.Window)(0)
       posbitmap_norm = [xyrange_norm(0,0)+borderthick_norm(0), xyrange_norm(1,0)+borderthick_norm(1)]
   END ELSE BEGIN
                               ; use the original xrange position and subtract 1/2 of a pixel
       npp = UConvert_Coord([_xrange(0),_xrange(1)],[_yrange(0), _yrange(1)], /DATA, /TO_NORMAL)
       wbitmap_norm = ABS(npp(0,1)-npp(0,0))+pixel_norm(0) 
       hbitmap_norm = ABS(npp(1,1)-npp(1,0))+pixel_norm(1) 
       posbitmap_norm = [npp(0,0)-pixel_norm(0)/2.+borderthick_norm(0), npp(1,0)-pixel_norm(1)/2.+borderthick_norm(1)]
   END
   bitmap_dev = long(uConvert_Coord([wbitmap_norm,hbitmap_norm], /Normal, /To_Device))
   
   
   
   ;;;
   ;;; plot the bitmap
   ;;; 
   IF Keyword_Set(NOSCALE) THEN BEGIN
       UTV, data, posbitmap_norm(0), posbitmap_norm(1), $
         X_SIZE=float(bitmap_dev(0))/!D.X_PX_CM, Y_SIZE=float(bitmap_dev(1))/!D.Y_PX_CM, $
         ORDER=UpSideDown, POLYGON=POLYGON ,$
         CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, TOP=top
   END ELSE BEGIN
       IF Set(_ZRANGE) THEN BEGIN
                                ; the user wants the data to use a
                                ; subrange of the available color
                                ; space therefore we can't use the
                                ; scaled version   
           IF ((min(data) LT _zrange(0)) OR (max(data) GT _zrange(1))) THEN Console, 'ZRANGE(0)<data<ZRANGE(1) violated..sorry', /FATAL
                                ; this is necessary because otherwise
                                ; data exceeds the valid color space
                                ; if nonetheless wanted you have to
                                ; implement some kind of clipping
                                ; after the scale call 

           UTV, Scl(data, [0, top], _ZRANGE), posbitmap_norm(0), posbitmap_norm(1), $
             X_SIZE=float(bitmap_dev(0))/!D.X_PX_CM, Y_SIZE=float(bitmap_dev(1))/!D.Y_PX_CM, $
             ORDER=UpSideDown, POLYGON=POLYGON, $
             CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, TOP=top
       END ELSE BEGIN
           UTVSCL, data, posbitmap_norm(0), posbitmap_norm(1), $
             X_SIZE=float(bitmap_dev(0))/!D.X_PX_CM, Y_SIZE=float(bitmap_dev(1))/!D.Y_PX_CM, $
             ORDER=UpSideDown, POLYGON=POLYGON, $
             CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, TOP=top
       END
   END
   ;; These lines are needed because there are still no axes when
   ;; using the /FITPLOT option. I simply copied the above section
   ;; while applying /NOERASE to the plot [MS]  
   IF Keyword_Set(FITPLOT) THEN BEGIN
       PTMP = !P.MULTI
       !P.MULTI(0) = 1
       Plot, indgen(2), /NODATA, /NOERASE, $ 
         Position=[Origin_norm(0),Origin_norm(1),xyrange_norm(0,1)-legwidth_norm(0),xyrange_norm(1,1)], $
         xrange=XBeschriftung, /xstyle, xtickformat=xtf, $
         yrange=YBeschriftung, /ystyle, ytickformat=ytf, $
         charsize=charsize,COLOR=color,_EXTRA=_extra
       !P.MULTI = PTMP
   END


   ;;
   ;; plot a legend if requested
   ;;
   IF Keyword_Set(LEGEND) THEN BEGIN
       Default, _ZRANGE, [min(data), max(data)]
       Default, LEGMAX, _ZRANGE(1)
       Default, LEGMIN, _ZRANGE(0)
       
       ; these values seem quite empirically to me, however they seem be quite ok
       TVSclLegend, xyrange_norm(0,1)-0.7*legwidth_norm(0),Origin_norm(1)+Hbitmap_Norm/2.0, $
         V_Stretch=hbitmap_Norm/4.*Visual(1)/(!D.Y_PX_CM), $
         H_Stretch=wbitmap_Norm/20.*Visual(0)/(!D.X_PX_CM), $
         Max=LEGMAX, Min=LEGMIN, $
         CHARSIZE=Charsize, $
         /Vertical, /Center, TOP=top, COLOR=color 
   END


   ;; restore original device parameters
;   !P.Region  = oldRegion 
;   !X.TickLen = oldXTicklen 
;   !Y.TickLen = oldYTicklen 
;   !X.Minor   = oldXMinor  
;   !Y.Minor   = oldYMinor   
   


   ;; return optional output
   Get_PixelSize = pixel_norm
   Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]


END