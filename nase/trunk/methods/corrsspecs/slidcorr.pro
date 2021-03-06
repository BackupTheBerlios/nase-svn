;+
; NAME:       SLIDCORR
;
; AIM:        calculates the timeresolved crosscorrelation beetween two bandpassed signals
;
; PURPOSE:    Diese Prozedur berechnet eine gleitende Kreuzkorrelation zwischen zwei Kan�len im Zeitbereich.
;             
;
; CATEGORY:   STAT
;
;
; CALLING SEQUENCE:  ergstruct = slidcorr ( xdata , ydata , [taxis] ,[FBAND=fband], [WSIZE=wsize] ,$
;                                  [STEPSIZE=stepsize], [HAMMING=hamming], [DOUBLE=double],$
;                                  [SAMPLPERIOD=samplperiod] , [PLOT=plot] , [NOSAMPLE = nosample], [NULLHYPO=nullhypo])
;
; 
; INPUTS:                xseries :    eine 1-dimensionale Zeitreihe  
;                                     mit mind. 10 Elementen
;                        yseries :    s. xseries 
;
;
; OPTIONAL INPUTS:
;                        taxis:       Zeitachse (1-dim)
;	
; KEYWORD PARAMETERS:
;                        HAMMING:     vor der Berechnung der Kreuzkorrellation wird das Signal im Freqber. mit der 
;                                     Hamming-Funktion gefenstert (siehe IDL-Hilfe)
;
;                        SAMPLPERIOD: Sampling-Periode (default: 0.001 sec) der Zeitreihe
;
;                        FBAND:       Frequenzband, in dem die Kreuzkorrelation durchgefuehrt wird
;
;                        WSIZE:       Dimension der gleitenden Fensterung des Eingangsignals in ms (default: 128)
;
;                        STEPSIZE:    Versatz der gleitenden Fensterung in ms (default: WSIZE/2)
;
;                        DOUBLE:      Berechnung mit DOUBLE-Prezision
;
;                        PLOT:        graphische Ausgabe (default: 0)
;			 NOSAMPLE:    graphische Ausgabe interpoliert
;
;                        NULLHYPO:    verrauscht (gleichverteilt) die Phasen der CrossPower bei gleichbleibender Amplitudenverteilung
;                                     (nuetzlich fuer Null-Hypothese)
;
; OUTPUTS:
;                        ERGSTRUCT:   Struktur mit folgenden Eintraegen
;
;                                     { 
;                                       FORMANT    : 2d-Array von CrossPowerspectren, erste Index steht fuer das i-te Spektrum
;                                       CCORR      : 2d-Array von Kreuzkorrelationen, s.o.
;                                       CHUELL     : 2d-Array von Einhuellenden der Kreuzkorrelationen, s.o.
;                                       ENERGIE    : 1d-Array von dem Energieanteil des gewaehlten Frequenzband im CrossPowerspectrum, s.o.
;                                       SHIFTHUELL : 2d-Array erste dim entspricht der zeitl. Position des Maximums der Einhuellenden, zweite dim entspricht der zugeh. Amplitude, sonst s.o.
;                                       SHIFTMAX   : 2d-Array erste dim entspricht der zeitl. Position des Maximums der Kreuzkorrelation , zweite dim entspricht der zugeh. Amplitude, sonst s.o.
;                                       SHIFTMIN   : 2d-Array erste dim entspricht der zeitl. Position des Minimums der Kreuzkorrelation , zweite dim entspricht der zugeh. Amplitude, sonst s.o.
;                                       F          : 1d-Array von der Frequenzachse, bzgl. der  CrossPowerspektren
;                                       T          : 1d-Array von der Zeitachse , bzgl. der zeitlichen Position der i-ten Kreuzkorrelation, bzw. i-ten  Spektrum
;                                       TAU        : 1d-Array von der Zeitachse , bzgl. der Kreuzkorrelationen
;                                     } 
;
;
; COMMON BLOCKS:
;                  COMMON SLIDCORR_BLOCK, SHEET_3 ,PLOTFLAG
;                  dient zur visuellen Anzeige
;
; SIDE EFFECTS:    nicht bekannt
;
;
; RESTRICTIONS:    nicht bekannt
;
; EXAMPLE:         
;                  	t_size = 1000                          ;; Laenge der Messung [ms]
;			m_size = 2                             ;; Anzahl der Messpunkte
;			SAMPLPERIOD = 2.                       ;; 1/Samplefrequenz [ms] 
;			fr = 50.                               ;; Frequenz des Inputs Hz 
;			n_size = 51                            ;; Laenge des Wellen-Signals [ms]
;			ushift = 10                            ;; kuenstlicher Phasenversatz [ms]
;
;			;; Einheiten anpassen
;			ushift = ushift /SAMPLPERIOD 
;			t_size = t_size/SAMPLPERIOD 
;
;			;; Signal erzeugen
;			n_size = FLOOR(n_size/SAMPLPERIOD)
;			xh = findgen(n_size)
;			w = 0.54 - 0.46*Cos(2*!Pi*xh/(n_size-1))
;			cos_input = (cos(2.*!PI*fr*SAMPLPERIOD *xh/1000))*w 
;
;			;; Einheiten anpassen
;			SAMPLPERIOD = SAMPLPERIOD /1000.
;
;			;;SignalArray erzeugen
;			input = dblarr(t_size,m_size)
;			;; bisschen Rauschen
;			noise = randomn(S,t_size,m_size)/1000.
;
;			for i = 0 , m_size-1 do begin
;			   input(200+i*ushift:200+n_size+i*ushift-1,i)=  cos_input(*)
;			endfor
;			input=input+noise
;			erg = slidcorr(input(*,0),input(*,1),/PLOT,SAMPLPERIOD=SAMPLPERIOD,/NOPERIOD,FBAND=[35,65])
;
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.13  2000/09/28 13:47:57  gabriel
;          AIM tag added; message <> console
;
;     Revision 1.12  2000/09/27 15:59:25  saam
;     service commit fixing several doc header violations
;
;     Revision 1.11  1999/02/12 15:58:52  gabriel
;          device, copy an handle sheets angep.
;
;     Revision 1.10  1998/07/01 08:53:55  gabriel
;          CROSSCORR korrigiert !?!
;
;
;     Revision 1.9  1998/06/23 11:16:13  saam
;           + indgen -> lindgen
;           + fix -> long
;           + new keyword TITLE
;
;     Revision 1.8  1998/06/22 21:07:24  saam
;           loop variable in line 174 was only int :(
;
;
;     Revision 1.7  1998/06/03 11:28:04  gabriel
;          PLOT Titel geaendert
;
;     Revision 1.6  1998/06/02 11:37:05  saam
;           Keyword Noperiod eliminated, its default now
;
;     Revision 1.5  1998/06/02 11:29:43  gabriel
;          Fehler im Common Block
;
;     Revision 1.4  1998/06/02 11:26:40  gabriel
;          Keyword NULLHypo neu, Energieanteil des Freqb. korrigiert
;
;     Revision 1.3  1998/05/12 17:50:30  gabriel
;          falsches Argument bei ubar_plot
;
;     Revision 1.2  1998/05/12 14:10:55  gabriel
;          code bei ubar_plot geaendert
;
;     Revision 1.1  1998/05/12 13:12:54  gabriel
;          Ob es funktioniert ?
;
;
;-

function slidcorr , xdata , ydata , taxis ,FBAND=fband, WSIZE=wsize , STEPSIZE=stepsize,$
                    HAMMING=hamming, DOUBLE=double, SAMPLPERIOD=samplperiod , PLOT=plot ,NOSAMPLE=nosample,$
                    SMOOTH=smooth,NULLHYPO=NULLHYPO,FYRANGE=FYRANGE, TITLE=title

   IF N_Params() NE 3 THEN console, /fatal, 'wrong number of parameters'

   COMMON SLIDCORR_BLOCK,SHEET_3, PLOTFLAG
   COMMON common_random, seed
   datsize = SIZE(datarr)

   ;;xdata = reform(datarr(chan1,*))
   ;;ydata = reform(datarr(chan2,*))
   ;IF set(logplot) THEN plot = 1
   Default, TITLE, "SLIDCROSSPOW- AND SLIDCROSSCORR-ANALYSIS"
   Default, Double, 0
   default,nosample,0
   default,NULLHYPO,0
   Default,hamming,0
   Default, SAMPLPERIOD  , 0.001
   DEFAULT,PlotPosition,0
   DEFAULT,PLOT,0
   DEFAULT,Plotflag,0
   Default,NoPeriod,1

   default,wsize,128
   default,stepsize,wsize/2
   _wsize =  ROUND(wsize/(SAMPLPERIOD * 1000))
   _stepsize = ROUND(stepsize/(SAMPLPERIOD * 1000))
   VERL = DBLARR(_wsize)
   dim = N_ELEMENTS(xdata)
   default,taxis, lindgen(dim) * SAMPLPERIOD * 1000
   steps = dim - _wsize
   tdata = (lindgen(steps/_stepsize+1)*_stepsize ) *   SAMPLPERIOD * 1000 + MIN(taxis)
   ;;stop
   XSIZE = 600 &  YSIZE=320
   IF plot eq 1 AND PLOTFLAG EQ 0 THEN BEGIN
      
      sheet_3 = definesheet(/WINDOW,XSIZE=XSIZE,YSIZE=YSIZE*2.5,TITLE=TITLE)
      plotflag = 1
   ENDIF

   FOR i=0l, steps - 1, _stepsize DO BEGIN
      xtmp = xdata(i:i+_wsize-1)
      ytmp = ydata(i:i+_wsize-1)
      
      IF NOPERIOD EQ 1  THEN BEGIN
         xtmp = [ xtmp, xtmp*0.]
         ytmp = [ ytmp, ytmp*0.]
         ;print,'hallo'
         ;stop
      ENDIF
       
       
      fdata =  taxis
      spec = crosspower(xtmp , ytmp ,fdata , HAMMING=hamming, DOUBLE=double,SAMPLPERIOD=samplperiod,/COMPLEX,/NEGFREQ)
      
;      IF set(setweight) THEN BEGIN
         
;         FOR CHAN=0 ,datsize(1)-1 DO BEGIN
;            dattmp = REFORM(datarr(chan,*))
;            dattmp = dattmp(i:i+_wsize-1)
;            IF SET(NOPERIOD) THEN BEGIN
;               dattmp = [ dattmp , VERL]
               
;            ENDif
;            pspec = powerspec(dattmp, fdata , HAMMING=hamming, DOUBLE=double,SAMPLPERIOD=samplperiod,/NEGFREQ)
;            IF chan EQ 0 THEN PSPECARR = pspec
;            pspecarr = [ [pspecarr], [pspec] ]
            
;         ENDFOR
;         weight = 1.
    
;         FOR CHAN=0 ,datsize(1)-1 DO BEGIN
;            tmpweight = REFORM(pspecarr(*,chan))
;            weight = weight *tmpweight
            
;         ENDFOR
;         IF i EQ 0 THEN  BEGIN
;            total = 1.
;            IF TOTAL(weight) NE 0 THEN total = total(weight)
;            weightarr = weight ;/ total
;         ENDIF  ELSE begin
;            total = 1.
;            IF TOTAL(weight) NE 0 THEN total = total(weight)
;            weightarr =[ [WEIGHTARR] ,[ weight  ] ]
;         ENDELSE 
     
;      ENDIF
      
      IF NULLHYPO GT 0 THEN BEGIN 
         phi = (randomu(seed,N_ELEMENTS(spec))) *2*!PI
         RADIUS = abs(spec)
         RE = RADIUS*cos(PHI)
         IM = RADIUS*sin(PHI)
         spec = complex(RE,IM)
      ENDIF
      IF i EQ 0 THEN  BEGIN
         ergsparr = spec
         
      ENDIF  ELSE begin
         ergsparr = [[ ERGSPARR ] ,[ spec] ]
        
      ENDELSE 
      
   ENDFOR
   
   
   ergsparr = transpose(ergsparr)
   ergsparrdim = size(ergsparr)
   DEFAULT,fband,[0,abs(fdata(N_ELEMENTS(fdata)-1))]
   plotfindex_R = where((fdata GE fband(0)) AND fdata LE fband(1),fcount) 
   IF FCOUNT EQ 0 THEN console, /fatal,"FBAND out of range"
   plotfindex_L = where((fdata LE -fband(0)) AND fdata GE -fband(1),fcount)

   fdata = shift(fdata,-ergsparrdim(2)/2)
   findex_R = where((fdata GE fband(0)) AND fdata LE fband(1),fcount) 
   IF FCOUNT EQ 0 THEN console, /fatal,"FBAND out of range"
   findex_L = where((fdata LE -fband(0)) AND fdata GE -fband(1),fcount)

   ;stop
   fx =  findgen(N_ELEMENTS(findex_R))
   fhamming =0.54 - 0.46*Cos(2*!Pi*fx/(N_ELEMENTS(findex_R)-1))
   fdim = N_ELEMENTS(fdata)
   taudata = (lindgen(fdim) - fdim/2)*(SAMPLPERIOD*1000)
   fdata = shift(fdata,ergsparrdim(2)/2)


   FOR K=0l,ergsparrdim(1)-1 DO BEGIN
      cspectmp = shift(reform(ergsparr(k,*)),-ergsparrdim(2)/2)
      ;IF set(setweight) THEN cspectmp = reform(ergsparr(k,*)*weightarr(k,*))
     
      cspectmpR = cspectmp(*) * 0 & cspectmpL = cspectmp(*) * 0  
      cspectmpR( findex_R ) = cspectmp(findex_R)*fhamming
      cspectmpL( findex_L ) = cspectmp(findex_L)*fhamming
      
      
      
      ccorr = shift ( FFT( [cspectmpL + cspectmpR], 1) ,ergsparrdim(2)/2 ) 
      ccorr = FLOAT(ccorr)
      
      chuell = shift ( FFT( [cspectmpR ], 1) , ergsparrdim(2)/2) 
      
      chuell = 2*ABS(chuell)
      

      energie = total(abs(cspectmp([findex_R,findex_L])))/total(abs(cspectmp(1:*)))
      ;wset,0
      ;!P.MULTI = 0
      ;plot,taudata,chuell
      ;oplot,taudata,ccorr
      ;wait,0.1
      ;IF MAX(chuell) GT 1 THEN stop

      IF k EQ  0  THEN BEGIN 
         ccorrarr = ccorr 
         chuellarr = chuell
         energiearr = energie 
      END ELSE BEGIN 
         ccorrarr = [[ccorrarr],[ccorr]]
         chuellarr = [[chuellarr],[chuell]]
         energiearr = [energiearr,energie] 
      ENDELSE 
   ENDFOR
   ccorrarr = transpose(ccorrarr)
   chuellarr =  transpose(chuellarr)
   
   faxis = fdata
   taxis = tdata


   ccorrsize = size(ccorrarr)
   ;;nach Peaks suchen
   flag = 0
   FOR k=0l, ccorrsize(1)-1 DO BEGIN 
      ccorr = REFORM(ccorrarr(k,*))
      chuell = REFORM(chuellarr(k,*))
      index1 = where(abs(chuell) EQ max(abs(chuell)) ,count1)
      index2 = where(FLOAT(ccorr) EQ max(FLOAT(ccorr)) ,count2)
      index3 = where(FLOAT(ccorr) EQ min(FLOAT(ccorr)) ,count3)
      IF count1 GT 0 THEN BEGIN
         IF flag EQ  0  THEN BEGIN 
            shifthuell = [taudata(index1(0)) , max(abs(chuell))] 
            shiftmax = [taudata(index2(0)) , max(FLOAT(ccorr)) ]
            shiftmin = [taudata(index3(0)) , min(FLOAT(ccorr))] 
            flag = 1
         END ELSE BEGIN 
            shifthuell = [[shifthuell], [taudata(index1(0)) , max(abs(chuell))]] 
            shiftmax = [[shiftmax], [taudata(index2(0)) , max(FLOAT(ccorr))]]
            shiftmin = [[shiftmin], [taudata(index3(0)) , min(FLOAT(ccorr))]] 
         ENDELSE 
      ENDIF
   ENDFOR


      IF PLOT eq 1  THEN BEGIN
         uloadct,5,/SILENT
         
       
 
         pix_1 = definesheet(/WINDOW,XSIZE=XSIZE,YSIZE=YSIZE,/PIXMAP)
         pix_2 = definesheet(/WINDOW,XSIZE=XSIZE,YSIZE=YSIZE,/PIXMAP)
         pix_3 = definesheet(/WINDOW,XSIZE=XSIZE,YSIZE=YSIZE/2.,/PIXMAP)
         ;;FORMANT
         opensheet,pix_1
         !P.MULTI = 0 
         __tmp = ergsparr
         ;ergsparr = weightarr
         ergsize = SIZE(ergsparr)
         tmparr = 2*abs(ergsparr(*,ergsize(2)/2:*))
         
         ergsize = SIZE(tmparr)
         plotdim = MAX([ergsize(1),ergsize(2)])
         tmparr = round(tmparr*1000)/1000.
         IF nosample THEN tmparr = REBIN(tmparr,(plotdim/FLOOR(ergsize(1)))*ergsize(1)*2,$
                                         (plotdim/FLOOR(ergsize(2)))*ergsize(2)*2)
         default,FYRANGE,[0,MAX(fdata)]
         
         findmax = where(fdata(N_ELEMENTS(fdata)/2:*) GE FYRANGE(1))
         PlotTvScl,tmparr(*,0:findmax(0)),XRANGE=[MIN(taxis),MAX(taxis)],YRANGE=FYRANGE,CHARSIZE=1.0,/LEGEND,$
          YTITLE="Frequency [Hz]", TITLE="SlidPowSpec-Plot" ,/FULLSHEET, GET_POSITION=PlotPosition
         fw = PlotPosition(2)-PlotPosition(0)
         fh = PlotPosition(3)-PlotPosition(1)
         fytick = (fh/FLOAT(findmax(0)+1))                       ;stop
         miny = (min(plotfindex_R)-N_ELEMENTS(fdata)/2) * fytick + PlotPosition(1)
         maxy = (max(plotfindex_R)-N_ELEMENTS(fdata)/2) * fytick + PlotPosition(1)
 ;stop
         coords = [ PlotPosition(0), miny ,PlotPosition(2),miny]
         plots,coords(0),coords(1),/NORMAL
         plots,coords(2),coords(3),/CONTINUE,COLOR=RGB(255,0,0,/NOALLOC),NOCLIP=0,/NORMAL
         coords = [ PlotPosition(0), maxy ,PlotPosition(2),maxy]
         plots,coords(0),coords(1),/NORMAL
         plots,coords(2),coords(3),/CONTINUE,COLOR=RGB(255,0,0,/NOALLOC),NOCLIP=0,/NORMAL          
         
         
         closesheet,pix_1
       
        
       
        
        ;;CORRBAND
         opensheet,pix_2
         !P.MULTI = 0
         tmparr = abs(chuellarr)
         chuellsize = size(chuellarr)
         plotdim = MAX([chuellsize(1),chuellsize(2)])
         tmparr = round(tmparr*1000)/1000.
         IF nosample THEN tmparr = REBIN(tmparr,(plotdim/FLOOR(chuellsize(1)))*chuellsize(1)*2,$
                        (plotdim/FLOOR(chuellsize(2)))*chuellsize(2)*2)
         
         PlotTvScl,tmparr,XRANGE=[MIN(taxis),MAX(taxis)],YRANGE=[MIN(taudata),MAX(taudata)],CHARSIZE=1.0,/LEGEND, $
          XTITLE="Time [ms]", YTITLE="Tau [ms]", TITLE="SlidCorr-Plot" ,/FULLSHEET, GET_POSITION=PlotPosition
         
         fw = PlotPosition(2)-PlotPosition(0)
         fh = PlotPosition(3)-PlotPosition(1)
         fytick = fh/N_ELEMENTS(fdata)  
         coords = [ PlotPosition(0), PlotPosition(1)+fh/2 ,PlotPosition(2),PlotPosition(1)+fh/2]
         plots,coords(0),coords(1),/NORMAL
         plots,coords(2),coords(3),/CONTINUE,COLOR=RGB(255,0,0,/NOALLOC),NOCLIP=0,/NORMAL
         closesheet,pix_2

         opensheet,pix_3
         !P.MULTI = 0
         ubar_plot,tdata,energiearr,COLORS=RGB(255,0,0,/NOALLOC),YTICKS=2,YRANGE=[0,1.]  , /YSTYLE,$
         ;poly_plot,tdata,showweight,COLORS=RGB(255,0,0,/NOALLOC),YTICKS=2,YRANGE=[0,1.]  , /YSTYLE,$
          YTITLE="Energy [perc]",CHARSIZE=1.,$
          TITLE="Energy of Frequenceband",BARSPACE=0,$
          POSITION=[ PlotPosition(0), 1.3*PlotPosition(1), PlotPosition(2), 0.9*PLOTPOSITION(3)]
         

         closesheet,pix_3
       
         opensheet,sheet_3
         !P.MULTI = 0
         device,copy=[0,0,XSIZE-1,YSIZE,0,0,getwinid(pix_2)]
         device,copy=[0,0,XSIZE-1,YSIZE/2.,0,YSIZE,getwinid(pix_3)]
         device,copy=[0,0,XSIZE-1,YSIZE,0,YSIZE*1.5,getwinid(pix_1)]

         closesheet,sheet_3
          
      destroysheet,pix_1
      destroysheet,pix_2
      destroysheet,pix_3
    
      ENDIF
      return,{ $
              FORMANT    : ergsparr ,$
              CCORR      : ccorrarr ,$
              CHUELL     : chuellarr ,$
              ENERGIE    : energiearr,$
              SHIFTHUELL : shifthuell,$
              SHIFTMAX   : shiftmax, $
              SHIFTMIN   : shiftmin, $
              F          : fdata ,$
              T          : tdata ,$
              TAU        : taudata } 
      
      
END

;t_size = 1000                          ;; Laenge der Messung [ms]
;m_size = 2                             ;; Anzahl der Messpunkte
;SAMPLPERIOD = 2.                       ;; 1/Samplefrequenz [ms] 
;fr = 50.                               ;; Frequenz des Inputs Hz 
;n_size = 51                            ;; Laenge des Wellen-Signals [ms]
;ushift = 10                            ;; kuenstlicher Phasenversatz [ms]

;;; Einheiten anpassen
;ushift = ushift /SAMPLPERIOD 
;t_size = t_size/SAMPLPERIOD 

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
;erg = slidcorr(input(*,0),input(*,1),/PLOT,SAMPLPERIOD=SAMPLPERIOD,/NOPERIOD,FBAND=[35,65])

;END
