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
;*      [,/LEGEND] [,LEGMARGIN=...] [,LEG???=...] 
;*      [,XRANGE=...] [,YRANGE=...] [,ZRANGE=...]
;*      [,CHARSIZE=...]
;*      [,/ORDER]
;*      [,/POLYGON]
;*      [,/SMOOTH] [,CUBIC=...] [, /INTERP] [, /MINUS_ONE]
;*      [,TOP=...]
;*      [,TRUE=...]
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
;  LEGMARGIN:: reserves space on the right side of the plot, that can
;              be used to plot the a legend, in percent of the total
;              plot width (<*>/LEGEND</*> will set this value to 0.15
;              but you can overwrite this). 
;  LEG???   :: all other keywords beginning with a <*>LEG</*> will be
;              passed to <A>TvSclLegend</A> without the leading
;              <*>LEG</*>. This can be used to adjust the legend to
;              your personal needs. 
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
;  TRUE      :: Set this keyword to a nonzero value to indicate that a
;               TrueColor (16-, 24-, or 32-bit) image is to be
;               displayed. The value assigned to TRUE specifies the
;               index of the dimension over which color is
;               interleaved. The image parameter must have three
;               dimensions, one of which must be equal to three. For
;               example, set <*>TRUE</*> to 1 to display an image that
;               is pixel interleaved and has dimensions of (3, m, n).
;               Specify 2 for row-interleaved images, of size (m, 3,
;               n), and 3 for band-interleaved images of the form (m, n, 3).
;  [XY]RANGE :: array containing values for an alternative [XY]-axis
;               labeling. This have to be at least two elements
;               (minimum and  maximum value) but can also contain more
;               data points in between. <C>PTVS</C> will take the
;               first and last element of the array and will
;               interpolate all other point equidistant.
;  ZRANGE    :: Minimum and maximum value to scale the
;               <*>data</*>. The minimum will be scaled to color index
;               0, the maximum to <*>TOP</*> or <*>!TOPCOLOR</*>. If
;               the actual data is larger than the provided range,
;               values exeeding these limits will be clipped to the
;               minimum or maximum allowed. If this happens, a warning
;               will be placed at the right side of the
;               plot. Additionally clipped positions will be marked
;               with a small dot. 
; 
;  CUBIC, INTERP, MINUS_ONE:: will be passed to IDL routine
;                            <C>ConGrid</C>, to smooth the
;                            bitmap. This only works, if
;                            <*>/POLYGON</*> is not set.   
;  SMOOTH :: smoothes the plot, using <*>CUBIC=-0.5</*> and <*>/MINUS_ONE</*>
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
; SEE ALSO: <A>PTV</A>, <A>PlotTV</A>, <A>UTVScl</A>, <A>TVSclLegend</A>
;          
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
          XRANGE=__xrange, YRANGE=__yrange, ZRANGE=zrange, $
          LEGEND=Legend, LEGMARGIN=LEGMARGIN, $
          POLYGON=POLYGON, $
          CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, SMOOTH=smooth, $
          GET_Position=Get_Position, GET_PIXELSIZE=Get_PixelSize, $
          TRUE=true, $
          _EXTRA=_extra

   On_Error, 2

   IF !D.Name EQ 'NULL' THEN RETURN

   ;;;   
   ;;; check the passed array
   ;;;
   IF NOT Set(data) THEN Console, 'argument undefined', /FATAL
   Default, TRUE, 0
   sd = SIZE(reform(data))
   CASE TRUE OF
       0 : BEGIN
           hdata = sd(2)
           wdata = sd(1)
       END
       1 : BEGIN
           hdata = sd(3)
           wdata = sd(2)
       END
       2 : BEGIN
           hdata = sd(3)
           wdata = sd(1)
       END
       3 : BEGIN
           hdata = sd(2)
           wdata = sd(1)
       END
       ELSE: CONSOLE, 'invalid value for TRUE', /FATAL
   END 


   ;;;
   ;;; extract parameters for the legend
   ;;;
   LEGEXTRA = ExtraDiff(_extra, 'LEG', /SUBSTRING)
                                ; remove all LEG strings from the tagnames
   IF TypeOf(LEGEXTRA) NE 'STRUCT' THEN undef, legextra ; extradiff returns !NONE if nothing could be extracted
   IF Set(LEGEXTRA) THEN BEGIN
       tn = Tag_Names(LEGEXTRA)
                                ; this can't be easiliy done in one
                                ; single loop, because DelTag changes
                                ; the order of tags arranged in the
                                ; structure and LEGEXTRA.(I) would
                                ; access wrong data
       FOR i=0, N_TAGS(LEGEXTRA)-1 DO SetTag, LEGEXTRA, strreplace(tn(i), 'LEG', '', /g, /i), LEGEXTRA.(i) 
       FOR i=0, N_Elements(tn)-1 DO DelTag, LEGEXTRA, tn(i)
   END


   ;;;   
   ;;; assure default settings
   ;;;
   Default, TRUE, 0
   Default, _Charsize, !P.CHARSIZE
                                ; lower the passed or default charsize, when there are multiple
                                ; plots per window
   IF (!P.MULTI(1) GT 1  AND !P.MULTI(2) GT 1) THEN Charsize = _Charsize*sqrt(1./FLOAT(!P.MULTI(1))) $
                                               ELSE Charsize = _Charsize



   Default, COLOR, GetForeground()

                                ; reverse space for the legend, either
                                ; if the user wants us to plot one,
                                ; or if he reserves some space for whatever 
   IF Keyword_Set(LEGEND) THEN Default, LEGMARGIN, 0.15 ELSE Default, LEGMARGIN, 0.0

   DEFAULT, top, !TOPCOLOR


   ; _XYRANGE contain the original scaling of the axes
   Default, __XRANGE, [0, wdata-1]
   IF N_Elements(__XRANGE) LT 2 THEN Console, /FATAL, 'you have to specify at least 2 elements for XRANGE'
   _XRANGE = [__XRANGE(0), last(__XRANGE)]
   Default, __YRANGE, [0, hdata-1]
   IF N_Elements(__YRANGE) LT 2 THEN Console, /FATAL, 'you have to specify at least 2 elements for YRANGE'
   _YRANGE = [__YRANGE(0), last(__YRANGE)]
   
   IF Keyword_Set(NOSCALE) THEN BEGIN
       IF Set(ZRANGE) THEN Console, "can't accept ZRANGE in NOSCALE mode", /FATAL
       Default, ZRANGE, [0,top]
       IF (NOT Set(TRUE)) AND ((MAX(data) GT top) OR (Min(data) LT 0)) THEN $
         Console, 'data exeeds [0,'+STR(top)+'], expect graphical nonsense', /WARN
   END ELSE Default, ZRANGE, [min(data),max(data)]




   ;; defaults passed UTV(SCL)
   Default, ORDER, 0
   Default, Polygon,0
   default, CUBIC, 0
   default, INTERP, 0
   default, MINUS_ONE, 0

   IF Keyword_Set(SMOOTH) THEN BEGIN
       CUBIC=-0.5
       MINUS_ONE=1
   END

   ;; set ticks and their lengths
   !X.TickLen = 0.02            ; temporarily set ticklen to a reasonable value, it may contain strange values  
   !Y.TickLen = 0.02            ; this will be changed later


   ; empirical settings that should reduce the number of minor
   ; axis ticks when there are only small arrays displayed

   IF hdata GE 15 THEN !Y.Minor = 0 ELSE $
     IF hdata GE 7 THEN !Y.Minor = 0 ELSE !Y.Minor=-1   
   IF wdata GE 15 THEN !X.Minor = 0 ELSE $
     IF wdata GE 7 THEN !X.Minor = 0 ELSE !X.Minor=-1



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
   


   ;; regionssize: total place available for the plot including labels...(device coordinates)
   Rs_Dev = RegionSize(/DEVICE)
   


   ;; legwidth: width that is reserved for the legend (may be zero)
   legwidth_dev = LEGMARGIN*Rs_Dev(0) 
   legwidth_norm = UConvert_Coord([legwidth_dev,0], /Device, /To_Normal)
   

   
   ;; origin : lower left corner of coordinate system 
   IF N_Params() EQ 3 THEN Origin_dev = (uConvert_Coord([XPos,YPos], /Normal, /To_Device)) $
                      ELSE Origin_dev = [xyrange_dev(0,0),xyrange_dev(1,0)]
   Origin_norm = uConvert_Coord(Origin_dev, /Device, /To_Normal)


   
   ;; upright : margin between the upper right corner of the coordinate
   ;;           system and the allowed region 
   UpRight_dev = ([RS_DEV(0) -(xyrange_dev(0,1)- xyrange_dev(0,0)), $
                     RS_DEV(1)-(xyrange_dev(1,1)-xyrange_dev(1,0))]+[legwidth_dev,0])
   UpRight_norm = uConvert_Coord(UpRight_dev, /Device, /To_Normal)
   
   RandNormal = Origin_norm + UpRight_Norm
   
   

  
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
      IF pixel_ratio GT 1 THEN pixel_norm(1)=pixel_norm(1)/pixel_ratio ELSE  pixel_norm(0)=pixel_norm(0)*pixel_ratio
      pixel_dev(pixel_dev(1) GE pixel_dev(0))  = pixel_dev(pixel_dev(1) LT pixel_dev(0))  
      pixel_data(pixel_dev(1) GE pixel_dev(0)) = pixel_data(pixel_dev(1) LT pixel_dev(0))  
   END ELSE pixel_ratio =  1.


   ;; now we can finally set the ticklen, because we now know the
   ;; width-to-height ratio of our device
   ;; this section assures that ordinate ticks have the same length as
   ;; abszissa ticks
   w_dev = Double(xyrange_dev(0,1)-xyrange_dev(0,0)-legwidth_dev)
   h_dev = Double(xyrange_dev(1,1)-xyrange_dev(1,0))
   IF w_dev GT h_dev THEN !Y.Ticklen = !Y.Ticklen*h_dev/w_dev/MIN([pixel_ratio,1.]) $ 
                     ELSE !X.Ticklen = !X.Ticklen*w_dev/h_dev/MIN([1./pixel_ratio,1.])

   ticklen_norm = [(xyrange_norm(0,1)-xyrange_norm(0,0))*!Y.Ticklen,$
                   (xyrange_norm(1,1)-xyrange_norm(1,0))*!X.Ticklen]
   ticklen_data = uconvert_coord([ticklen_norm(0), 2*ticklen_norm(0)],$
                                 [ticklen_norm(1), 2*ticklen_norm(1)], /NORM, /TO_DATA)
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
   Plot, indgen(2), /NODATA,$
     xrange=XBeschriftung, xstyle=mystyle, xtickformat=xtf,$
     yrange=YBeschriftung, ystyle=mystyle, ytickformat=ytf,$
     charsize=Charsize,COLOR=color,$
     Position=[Origin_norm(0),Origin_norm(1),$
               Origin_norm(0)+(xyrange_norm(0,1)-Origin_norm(0)-legwidth_norm(0))*MIN([pixel_ratio,1.]),$
               Origin_norm(1)+(xyrange_norm(1,1)-Origin_norm(1))*MIN([1./pixel_ratio,1.])],$
     _EXTRA=_extra
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
         CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, TOP=top, TRUE=true
   END ELSE BEGIN
       _data = ScaleTv(data, ZRANGE=zrange, TOP=top, CUTLO=cutlo, CUTHI=cuthi)

       ;;
       ;; plot the (possibly) clipped data 
       ;;
       UTV, _data, posbitmap_norm(0), posbitmap_norm(1), $
         X_SIZE=float(bitmap_dev(0))/!D.X_PX_CM, Y_SIZE=float(bitmap_dev(1))/!D.Y_PX_CM, $
         ORDER=UpSideDown, POLYGON=POLYGON, $
         CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, TOP=top, TRUE=true
       
       
       warnstr = ''
       IF cuthi(0) NE -1 THEN BEGIN
           Plots, _XRANGE(0)+(_XRANGE(1)-_XRANGE(0))*(cuthi MOD wdata)/(wdata-1) , $
             _YRANGE(0)+(_YRANGE(1)-_YRANGE(0))*(cuthi  /  wdata)/(hdata-1) , PSYM=7, COLOR=color, SYMSIZE=30*MIN(pixel_norm)
           warnstr = warnstr + 'maxima'
       END
       IF cutlo(0) NE -1 THEN BEGIN
           Plots, _XRANGE(0)+(_XRANGE(1)-_XRANGE(0))*(cutlo MOD wdata)/(wdata-1) , $
             _YRANGE(0)+(_YRANGE(1)-_YRANGE(0))*(cutlo  /  wdata)/(hdata-1) , PSYM=7, COLOR=color, SYMSIZE=30*MIN(pixel_norm)
                                ; clipped positions are marked by a
                                ; small x, symsize is just
                                ; empirical...not to prominent
           IF (cuthi(0) NE -1) THEN warnstr = warnstr + ' and '
           warnstr = warnstr + 'minima'
       END
       IF (warnstr NE "") THEN Inscription, 'WARNING: '+warnstr+' clipped', /MIDDLE, /RIGHT, /OUTSIDE, COLOR=color
       
   END
   ;; These lines are needed because there are still no axes when
   ;; using the /FITPLOT option. I simply copied the above section
   ;; while applying /NOERASE to the plot [MS]  
   IF Keyword_Set(FITPLOT) THEN BEGIN
       PTMP = !P.MULTI
       !P.MULTI(0) = 1
       Plot, indgen(2), /NODATA,$
         xrange=XBeschriftung, xstyle=1, xtickformat=xtf,$
         yrange=YBeschriftung, ystyle=1, ytickformat=ytf,$
         charsize=Charsize,COLOR=color,$
         Position=[Origin_norm(0),Origin_norm(1),$
                   Origin_norm(0)+(xyrange_norm(0,1)-Origin_norm(0)-legwidth_norm(0))*MIN([pixel_ratio,1.]),$
                   Origin_norm(1)+(xyrange_norm(1,1)-Origin_norm(1))*MIN([1./pixel_ratio,1.])],$
         _EXTRA=_extra
       !P.MULTI = PTMP
   END



   ;;
   ;; plot a legend if requested
   ;;
   IF Keyword_Set(LEGEND) THEN BEGIN
       IF (LONG(ZRANGE(1)) NE !NONEl) THEN Default, LEGMAX, ZRANGE(1) ELSE Default, LEGMAX, MAX(data)
       IF (LONG(ZRANGE(0)) NE !NONEl) THEN Default, LEGMIN, ZRANGE(0) ELSE Default, LEGMIN, MIN(data)
                                ; if user specifies ZRANGE as !NONE he
                                ; wants it to be scaled to MIN/MAX of
                                ; the data

       
       ; these values are a bit empirical, however they seem be quite ok

;; old version
;       TVSclLegend, Origin_norm(0)+(xyrange_norm(0,1)-Origin_norm(0)-legwidth_norm(0))*MIN([pixel_ratio,1.])+0.05*legwidth_norm(0),Origin_norm(1)+Hbitmap_Norm/2.0, $
;         V_Stretch=hbitmap_Norm/4.*Rs_Dev(1)/(!D.Y_PX_CM), $
;         H_Stretch=wbitmap_Norm/20.*Rs_Dev(0)/(!D.X_PX_CM), $
;         Max=LEGMAX, Min=LEGMIN, $
;         CHARSIZE=Charsize, $
;         /Vertical, /YCenter, TOP=top, COLOR=color, _EXTRA=LEGEXTRA

       ;; reserve additional space for a possible rotatetd title of
       ;; the legend by adding the height of a char
       y_ch_size = !D.Y_CH_SIZE*Charsize / FLOAT(!D.Y_SIZE)
       TVSclLegend $
        , (xyrange_norm(0,1)-legwidth_norm(0))*MIN([pixel_ratio,1.])+0.05*legwidth_norm(0)+1.5*y_ch_size $
        , Origin_norm(1)+Hbitmap_Norm/2.0 $
        , NORM_Y_SIZE=hbitmap_Norm*0.75 $
        , NORM_X_SIZE=wbitmap_Norm/20. $
        , Max=LEGMAX, Min=LEGMIN, $
         CHARSIZE=Charsize, $
         /Vertical, /YCenter, TOP=top, COLOR=color, _EXTRA=LEGEXTRA
   END


   ;; return optional output
   Get_PixelSize = pixel_norm
   Get_Position = [(!X.Window)(0), (!Y.Window)(0), (!X.Window)(1), (!Y.Window)(1)]


END
