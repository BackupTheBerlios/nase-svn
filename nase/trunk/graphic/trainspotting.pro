;+
; NAME: TRAINSPOTTING
;
; PURPOSE: Stellt ein Spikeraster dar (Ordinate: Neuronen, Abszisse: Zeit)
;
; CATEGORY: GRAPHICS
;
; CALLING SEQUENCE: Trainspotting, nt 
;                                  [, TITLE=title] [,XTITLE=xtitle]
;                                  [, WIN=win], [CHARSIZE=Schriftgroesse]
;                                  [, LEVEL=level] [, OFFSET=offset]
;                                  [, XSYMBOLSIZE=Symbolbreite] [YSYMBOLSIZE=Symbolhoehe]
;                                  [, OVERSAMPLING=Oversampling]
;                                  [,/CLEAN]
; INPUTS: nt: 2-dimensionales Array, erster Index: Neuronennummern, zweiter Index: Zeit
;
; OPTIONAL INPUTS: Title:          der Titel des Plots
;                  xtitle:         Beschriftung der X-Achse, Default: 'Time / ms' 
;                  Win:            oeffnet und benutzt Fenster NR. Win zur Darstellung
;                  Schriftgroesse: die Groesse der Achsenbeschriftung.
;                  Level:          gibt an, wie gro"s ein Eintrag in nt sein muss, um 
;                  Offset:         Zahlenwert, der zur x-Achsenbeschriftung addiert wird; 
;                                  sinnvoll, wenn man nur einen Teil der Zeitachse darstellen 
;                                  will und der Prozedur, z.B. nt(*,500:1000) uebergibt; dann 
;                                  kann man mit OFFSET=500 die Darstellung korrigieren
;                                  dargestellt zu werden.
;                                  Default: 1.0 (-> 1 Spike)
;                  Oversampling:   Gewaehrleistet eine korrekte Darstellung von Neuronen
;                                  mit Oversampling, BIN <-> ms  
;                  Symbolbreite:   Die Breite der zur Darstellung der Spikes verwendeten
;                                  Symbole in Bruchteilen der verfuegbaren Plotbreite.
;                                  (Diese seltsame Einheit wurde gewaehlt, um eine einheit-
;                                  liche Darstellung auf unterschiedlichen Sheets zu erzielen.)
;                                  Default: ein Pixel
;                  Symbolhoehe:    Die Hoehe der zur Darstellung der Spikes verwendeten
;                                  Symbole in Bruchteilen der verfuegbaren Plothoehe.
;                                  Default: 1 / Anzahl der dargestellten Neuronen 
;
; KEYWORD PARAMETERS: CLEAN : unterdrueckt saemtliche Beschriftungen und malt nur Spikes.
;                             (fuer Weiterbearbeitungen mit anderen Programmen)
;
; PROCEDURE: Default
;
; EXAMPLE:               
;          nt = randomu(seed,20,200) GE 0.8    
;          Trainspotting, nt, TITLE='Spikeraster Layer 1', WIN=1, OFFSET=5000
;
;          zur Verwendung der Symbolgroesse:
;          Trainspotting, nt, TITLE='Spikes mit Idealgroesse'
;          Trainspotting, nt, TITLE='Dickere Spikes', XSYMBOLSIZE=0.02
;          Trainspotting, nt, TITLE='Niedliche Spikes', YSYMBOLSIZE=0.02
;          Trainspotting, nt, TITLE='Richtig Fette Spikes', XSYMBOLSIZE=0.02, YSYMBOLSIZE=0.1
;
;
; MODIFICATION HISTORY:  
;
;     $Log$
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
;     TICKLEN minimal eingestellt, dass Achsenticks nicht mehr sichtbar sind, Mirko, 13.8.97
;
;-



PRO Trainspotting, nt, TITLE=title, LEVEL=level, WIN=win, OFFSET=offset, CLEAN=clean, $
                   STRETCH=stretch, V_STRETCH=v_stretch, CHARSIZE=Charsize, $
                   XSYMBOLSIZE=XSymbolSize, YSYMBOLSIZE=YSymbolSize, OverSampling=OverSampling, $
                   XTITLE=xtitle, _EXTRA=_extra

