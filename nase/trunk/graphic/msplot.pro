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
;*         [,/SDMEAN]  [,/POSITIVE]
;*         [{[,MCOLOR=...] [,SDCOLOR=...]} | /BW ]
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
;  BW      :: Creates output for black/white devices. The errors are
;             plotted as dotted lines. <*>MCOLOR</*> and
;             <*>SDCOLOR</*> are ignored. 
;  MCOLOR  :: Colorindex used for plotting the data (default:
;             foreground color).
;  OPLOT   :: plots data into an already existing window 
;  SDCOLOR :: Colorindex used to draw error area (default: darkblue).  
;  SDMEAN  :: <*>sd</*> entries are interpreted as absolute values
;             (mean+-error). This kind of output is e.g. provided by <A>FZTmean</A>. 
;  _EXTRA  :: All other unrecognized options are passed to the
;             underlying <*>Plot</*> procedures.
;  
; RESTRICTIONS:
;  <*>X-/YTITLE</*> and <*>X-/YTICKFORMAT</*> can only be used for
;  left and bottom axes, labeling of right and top axes is suppressed.
;
; PROCEDURE:
;  + establish coordinate system<BR>
;  + error area via PolyFill<BR>
;  + mean via oplot<BR>
;  + plot axes again to overwrite error area<BR>
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
;  IDL's own routines <C>OPLOTERR</C>, <C>PLOT</C>, <C>PLOTERR</C>.
;-



PRO MSPLOT, z, zz, zzz $
            , MCOLOR=mcolor, SDCOLOR=sdcolor, XRANGE=xrange, YRANGE=yrange $
            , SDMEAN=sdmean $
            , BW=bw, OPLOT=oplot $
            , XSTYLE=xstyle, YSTYLE=ystyle $ 
            , _EXTRA=e

   On_Error, 2

   Default, SDCOLOR, RGB(100,100,200)
   Default, MCOLOR, GetForeground()
   
   Default, xstyle, 0
   Default, ystyle, 0

   IF N_Params() LT 2 THEN Message, 'wrong number of arguments'
   n = N_Elements(z)
   IF N_Params() EQ 3 THEN BEGIN
      x  = REFORM(z)
      m  = REFORM(zz)
      sd = REFORM(zzz)
   END ELSE BEGIN
      x  = LindGen(n)
      m  = REFORM(z)
      sd = REFORM(zz)
   END

   ; sd may be an (2,t) array containing lower and upper
   ; if not it will be converted to be
   IF (SIZE(sd))(0) LT 2 THEN sd = REBIN(REFORM(sd,1,N_Elements(sd)), 2, N_Elements(sd), /SAMPLE) 

   IF 2*N_Elements(m) NE N_Elements(sd) THEN $
    Console, 'Mean and deviation values are of different count.', /FATAL
   IF N_Elements(m) NE N_Elements(x)  THEN $
    Console, 'Abszissa and ordinate values are of different count.', /FATAL

   ; eg. fztmean returns sd as absolute values 
   IF Keyword_Set(SDMEAN) THEN BEGIN
       sd(0,*) = -sd(0,*)+m
       sd(1,*) = sd(1,*)-m
   END

   IF Set(XRANGE) THEN BEGIN
      xri = [(Where(x GE xrange(0)))(0), last((Where(x LE xrange(1))))] 
      xf = x > XRANGE(0) < XRANGE(1)
      yr = [MIN(m(xri(0):xri(1))-sd(0,xri(0):xri(1))) $
            , MAX(m(xri(0):xri(1))+sd(1,xri(0):xri(1)))]
   ENDIF ELSE BEGIN
      xf = x
      yr = [MIN(m-sd(0,*)), MAX(m+sd(1,*))]
   ENDELSE
   IF Set(YRANGE) THEN yr=YRANGE ;if not the default is already set above
   


   ; initialize coordinate system, without actually plotting the axes
   IF NOT Keyword_Set(OPLOT) THEN $
    Plot, x, m, /NODATA, XRANGE=xrange, XSTYLE=xstyle+4, YRANGE=yr, YSTYLE=ystyle+4, _EXTRA=e

   IF Keyword_Set(BW) THEN BEGIN
       OPlot, x, m+sd(1,*), LINESTYLE=1
       OPlot, x, m-sd(0,*), LINESTYLE=1
       OPlot, x, m 
   END ELSE BEGIN
       PolyFill, [xf,xf(n-1),REVERSE(xf), xf(0)] ,$
         [m+sd(1,*), m(n-1)-sd(0,n-1), REVERSE(m-sd(0,*)), m(0)+sd(1,0)],$
         COLOR=sdcolor, NOCLIP=0
       OPlot, x, m, COLOR=mcolor
   END

   ; plot coordinate system only
   IF NOT KEYWORD_Set(OPLOT) THEN $
     Plot, x, m, /NODATA, /NOERASE, XRANGE=xrange, XSTYLE=xstyle, YRANGE=yr, YSTYLE=ystyle, _EXTRA=e
END
