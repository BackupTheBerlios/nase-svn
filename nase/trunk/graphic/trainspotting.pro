;+
; NAME:                   TRAINSPOTTING
;
; PURPOSE:                Stellt ein Spikeraster dar (Ordinate: Neuronen, Abszisse: Zeit)
;
; CATEGORY:               GRAPHICS
;
; CALLING SEQUENCE:       Trainspotting, nt 
;                                        [, TITLE=title] [, STRETCH=stretch] [, LEVEL=level] 
;                                        [, WIN=win] [, OFFSET=offset]
;                                        [,/CLEAN] [, V_STRETCH=v_stretch]
;
; INPUTS:                 nt      : 2-dimensionales Array, erster Index: Neuronennummern, zweiter Index: Zeit
;
; KEYWORD PARAMETERS:
;                        TITLE     : der Titel des Plots
;                        STRETCH   : Skalierungsfaktor fuer die Groesse der Symbole; 
;                                     wird automatisch angepasst und muss nur selten von
;                                     Hand gesetzt werden
;                        LEVEL     : gibt an, wie gro"s ein Eintrag in nt sein muss, um 
;                                     dargestellt zu werden, Default 1.0 (-> 1 Spike)
;                        WIN       : oeffnet und benutzt Fenster NR. Win zur Darstellung
;                        OFFSET    : Zahlenwert, der zur x-Achsenbeschriftung addiert wird; 
;                                     sinnvoll, wenn man nur einen Teil der Zeitachse darstellen 
;                                     will und der Prozedur, z.B. nt(*,500:1000) uebergibt; dann 
;                                     kann man mit OFFSET=500 die Darstellung korrigieren
;                        CLEAN     : unterdrueckt saemtliche Beschriftungen 
;                                     (fuer Weiterbearbeitungen mit anderen Programmen)
;                        V_STRETCH : vertikaler Verzerrungsfaktor fuer die Groesse der Symbole; 1.0 (Default) -> Quadrat
;
; PROCEDURE:             Default
;
; EXAMPLE:               
;                        nt = randomu(seed,20,200) GE 0.8    
;                        trainspotting, nt, TITLE='Spikeraster Layer 1', WIN=1, OFFSET=5000
;                        trainspotting, nt, WIN=2, STRETCH=0.5,  /CLEAN
;
; MODIFICATION HISTORY:  
;
;     $Log$
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


PRO Trainspotting, nt, TITLE=title, STRETCH=stretch, LEVEL=level, WIN=win, OFFSET=offset, CLEAN=clean, V_STRETCH=v_stretch

;---------------> check syntax  IF (N_PARAMS() LT 1) THEN Message, 'wrong number of arguments'
   IF ((Size(nt))(0) NE 2) THEN Message, 'first arg must be a 2-dim array'
   
   neurons = (SIZE(nt))(1)-1
   IF (neurons LT 0) THEN Message, 'keine Neuronen zum Darstellen'
   time =  (SIZE(nt))(2)-1
   IF (time LT 0) THEN Message, 'keine Zeit zum Darstellen :-)'
   
   
   Default, title  , 'Spikeraster'
   Default, stretch, 1.0
   Default, level  , 1.0
   Default, offset , 0.0
   
   
;---------------> use own window if wanted
  IF KEYWORD_SET(WIN) THEN BEGIN
      Window,win,XSIZE=500,YSIZE=250, TITLE=title
      !P.MULTI = [0,0,1,0,0]
   END 
   
   
   
;---------------> plot axis
   IF KEYWORD_SET(clean) THEN BEGIN
      empty=StrArr(25)
      for i=0,24 DO empty(i)=' '
      plot, nt, /NODATA, XRANGE=[offset,time+offset+FIX(stretch)], YRANGE=[-FIX(stretch),neurons+FIX(stretch)], XSTYLE=5, YSTYLE=5, YTICKNAME=empty, XTICKNAME=empty, XTICKLEN=0.00001, YTICKLEN=0.00001, XMARGIN=[0.2,0.2], YMARGIN=[0.2,0.2]
   END ELSE BEGIN
      Plot, nt, /NODATA, CHARSIZE=1.5 ,XRANGE=[offset,time+offset+FIX(stretch)], YRANGE=[-FIX(stretch),neurons+FIX(stretch)], XSTYLE=1, YSTYLE=1, $
       XTITLE='Time / BIN', YTITLE='Neuron #', TITLE=title, $
       XTICKLEN=0.00001, YTICKLEN=0.00001, $
       ytickformat='KeineNegativenUndGebrochenenTicks', $
      Xtickformat='KeineNegativenUndGebrochenenTicks'
   END


;----------------> define filled square
   Default, v_stretch, 1.0
  
;   height = LONG(4*v_stretch)
   height = LONG(2*v_stretch)

;   UserSym, [ 0, 0, 4, 4, 0], [ 0, height, height, 0, 0], /FILL
   UserSym, [ -2, 2, 2, -2, -2], [ -height, -height, height, height, -height], /FILL
      

;----------------> plot spikes
   spikes = where(nt GE level, count)
   IF (count NE 0) THEN BEGIN
      PlotS, LONG(spikes / FLOAT(neurons+1) + offset), spikes MOD (neurons+1), PSYM=8, SYMSIZE= MAX([MIN([1.0, 35./time])*stretch,0.1])
   END


END

