;+
; NAME:               WAVESCAN
;
;
; PURPOSE:            Mit WAVESCAN kann man den reziproken Wert der Gruppengeschwindigkeit einer laufenden Welle bestimmen.
;                     Als Eingangsdaten dienen die Amplituden des Signals in Abh. der Zeit, deren Messpunkte aequdistant 
;                     in einer Dimension am Ort verteilt sind.
;                     
; CATEGORY:           STAT
;
;
; CALLING SEQUENCE:   distvel = wavescan(array,timearr,[TRANSP=TRANSP],[FBAND=FBAND],$
;                              [STEPSIZE=STEPSIZE],[WSIZE=WSIZE],[VELCRIT=VELCRIT],[ELDIST=ELDIST],$
;                              [SAMPLPERIOD=SAMPLPERIOD],[NEIGHBORS=NEIGHBORS],[PLOT=PLOT],[NULLHYPO=NULLHYPO])
;
; 
; INPUTS:
;                     array:   (MxN)-Matrix. M Dimension der Zeit. N Anzahl der Messpunkte.
;

;                  
;
; OPTIONAL INPUTS:
;
;                     timearr: Zeitachse 
;

;
;	
; KEYWORD PARAMETERS:
;                    
;                     TRANSP:     Falls M und N vertauscht
;
;
;                     FBAND:      Frequenzband, in dem laufende Wellen im Signal vermutet werden
;
;                     WSIZE:      Dimension der Fensterung des Eingangsignals in ms (default: 128)
;
;                     STEPSIZE:   Versatz der Fensterung in ms (default: WSIZE/16)
;
;                     VELCRIT:    maximale Abweichung der rezip. Geschwindigkeiten entlang der Nachbarn
;                                 (default: 1.0 ) multipliziert mi dem Fehler der Messgroesse 
;                                 dt/dx =: rezip. Geschw., hier SAMPLPERIOD/ELDIST  
;
;                     ELDIST:     Distanz zw. den Messpunkten in mm
;
;                     SAMPLPERIOD: Sampling-Periode (default: 0.001 sec) des Signals
;
;                     PLOT:        graphische Ausgabe (default: 0)
;
;                     NULLHYPO:    verrauscht (gleichverteilt) die Phasen der CrossPower bei gleichbleibender Amplitudenverteilung
;                                  (nuetzlich fuer Null-Hypothese)
;
;                     NBARR:      Array [ von , bis ] der zu beruecksichtigten Nachbarn ,
;                                 ueber die die Welle laeuft (default: [N, N] ,also ueber alle Messpunkte)
;                                 Achtung: RELCRIT wird jeweils auf die Anzahl NB der zu beruecksichtigten Nachbarn 
;                                 angepasst, und mit dem Faktor (NB * (NB -1))/(von * (von-1)) gewichtet 
;
;
;                     AMPLCRIT:   nur Gebiete auswaehlen deren Wert 98% (default) des lokalen Mittelwerts (Anzahl der Fenster 2*STEPSIZE) 
;                                 der MAXIMA der CrossCorr und deren Wert gleichzeitig die mittlere Amplitude uebersteigt
;
;                     VIDREC:     Aufzeichnen der Daten die Intern von SlidCorr erzeugt wurden
;
;                     VIDPLAY:    Auswerten der Daten die zuvor mit KEYWORD VIDREC erzeugt wurden
;
;                     FILENAME:   Name des Files fuer KEYWORD VIDREC/VIDPLAY (default: correllation ) mit Suffix ".cor"
;
;
;
;                                      i-ter Handle bezieht sich auf den berücksichtigten Nachbarn
;   result = { info                    : 'wavescan' ,$;; Info
;              MED_VEL_CRIT_distvel    : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi bzgl. Vel-Crit: mittlere rezipr. Geschw. 
;              MED_VEL_CRIT_amplitude  : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi bzgl. Vel-Crit: mittlere Amplitudenmax der CrossCorr
;              VEL_CRIT_distvel        : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi bzgl. Vel-Crit: paarweise rezipr. Geschw. 
;              VEL_CRIT_amplitude      : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi bzgl. Vel-Crit: paarweise Amplitudenmax der CrossCorr
;              AMPL_CRIT_distvel       : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi bzgl. Ampl-Crit: paaarw. rezipr. Geschw. 
;              AMPL_CRIT_amplitude     : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi bzgl. Ampl-Crit: paarw Amplitudenmax der CrossCorr
;              count                   : LONARR(handledim),$ ;; Anzahl der  gefundenen laufenden Oszi
;              relcrit                 : FLTARR(handledim),$ ;; Relatives Kriterium (gewichtet bzgl. der Anzahl paarweiser Geschwindigk.)
;              WINDOW_COUNT            : LONARR(handledim),$ ;; Anzahl der Slid-Fenster
;              AMPL_CRIT_COUNT         : LONARR(handledim),$ ;; Anzahl der Fenster, die das Amplitudenkriterium erfuellen
;              REL_AMPL_CRIT_COUNT     : LONARR(handledim),$ ;; Anzahl der zusammengehoerigen Fenster, die das Ampl-Crit erfuellen
;              REL_VEL_CRIT_COUNT      : LONARR(handledim),$ ;; Anzahl der zusammengehoerigen Fenster, die das Vel-Crit und das Ampl-Kriterium erfuel.
;              NEIGHBORS               : LONARR(handledim),$ ;; Anzahl der einbezogenen Nachbarn
;              dim                     : handledim $ ;; Dimension der Handle-Arrays, Dimension bezieht sich auf die berucksichtigten Nachbarn, bei NBARR = [N,N] ist dim = 1
;            }
;
;
;
;
; COMMON BLOCKS:    
;                    wavescan_BLOCK, SHEET_1, SHEET_2 ,PLOTFLAG
;                    dient zur graphischen Ausgabe
;
; RESTRICTIONS:
;              
;
;
; EXAMPLE:
;
;
;          t_size = 1000                          ;; Laenge der Messung [ms]
;          m_size = 7                             ;; Anzahl der Messpunkte
;          SAMPLPERIOD = 2.                       ;; 1/Samplefrequenz [ms] 
;          fr = 50.                               ;; Frequenz des Inputs Hz 
;          n_size = 51                            ;; Laenge des Wellen-Signals [ms]
;          ushift = 10                            ;; kuenstlicher Phasenversatz [ms]
;
;          ;; Einheiten anpassen
;          ushift = ushift /SAMPLPERIOD 
;          t_size = t_size/SAMPLPERIOD 
;
;          ;; Signal erzeugen
;          n_size = FLOOR(n_size/SAMPLPERIOD)
;          xh = findgen(n_size)
;          w = 0.54 - 0.46*Cos(2*!Pi*xh/(n_size-1))
;          cos_input = (cos(2.*!PI*fr*SAMPLPERIOD *xh/1000))   *w 
;
;          ;; Einheiten anpassen
;          SAMPLPERIOD = SAMPLPERIOD /1000.
;
;          ;;SignalArray erzeugen
;          input = dblarr(t_size,m_size)
;          ;; bisschen Rauschen
;          noise = randomn(S,t_size,m_size)/1000.
;          
;          for i = 0 , m_size-1 do begin
;            input(200+i*ushift:200+n_size+i*ushift-1,i)=  cos_input(*)
;          endfor
;          input=input+noise
;
;          result = wavescan( input,FBAND=[35,65],SAMPLPERIOD=SAMPLPERIOD,/PLOT)
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.5  1998/07/10 10:21:45  gabriel
;          Falsches Keyword in Doku Statt WAVECRIT heisst es VELCRIT
;
;     Revision 1.4  1998/07/07 20:08:40  gabriel
;          Tja viele neue Keywords ......
;
;     Revision 1.3  1998/06/02 16:06:13  gabriel
;          Keyword NULLHYPO neu
;
;     Revision 1.2  1998/05/12 17:55:24  gabriel
;          Falsches KEYWORD in Funktion (TRANSP ergaenzt)
;
;     Revision 1.1  1998/05/12 13:14:05  gabriel
;          Geburt war schwer
;
;
;-
FUNCTION wavescan, array,timearr,FBAND=FBAND,WSIZE=WSIZE,STEPSIZE=STEPSIZE,VELCRIT=VELCRIT,AMPLCRIT=AMPLCRIT,ELDIST=ELDIST,$
                   SAMPLPERIOD=SAMPLPERIOD,NBARR=NBARR,PLOT=PLOT,TRANSP=TRANSP,NULLHYPO=NULLHYPO,PSPLOT=PSPLOT,$
                   FILENAME=filename,VIDREC=vidrec,VIDPLAY=VIDPLAY,XSIZE=XSIZE,YSIZE=YSIZE,VERBOSE=VERBOSE,_EXTRA=e

   IF N_Params() NE 2 THEN Message, 'wrong number of parameters'
   IF KEYWORD_SET(vidrec) AND KEYWORD_SET(VIDPLAY) THEN Message, 'recording and playing is not possible'

   COMMON wavescan_BLOCK, SHEET_2, PLOTFLAG
   DEFAULT,filename,"./correlation"
   DEFAULT,VIDPLAY,0
   DEFAULT,VIDREC,0
   DEFAULT,Plotflag,0
   DEFAULT,NULLHYPO,0
   DEFAULT,WSIZE,128   
   DEFAULT,STEPSIZE,WSIZE/16
   DEFAULT,SAMPLPERIOD,0.001
   DEFAULT,ELDIST,1.0
   DEFAULT,VELCRIT,1.0
   DEFAULT,AMPLCRIT,0.98
   DEFAULT,plot,0
   DEFAULT,psplot,0
   DEFAULT,XSIZE,600
   DEFAULT,YSIZE,200
   IF KEYWORD_SET(plot) AND KEYWORD_SET(psplot) THEN  Message,'KEYWORD-CONFLICT: PSPLOT and PLOT '
    
   IF KEYWORD_SET(plot)  AND (PLOTFLAG EQ 0) THEN BEGIN

      ;SHEET_2 = definesheet( /WINDOW ,XSIZE=XSIZE,ySIZE=YSIZE*2.5,TITLE="max. Amplitudes of SlidCorr")
      SHEET_2 = definesheet( /WINDOW ,XSIZE=XSIZE,ySIZE=YSIZE,TITLE="max. Amplitudes of SlidCorr",MULTI=[3,1,3])
      plotflag = 1
   ENDIF  
   IF KEYWORD_SET(psplot)  AND (PLOTFLAG EQ 0) THEN BEGIN

      ;SHEET_2 = definesheet( /WINDOW ,XSIZE=XSIZE,ySIZE=YSIZE*2.5,TITLE="max. Amplitudes of SlidCorr")
      SHEET_2 = definesheet( /PS , FILENAME='wavescan',/ENCAPSULATED,XSIZE=300,YSIZE=150,MULTI=[3,1,3])
      plotflag = 1
   ENDIF 
   work_array = array
   IF set(TRANSP) THEN work_array =  transpose(array)
   datas = size(work_array)

   DEFAULT,NBARR,[datas(2),datas(2)]
   DEFAULT,TIMEARR,indgen(datas(1))
   ;NEIGHBORS = FLOAT(NEIGHBORS)
   IF NBARR(1) GT datas(2) THEN message , "count of neighbors must be <= available channels"  

   m_size = datas(2)
   channels = indgen(m_size)
   counter = 0
   IF KEYWORD_SET(VIDREC) OR KEYWORD_SET(VIDPLAY) THEN BEGIN 
      GET_LUN, lun   
      IF KEYWORD_SET(VIDREC) THEN openw,  lun , filename + '.cor' 
      IF KEYWORD_SET(VIDPLAY) THEN BEGIN
         unzip,filename + '.cor'
         openr,  lun , filename + '.cor' 
      END
   ENDIF
   neighbors = m_size
   FOR CHANCOUNT=0, m_size - neighbors  DO BEGIN
      TMP_CHANNELS = CHANNELS+ CHANCOUNT
      FOR chanindex_1=0 , neighbors-1 DO BEGIN
         FOR chanindex_2=0 , neighbors-1 DO BEGIN
            chan1 = TMP_channels(chanindex_1)
            chan2 = TMP_channels(chanindex_2)
            
            IF TMP_channels(neighbors-1) GT (m_size-1) THEN chanindex_1 = neighbors
            IF KEYWORD_SET(VERBOSE) THEN print,"Correlation ", chan1,"   with",chan2
            
            IF chanindex_1 LE chanindex_2 THEN BEGIN 
               n = chanindex_1*neighbors+chanindex_2 
               xdata = work_array(*,chan1)
               ydata = work_array(*,chan2)
               IF NOT KEYWORD_SET(VIDPLAY) THEN BEGIN
                  erg =  slidcorr(xdata,ydata,timearr, stepsize=stepsize,NULLHYPO=NULLHYPO,$
                                  FBAND=fband,SAMPLPERIOD=samplperiod,PLOT=PLOT,wsize=wsize,_EXTRA=e)
                  
               ENDIF
                                ; stop 
               
               IF KEYWORD_SET(VIDREC) THEN BEGIN
                  
                  savestruc,lun,{ $
                                 SHIFTHUELL : erg.shifthuell,$
                                 SHIFTMAX   : erg.shiftmax, $
                                 SHIFTMIN   : erg.shiftmin, $
                                 T          : erg.t    ,$
                                 TAU        : erg.tau  } 
                  
                  
                  
               ENDIF

               IF KEYWORD_SET(VIDPLAY)  THEN erg=loadstruc(lun)
               
               
               
               

               IF chanindex_1 EQ 0 AND chanindex_2 EQ 0 THEN BEGIN
                  ;;ergarr =  erg 
                  tot_timeshift = REFORM(erg.shifthuell(0,*))
                  tot_amplshift = REFORM(erg.shifthuell(1,*))
                  
               END ELSE BEGIN
                  ;;ergarr = [[ergarr],[erg]]
                  tot_timeshift = [[tot_timeshift],[ REFORM(erg.shifthuell(0,*))]]
                  tot_amplshift = [[tot_amplshift],[ REFORM(erg.shifthuell(1,*))]]
                  
               ENDELSE
               ;;indexing(c_trial,l,*) = [ chan, l ] 
               
            END  ELSE BEGIN
               n = chanindex_2*neighbors+chanindex_1
               tot_timeshift = [[tot_timeshift],[- tot_timeshift(*,n)]]
               tot_amplshift = [[tot_amplshift],[  tot_amplshift(*,n)]]
               ;;print,n,countarr(n)
            ENDELSE
               
               
         ENDFOR
      ENDFOR
         
   ENDFOR   
   IF KEYWORD_SET(VIDREC) OR KEYWORD_SET(VIDPLAY) THEN BEGIN
      CLOSE,lun
      FREE_LUN, lun   
      IF KEYWORD_SET(VIDREC) THEN zip,filename + '.cor'
      IF KEYWORD_SET(VIDPLAY) THEN zipfix,filename + '.cor'
   ENDIF

   handledim = nbarr(1)-nbarr(0)+1
   result = { info                : 'wavescan' ,$;; Info
              MED_VEL_CRIT_distvel    : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi Vel-Crit: mittlere rezipr. Geschw. 
              MED_VEL_CRIT_amplitude  : LONARR(handledim) ,$;; Handle-Array auf gefundene laufende Oszi Vel-Crit: mittlere Amplitudenmax der CrossCorr
              VEL_CRIT_distvel        : LONARR(handledim),$ ;; Handle-Array auf gefundene laufende Oszi Vel-Crit: paarweise rezipr. Geschw. 
              VEL_CRIT_amplitude      : LONARR(handledim) ,$;; Handle-Array auf gefundene laufende Oszi Vel-Crit: paarweise Amplitudenmax der CrossCorr
              AMPL_CRIT_distvel       : LONARR(handledim), $;; Handle-Array auf gefundene laufende Oszi Ampl-Crit: paaarw. rezipr. Geschw. 
              AMPL_CRIT_amplitude     : LONARR(handledim) ,$;; Handle-Array auf gefundene laufende Oszi Ampl-Crit: paarw Amplitudenmax der CrossCorr
              count               : LONARR(handledim) ,$;; Anzahl der  gefundenen laufende Oszi
              relcrit             : FLTARR(handledim) ,$;; Relatives Kriterium
              WINDOW_COUNT        : LONARR(handledim) ,$;; Anzahl der Slid-Fenster
              AMPL_CRIT_COUNT     : LONARR(handledim) ,$;; Anzahl der Fenster, die das Amplitudenkriterium erfuellen
              REL_AMPL_CRIT_COUNT : LONARR(handledim) ,$;; Anzahl der zusammengehoerigen Fenster, die das Ampl-Crit erfuellen
              REL_VEL_CRIT_COUNT  : LONARR(handledim) ,$;; Anzahl der zusammengehoerigen Fenster, die das Vel-Crit und das Ampl-Kriterium erf.
              NEIGHBORS           : LONARR(handledim) ,$;; Anzahl der einbezogenen Nachbarn
              dim                 : handledim $;; Dimension der Handle-Arrays, Dimension bezieht sich auf die Nachbarn
            }
            
            
   
   handlecount = 0
   FOR neighbors = nbarr(0) ,nbarr(1) DO BEGIN
      channels = indgen(neighbors)
      counter = 0
      VEL_flag = 0
      AMPL_FLAG = 0
      glob_vel_crit_count = 0
      glob_REL_VEL_CRIT_COUNT = 0
      glob_AMPL_CRIT_COUNT = 0
      glob_REL_AMPL_CRIT_COUNT = 0 

      FOR CHANCOUNT=0, m_size - neighbors  DO BEGIN
         TMP_CHANNELS = CHANNELS+ CHANCOUNT
         FOR chanindex_1=0 , neighbors-1 DO BEGIN
            FOR chanindex_2=0 , neighbors-1 DO BEGIN
               chan1 = TMP_channels(chanindex_1)
               chan2 = TMP_channels(chanindex_2)
               
               IF TMP_channels(neighbors-1) GT (m_size-1) THEN chan1 = neighbors
               IF KEYWORD_SET(VERBOSE) THEN print,"Correlation ", chan1,"   with",chan2
               
               IF chanindex_1 LE chanindex_2 THEN BEGIN 
                  n = chan1*m_size+chan2 
                  
                  IF chanindex_1 EQ 0 AND chanindex_2 EQ 0 THEN BEGIN
                     ;;ergarr =  erg 
                     timeshift = tot_timeshift(*,n)
                     amplshift = tot_amplshift(*,n)
                     
                  END ELSE BEGIN
                     ;;ergarr = [[ergarr],[erg]]
                     timeshift = [[timeshift],[  tot_timeshift(*,n)]]
                     amplshift = [[amplshift],[  tot_amplshift(*,n)]]
                     
                  ENDELSE
                  ;;indexing(c_trial,l,*) = [ chan, l ] 
                  
               END  ELSE BEGIN
                  n = chan2*m_size+chan1
                  timeshift = [[timeshift],[- tot_timeshift(*,n)]]
                  amplshift = [[amplshift],[  tot_amplshift(*,n)]]
                  ;;print,n,countarr(n)
               ENDELSE
               
               
            ENDFOR
         ENDFOR
         
         



         ;;ha = hist(timeshift,x,1)
         ;;     wset,0

         ;;      ubar_plot,x,ha
      
         as = size(timeshift)
         distance = (transpose(FLOOR(indgen(as(2),as(1)) MOD neighbors^2) / FLOOR(neighbors) )$
          - transpose(indgen(as(2),as(1)) MOD neighbors) )
         
         ;distance = signum(distance)*(abs(distance))^5
         
         index = where(distance NE 0 )
         
         velocity = FLOAT(timeshift)*0
         velocity(index)=FLOAT(timeshift(index))/(FLOAT(distance(index))*eldist)

         RELCRIT = (erg.tau(1)-erg.tau(0))/FLOAT(ELDIST)*VELCRIT*FLOAT(neighbors*(neighbors-1))/FLOAT(NBARR(0))/(FLOAT(NBARR(0))-1.)*1.01


         medampl= TOTAL(lextrac(amplshift,2,(neighbors+1)* indgen(neighbors),/COMPL),2)/FLOAT(neighbors*(neighbors-1))
         selectvel = lextrac(velocity,2,(neighbors+1)* indgen(neighbors),/COMPL)
         selectampl = lextrac(amplshift,2,(neighbors +1)* indgen(neighbors),/COMPL)
         medvel = TOTAL(selectvel,2)/FLOAT(neighbors*(neighbors-1))

         variance_vel = medvel * 0.
         FOR n=0,(neighbors*(neighbors-1)) - 1  DO BEGIN
            variance_vel = variance_vel +  (selectvel(*,n) - medvel)^2 /FLOAT(neighbors*(neighbors-1))     
         ENDFOR
         sigvel = sqrt(variance_vel)
         showmedvel = medvel
         showmedampl = medampl

         ;; haben alle werte das gleiche Vorzeichen, d.h. laeuft die Osci in eine richtung
         test =  TOTAL(abs(selectvel),2)/FLOAT(neighbors*(neighbors-1)) - abs(TOTAL((selectvel),2)/FLOAT(neighbors*(neighbors-1)))
         testindex = where( (test GT 0) AND (NOT (abs(medvel) LE RELCRIT)) , testcount )         
         ;stop
         IF testcount GT 0 THEN BEGIN
            sigvel(testindex) = -1
            IF KEYWORD_SET(VERBOSE) THEN print,"Vorzeichenwechsel bei paarweisen Geschw. gefunden!"
           
         ENDIF


         kksize = stepsize*2
         tmpMEDAMPL = smooth(MEDAMPL,5) ;;bisschen Glaetten
         regofinterest = sigvel*0+1 
         astmpvel = selectvel*0.+1
         ;;nur Gebiete auswaehlen deren Wert 98% des lokalen Mittelwerts uebersteigt und
         ;;nur Gebiete auswaehlen deren Wert die mittlere Amplitude uebersteigt
         AMPL_CRIT_INDEX = -1
         FOR KK=0 , N_ELEMENTS(tmpmedampl)- kksize DO BEGIN
            IF tmpMEDAMPL(KK+kksize/2.) LT AMPLCRIT * TOTAL(tmpmedampl(kk:kk+kksize-1))/FLOAT(kksize) $
             OR tmpMEDAMPL(KK+kksize/2.) LT Total(tmpmedampl)/FLOAT(N_ELEMENTS(tmpmedampl)) THEN BEGIN
               sigvel(kk+kksize/2.) = -1
               regofinterest(kk+kksize/2.) = 0
               astmpvel(kk+kksize/2.,*) = 0
                    
            ENDIF
         ENDFOR
         
         ;;Anzahl der Slid-Fenster die das Ampl-Kriterium erfuellen
         AMPL_CRIT_INDEX = where(regofinterest EQ 1,AMPL_CRIT_count)
         ;;Anzahl aller Slid-Fenster
         window_count = N_ELEMENTS(erg.t)
         ;;Anzahl der Oszillatinen bzgl. Amplitudenkriteriums
         REL_AMPL_CRIT_count = ROUND(total(abs(regofinterest - shift(regofinterest,1)))/2.)
         
         ;;nur Gebiete auswaehlen deren Geschwindigkeiten das Vel-Kriterium erfuellen
         VEL_CRIT_index = where(sigvel LE relcrit AND sigvel GE 0.0 , vel_crit_count)      
         
         astmp = FIX((sigvel LE relcrit)  AND (sigvel GE 0.0 ))
         
         ;;Anzahl der Oszillatinen bzgl. Amplitudenkriteriums und Vel-Kriterium
         REL_VEL_CRIT_count = ROUND(total(abs(astmp - shift(astmp,1)))/2.)
         
         ;stop
         psarr = 0.
         chan = 0

         ;;plotten der gefundenen Oszillationen
         IF KEYWORD_SET(PLOT)  THEN BEGIN
            ;;gemitteltes Spektrum der Amplituden der CrossCorrelationen
            FOR k = 0 ,as(2)-1 DO begin 
               
               IF K  NE chan THEN BEGIN
                  IF (k MOD neighbors) EQ 0 AND (k GT 0) THEN  CHAN =  CHAN + 1
                  tmparr = [ REFORM(amplshift(*,k)) , FLTARR(N_ELEMENTS(REFORM(amplshift(*,k)))) ]
                  ps = powerspec(tmparr,psf,SAMPLPERIOD=(erg.T(1)-erg.T(0))/1000.)
                  psarr = psarr + ps /FLOAT(as(1)-1)
                  
               ENDIF
               
            ENDFOR 
            ULOADCT,5,/SILENT
            ;TVLCT,R,G,B,/GET
            ;TVLCT,REVERSE(r),REVERSE(G),REVERSE(B)
            ;pix_1 = definesheet( /WINDOW ,XSIZE=XSIZE,ySIZE=YSIZE,/PIXMAP)
            ;pix_2 = definesheet( /WINDOW ,XSIZE=XSIZE,ySIZE=YSIZE,/PIXMAP)
            
            ;opensheet,pix_1
            opensheet,sheet_2,0
            !P.BACKGROUND = RGB(255,255,255,/NOALLOC)
            !P.MULTI = 0
            TITLE = "max. Amplitudes "+'(Neighbors: '+ $ 
             STRCOMPRESS(STRING(NBARR(0)+handlecount),/REMOVE_ALL) + ')'
            plottvscl,selectampl,/FULLSHEET ,XRANGE=[timearr(0),timearr(N_ELEMENTS(timearr)-1)],$
              XTITLE="Time [ms]",YTITLE="Channel Nr.",/LEGEND,GET_POSITION=PlotPosition,TITLE=TITLE
            ;closesheet,pix_1
            closesheet,sheet_2,0
            ;opensheet,pix_2
            opensheet,sheet_2,1
            !P.BACKGROUND = RGB(255,255,255,/NOALLOC)
            !P.MULTI = 0
            TITLE = "Selected max. Amplitudes"
                                ;stop
            sa = size(amplshift)
            tmpregofinterest = REBIN(regofinterest,as(1),as(2),/SAMPLE)
            tmpregofinterest(*) = RGB(255,255,255,/NOALLOC)
            index = where(REBIN(regofinterest,as(1),as(2),/SAMPLE) EQ 1,found)
            IF found GT 0 THEN tmpregofinterest(index) =  RGB(0,0,255,/NOALLOC)
            index = where(REBIN(FLOAT(astmp),as(1),as(2),/SAMPLE) EQ 1, found)
            IF found GT 0 THEN tmpregofinterest(index)=  RGB(255,0,0,/NOALLOC)
            plottvscl,tmpregofinterest,/FULLSHEET ,XRANGE=[timearr(0),timearr(N_ELEMENTS(timearr)-1)],$
             XTITLE="Time [ms]",YTITLE="Channel Nr.",/LEGEND,GET_POSITION=PlotPosition,TITLE=TITLE,/NOSCALE
            ;stop
            ;closesheet,pix_2
            closesheet,sheet_2,1

            opensheet,sheet_2,2
            !P.BACKGROUND = RGB(255,255,255,/NOALLOC)
            !P.MULTI = 0
            ;TITLE = "Fequency of max Amplitudes in CrossCorr" 
            ;plot,psf,psarr,POSITION=[PlotPosition(0),0.3*YSIZE/2./(2.5*YSIZE),PlotPosition(2),0.85*YSIZE/2./(2.5*YSIZE)],$
            ; TITLE=TITLE,XRANGE=[0,10],XTITLE="frequency [Hz]",YTITLE="Power",XTICKS=10
            TITLE = "Mean Power of max Amplitudes in CrossCorr" 
            ;stop
            ;plot,erg.t,(medampl),POSITION=[PlotPosition(0),0.3*YSIZE/2./(2.5*YSIZE),PlotPosition(2),0.85*YSIZE/2./(2.5*YSIZE)],$
            ; TITLE=TITLE,XTITLE="time [ms]",YTITLE="Power",/XSTYLE,COLOR=RGB(0,0,0,/NOALLOC)
            plot,erg.t,(medampl),POSITION=PlotPosition,$
             TITLE=TITLE,XTITLE="time [ms]",YTITLE="Power",/XSTYLE,COLOR=RGB(0,0,0,/NOALLOC)         ;device,copy=[0,0,XSIZE-1,YSIZE,0,1.5*YSIZE,pix_1.winid]
            coords = [ erg.t(0),Total(medampl)/N_ELEMENTS(medampl) ,erg.t(N_ELEMENTS(erg.t)-1),Total(medampl)/N_ELEMENTS(medampl)]
            plots,coords(0),coords(1),/DATA
            plots,coords(2),coords(3),/CONTINUE,COLOR=RGB(255,0,0,/NOALLOC),NOCLIP=0,/DATA 
            ;device,copy=[0,0,XSIZE-1,YSIZE,0,.5*YSIZE,pix_2.winid]
            closesheet,sheet_2,2 
            ;destroysheet,pix_1         
            ;destroysheet,pix_2 
                                ;wait,2.
         ENDIF
         
         IF vel_crit_count GT 0 THEN BEGIN
            MED_VEL_CRIT_tmpdistvel = medvel(vel_crit_index)
            MED_VEL_CRIT_tmpamplitude = medampl(vel_crit_index)
            VEL_CRIT_tmpdistvel = selectvel(vel_crit_index,*)
            VEL_CRIT_tmpamplitude = selectampl(vel_crit_index,*)
            VEL_CRIT_tmpdistvel = VEL_CRIT_tmpdistvel(*)
            VEL_CRIT_tmpamplitude = VEL_CRIT_tmpamplitude(*)
            
         ENDIF

         IF ampl_crit_count GT 0  THEN BEGIN    
            AMPL_CRIT_tmpdistvel = selectvel(ampl_crit_index,*)
            AMPL_CRIT_tmpamplitude = selectampl(ampl_crit_index,*)
            AMPL_CRIT_tmpdistvel = AMPL_CRIT_tmpdistvel(*)
            AMPL_CRIT_tmpamplitude = AMPL_CRIT_tmpamplitude(*)
            
         ENDIF
         
         IF VEL_flag EQ 0 AND VEL_CRIT_COUNT GT 0 THEN BEGIN
            
            med_vel_crit_distvel =   MED_VEL_CRIT_tmpdistvel
            med_vel_crit_amplitude = MED_VEL_CRIT_tmpamplitude
            vel_crit_distvel =   VEL_CRIT_tmpdistvel
            vel_crit_amplitude = VEL_CRIT_tmpamplitude
            glob_vel_crit_count = vel_crit_count
            glob_REL_VEL_CRIT_COUNT =  REL_VEL_CRIT_COUNT
            VEL_flag =  1
            
         ENDIF

         IF AMPL_flag EQ 0 AND AMPL_CRIT_COUNT GT 0 THEN BEGIN
            AMPL_crit_distvel =   AMPL_CRIT_tmpdistvel
            AMPL_crit_amplitude = AMPL_CRIT_tmpamplitude 
            glob_WINDOW_COUNT = WINDOW_COUNT
            glob_AMPL_CRIT_COUNT = AMPL_CRIT_COUNT
            glob_REL_AMPL_CRIT_COUNT = REL_AMPL_CRIT_COUNT
            AMPL_FLAG = 1
         ENDIF


         IF VEL_flag EQ 1 AND VEL_CRIT_COUNT GT 0 THEN BEGIN   
            med_vel_crit_distvel =   [med_vel_crit_distvel  , MED_VEL_CRIT_tmpdistvel]
            med_vel_crit_amplitude = [med_vel_crit_amplitude, MED_VEL_CRIT_tmpamplitude]
            vel_crit_distvel =       [vel_crit_distvel  , VEL_CRIT_tmpdistvel]
            vel_crit_amplitude =     [vel_crit_amplitude, VEL_CRIT_tmpamplitude]
            glob_vel_crit_count = glob_vel_crit_count + vel_crit_count
            glob_REL_VEL_CRIT_COUNT =  REL_VEL_CRIT_COUNT + glob_REL_VEL_CRIT_COUNT
            

         ENDIF
         IF AMPL_flag EQ 1 AND AMPL_CRIT_COUNT GT 0 THEN BEGIN   
            ampl_crit_distvel =      [ampl_crit_distvel  , AMPL_CRIT_tmpdistvel]
            ampl_crit_amplitude =    [ampl_crit_amplitude, AMPL_CRIT_tmpamplitude]
            glob_WINDOW_COUNT = WINDOW_COUNT + glob_WINDOW_COUNT
            glob_AMPL_CRIT_COUNT = AMPL_CRIT_COUNT + glob_AMPL_CRIT_COUNT 
            glob_REL_AMPL_CRIT_COUNT = REL_AMPL_CRIT_COUNT + glob_REL_AMPL_CRIT_COUNT  
         ENDIF
         
         
      ENDFOR  
   IF VEL_flag EQ 0 THEN BEGIN
      med_vel_crit_distvel =  -1
      med_vel_crit_amplitude = -1
      vel_crit_distvel =  -1
      vel_crit_amplitude = -1
      glob_vel_crit_count = 0
      glob_REL_VEL_CRIT_COUNT = 0
   ENDIF

   IF AMPL_FLAG EQ 0 THEN BEGIN
      ampl_crit_distvel =  -1
      ampl_crit_amplitude = -1
      glob_AMPL_CRIT_COUNT = 0
      glob_REL_AMPL_CRIT_COUNT = 0
      glob_WINDOW_COUNT = 0 
   ENDIF

   result.MED_VEL_CRIT_distvel(handlecount) = handle_create(!MH,VALUE=med_vel_crit_distvel)
   result.MED_VEL_CRIT_amplitude(handlecount) =handle_create(!MH,VALUE=med_vel_crit_amplitude)
   result.VEL_CRIT_distvel(handlecount) = handle_create(!MH,VALUE=vel_crit_distvel)
   result.VEL_CRIT_amplitude(handlecount) =handle_create(!MH,VALUE=vel_crit_amplitude)
   result.AMPL_CRIT_distvel(handlecount) = handle_create(!MH,VALUE=ampl_crit_distvel)
   result.AMPL_CRIT_amplitude(handlecount) =handle_create(!MH,VALUE=ampl_crit_amplitude)
   result.count(handlecount) = glob_vel_crit_count
   result.relcrit(handlecount)= relcrit
   result.WINDOW_COUNT(handlecount)=glob_WINDOW_COUNT
   result.AMPL_CRIT_COUNT(handlecount)=glob_AMPL_CRIT_COUNT 
   result.REL_AMPL_CRIT_COUNT(handlecount)=glob_REL_AMPL_CRIT_COUNT
   result.REL_VEL_CRIT_COUNT(handlecount)=glob_REL_VEL_CRIT_COUNT
   result.NEIGHBORS(handlecount) = neighbors
   handlecount =  handlecount+1

   ENDFOR
   return,result