;-----Keine alten Keywords mehr verwenden:
IF Set(STRETCH) OR Set(V_STRETCH) THEN message, /INFORM, 'Statt STRETCH und V_STRETCH werden ab sofort per Order di Mufti X- und YSYMBOLSIZE verwendet. Die momentane Darstellung erfolgt mit deren Default-Werten. Noch Fragen???'


;---------------> check syntax
IF (N_PARAMS() LT 1) THEN Message, 'wrong number of arguments'

s = SIZE(nt)
IF S(0) EQ 1 THEN BEGIN ; correction for a single spiketrain
   modified = 1
   nt = REFORM(nt, 1, N_Elements(nt), /OVERWRITE)
END ELSE BEGIN
   modified = 0
   IF s(0) NE 2 THEN Message, 'first arg must be a 2-dim array'
END

neurons = (SIZE(nt))(1)-1
IF (neurons LT 0) THEN Message, 'keine Neuronen zum Darstellen'

   
   
Default, title  , 'Spikeraster'
Default, xtitle, 'Time / ms'
Default, level  , 1.0
Default, offset , 0.0
Default, Charsize, 1.0
Default, OverSampling, 1.0

Offset = Offset / FLOAT(OverSampling)
time =  Float((SIZE(nt))(2)-1) / FLOAT(OverSampling)
IF (time LT 0) THEN Message, 'keine Zeit zum Darstellen :-)'


;---------------> use own window if wanted
IF KEYWORD_SET(WIN) THEN BEGIN
   Window,win,XSIZE=500,YSIZE=250, TITLE=title
   !P.MULTI = [0,0,1,0,0]
END 
   
   
   
;---------------> plot axis
IF KEYWORD_SET(clean) THEN BEGIN
   empty=StrArr(25)
   FOR i=0,24 DO empty(i)=' '
   Plot, nt, /NODATA, XRANGE=[offset,time+offset], YRANGE=[-1,neurons+1], $
    XSTYLE=5, YSTYLE=5, YTICKNAME=empty, XTICKNAME=empty, XTICKLEN=0.00001, YTICKLEN=0.00001, $
    XMARGIN=[0.2,0.2], YMARGIN=[0.2,0.2], CHARSIZE=Charsize, _EXTRA=_extra
END ELSE BEGIN
   Plot, nt, /NODATA, CHARSIZE=Charsize , $
    XRANGE=[offset,time+offset], $
    YRANGE=[-1,neurons+1], $
    XSTYLE=1, YSTYLE=1, $
    XTITLE=xtitle, YTITLE='Neuron #', TITLE=title, $
    XTICKLEN=0.00001, YTICKLEN=0.00001, $
    YTICKFORMAT='KeineNegativenUndGebrochenenTicks', XTICKFORMAT='KeineNegativenUndGebrochenenTicks', _EXTRA=_extra
ENDELSE 



;----------------> define UserSymbol: filled square
PlotWidthNormal = (!X.Window)(1)-(!X.Window)(0)
PlotHeightNormal = (!Y.Window)(1)-(!Y.Window)(0)

PlotAreaDevice = Convert_Coord([PlotWidthNormal,PlotHeightNormal], /Normal, /To_Device)

Default, XSymbolSize, 0.0
Default, YSymbolSize, 2.0/(Neurons+1)

;----- Usersymbols, die nur ein Pixel breit sind (Stretch=0.0), duerfen
;      nicht FILLed dargestellt werden, da sie dann nicht zu sehen sind:

IF XSymbolSize EQ 0.0 THEN Fill = 0 ELSE Fill = 1

xsizedevice = xsymbolsize*PlotAreaDevice(0)
ysizedevice = ysymbolsize*PlotAreaDevice(1)

xsizechar = xsizedevice/!D.X_CH_SIZE
ysizechar = ysizedevice/!D.Y_CH_SIZE

UserSym, [-xsizechar/2.0, xsizechar/2.0, xsizechar/2.0, -xsizechar/2.0, -xsizechar/2.0], [-ysizechar/2.0,-ysizechar/2.0,ysizechar/2.0,ysizechar/2.0,-ysizechar/2.0], FILL=Fill



;----------------> plot spikes
spikes = where(nt GE level, count)
IF (count NE 0) THEN PlotS, LONG((spikes / FLOAT(neurons+1))/OverSampling + offset), spikes MOD (neurons+1), PSYM=8, SYMSIZE=1.0


; correction for a single spiketrain
IF modified THEN nt = REFORM(nt, /OVERWRITE)

END

