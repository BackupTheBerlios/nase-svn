;+
; NAME: 
;  Trainspotting
;
; VERSION:
;  $Id$
;
; AIM:
;  displays spiketrains as spike raster diagram
;
; PURPOSE:
;  Displays numerous spike trains as a commonly spike raster
;  diagram. The Ordinate lists neuron indides, the abszissa is
;  interpreted as time and each spike is displayed as a dot.
;
; CATEGORY:
;  Graphic
;  Layers
;  Signals
;
; CALLING SEQUENCE: 
;* Trainspotting, nt [,XRANGE=xrange] [,YRANGE=yrange]
;*                   [,TITLE=...] [,XTITLE=...] [,YTITLE=...]
;*                   [,WIN=...], [CHARSIZE=...]
;*                   [,LEVEL=...] [,OFFSET=...]
;*                   [,XSYMBOLSIZE=...] [YSYMBOLSIZE=...]
;*                   [,OVERSAMPLING=...]
;*                   [,/MUA [,MCOLOR=...]]
;*                   [,/CLEAN] [,/SPASS] [,/OVERPLOT]
;
; INPUTS: 
;  nt:: Two dimensional array (neuron index, time), where each value
;       greater than <*>level</*> is interpreted as
;       spike. Alternatively, you may specify a sparse version of the
;       array, using <*>SPASS</*> keyword.
;
; OPTIONAL INPUTS:
;    XRANGE/YRANGE:: Bereich aus dem gesamten Spikeraster, der in der 
;                    Darstellung erscheinen soll. Man beachte, daß diese
;                    Werte den tatsächlichen Achsenbeschriftungen entsprechen,
;                    falls also OVERSAMPLING benutzt wird, müssen die
;                    xrange-Werte angepaßt werden.
;    title::         der Titel des Plots, Default: 'Spikeraster'
;    xtitle::        Beschriftung der X-Achse, Default: 'Time / ms'
;    ytitle::        Beschriftung der Y-Achse, Default: 'Neuron #' 
;    win::           oeffnet und benutzt Fenster NR. Win zur Darstellung
;    CHARSIZE:: die Größe der Achsenbeschriftung.
;    offset::         Zahlenwert, der zur x-Achsenbeschriftung addiert wird
;                    (beachte also OVERSAPMPLING); 
;                    sinnvoll, wenn man nur einen Teil der Zeitachse 
;                    darstellen will und der Prozedur, z.B. nt(*,500:1000) 
;                    uebergibt; dann kann man mit OFFSET=500 die Darstellung 
;                    korrigieren
;    level::          gibt an, wie groß ein Eintrag in nt sein muss, um 
;                    dargestellt zu werden. Default: 0.0, dh alle 
;                    Einträge GT 0 werden dargestellt. 
;    oversampling::   Gewaehrleistet eine korrekte Darstellung von Neuronen
;                    mit Oversampling, BIN <-> ms. Mit oversampling kann
;                    aber auch elegant die Achsenbeschriftung geändert 
;                    werden, ohne daß sich die Beziehung BIN-ms geändert
;                    haben muss. ZB liefert oversampling=1000 eine 
;                    Beschriftung in Sekunden, falls ein BIN weiterhin eine 
;                    Millisekunde lang ist.   
;    XSYMBOLSIZE::   Die Breite der zur Darstellung der Spikes verwendeten
;                    Symbole in Bruchteilen der verfuegbaren Plotbreite.
;                    (Diese seltsame Einheit wurde gewaehlt, um eine einheit-
;                    liche Darstellung auf unterschiedlichen Sheets zu 
;                    erzielen.) Default: ein Pixel
;    YSYMBOLSIZE::    Die Hoehe der zur Darstellung der Spikes verwendeten
;                    Symbole in Bruchteilen der verfuegbaren Plothoehe.
;                    Default: 1 / Anzahl der dargestellten Neuronen 
;    OVERPLOT::      Plots data into the already existing coordinate system
;                     
;
; INPUT KEYWORDS: 
;    CLEAN :: unterdrueckt saemtliche Beschriftungen und malt nur Spikes.
;             (fuer Weiterbearbeitungen mit anderen Programmen)
;    MCOLOR:: color index used for the <*>/MUA</*> option (default is red)
;    MUA  :: Shades the plot with the time-resolved total spike
;            activity scaled using the already existing ordinate. This
;            cannot be done in advance (e.g. before the call of
;            <C>Trainspotting</C> because the coordinate doesn't yet exist.)
;    SPASS:: Gibt an, ob das übergebene nt-Array als Sparse interpretiert werden
;           soll. Dazu muß das Sparse-Array allerdings Infromation über die
;           Dimension enthalten. Siehe dazu /DIMENSIONS - Keyword in 
;           <A>Spassmacher</A>.
;
; PROCEDURE:
;            1. Konventionelles oder Sparse-Array? Größen entsprechend 
;               auslesen.<BR>
;            2. Defaults und Ranges setzen.<BR>
;            3. Achsen plotten.<BR>
;            4. Usersymbol für Spikes definieren, vorher Größe dafür berechnen.<BR>
;            5. Indizes der Spikes auslesen.<BR>
;            6. Plot der Spikes, die innerhalb der Ranges liegen.<BR>
;
; EXAMPLE:               
;* nt = randomu(seed,20,200) GE 0.8    
;* Trainspotting, nt, TITLE='Spikeraster Layer 1', WIN=1, OFFSET=5000
;
;usage of symbolgroesse:
;* Trainspotting, nt, TITLE='spikes with ideal size'
;* Trainspotting, nt, TITLE='thicker spikes', XSYMBOLSIZE=0.02
;* Trainspotting, nt, TITLE='cute spikes', YSYMBOLSIZE=0.02
;* Trainspotting, nt, TITLE='real fat spikes', XSYMBOLSIZE=0.02,$
;*                                                  YSYMBOLSIZE=0.1
;
;spass arrays and ranges:
;* snt = Spassmacher(nt, /DIMENSIONS)
;* Trainspotting, snt, /SPASS
;* Trainspotting, snt, /SPASS, xrange=[50,150], yrange=[5,15]
;* Trainspotting, snt, /SPASS, xrange=[0.05,0.15], yrange=[5,15], $
;*                     OVERSAMP=1000, XTITLE='Time / s'
;
; SEE ALSO: <A>TrainspottingScope</A>, <A>Spassmacher</A>
;
;-



PRO Trainspotting, nt, TITLE=title, LEVEL=level, WIN=win, OFFSET=offset, $
                   CLEAN=clean, OVERPLOT=overplot, CHARSIZE=Charsize, $
                   XSYMBOLSIZE=XSymbolSize, YSYMBOLSIZE=YSymbolSize, $
                   OverSampling=OverSampling, $
                   XTITLE=xtitle, SPASS=spass, $
                   XRANGE=xrange, YRANGE=yrange, $
                   MUA=mua, MCOLOR=mcolor ,$
                   _EXTRA=_extra

;---------------> check syntax
   IF (N_PARAMS() LT 1) THEN Message, 'wrong number of arguments'


   s = SIZE(nt)
   IF Keyword_Set(SPASS) THEN BEGIN
      ; if there's only one dimension (empty sparse array) or there are
      ; as many entries in sparse(0,0) than in the whole array, then there
      ; can't be any dimension-information:
      IF (s(0) EQ 1) OR (s(s(0)) EQ nt(0,0)+1) THEN $
       Message, 'No dimension information present.'
      IF nt(0,nt(0,0)+1) NE 2 THEN $
       Message, 'Sparse array must be made from 2-dim original.'
      s(1:2) = nt(0,nt(0)+2:nt(0)+3)
   ENDIF ELSE BEGIN
      IF S(0) EQ 1 THEN BEGIN   ; correction for a single spiketrain
         modified = 1
         nt = REFORM(nt, 1, N_Elements(nt), /OVERWRITE)
         s = SIZE(nt)
      END ELSE BEGIN
         modified = 0
         IF s(0) NE 2 THEN Message, 'first arg must be a 2-dim array'
      END
   ENDELSE


   Default, title, 'Spikeraster'
   Default, xtitle, 'Time / ms'
   Default, ytitle, 'Neuron #'
   Default, level, 0.0
   Default, offset , 0.0
   Default, Ccharsize, 1.0
   Default, oversampling, 1.0

   oversampling = Float(oversampling)

   allneurons = s(1)-1 ; this is needed to determine ccords from inidces
   time =  Float(s(2)-1) / oversampling


   IF Set(XRANGE) THEN xr=[(xrange(0)>0), $
                           (xrange(1)<(s(2)-1))] $
   ELSE xr = [0,time]

   IF Set(YRANGE) THEN BEGIN
      yr = [yrange(0) > 0, yrange(1) < (s(1)-1)]
      showneurons = yr(1)-yr(0) ; this is needed to determine size of symbols
      yr = [yr(0)-1,yr(1)+1]
   ENDIF ELSE BEGIN 
      showneurons = s(1)-1
      yr = [-1,allneurons+1]
   ENDELSE


;---------------> use own window if wanted
   IF KEYWORD_SET(WIN) THEN BEGIN
      Window,win,XSIZE=500,YSIZE=250, TITLE=title
      !P.MULTI = [0,0,1,0,0]
   END 
   
   
   
;---------------> plot axis
   IF NOT KEyword_Set(OVERPLOT) THEN BEGIN
       IF KEYWORD_SET(clean) THEN BEGIN
           empty=StrArr(25)
           FOR i=0,24 DO empty(i)=' '
           Plot, nt, /NODATA, $
             XRANGE=xr+offset, YRANGE=yr, $
             XSTYLE=5, YSTYLE=5, YTICKNAME=empty, XTICKNAME=empty, $
             XTICKLEN=0.00001, YTICKLEN=0.00001, $
             XMARGIN=[0.2,0.2], YMARGIN=[0.2,0.2], CHARSIZE=Charsize, $
             _EXTRA=_extra
       END ELSE BEGIN
           Plot, nt, /NODATA, CHARSIZE=Charsize , $
             XRANGE=xr+offset, $ 
             YRANGE=yr, $
             XSTYLE=1, YSTYLE=1, $
             XTITLE=xtitle, YTITLE=ytitle, TITLE=title, $
             XTICKLEN=0.00001, YTICKLEN=0.00001, $
             YTICKFORMAT='KeineNegativenUndGebrochenenTicks', $
             _EXTRA=_extra
       ENDELSE 
   END



;----------------> plot shaded mua 
   IF Keyword_Set(MUA) THEN BEGIN
       Default, MCOLOR, RGB(200,0,0)
       Polyfill, [0,LIndgen((SIZE(nt))(2)), (SIZE(nt))(2),0], [0,TOTAL(nt,1), 0, 0], COLOR=mcolor
   END



;----------------> define UserSymbol: filled square
   PlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
   PlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)
   
   PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], $
                                  /Normal, /To_Device)
   
   Default, XSymbolSize, 0.0
   Default, YSymbolSize, 2.0/(showneurons+1)
   
;----- Usersymbols, die nur ein Pixel breit sind (Stretch=0.0), duerfen
;      nicht FILLed dargestellt werden, da sie sonst nicht zu sehen sind:

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
   
   
;----------------> plot spikes
   doplot = 1

   IF Keyword_Set(SPASS) THEN BEGIN
      IF nt(0) NE 0 THEN BEGIN ; are there any spikes?
         IF LEVEL GT 0.0 THEN BEGIN ; level set, so values must be checked: 
            higherthanlevel = where(nt(1,1:nt(0)) GE level, c)
            IF c NE 0 THEN spikes = nt(0,1+higherthanlevel) ELSE doplot = 0
         ENDIF ELSE BEGIN
            spikes = nt(0,1:nt(0)) ; no level set, first col of sparse array 
                                   ; already contains indices
         ENDELSE
      ENDIF ELSE doplot = 0 ; no spikes to plot
      
   ENDIF ELSE BEGIN ; conventional nt-array
      spikes = where(nt GT level, doplot) ; level check
      ; correction for a single spiketrain
      IF modified THEN nt = REFORM(nt, /OVERWRITE)
   ENDELSE

   ; now procedure is the same for sparse and conventional:
   IF (doplot NE 0) THEN BEGIN
      ; Determine coords from indices:
      x = spikes / FLOAT(allneurons+1) / oversampling
      y = spikes MOD (allneurons+1)
      ; Use only coords that are in x/y-range:
      yi = Where(y GT yr(0) AND y LT yr(1), no)
      IF no NE 0 THEN BEGIN
         x = Temporary(x(yi))
         y = Temporary(y(yi))
         xi = Where(x GT xr(0) AND x LT xr(1), no)
         IF no NE 0 THEN PlotS, x(xi) + offset, y(xi), PSYM=8, SYMSIZE=1.0
      ENDIF

   ENDIF

      

END

