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
; CALLING SEQUENCE:   distvel = wavescan(array,timearr,[TRANSP=TRANSP],[AMPLITUDE=AMPLITUDE],[COUNT=COUNT],[FBAND=FBAND],$
;                              [STEPSIZE=STEPSIZE],[WSIZE=WSIZE],[WAVECRIT=WAVECRIT],[ELDIST=ELDIST],$
;                              [SAMPLPERIOD=SAMPLPERIOD],[NEIGHBORS=NEIGHBORS],[PLOT=PLOT])
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
;                     NEIGHBORS:  Anzahl der zu beruecksichtigten Nachbarn,
;                                 ueber die die Welle laeuft (default: N ,also alle Messpunkte)
;
;                     FBAND:      Frequenzband, in dem laufende Wellen im Signal vermutet werden
;
;                     WSIZE:      Dimension der Fensterung des Eingangsignals in ms (default: 128)
;
;                     STEPSIZE:   Versatz der Fensterung in ms (default: WSIZE/16)
;
;                     WAVECRIT:   relative maximale Abweichung der rezip. Geschwindigkeiten entlang der Nachbarn
;                                 (default: 0.05 [=5%])
;
;                     ELDIST:     Distanz zw. den Messpunkten in mm
;
;                     SAMPLPERIOD: Sampling-Periode (default: 0.001 sec) des Signals
;
;                     PLOT:        graphische Ausgabe
;
;
;
; OUTPUTS:
;                    DISTVEL      Array der rezip. Geschwindigkeiten der laufenden Wellen. Wenn keine Welle 
;                                 gefunden wurde, ist das Ergebnis -1 .
;
; OPTIONAL OUTPUTS:
;                    AMPLITUDE:   Array der mittl. Amplitude (Huellkurve) der laufenden Wellen
;                    COUNT:       Ahnzahl der gefundenen laufenden Wellen
;
;
; COMMON BLOCKS:    
;                    wavescan_BLOCK, SHEET_1, SHEET_2 ,PLOTFLAG
;                    dient zur graphischen Ausgabe
;
; RESTRICTIONS:
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
;          distvel = wavescan( input,FBAND=[35,65],SAMPLPERIOD=SAMPLPERIOD,/PLOT)
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  1998/05/12 17:55:24  gabriel
;          Falsches KEYWORD in Funktion (TRANSP ergaenzt)
;
;     Revision 1.1  1998/05/12 13:14:05  gabriel
;          Geburt war schwer
;
;
;-
FUNCTION wavescan, array,timearr,COUNT=COUNT,FBAND=FBAND,WSIZE=WSIZE,STEPSIZE=STEPSIZE,WAVECRIT=WAVECRIT,ELDIST=ELDIST,$
              SAMPLPERIOD=SAMPLPERIOD,NEIGHBORS=NEIGHBORS,PLOT=PLOT,AMPLITUDE=AMPLITUDE,TRANSP=TRANSP
   COMMON wavescan_BLOCK, SHEET_1, SHEET_2 ,PLOTFLAG

   DEFAULT,Plotflag,0
   
   DEFAULT,WSIZE,128   
   DEFAULT,STEPSIZE,WSIZE/16
   DEFAULT,SAMPLPERIOD,0.001
   DEFAULT,ELDIST,1.0
   DEFAULT,WAVECRIT,0.05
   DEFAULT,plot,0
   RELCRIT = SAMPLPERIOD*1000/ELDIST*WAVECRIT
   IF plot AND (PLOTFLAG EQ 0) THEN BEGIN
      sheet_1 = definesheet( /WINDOW ,XSIZE=500,ySIZE=250,/PIXMAP)
      SHEET_2 = definesheet( /WINDOW ,XSIZE=500,ySIZE=250*1.5,TITLE="max. Amplitudes of SlidCorr")
      plotflag = 1
   ENDIF  

   work_array = array
   IF set(TRANSP) THEN work_array =  transpose(array)
   datas = size(work_array)

   DEFAULT,NEIGHBORS,datas(2)
   DEFAULT,TIMEARR,indgen(datas(1))

   IF NEIGHBORS GT datas(2) THEN message , "count of neighbors must be <= available channels"  

   m_size = datas(2)
   channels = indgen(neighbors)
   counter = 0
      
   FOR CHANCOUNT=0, m_size - neighbors  DO BEGIN
      TMP_CHANNELS = CHANNELS+ CHANCOUNT
      FOR chanindex_1=0 , neighbors-1 DO BEGIN
         FOR chanindex_2=0 , neighbors-1 DO BEGIN
            chan1 = TMP_channels(chanindex_1)
            chan2 = TMP_channels(chanindex_2)
            
            IF TMP_channels(neighbors-1) GT (m_size-1) THEN chanindex_1 = neighbors
            print,"ABLEIT", chan1,"   mit",chan2
            
            IF chanindex_1 LE chanindex_2 THEN BEGIN 
               n = chanindex_1*neighbors+chanindex_2 
               xdata = work_array(*,chan1)
               ydata = work_array(*,chan2)
               erg =  slidcorr(xdata,ydata,timearr, stepsize=stepsize,$
                               FBAND=fband,SAMPLPERIOD=samplperiod,PLOT=PLOT,/NOPERIOD,wsize=wsize)
             
               IF chanindex_1 EQ 0 AND chanindex_2 EQ 0 THEN BEGIN
                  ;;ergarr =  erg 
                  timeshift = REFORM(erg.shifthuell(0,*))
                  amplshift = REFORM(erg.shifthuell(1,*))
                  
               END ELSE BEGIN
                  ;;ergarr = [[ergarr],[erg]]
                  timeshift = [[timeshift],[ REFORM(erg.shifthuell(0,*))]]
                  amplshift = [[amplshift],[ REFORM(erg.shifthuell(1,*))]]
                  
               ENDELSE
               ;;indexing(c_trial,l,*) = [ chan, l ] 
               
            END  ELSE BEGIN
               n = chanindex_2*neighbors+chanindex_1
               timeshift = [[timeshift],[- timeshift(*,n)]]
               amplshift = [[amplshift],[  amplshift(*,n)]]
               ;;print,n,countarr(n)
            ENDELSE
               
               
            ENDFOR
         ENDFOR
         
      ENDFOR   

      
      as = size(timeshift)
      distance = transpose(FLOOR(indgen(as(2),as(1)) MOD neighbors^2) / neighbors )$
       - transpose(indgen(as(2),as(1)) MOD neighbors) 
      index = where(distance NE 0 )
      velocity = FLOAT(timeshift)*0
      velocity(index)=FLOAT(timeshift(index))/(FLOAT(distance(index))*eldist)
      medampl = fltarr(as(1),as(2)/neighbors)
      medvel = fltarr(as(1),as(2)/neighbors)
      sigvel = fltarr(as(1),as(2)/neighbors)
      FOR n=0, as(2)/neighbors -1 DO BEGIN
         medampl(*,n) = TOTAL( lextrac(amplshift(*,n * neighbors : (n+1)*neighbors -1),2,[n],/COMPL),2)/FLOAT(neighbors-1)
         medvel(*,n) = TOTAL( lextrac(velocity(*,n * neighbors : (n+1)*neighbors -1),2,[n],/COMPL),2)/FLOAT(neighbors-1)
         FOR k=0, neighbors -1 DO BEGIN
            IF (n * neighbors + k) NE (n * neighbors + n ) THEN $
            sigvel(*,n) = sigvel(*,n) + (velocity(*,n * neighbors + k) - medvel(*,n))^2
         ENDFOR
         sigvel(*,n) = sigvel(*,n)/FLOAT(neighbors-1)
      ENDFOR
      sigvel = sqrt(sigvel)
      index = where(sigvel LT relcrit , count)      
      
      astmp = sigvel LT relcrit
      psarr = 0.
      chan = 0
      ;;gemitteltes Spektrum der Amplituden der CrossCorrelationen
      FOR k = 0 ,as(2)-1 DO begin 
         
         IF K  NE chan THEN BEGIN
            IF (k MOD neighbors) EQ 0 AND (k GT 0) THEN  CHAN =  CHAN + 1
            tmparr = [ REFORM(amplshift(*,k)) , FLTARR(N_ELEMENTS(REFORM(amplshift(*,k)))) ]
            ps = powerspec(tmparr,psf,SAMPLPERIOD=(erg.T(1)-erg.T(0))/1000.)
            psarr = psarr + ps /FLOAT(as(1)-1)
            
         ENDIF
         
      ENDFOR 
      ;;plotten der gefundenen Wellen
      IF PLOT THEN BEGIN

         opensheet,sheet_1
         !P.MULTI = 0
         TITLE = "Selected max. Amplitudes"
         plottvscl,amplshift*astmp,/FULLSHEET ,XRANGE=[timearr(0),timearr(N_ELEMENTS(timearr)-1)],$
          YRANGE=[0,neighbors^2-1], XTITLE="Time [ms]",YTITLE="Channel Nr.",/LEGEND,GET_POSITION=PlotPosition,TITLE=TITLE
         closesheet,sheet_1
         opensheet,sheet_2
         !P.MULTI = 0
         TITLE = "Fequency of max Amplitudes in CrossCorr" 
         plot,psf,psarr,POSITION=[PlotPosition(0),PlotPosition(1)/1.5,PlotPosition(2),1./3.5],$
          TITLE=TITLE,XRANGE=[0,10],XTITLE="frequency [Hz]",YTITLE="Power",XTICKS=10
         device,copy=[0,0,500-1,250,0,1.5*250/3.,sheet_1.winid]
         closesheet,sheet_2 
         
      ENDIF

      IF count GT 0 THEN BEGIN
         dvelocity = medvel(index)
         amplitude = medampl(index)
         develsig =  sigvel(index)
      return, dvelocity
      ENDIF
      return, -1

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
