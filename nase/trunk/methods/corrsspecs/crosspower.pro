;+
; NAME:                  CrossPower
;
; PURPOSE:               Berechnet die CrossPower aus zwei Zeitreihen
;                        + Zeitreihen muessen eine Aufloesung von 1 BIN haben 
;                           (bei Marburger Modellneuronen eh nur moeglich!)
;                        + gefenstert wird delaultmaessig nicht, optional 
;                           ist ein Hamming-Fenster moeglich 
;
; CATEGORY:              STATISTICS
;
; CALLING SEQUENCE:      cp = CrossPower( xseries,yseries [,xaxis] [,/HAMMING][,/DOUBLE]        $
;                                        [,PHASE=phase] [,COMPLEX=complex] [,NEGFREQ=negfreq]$
;                                        [,TRUNC_PHASE=trunc_phase] [,KERNEL=kernel] , [SAMPLEPERIOD=sampleperiod])
;
; INPUTS:                xseries : eine 1-dimensionale Zeitreihe (Zeitaufloesung 1 BIN) 
;                                  mit mind. 10 Elementen
;                        yseries : s. xseries
;
;
; KEYWORD PARAMETERS:    HAMMING:      vor der Berechnung des Spektrums wird mit der 
;                                      Hamming-Funktion gefenstert (siehe IDL-Hilfe)
;                        DOUBLE:       rechnet mit doppelter Genauigkeit (dies ist
;                                      erst ab IDL-Version 4.0 moeglich)
;                        TRUNC_PHASE:  Phasenbeitraege werden fuer Werte <= (TRUNC_PHASE (in Prozent) * MAX(cp))
;                                      auf Null gesetzt.
;                        KERNEL:       Filterkernel zum Smoothen des CrossSpectrums, empfehlenswert bei 
;                                      KEYWORD PHASE
;                        COMPLEX:      als Output complexe CrossPower
;
;                        NEGFREQ:      Output mit negativen Frequenzen (default ist: nur pos. freq.)
;
;                        SAMPLEPERIOD: Sampling-Periode (default: 0.001 sec) der Zeitreihe
;
;
; OUTPUTS:               cp      : Betrag der berechneten CrossPower
;
; OPTIONAL OUTPUTS:      xaxis   : gibt die zu cp entsprechenden Frequenzwerte zurueck
;                        phase  : gibt die zu cp entsprechende CrossPhasenwinkel zu den Frequenzwerten zuruek
;
;
; SIDE EFFECTS:          Falls xaxis uebergeben wird, wird es neu gesetzt
;
; RESTRICTIONS:          series muss mind. 10 Elemente enthalten
;
; EXAMPLE:          
;                        f1 = 50
;                        
;                        
;                        
;                        xseries = 0.1*sin(findgen(1000)/1000.*2*!Pi*f1)
;                        ;yseries mit Phaseversatz um 10 BIN
;                        yseries = 0.1*sin((findgen(1000)+10)/1000.*2*!Pi*f1)
;                        
;                        
;                        Window,/FREE
;                        !P.Multi = [0,1,3,0,0]
;                        
;                        Plot, Xseries, TITLE='Time Series'
;                        oplot,yseries,linestyle=2
;                        Phase=0 
;                        cp = CrossPower(xseries,yseries, xaxis,Phase=Phase)
;                        Plot, xaxis(0:40), cp(0:40), TITLE='CrossPowerspektrum', XTITLE='Frequency / Hz', YTITLE='CrossPower'
;                        Plot, xaxis(0:40), phase(0:40), TITLE='CrossPhasenspektrum', XTITLE='Frequency / Hz', YTITLE='CrossPhase'
;
;
;
;
; MODIFICATION HISTORY:
;
; $Log$
; Revision 1.5  1998/08/24 10:30:31  saam
;       keyword SAMPLPERIOD replaced by SAMPLEPERIOD, the old
;       version produces a warning but still works
;
; Revision 1.4  1998/05/04 17:59:57  gabriel
;       SAMPLPERIOD Keyword neu
;
; Revision 1.3  1998/02/23 11:24:26  gabriel
;      KEYWORD PHASE Fehler behoben, neue Keywords NEGFREQ und COMPLEX
;
; Revision 1.2  1998/01/27 18:40:30  gabriel
;      Smooth Kernel Keyword hinzugefuegt
;
; Revision 1.1  1998/01/27 11:34:38  gabriel
;      eine geburt
;
; 
;
;-




