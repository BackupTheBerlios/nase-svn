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
;                                        [,PHASE=phase] [,TRUNC_PHASE=trunc_phase])
;
; INPUTS:                xseries : eine 1-dimensionale Zeitreihe (Zeitaufloesung 1 BIN) 
;                                  mit mind. 10 Elementen
;                        yseries : s. xseries
;
;
; KEYWORD PARAMETERS:    HAMMING:     vor der Berechnung des Spektrums wird mit der 
;                                     Hamming-Funktion gefenstert (siehe IDL-Hilfe)
;                        DOUBLE:      rechnet mit doppelter Genauigkeit (dies ist
;                                     erst ab IDL-Version 4.0 moeglich)
;                        TRUNC_PHASE: Phasenbeitraege werden fuer Werte <= (TRUNC_PHASE (in Prozent) * MAX(cp))
;                                     auf Null gesetzt.
;
;
; OUTPUTS:               cp      : die berechnete CrossPower
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
; Revision 1.1  1998/01/27 11:34:38  gabriel
;      eine geburt
;
; 
;
;-




FUNCTION CrossPower, xseries, yseries, xaxis, hamming=HAMMING, DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE
   
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

   Default, Double, 0
      
   SamplingPeriod = 0.001       ; 1 ms 
   SamplingFreq   = 1.0 / SamplingPeriod
   FreqRes        = SamplingFreq / N

   xMedian  = Total(xseries) / N
   yMedian  = Total(yseries) / N
   xSeries0 = xseries - xMedian  ; times series without constant offset 
   ySeries0 = yseries - yMedian  ; times series without constant offset 

   IF Keyword_Set(hamming) THEN BEGIN
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
   
   CPower = 2*CPower(0:N/2-1) ; use the symmetry
   CPower(0) = CPower(0) + xMedian*yMedian

   ; generate x-axis
   xaxis = FIndGen(N_Elements(CPower))*FreqRes


   IF SET(Phase) THEN BEGIN
      IF DOUBLE THEN RE_CPower = DOUBLE(CPower) $
      ELSE RE_CPower =  FLOAT(CPower)
      IM_CPower = IMAGINARY(CPower)
      Phase = ATAN(-RE_CPower, IM_CPower)
   ENDIF
   CPOWER = ABS(CPOWER)
   IF SET(TRUNC_PHASE) THEN BEGIN
      TRUNC = CPower GT  (TRUNC_PHASE * MAX(CPower)) 
      Phase = TRUNC * Phase
   ENDIF

   RETURN, CPower
END