END


;t_size = 1000                          ;;   Laenge der Messung [ms]
;m_size = 7                             ;; Anzahl der Messpunkte
;SAMPLPERIOD = 2.                        ;; 1/Samplefrequenz [ms] 
;fr = 50.                               ;;Frequenz des Inputs Hz 
;n_size = 51                            ;;Laenge des Wellen-Signals [ms]
;ushift = 10                           ;;kuenstlicher Phasenversatz [ms]

;;; Einheiten anpassen
;ushift = ushift /SAMPLPERIOD 
;t_size = t_size /SAMPLPERIOD 
;;; Signal erzeugen
;n_size = FLOOR(n_size/SAMPLPERIOD)
;xh = findgen(n_size)
;w = 0.54 - 0.46*Cos(2*!Pi*xh/(n_size-1))
;cos_input = (cos(2.*!PI*fr*SAMPLPERIOD *xh/1000))   *w 
;;; Einheiten anpassen
;SAMPLPERIOD = SAMPLPERIOD /1000.

;;;SignalArray erzeugen
;input = dblarr(t_size,m_size)
;;; bisschen Rauschen
;noise = randomn(S,t_size,m_size)/1000.

;for i = 0 , m_size-1 do begin
;   input(200+i*ushift:200+n_size+i*ushift-1,i)=  cos_input(*)
;endfor
;input=input+noise
;erg = wavescan( input,COUNT=COUNT,FBAND=[35,65],SAMPLPERIOD=SAMPLPERIOD,/PLOT)

;END

