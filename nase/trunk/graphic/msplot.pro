;+
; NAME:
;  MSPlot
;
; VERSION:
;  $Id$
;
; AIM:
;  Plots error values as a colored area around data.
;  
; PURPOSE:
;  Plots onedimensional data and depicts supplied error values
;  by drawing a colored area around the data plot.
;  
; CATEGORY:
;  Graphic
;  
; CALLING SEQUENCE:
;*  MSPlot [,x] ,mean ,sd 
;*         [,/SDMEAN]
;*         [,MCOLOR=...] [,SDCOLOR=...][, /SIMPLE ]
;*         [,/OPLOT]
;*         [,_EXTRA=...]
;
;  
; INPUTS:
;  mean :: Onedimensional array containing n data values.
;  sd   :: Either an array with n elements containing the corresponding
;          error values, that are assumed to be symmetrically distributed
;          around the <*>mean</*>; or a (2,n) array containing the lower and
;          upper errors for each mean value. Also note the
;          <*>/SDMEAN</*> keyword.
;  
; OPTIONAL INPUTS:
;  x:: Abscissa values corresponding to <*>mean</*> and <*>sd</*>
;      (default is equidistant ranging from 0 to n-1).
;
; INPUT KEYWORDS:
;  SIMPLE:: Creates output without using polygons, instead indicating the
;           error by dotted curves (<*>LINESTYLE=1</*>). This may be
;           useful if polygons would cover other important data or if
;           extra small Postscript output is needed. 
;  MCOLOR  :: Colorindex used for plotting the data (default:
;             foreground color).
;  OPLOT   :: plots data into an already existing window 
;  SDCOLOR :: Colorindex used to draw error area (default: darkblue).  
;  SDMEAN  :: <*>sd</*> entries are interpreted as absolute values
;             (mean+-error). This kind of output is e.g. provided by <A>FZTmean</A>. 
;  _EXTRA  :: All other unrecognized options are passed to the
;             underlying <*>Plot</*> and <*>Axis</*> procedures.
;  
; RESTRICTIONS:
;  <*>X-/YTITLE</*> and <*>X-/YTICKFORMAT</*> can only be used for
;  left and bottom axes, labeling of right and top axes is suppressed.
;
; PROCEDURE:
;  + establish coordinate system<BR>
;  + error area via multiple <C>PolyFill</C>s<BR>
;  + mean via <C>OPlot</C><BR>
;  + plot axes to overwrite error area<BR>
;  
; EXAMPLE:
;*  x  = Indgen(30)/10.
;*  m  = 0.02*randomu(seed,30)+0.4
;*  sd = 0.005*randomn(seed,30)+0.05
;*  MSPlot, m, sd
;*  MSPlot, x, m, sd, YRANGE=[0,1],/XSTYLE $
;*   , MCOLOR=RGB(200,100,100), SDCOLOR=RGB(100,50,50)
;  
; SEE ALSO:
;  IDL's own routines <C>Plot</C>, <C>Axis</C>, <C>OPlotErr</C> and <C>PlotErr</C>.
;-



PRO MSPLOT, z, zz, zzz $
            , MCOLOR=mcolor, SDCOLOR=sdcolor $
            , XRANGE=xrange, YRANGE=yrange $
            , SDMEAN=sdmean $
            , BW=bw, SIMPLE=simple, OPLOT=oplot $
            , XSTYLE=xstyle, YSTYLE=ystyle $
            , XTICKFORMAT=xtickformat, YTICKFORMAT=ytickformat $
            , YTICK_GET=ytick_get $
            , _EXTRA=extra

   On_Error, 2

   IF Keyword_Set(BW) THEN $
    Console, /WARN, '/BW has been disabled and substituted by /SIMPLE.'

   Default, simple, 0
   Default, SDCOLOR, RGB(100,100,200)
   Default, MCOLOR, GetForeground()
   
   Default, xstyle, 0
   Default, ystyle, 0

   polysize = 250

   IF N_Params() LT 2 THEN Console, /FATAL, 'Wrong number of arguments.'
   
   IF N_Params() EQ 3 THEN BEGIN
      x  = REFORM(z)
      m  = REFORM(zz)
      sd = REFORM(zzz)
   END ELSE BEGIN
      x  = LindGen(N_Elements(z))
      m  = REFORM(z)
      sd = REFORM(zz)
   END

   ;; sd may be an (2,t) array containing lower and upper
   ;; if not it will be converted to be
   IF (SIZE(sd))(0) LT 2 THEN $
    sd = Rebin(Reform(sd,1,N_Elements(sd)), 2, N_Elements(sd), /SAMPLE) 

   IF 2*N_Elements(m) NE N_Elements(sd) THEN $
    Console, 'Mean and deviation values are of different count.', /FATAL
   IF N_Elements(m) NE N_Elements(x)  THEN $
    Console, 'Abscissa and ordinate values are of different count.', /FATAL

   ; eg. fztmean returns sd as absolute values 
   IF Keyword_Set(SDMEAN) THEN BEGIN
       sd(0,*) = -sd(0,*)+m
       sd(1,*) = sd(1,*)-m
   END

   IF Set(XRANGE) THEN BEGIN
      xri = LonArr(2)
      ;; Compute first and last index inside the XRANGE
      whf = Where(x LT xrange[0], c)
      IF c NE 0 THEN xri[0] = Last(whf) ELSE xri[0] = 0
      whl = Where(x GT xrange[1], c)
      IF c NE 0 THEN xri[1] = whl[0] ELSE xri[1] = N_Elements(x)-1
;      xri = [Last(Where(x LT xrange[0])), ((Where(x GT xrange[1])))[0]]
   ENDIF ELSE BEGIN
      ;; All indices are in XRANGE
      xri = [0, N_Elements(x)-1]
   ENDELSE

   ;; Generate index array for XRANGE
   idx = LIndGen(xri[1]-xri[0]+1)+xri[0]

   ;; Compute YRANGE for actually visible data
   yr = [Min(m[idx]-sd[0,idx]), Max(m[idx]+sd[1,idx])]

   n = N_Elements(idx)

   IF Set(YRANGE) THEN yr=YRANGE ;if not the default is already set above
   
   ;; initialize coordinate system, with actually plotting neither
   ;; data nor the axes :
   IF NOT Keyword_Set(OPLOT) THEN $
    Plot, x, m, /NODATA, XRANGE=xrange, XSTYLE=xstyle+4 $
    , YRANGE=yr, YSTYLE=ystyle+4, _EXTRA=extra

   IF Keyword_Set(SIMPLE) THEN BEGIN

      OPlot, x, m+sd[1,*], LINESTYLE=1, COLOR=SDCOLOR
      OPlot, x, m-sd[0,*], LINESTYLE=1, COLOR=SDCOLOR
      OPlot, x, m, COLOR=MCOLOR 

   END ELSE BEGIN
      ;; divide polygon for sd into seperate parts each polysize long,
      ;; to avoid large single polygons whose postscript size strangely
      ;; explodes if they contains more than ca. 16000 points. Maybe
      ;; they are then generated as a bitmap? Ask IDL's Polyfill.
      steps = n/polysize ;; integer division!
      rest = n MOD polysize

      FOR si=0, steps-1 DO BEGIN
         ;; +2 in IndGen is to generate overlap, otherwise, small gaps
         ;; may be visible
         idx = LIndGen(polysize+2)+si*polysize+xri[0]
         ;; choose the present part of data to be drawn
         xnow = x[idx]
         mnow = m[idx]
         sdnow = sd[*, idx]
         PolyFill, [xnow, Reverse(xnow), xnow[0]] $
          , [mnow+sdnow[1,*], Reverse(mnow-sdnow[0,*]), mnow[0]+sdnow[1,0]] $
          , COLOR=sdcolor, NOCLIP=0
      ENDFOR ;; si

      ;; draw the last polygon, which may be smaller then polysize
      IF rest NE 0 THEN BEGIN
         idx = LIndGen(rest+2)+steps*polysize+xri[0]
         xnow = x[idx]
         mnow = m[idx]
         sdnow = sd[*, idx]
         PolyFill, [xnow, Reverse(xnow), xnow[0]] $
          , [mnow+sdnow[1,*], Reverse(mnow-sdnow[0,*]), mnow[0]+sdnow[1,0]] $
          , COLOR=sdcolor, NOCLIP=0
      ENDIF ;;rest NE 0 

      ;; draw the mean 
      OPlot, x, m, COLOR=mcolor

   ENDELSE ;; Keyword_Set(BW) 


   ;; extract titles from extra keywords, because they should not
   ;; appear at all four axes, but only left and below the plot as usual 
   extratitles = ExtraDiff(extra, ['XTITLE', 'YTITLE'])

   ;; maybe XYTITLE= are not set, then ExtraDiff returns !NONE, which
   ;; is no structure. In this case, xytitle are set manually to be
   ;; empty strings.
   IF Size(extratitles, /TNAME) NE 'STRUCT' THEN BEGIN
      xtitle = ''
      ytitle = ''
   ENDIF ELSE BEGIN ;; at least one of the two keywords is set
      IF N_TAGS(extratitles) EQ 2 THEN BEGIN ;; both keywords are set
         xtitle = extratitles.xtitle
         ytitle = extratitles.ytitle
      ENDIF ELSE BEGIN
         IF (Tag_Names(extratitles))[0] EQ 'XTITLE' THEN BEGIN 
            ;; xtitle is set, but ytitle is not
            xtitle = extratitles.xtitle
            ytitle = ''
         ENDIF ELSE BEGIN ;; vice versa
            xtitle = ''
            ytitle = extratitles.ytitle
         ENDELSE ;; (Tag_Names(extratitles))[0] EQ 'XTITLE'
      ENDELSE ;; N_TAGS(extratitles) EQ 2 
   ENDELSE ;; Size(extratitles, /TNAME) NE 'STRUCT'

   ; plot coordinate system only
   IF NOT Keyword_Set(OPLOT) THEN BEGIN 
      Axis, XAXIS=0, XRANGE=xrange, XSTYLE=xstyle, XTITLE=xtitle $
       , XTICKFORMAT=xtickformat, _EXTRA=extra
      Axis, XAXIS=1, XRANGE=xrange, XSTYLE=xstyle, XTICKFORMAT='noticks' $
       , _EXTRA=extra
      Axis, YAXIS=0, YRANGE=yr, YSTYLE=ystyle, YTITLE=ytitle $
       , YTICKFORMAT=ytickformat, YTICK_GET=ytick_get, _EXTRA=extra
      Axis, YAXIS=1, YRANGE=yr, YSTYLE=ystyle, YTICKFORMAT='noticks' $
       , _EXTRA=extra
   ENDIF
 

END
