;+
; NAME:
;  newPTV
;
; VERSION:
;  $Id$
;
; AIM:
;  Color coded display of a two-dimensional array in a coordinate system.
;
; PURPOSE:
;  Color coded display of a two-dimensional array in a coordinate
;  system. This version is similar to <A>PTV</A>, but supports
;  optional x- and y-axis annotation, displaying subarrays via the
;  usual <*>XYRANGE</*>-keywords and does not draw tick marks where there are
;  no array entries. It is intended to inherit all of PTV's
;  functionality in the future, but this has not yet been accomplished.<BR>
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;* newPTV, image [,x [,y]] [,/FITPLOT] [,/ORDER] [,/POLYGON] [,/CORNERS] 
;*                   [,CUBIC=...] [,/INTERP] [,/MINUS_ONE] [,/SMOOTH] 
;*                   [,/LEGEND] [,LEGMARGIN=...]
;
; INPUTS:
;  image:: One- or two dimensional array of color indices.
;
; OPTIONAL INPUTS:
;  x, y:: x and y values corresponding to the array indices.
;
; INPUT KEYWORDS:
;  /FITPLOT:: The standard behavior of this routine is to plot the
;             coordinate system outside the bitmap, with the tickmarks
;             touching the border of the bitmap. Turning on the
;             <*>/FITPLOT</*> option, the bitmap will touch the axes
;             instead, with the tickmarks overlaying the bitmap.
;  /ORDER:: If specified, the image's first line (i.e. <*>image[*,0]</*>
;           is drawn at the top of the window, instead of drawing
;           <*>image[*,0]</*> at the window's bottom. <*>/ORDER</*> reverses
;           the y-axis annotation, but only after <*>YRANGE</*> has
;           been applied.
;  /POLYGON:: When producing postscript output, <A>UTV</A> and its
;             partners produce bitmap output. With this option, the
;             bitmap is composed of polygons (each pixel a filled
;             polygon). This is advantageous if you want to edit the
;             pixels with a vector drawing program like
;             COREL. Furthermore, for
;             small arrays (up to 1000 entries), the output files
;             composed of polygons are 
;             smaller than their bitmap counterparts. But
;             <B>beware</B>, for arrays with many entries composing output
;             out of polygons results in huge PS files. Note that
;             setting the <*>/POLYGON</*> option disables the function of
;             <*>/CUBIC</*>, <*>/INTERP</*> and <*>/MINUS_ONE</*>.
; /CORNERS:: In addition to the axes that start and end in the middle
;            of the array pixels, setting this option draws additional
;            corners that result in a normal IDL axes box surrounding
;            the image. Default: 1.
; CUBIC, /INTERP, /MINUS_ONE:: These will be passed to the underlying
;                              IDL routine <C>ConGrid</C> to smooth
;                              the bitmap. See <C>Congrid</C>'s documentation
;                              for more info. This only works if
;                              <*>/POLYGON</*> is not set.   
; /SMOOTH:: Smoothes the plot, shortcut for setting <*>CUBIC=-0.5</*>
;           and <*>/MINUS_ONE</*>. 
; /LEGEND:: Displays a legend of the color code on the very right of
;            the plot using <A>TvSclLegend</A>. 
; LEGMARGIN:: Modifies the amount of space on the right side of the
;             plot that is used to plot the legend, in percent of the
;             total plot width. Default: 0.15. 
; LEG???:: All other keywords beginning with a <*>LEG</*> will be
;          passed to <A>TvSclLegend</A> without the leading
;          <*>LEG</*>. This can be used to adjust the legend to your
;          personal needs. 
;
; OPTIONAL OUTPUTS:
;  None yet.
;
; SIDE EFFECTS:
;  None yet.
;
; RESTRICTIONS:
;  - The legend title is always on ths same side as the annotation to save
;  space. Usage of <*>LEGMID</*> is therefore not recommended, since
;  the middle annotation would occur in the same place as the title.<BR>
;  <BR>
;  Not yet implemented: <BR>
;  - optional positioning <BR>
;  - ranges that extend beyond the array values <BR>
;  - ranges with first value larger than second <BR>
;  - quadratic pixels <BR>
;  - where should extra go? <BR>
;  - true color support <BR>
;  - scale counterpart: newPTVS <BR>
;  - ZRANGE, without clipping but stretching instead , makes only
;  sense in PTVScale?<BR>
;
; PROCEDURE:
;  Well.
;
; EXAMPLE:
;* NewPTV, Scl(IndGen(20,5),[0,!topcolor]), FIndGen(20)*0.02, /LEGEND, XRANGE=[0.1,0.3]
;
; SEE ALSO:
;  <A>PTVS</A>, <A>PTV</A>, <A>PlotTV</A>, IDL's <C>TV</C> and <C>Congrid</C>.
;-


; oldPTV INPUT KEYWORDS:
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
;;  

PRO newPTV, first, second, third $
            , XRANGE=xrange, YRANGE=yrange $
            , XTICKLEN=xticklen, YTICKLEN=yticklen $
            , XMINOR=xminor, YMINOR=yminor $
            , TITLE=title, XTITLE=xtitle, YTITLE=ytitle $
            , FITPLOT=fitplot, CORNERS=corners $
            , POLYGON=polygon, ORDER=order $
            , LEGEND=legend, LEGMARGIN=legmargin, LEGCHARSIZE=legcharsize $
            , LEGMIN=legmin, LEGMAX=legmax $
            , CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one, SMOOTH=smooth $
            , CHARSIZE=charsize $
            , _EXTRA=_extra
   
   ;;On_Error, 2

   IF !D.Name EQ 'NULL' THEN RETURN
   
   Default, xticklen, 0.02
   Default, yticklen, xticklen
   Default, fitplot, 0
   Default, corners, 1
   Default, polygon, 0
   Default, order, 0
   Default, legend, 0
   Default, cubic, 0
   Default, interp, 0
   Default, minus_one, 0
   Default, charsize, !P.CHARSIZE

   IF Keyword_Set(SMOOTH) THEN BEGIN
      cubic=-0.5
      minus_one=1
   END

   IF Keyword_Set(LEGEND) THEN BEGIN
      Default, legmargin,  0.15
      Default, legcharsize, charsize
      Default, legmin, Str(Min(first), FORMAT='(G0.0)')
      Default, legmax, Str(Max(first), FORMAT='(G0.0)')
   ENDIF ELSE BEGIN
      legmargin = 0.
   ENDELSE

   ;; extract parameters for the legend (form PTVS)
   legextra = ExtraDiff(_extra, 'LEG', /SUBSTRING)
                                ; remove all LEG strings from the tagnames
   IF TypeOf(legextra) NE 'STRUCT' THEN UnDef, legextra 
   ;; extradiff returns !NONE if nothing could be extracted
   
   IF Set(legextra) THEN BEGIN
      tn = Tag_Names(legextra)
      ;; this can't be easiliy done in one
      ;; single loop, because DelTag changes
      ;; the order of tags arranged in the
      ;; structure and LEGEXTRA.[i] would
      ;; access wrong data
      FOR i=0, N_Tags(legextra)-1 DO $
       SetTag, legextra, StrReplace(tn(i), 'LEG', '', /g, /i), legextra.(i) 
      FOR i=0, N_Elements(tn)-1 DO $
       DelTag, legextra, tn(i)
   ENDIF 


   IF ((xticklen GE 0.5) OR (yticklen GE 0.5)) $
    AND (NOT Keyword_Set(FITPLOT)) THEN $
    Console, /WARN, $
    'TICKLEN GT 0.5 while FITPLOT not set. Plot will be empty or reversed.'

   sf = Size(first)

   IF (sf[0] GE 1) AND (sf[0] LE 2) THEN BEGIN
      IF sf[0] EQ 1 THEN BEGIN
         first = Reform(first,sf[1], 1, /OVER)
      ENDIF
   ENDIF ELSE Console, /FATAL $
    , 'Only 1- or 2-dimensional arrays can be displayed.'
   
   ;; Deal with different parameter combinations and set the ranges
   ;;
   ;; xrange = actual data range
   ;; xr = start and end index
   CASE N_Params() OF
      1: BEGIN ;; only the array is passed
         IF Set(XRANGE) THEN $
          xr = xrange $
         ELSE BEGIN
            xr = [0, (Size(first))[1]-1]
            xrange = xr
         ENDELSE
         IF Set(YRANGE) THEN $
          yr = yrange $
         ELSE BEGIN
            yr = [0, (Size(first))[2]-1]
            yrange = yr
         ENDELSE
         ;; have a second dimension in any case, at least its 1
         a = Reform(first[xr[0]:xr[1], yr[0]:yr[1]], xr[1]-xr[0]+1, yr[1]-yr[0]+1) 
         sa = Size(a)
         nx = sa[1]
         ny = sa[2]
      END
      2: BEGIN ;; the array and x values are passed
         IF N_Elements(second) NE (Size(first))[1] THEN $
          Console, /FATAL, 'Second argument must have as many entries as first dimension of first argument.'
         IF Set(XRANGE) THEN BEGIN
            i = Where((second GE xrange[0]) AND (second LE xrange[1]), count)
            IF count NE 0 THEN BEGIN
               xr = [i[0], Last(i)]
               xrange = Double(second[xr])
            ENDIF ELSE Console, /FATAL, 'XRANGE wrong.'
         ENDIF ELSE BEGIN
            xr = [0, N_Elements(second)-1]
            xrange = Double([second[0], Last(second)])
         ENDELSE
         IF Set(YRANGE) THEN $
          yr = yrange $
         ELSE BEGIN
            yr = [0, (Size(first))[2]-1]
            yrange = Double(yr)
         ENDELSE
;         a = first[xr[0]:xr[1], yr[0]:yr[1]]
         a = Reform(first[xr[0]:xr[1], yr[0]:yr[1]], xr[1]-xr[0]+1, yr[1]-yr[0]+1) 
         sa = Size(a)
         nx = sa[1]
         ny = sa[2]
      END
      3: BEGIN ;; array, x and y values are passed
         IF (N_Elements(second) NE (Size(first))[1]) OR $
          (N_Elements(third) NE (Size(first))[2]) THEN $
          Console, /FATAL, 'First and second argument do not match dimensions of third argument.'
         IF Set(XRANGE) THEN BEGIN
            i = Where((second GE xrange[0]) AND (second LE xrange[1]), count)
            IF count NE 0 THEN BEGIN
               xr = [i[0], Last(i)]
               xrange = Double(Second[xr])
            ENDIF ELSE Console, /FATAL, 'XRANGE wrong.'
         ENDIF ELSE BEGIN
            xr = [0, N_Elements(second)-1]
            xrange = Double([second[0], Last(second)])
         ENDELSE
         IF Set(YRANGE) THEN BEGIN
            i = Where((third GE yrange[0]) AND (third LE yrange[1]), count)
            IF count NE 0 THEN BEGIN
               yr = [i[0], Last(i)]
               yrange = Double(third[yr])
            ENDIF ELSE Console, /FATAL, 'YRANGE wrong.'
         ENDIF ELSE BEGIN
            yr = [0, N_Elements(third)-1]
            yrange = Double([third[0], Last(third)])
         ENDELSE
         a = Reform(first[xr[0]:xr[1], yr[0]:yr[1]], xr[1]-xr[0]+1, yr[1]-yr[0]+1) 
;         a = first[xr[0]:xr[1], yr[0]:yr[1]]
         sa = Size(a)
         nx = sa[1]
         ny = sa[2]
      END
      ELSE: Console, /FATAL, 'Incorrect number of arguments.'
   ENDCASE

;   help, a
;   help, yr
;   help, yrange
;   help, ny

   IF Keyword_Set(ORDER) THEN BEGIN
      yr = Reverse(yr)
      yrange = Reverse(yrange)
   ENDIF

   ;; save old region, without legend space
   oldreg = Region()

   ;; reserve space for legend to the right of the plot.
   !P.REGION = Region()-[0,0,(RegionSize())(0)*legmargin,0]

   ;; Now determine the total plotting area minus the legend space,
   ;; but do not draw 
   ;; anything except a possible title of the plot.
   Plot, IndGen(5), /NODATA, XSTYLE=4, YSTYLE=4 $
    , TITLE=title, CHARSIZE=charsize

   xo = !X.WINDOW[0] ;; corners of plot area in normal coords
   yo = !Y.WINDOW[0]
   xe = !X.WINDOW[1]
   ye = !Y.WINDOW[1]

   w = xe-xo ;; width of plot area
   h = ye-yo ;; height of plot area

   ;; it seems that Ticklen is measured without the border line
   ;; so we have to add one pixel (point) for the right positioning
   ;; this is taken from PTVS
   borderthick_norm = UConvert_Coord([1., 1.], /DEVICE, /TO_NORMAL)

   IF Keyword_Set(FITPLOT) THEN BEGIN
      xarro = xo ;; normal coords of array area
      yarro = yo
      xarre = xe
      yarre = ye
   ENDIF ELSE BEGIN
      xarro = xo+yticklen*w+borderthick_norm[0] ;; normal coords of array area
      yarro = yo+xticklen*h+borderthick_norm[1]
      xarre = xe-yticklen*w+borderthick_norm[0]
      yarre = ye-xticklen*h+borderthick_norm[1]
   ENDELSE

   warr = xarre-xarro ;; width and height of array area
   harr = yarre-yarro

   wpix = warr/nx ;; pixel width
   hpix = harr/ny ;; pixel height

   ;; positions of first and last tick, needed for displacement of the
   ;; axes
   xtickpos = xarro+0.5*wpix+[0, nx-1]*wpix
   ytickpos = yarro+0.5*hpix+[0, ny-1]*hpix

   ;; Draw the array
   IF Keyword_Set(POLYGON) THEN $
    PolyTV, a, XORPOS=xarro, XSIZE=warr, YORPOS=yarro, YSIZE=harr $
    , ORDER=order $
   ELSE $
    UTVScl, a, xarro, yarro, NORM_X_SIZE=warr, NORM_Y_SIZE=harr $
    , ORDER=order, /NOSCALE, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one

   ;; have a single number indicating whether the array has a single
   ;; entry, is a single row or column or a normal two dim array
   dimflag = 2*(ny GT 1)+(nx GT 1)
   CASE dimflag OF
      0: BEGIN
         ;; DMsg, '1x1 array'
         !P.POSITION = [xo, yo, xe, ye]
         xfrac = 1.
         yfrac = 1.
      END
      1: BEGIN
         ;; DMsg, 'nx1 array'
         !P.POSITION = [xtickpos[0], yo, Last(xtickpos), ye]
         xfrac = (xe-xo)/(Last(xtickpos)-xtickpos[0])
         yfrac = 1.
      END
      2: BEGIN
         ;; DMsg, '1xm array'
         !P.POSITION = [xo, ytickpos[0], xe, Last(ytickpos)]
         xfrac = 1.
         yfrac = (ye-yo)/(Last(ytickpos)-ytickpos[0])
      END
      3: BEGIN
         ;;DMsg, 'nxm array'
         !P.POSITION = [xtickpos[0], ytickpos[0], Last(xtickpos), Last(ytickpos)]
         ;; since the plotting area is modified, XYTICKLEN do no longer apply
         ;; to the correct coordinates, they have to be corrected by the
         ;; following fractions 
         xfrac = (xe-xo)/(Last(xtickpos)-xtickpos[0])
         yfrac = (ye-yo)/(Last(ytickpos)-ytickpos[0])
      END
      ELSE: Console, /FATAL, 'Cannot happen.'
   ENDCASE

   ;; Change the default axis positions such that axes start at the
   ;; pixels. This is needed since AXIS does only allow positioning
   ;; the axis in the direction perpendicular to the axis direction.
   ;; Also get xtg/ytg = which ticks does IDL want to draw
   Plot, IndGen(5), /NODATA, XSTYLE=5, YSTYLE=5 $
    , XRANGE=xrange, YRANGE=yrange, /NOERASE $
    , XTICK_GET=xtg, YTICK_GET=ytg, CHARSIZE=charsize

   ;; dont allow IDL to use more ticks than array entries. If it wants
   ;; to, set tickinterval = difference between axis array
   ;; entries. 
   IF N_Elements(xtg) GE nx THEN BEGIN
      IF nx EQ 1 THEN BEGIN
         ;; a one column array? Then set keywords such that only a center
         ;; tick appears with a single value
         xticks = 2
         xtickname = [' ', Str(xrange[0], FORMAT='(G0.0)'), ' ']
      ENDIF ELSE $
      xtinter = (xrange[1]-xrange[0])/(nx-1)
      ;; no minor tick marks, since each array column is marked by a
      ;; major tick
      Default, xminor, -1
   ENDIF ELSE BEGIN
      ;; major ticks as desired by IDL
      xtinter = xtg[1]-xtg[0]
      ;; no more than 5 minors 
      Default, xminor, (nx/N_Elements(xtg)) < 5
   ENDELSE

   IF N_Elements(ytg) GE ny THEN BEGIN
      IF ny EQ 1 THEN BEGIN
         ;; a one row array? Then set keywords such that only a center
         ;; tick appears with a single value
         yticks = 2
         ytickname = [' ', Str(yrange[0], FORMAT='(G0.0)'), ' ']
      ENDIF ELSE $
      ytinter = Abs(yrange[1]-yrange[0])/(ny-1)
      ;; Abs() because /ORDER may have reversed the annotation
      Default, yminor, -1
   ENDIF ELSE BEGIN
      ytinter = Abs(ytg[1]-ytg[0])
      Default, yminor, (ny/N_Elements(ytg)) < 5
   ENDELSE

   ;; Draw the axes. In the axis direction, they start and end at the
   ;; middle of the pixels, since the modified plotting area is set
   ;; this way. In the other direction, they are displaced such they
   ;; appear below/left the array plot
   Axis, 23., yo, XAXIS=0, /NORMAL, XSTYLE=1 $
    , XTICKINTERVAL=xtinter, XTICKS=xticks, XTICKNAME=xtickname $
    , XMINOR=xminor, XTICKLEN=xticklen*yfrac, XTITLE=xtitle $
    , CHARSIZE=charsize

   Axis, xo, 23., YAXIS=0, /NORMAL, YSTYLE=1 $
    , YTICKINTERVAL=ytinter, YTICKS=yticks, YTICKNAME=ytickname $
    , YMINOR=yminor, YTICKLEN=yticklen*xfrac, YTITLE=ytitle $
    , CHARSIZE=charsize

   Axis, 23., ye, XAXIS=1, /NORMAL, XSTYLE=1, XTICKFORMAT='noticks' $
    , XTICKS=xticks, XTICKINTERVAL=xtinter $
    , XMINOR=xminor, XTICKLEN=xticklen*yfrac $
    , CHARSIZE=charsize

   Axis, xe, 23., YAXIS=1, /NORMAL, YSTYLE=1, YTICKFORMAT='noticks' $
    , YTICKS=yticks, YTICKINTERVAL=ytinter $
    , YMINOR=yminor, YTICKLEN=yticklen*xfrac $
    , CHARSIZE=charsize


   ;; Add the corners
   IF Keyword_Set(CORNERS) THEN BEGIN
      ;; Add the corners
      PlotS, [xo, xo, xtickpos[0]], [ytickpos[0], yo, yo] $
       , /NORMAL, COL=GetForeGround()
      PlotS, [xe, xe, Last(xtickpos)], [ytickpos[0], yo, yo] $
       , /NORMAL, COL=GetForeGround()
      PlotS, [xo, xo, xtickpos[0]], [Last(ytickpos), ye, ye] $
       , /NORMAL, COL=GetForeGround()
      PlotS, [xe, xe, Last(xtickpos)], [Last(ytickpos), ye, ye] $
       , /NORMAL, COL=GetForeGround()
   ENDIF

   ;; plot a legend if requested (modified from PTVS)
   IF Keyword_Set(LEGEND) THEN BEGIN
      maxstr = [legmin, legmax]
      x_ch_size = !D.X_CH_SIZE*legcharsize / FLOAT(!D.X_SIZE)
      ;; add 4 character widths for left and right margins
      annotwidth = (4+Max(StrLen(maxstr)))*x_ch_size
      ;; make legend including the values of max and min as wide as
      ;; possible
      finalwidth = (oldreg[2]-xe)-annotwidth
      IF finalwidth LT 0 THEN Console, /WARN $
       , 'Legend plus annotation too broad.'
      ;; Displace legend by 2 charwidth from the end of the axis,
      ;; thereby centering it inside the remaining area left of the
      ;; plot. 
      TVSclLegend, xe+2*x_ch_size, yo+0.5*h $
       , MIN=legmin, MAX=legmax, /NOSCALE $
       , /VERTICAL, /YCENTER $
       , NORM_X_SIZE=finalwidth $
       , NORM_Y_SIZE=0.75*h $
       , CHARSIZE=legcharsize $
       , /SAMESIDE $
       , _EXTRA=legextra
   ENDIF ;; Keyword_Set(LEGEND)

   ;; restore default settings
   !P.POSITION = FltArr(4)
   !P.REGION = FltArr(4)


END