FUNCTION CrossPower, xseries, yseries, xaxis, hamming=HAMMING,$
                     DOUBLE=Double ,COMPLEX=COMPLEX,Phase=Phase ,$
                     TRUNC_PHASE=TRUNC_PHASE,KERNEL=kernel, NEGFREQ=negfreq,SAMPLPERIOD=SAMPLPERIOD, SAMPLEPERIOD=sampleperiod


   IF Set(SAMPLPERIOD) THEN BEGIN
      SamplePeriod = SamplPeriod
      print 'CROSSPOWER:  BEWARE! keyword SAMPLPERIOD is out of date, its now called SAMPLEPERIOD'
   END

   
   IF (N_PARAMS() GT 3) OR (N_Params() LT 2) THEN Message, 'wrong number of arguments'
   IF (Size(xseries))(0) NE 1                 THEN Message, 'wrong format for x-signal'
   IF (Size(yseries))(0) NE 1                 THEN Message, 'wrong format for y-signal'
   IF set(TRUNC_PHASE) AND NOT set(PHASE)   THEN Message, 'Keyword TRUNC_PHASE must be set with Keyword PPHASE'
   IF N_Elements(xseries) NE N_Elements(yseries) THEN Message, 'x-signal and y-signal must have same length'
   N = N_Elements(xseries)
   IF (N LT 10) THEN BEGIN
      Print, 'PowerSpec WARNING: time series to short'
      RETURN, -1
   END


   DEFAULT,negfreq,0
   Default, Double, 0
   Default,hamming,0
   Default, SAMPLEPERIOD  , 0.001   
   SamplingFreq   = 1.0 / SamplePeriod
   FreqRes        = SamplingFreq / N

   xMedian  = Total(xseries) / N
   yMedian  = Total(yseries) / N
   xSeries0 = xseries - xMedian  ; times series without constant offset 
   ySeries0 = yseries - yMedian  ; times series without constant offset 

   IF (hamming) THEN BEGIN
      HammingWin  = Hanning(N, ALPHA=0.54)  ;generate hamming window
      HammingNorm = Total(HammingWin^2) / N ;normalization for hamming-window, normed power
      xSeries0 = (xSeries0 * HammingWin)
      ySeries0 = (ySeries0 * HammingWin)
   END ELSE BEGIN
      HammingNorm = 1.0
   END
   
   IF Double THEN BEGIN 
      xFFT = FFT(xSeries0,-1, /DOUBLE)
      yFFT = FFT(ySeries0,-1, /DOUBLE)
   END  ELSE BEGIN 
      xFFT = FFT(xSeries0,-1)
      yFFT = FFT(ySeries0,-1)
   ENDELSE
 
  
   CPower = (xFFT*CONJ(yFFT) ) * N / HammingNorm
   CPower(0) = CPower(0) + xMedian*yMedian

   IF (NEGFREQ) THEN BEGIN
      CPower = shift(CPower,N/2)
                                ; generate x-axis
      xaxis = (FIndGen(N_Elements(CPower))-N/2)*FreqRes
   END ELSE BEGIN
      CPower = 2*CPower(0:N/2-1) ; use the symmetry
                                ; generate x-axis
      xaxis = FIndGen(N_Elements(CPower))*FreqRes
      
   ENDELSE


   


   
   IF SET(Phase) THEN BEGIN
      IF DOUBLE THEN RE_CPower = DOUBLE(CPower) $
      ELSE RE_CPower =   FLOAT(CPower)
      IM_CPower =IMAGINARY(CPower)
      IF SET(KERNEL) THEN BEGIN 
         CPower = convol(CPower,kernel,/EDGE_TRUNCATE,/CENTER)
      ENDIF
      Phase = ATAN(-IM_CPower, RE_CPower)
      
   
       

   ENDIF

   IF NOT Set(COMPLEX) THEN CPOWER = ABS(CPOWER)

   IF SET(TRUNC_PHASE) THEN BEGIN
      TRUNC = ABS(CPower) GT  (TRUNC_PHASE * MAX(ABS(CPower))) 
      Phase = TRUNC * Phase
   ENDIF

   RETURN, CPower
END
