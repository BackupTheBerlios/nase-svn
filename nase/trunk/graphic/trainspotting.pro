;+
; NAME: TRAINSPOTTING
;
; AIM:
;  Display spiketrains(s).
;
; PURPOSE: Stellt ein Spikeraster dar (Ordinate: Neuronen, Abszisse: Zeit)
;
; CATEGORY: GRAPHICS
;
; CALLING SEQUENCE: 
;    Trainspotting, nt [,XRANGE=xrange] [,YRANGE=yrange]
;                      [,TITLE=title] [,XTITLE=xtitle] [,YTITLE=ytitle]
;                      [,WIN=win], [CHARSIZE=schriftgroesse]
;                      [,LEVEL=level] [, OFFSET=offset]
;                      [,XSYMBOLSIZE=symbolbreite] [YSYMBOLSIZE=symbolhoehe]
;                      [,OVERSAMPLING=oversampling]
;                      [,/CLEAN] [,/SPASS]
;
; INPUTS: nt: 2-dimensionales Array, erster Index: Neuronennummer, 
;                                   zweiter Index: Zeit
;             wahlweise die Sparse Version eines solchen Arrays, siehe 
;             Keyword /SPASS
;
; OPTIONAL INPUTS:
;    x/yrange:       Bereich aus dem gesamten Spikeraster, der in der 
;                    Darstellung erscheinen soll. Man beachte, daß diese
;                    Werte den tatsächlichen Achsenbeschriftungen entsprechen,
;                    falls also OVERSAMPLING benutzt wird, müssen die
;                    xrange-Werte angepaßt werden.
;    title:          der Titel des Plots, Default: 'Spikeraster'
;    xtitle:         Beschriftung der X-Achse, Default: 'Time / ms'
;    ytitle:         Beschriftung der Y-Achse, Default: 'Neuron #' 
;    win:            oeffnet und benutzt Fenster NR. Win zur Darstellung
;    schriftgroesse: die Größe der Achsenbeschriftung.
;    offset:         Zahlenwert, der zur x-Achsenbeschriftung addiert wird
;                    (beachte also OVERSAPMPLING); 
;                    sinnvoll, wenn man nur einen Teil der Zeitachse 
;                    darstellen will und der Prozedur, z.B. nt(*,500:1000) 
;                    uebergibt; dann kann man mit OFFSET=500 die Darstellung 
;                    korrigieren
;    level:          gibt an, wie groß ein Eintrag in nt sein muss, um 
;                    dargestellt zu werden. Default: 0.0, dh alle 
;                    Einträge GT 0 werden dargestellt. 
;    oversampling:   Gewaehrleistet eine korrekte Darstellung von Neuronen
;                    mit Oversampling, BIN <-> ms. Mit oversampling kann
;                    aber auch elegant die Achsenbeschriftung geändert 
;                    werden, ohne daß sich die Beziehung BIN-ms geändert
;                    haben muss. ZB liefert oversampling=1000 eine 
;                    Beschriftung in Sekunden, falls ein BIN weiterhin eine 
;                    Millisekunde lang ist.   
;    symbolbreite:   Die Breite der zur Darstellung der Spikes verwendeten
;                    Symbole in Bruchteilen der verfuegbaren Plotbreite.
;                    (Diese seltsame Einheit wurde gewaehlt, um eine einheit-
;                    liche Darstellung auf unterschiedlichen Sheets zu 
;                    erzielen.) Default: ein Pixel
;    symbolhoehe:    Die Hoehe der zur Darstellung der Spikes verwendeten
;                    Symbole in Bruchteilen der verfuegbaren Plothoehe.
;                    Default: 1 / Anzahl der dargestellten Neuronen 
;
; KEYWORD PARAMETERS: 
;    CLEAN : unterdrueckt saemtliche Beschriftungen und malt nur Spikes.
;            (fuer Weiterbearbeitungen mit anderen Programmen)
;    SPASS: Gibt an, ob das übergebene nt-Array als Sparse interpretiert werden
;           soll. Dazu muß das Sparse-Array allerdings Infromation über die
;           Dimension enthalten. Siehe dazu /DIMENSIONS - Keyword in 
;           <A HREF="../misc/arrays/#SPASSAMCHER">Spassmacher</A>.
;
; PROCEDURE: 1. Konventionelles oder Sparse-Array? Größen entsprechend 
;               auslesen.
;            2. Defaults und Ranges setzen.
;            3. Achsen plotten.
;            4. Usersymbol für Spikes definieren, vorher Größe dafür berechnen.
;            5. Indizes der Spikes auslesen.
;            6. Plot der Spikes, die innerhalb der Ranges liegen.
;
; EXAMPLE:               
;          nt = randomu(seed,20,200) GE 0.8    
;          Trainspotting, nt, TITLE='Spikeraster Layer 1', WIN=1, OFFSET=5000
;
;          zur Verwendung der Symbolgroesse:
;          Trainspotting, nt, TITLE='Spikes mit Idealgroesse'
;          Trainspotting, nt, TITLE='Dickere Spikes', XSYMBOLSIZE=0.02
;          Trainspotting, nt, TITLE='Niedliche Spikes', YSYMBOLSIZE=0.02
;          Trainspotting, nt, TITLE='Richtig Fette Spikes', XSYMBOLSIZE=0.02,$
;                                                          YSYMBOLSIZE=0.1
;
;          mit Sparse-Array und Ranges:
;          snt = Spassmacher(nt, /DIMENSIONS)
;          Trainspotting, snt, /SPASS
;          Trainspotting, snt, /SPASS, xrange=[50,150], yrange=[5,15]
;          Trainspotting, snt, /SPASS, xrange=[0.05,0.15], yrange=[5,15], $
;                               OVERSAMP=1000, XTITLE='Time / s'
;
; SEE ALSO: <A HREF="plotcilloscope/#TRAINSPOTTINGSCOPE">TrainspottingScope</A>, <A HREF="../misc/arrays/#SPASSAMCHER">Spassmacher</A>
;
; MODIFICATION HISTORY:  
;
;     $Log$
;     Revision 1.13  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 1.12  1999/12/06 13:25:47  thiel
;         Tried to turn on cvs watches.
;
;     Revision 1.11  1999/12/06 13:18:45  thiel
;         Now able to use sparse-nt-arrays and x/yrange.
;
;     Revision 1.10  1999/06/16 09:16:39  thiel
;         Hatte gar kein _EXTRA, jetzt schon.
;
;     Revision 1.9  1999/02/03 12:51:50  saam
;           + problem with OFFSET corrected
;           + works for a one-dimensional spiketrain, also
;
;     Revision 1.8  1998/06/30 12:19:28  thiel
;            Schluesselwort XTITLE hinzugefuegt.
;
;     Revision 1.7  1998/05/14 08:59:13  saam
;          keyword oversamp renamed to oversampling
;          and added to the header
;
;     Revision 1.6  1998/02/05 13:31:28  saam
;           new keyword to handle other time resolutions
;           abszissa in ms and not in BIN
;
;     Revision 1.5  1998/01/17 17:13:57  thiel
;            Neue Behandlung der Plotsymbolgroesse.
;
;     Revision 1.4  1997/12/10 15:12:33  thiel
;            Jetzt mit neuen Usersymbols (zentriert)
;            und schoenerer Achsenbeschriftung (nicht negativ
;            und keine Brueche).
;
;     Revision 1.3  1997/11/26 09:26:56  saam
;           Keyword V_STRETCH hinzugefuegt
;
;                              
;     Urversion erstellt, Mirko, 13.8.97
;     TICKLEN minimal eingestellt, dass Achsenticks nicht mehr sichtbar sind,
;     Mirko, 13.8.97
;
;-



PRO Trainspotting, nt, TITLE=title, LEVEL=level, WIN=win, OFFSET=offset, $
                   CLEAN=clean, CHARSIZE=Charsize, $
                   XSYMBOLSIZE=XSymbolSize, YSYMBOLSIZE=YSymbolSize, $
                   OverSampling=OverSampling, $
                   XTITLE=xtitle, SPASS=spass, $
                   XRANGE=xrange, YRANGE=yrange, _EXTRA=_extra

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

