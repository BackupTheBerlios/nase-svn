;+
; NAME: 
;  Trainspotting
;
; VERSION:
;  $Id$
;
; AIM:
;  Displays spiketrains as spike raster diagram.
;
; PURPOSE:
;  Displays numerous spike trains as a commonly used spike raster
;  diagram. The ordinate lists neuron indices, the abszissa is
;  interpreted as time and each spike is displayed as a vertical line
;  or as a dot.
;
; CATEGORY:
;  Graphic
;  Layers
;  Signals
;
; CALLING SEQUENCE: 
;* Trainspotting, tn [,XRANGE=...] [,YRANGE=...]
;*                   [,TITLE=...] [,XTITLE=...] [,YTITLE=...]
;*                   [,WIN=...]
;*                   [,LEVEL=...] [,OFFSET=...]
;*                   [,XSYMBOLSIZE=...] [YSYMBOLSIZE=...]
;*                   [,OVERSAMPLING=...]
;*                   [,/MUA [,MCOLOR=...]]
;*                   [,/CLEAN] [,/SPASS] [,/OVERPLOT]
;*                   [,/NTOLDSTYLE]
; INPUTS: 
;  tn:: Two dimensional array (time, neuron index), where each value
;       greater than <*>level</*> is interpreted as an action
;       potential. Alternatively, you may specify a sparse version of the
;       array, and set the <*>SPASS</*> keyword.
;
; INPUT KEYWORDS:
;  XRANGE/YRANGE:: Area of the whole spike raster that is
;                    displayed. Note that the values given here
;                    correspond to the actual axis annotation, not to
;                    array indices. If <*>OVERSAMPLING</*> is set,
;                    <*>XRANGE</*> may have to be adjusted properly.
;  TITLE:: Title of the plot, default: 'Spikeraster'
;  XTITLE:: Annotation of the x-axis, default: 'Time / ms'
;  YTITLE:: Annotation of the y-axis, default: 'Neuron #' 
;  WIN:: Opens and uses window no. <*>WIN</*> to display
;          rasterplot.
;  LEVEL:: Specifys the value an entry in <*>tn</*> must at least have to
;            be displayed. Default: 0.0, ie all entries GT 0.0 are plotted.
;  OFFSET:: Value added to the x-axis annotation. This may be useful
;             if only a part of the original array is to be displayed
;             and passed to <C>Trainspotting</C> in the form of eg
;             <*>tn(500:1000,*)</*>. With appropriate <*>OFFSET</*>,
;             the annotation can be corrected. Note that <*>OFFSET</*>
;             is added to <*>XRANGE</*>, but only affects the
;             annotation, not the data actually displayed. To avoid
;             confusion, it is recommended to use <*>XRANGE</*>
;             as in common IDL.
;  OVERSAMPLING:: If binsize is not 1 ms, the value passed with this
;                   keyword is used to correct the abscissa
;                   annotation. Additionally, annotation can be
;                   changed easily with this keyword even if the
;                   relation between bins and time is the same. For
;                   example, setting <*>OVERSAMPLING=1000</*> yields
;                   annotation in seconds, if bins are still 1 ms long.   
;  XSYMBOLSIZE/YSYMBOLSIZE:: Width and height of the symbols used
;                              to draw the spikes as a fraction of the
;                              total plot width respectively
;                              height. This strange unit was chosen to
;                              guarantee the same size of symbols on
;                              different 
;                              <A NREF=DEFINESHEET>sheets</A>. Defaults: 
;                              <*>XSYMBOLSIZE=1 pixel</*>,
;                              <*>YSYMBOLSIZE=1/number of neurons</*>.
;  OVERPLOT:: Plots the data into an already existing coordinate system
;  CLEAN :: Supresses all annotation and axes and draws only
;             spikes. This is useful for importing the graphics into other
;             programs.
;  MCOLOR:: Color index used for the <*>/MUA</*> option (default is red).
;  /MUA:: Shades the plot with the time-resolved total spike
;            activity scaled using the already existing ordinate. This
;            cannot be done in advance (e.g. before the call of
;            <C>Trainspotting</C> because the coordinate doesn't yet
;            exist).
;  /SPASS:: Setting this keyword lets <C>Trainspotting</C> interpret
;          its input as an array in <A NREF=SPASSMACHER>sparse</A>
;          format. To enable correct plotting, the 
;          sparse array has to include information about the
;          dimensions of the original array, i.e. it has to be
;          generated with the <*>/DIMENSIONS</*> option of
;          <A>Spassmacher</A> set. 
; /NTOLDSTYLE:: Force <C>Trainspotting</C> to interpret its input in the
;               old format of <*>tn(neuron index, time)</*>, violating the
;               NASE convention of time being the first index. This
;               option is added for reasons of compatibility and does
;               not support setting the <*>/SPASS</*> keyword simultaneously. 
;
; RESTRICTIONS:
;  <*>/NTOLDSTYLE</*> does not support setting the <*>/SPASS</*>
;  keyword simultaneously. As <*>/NTOLDSTYLE</*> is for compatibility
;  anyway, this is not a large problem. In the future,
;  <*>/NTOLDSTYLE</*> may be removed, because it needs the input array
;  to be transposed and copied internally to avoid modification of the
;  original input, which is very memory consuming.
;
; PROCEDURE:
;  1. Conventional or sparse array? Determine sizes accordingly.<BR>
;  2. Set defaults and xyranges.<BR>
;  3. Plot axes.<BR>
;  4. Define usersymbol for spikes, compute size in advance.<BR>
;  5. Read indices of spikes from array.<BR>
;  6. Plot spikes which are inside the xyranges.<BR>
;
; EXAMPLE:               
;* tn = randomu(seed,200,20) GE 0.8    
;* Trainspotting, tn, TITLE='Spikeraster Layer 1', WIN=1, OFFSET=5000
;
; Usage of symbolsize:
;* Trainspotting, tn, TITLE='spikes with ideal size'
;* Trainspotting, tn, TITLE='thicker spikes', XSYMBOLSIZE=0.02
;* Trainspotting, tn, TITLE='cute spikes', YSYMBOLSIZE=0.02
;* Trainspotting, tn, TITLE='real fat spikes', XSYMBOLSIZE=0.02,$
;*                                                  YSYMBOLSIZE=0.1
;
; Sparse arrays and ranges:
;* stn = Spassmacher(tn, /DIMENSIONS)
;* Trainspotting, stn, /SPASS
;* Trainspotting, stn, /SPASS, xrange=[50,150], yrange=[5,15]
;* Trainspotting, stn, /SPASS, xrange=[0.05,0.15], yrange=[5,15], $
;*                     OVERSAMP=1000, XTITLE='Time / s'
;
; SEE ALSO: <A>TrainspottingScope</A>, <A>Spassmacher</A>
;
;-



PRO Trainspotting, _nt, TITLE=title, LEVEL=level, WIN=win, OFFSET=offset, $
                   CLEAN=clean, OVERPLOT=overplot, CHARSIZE=Charsize, $
                   XSYMBOLSIZE=XSymbolSize, YSYMBOLSIZE=YSymbolSize, $
                   OverSampling=OverSampling, $
                   XTITLE=xtitle, SPASS=spass, $
                   XRANGE=xrange, YRANGE=yrange, $
                   MUA=mua, MCOLOR=mcolor $
                   , NTOLDSTYLE=ntoldstyle $
                   , _EXTRA=_extra

   On_Error, 2

   ;;---------------> check syntax
   IF (N_PARAMS() LT 1) THEN Console, /FATAL, 'Wrong number of arguments.'

   Default, ntoldstyle, 0

   IF Keyword_Set(NTOLDSTYLE) THEN BEGIN
      nt = Transpose(_nt)
      Console, /WARN, 'NTOLDSYTLE does not conform to NASE convention.'
      IF Keyword_Set(SPASS) THEN Console, /FATAL, 'Setting both SPASS and NTOLDSYTLE is not supported.'
   ENDIF ELSE BEGIN
      nt = _nt
      IF (Size(nt))(1) LT (Size(nt))(2) THEN $
       Console, /WARN, 'Did you consider NASE convention of time = first index?'
   ENDELSE

   
   s = Size(nt)
   IF Keyword_Set(SPASS) THEN BEGIN
      ; if there's only one dimension (empty sparse array) or there are
      ; as many entries in sparse(0,0) than in the whole array, then there
      ; can't be any dimension-information:
      IF (s(0) EQ 1) OR (s(s(0)) EQ nt(0,0)+1) THEN $
       Console, /FATAL, 'No dimension information present.'
      IF nt(0,nt(0,0)+1) GT 2 THEN $
       Console, /FATAL, 'Sparse array must be made from 1- or 2-dim original.'
      IF nt(0,nt(0,0)+1) EQ 1 THEN $
       s(1:2) = [nt(0,nt(0)+2), 1] $
      ELSE s(1:2) = nt(0,nt(0)+2:nt(0)+3)
   ENDIF ELSE BEGIN
      IF s(0) EQ 1 THEN BEGIN   ; correction for a single spiketrain
;         modified = 1
;         nt = REFORM(nt, 1, N_Elements(nt), /OVERWRITE)
         s = [s(0:1), 1, s(2:*)]
      END ELSE BEGIN
;         modified = 0
         IF s(0) NE 2 THEN Console, /FATAL $
          , 'First argument must be a 2-dim array.'
      END
   ENDELSE

   Default, title, 'Spikeraster'
   Default, xtitle, 'Time / ms'
   Default, ytitle, 'Neuron #'
   Default, level, 0.0
   Default, offset , 0.0
   Default, ccharsize, 1.0
   Default, oversampling, 1.0

   oversampling = Float(oversampling)

; old nt version commented out below
;   allneurons = s(1)-1 ; this is needed to determine ccords from inidces
;   time =  Float(s(2)-1) / oversampling

; new tn version
   allneurons = s(2)-1 ; this is needed to determine coords from indices
   time =  Float(s(1)-1) / oversampling



   IF Set(XRANGE) THEN xr=[(xrange(0)>0), $
;                           (xrange(1)<(s(2)-1))] $
                           (xrange(1)<(s(1)-1))] $
   ELSE xr = [0,time]

   IF Set(YRANGE) THEN BEGIN
;      yr = [yrange(0) > 0, yrange(1) < (s(1)-1)]
      yr = [yrange(0) > 0, yrange(1) < (s(2)-1)]
      showneurons = yr(1)-yr(0) ; this is needed to determine size of symbols
      yr = [yr(0)-1,yr(1)+1]
   ENDIF ELSE BEGIN 
;      showneurons = s(1)-1
      showneurons = s(2)-1
      yr = [-1,allneurons+1]
   ENDELSE


   ;;---------------> use own window if wanted
   IF KEYWORD_SET(WIN) THEN BEGIN
      Window,win,XSIZE=500,YSIZE=250, TITLE=title
      !P.MULTI = [0,0,1,0,0]
   END 
   
   
   
   ;;---------------> plot axis
   IF NOT KEyword_Set(OVERPLOT) THEN BEGIN
       IF KEYWORD_SET(clean) THEN BEGIN
;           empty=StrArr(25)
;           FOR i=0,24 DO empty(i)=' '
           Plot, nt, /NODATA, $
             XRANGE=xr+offset, YRANGE=yr, $
;             XSTYLE=5, YSTYLE=5, YTICKNAME=empty, XTICKNAME=empty, $
             XSTYLE=5, YSTYLE=5, YTICKFORMAT=noticks, XTICKFORMAT=noticks, $
             XMINOR=1, YMINOR=1, $
             XTICKLEN=!X.TICKLEN*0.4, YTICKLEN=!Y.TICKLEN*0.4, $
             XMARGIN=[0.2,0.2], YMARGIN=[0.2,0.2], CHARSIZE=Charsize, $
             _EXTRA=_extra
       END ELSE BEGIN
           Plot, nt, /NODATA, CHARSIZE=Charsize , $
             XRANGE=xr+offset, $ 
             YRANGE=yr, $
             XSTYLE=1, YSTYLE=1, $
             XTITLE=xtitle, YTITLE=ytitle, TITLE=title, $
             XMINOR=1, YMINOR=1, $
             XTICKLEN=!X.TICKLEN*0.4, YTICKLEN=!Y.TICKLEN*0.4, $
             YTICKFORMAT='KeineNegativenUndGebrochenenTicks', $
             _EXTRA=_extra
       ENDELSE 
   END



   ;;----------------> define UserSymbol: filled square
   PlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
   PlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)
   
   PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], $
                                  /Normal, /To_Device)
   
   Default, XSymbolSize, 0.0
   Default, YSymbolSize, 2.0/(showneurons+1)
   
   ;;----- Usersymbols, die nur ein Pixel breit sind (Stretch=0.0), duerfen
   ;;      nicht FILLed dargestellt werden, da sie sonst nicht zu sehen sind:

   IF XSymbolSize EQ 0.0 THEN Fill = 0 ELSE Fill = 1
   
   xsizedevice = xsymbolsize*PlotAreaDevice(0)
   ysizedevice = ysymbolsize*PlotAreaDevice(1)
   
   xsizechar = xsizedevice/!D.X_CH_SIZE
   ysizechar = ysizedevice/!D.Y_CH_SIZE
   
   UserSym, [-xsizechar/2.0, xsizechar/2.0, xsizechar/2.0, $
             -xsizechar/2.0, -xsizechar/2.0], $
            [-ysizechar/2.0, -ysizechar/2.0, ysizechar/2.0, $
             ysizechar/2.0, -ysizechar/2.0], $
            FILL=fill
   
   
   ;;----------------> plot spikes
   doplot = 1

   IF Keyword_Set(SPASS) THEN BEGIN
      IF nt(0) NE 0 THEN BEGIN  ; are there any spikes?
         IF LEVEL GT 0.0 THEN BEGIN ; level set, so values must be checked: 
            higherthanlevel = where(nt(1,1:nt(0)) GE level, c)
            IF c NE 0 THEN spikes = nt(0,1+higherthanlevel) ELSE doplot = 0
         ENDIF ELSE BEGIN
            spikes = nt(0,1:nt(0)) ; no level set, first col of sparse array 
                                ; already contains indices
         ENDELSE
      ENDIF ELSE doplot = 0     ; no spikes to plot
      
   ENDIF ELSE BEGIN ; conventional tn-array
      spikes = where(nt GT level, doplot) ; level check
      ;; correction for a single spiketrain
;      IF modified THEN nt = REFORM(nt, /OVERWRITE)
   ENDELSE


   ;;----------------> plot shaded mua (old code, new version happens below)
;   IF Keyword_Set(MUA) THEN BEGIN
;      IF Keyword_Set(SPASS) THEN Console, /FATAL, 'MUA and SPASS option do not work simultaneously yet!'
;      Default, mcolor, RGB(200,0,0)
;;       Polyfill, offset+[0,LIndgen((SIZE(nt))(2)), (SIZE(nt))(2),0], [0,TOTAL(nt,1), 0, 0], COLOR=mcolor
;      Polyfill, offset+[0,LIndgen((SIZE(nt))(1)), (SIZE(nt))(1),0]/oversampling, [0,Total(nt,2), 0, 0], COLOR=mcolor
;   END



   ;; now procedure is the same for sparse and conventional:
   IF (doplot NE 0) THEN BEGIN

      ;; extract color from _EXTRA tag
      IF ExtraSet(_extra, 'COLOR') THEN color = _extra.color $
      ELSE color = getforeground()

      ;; Determine coords from indices:
;      x = FLOAT(spikes / (allneurons+1)) / oversampling
;      y = spikes MOD (allneurons+1)
      y = Long(spikes/(s(1)))
      x = Float(spikes MOD (s(1)))/oversampling

      ;; Use only coords that are in x/y-range:
      yi = Where(y GT yr(0) AND y LT yr(1), no)
      IF no NE 0 THEN BEGIN
         x = Temporary(x(yi))
         y = Temporary(y(yi))
         xi = Where(x GT xr(0) AND x LT xr(1), no)
         IF no NE 0 THEN BEGIN

            ;; Plot shaded MUA before spikes are plottet
            IF Keyword_Set(MUA) THEN BEGIN
               Default, mcolor, RGB(200,0,0)
               tot = LonArr(s(1))
               FOR idx=0, s(1)-1 DO BEGIN
                  dummy = Where(x(xi) EQ idx, count)
                  tot(idx) = count
               ENDFOR
               Polyfill, offset+[0,LIndgen(s(1)),s(1),0]/oversampling $
                , [0,tot,0, 0], COLOR=mcolor
            ENDIF ;; Keyword_Set(MUA)

            ;; Plot spikes
            PlotS, x(xi) + offset, y(xi), PSYM=8, SYMSIZE=1.0, COLOR=color

         ENDIF
      ENDIF
   ENDIF ;; (doplot NE 0)
      

END

