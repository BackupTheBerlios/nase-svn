;+
; NAME:                  PowerSpec
;
; PURPOSE:               Berechnet das Powerspektrum aus einer Zeitreihe
;                        + Zeitreihe muss eine Aufloesung von 1 BIN haben (bei Marburger Modellneuronen eh nur moeglich!)
;                        + gefenstert wird delaultmaessig nicht, optional ist ein Hamming-Fenster moeglich 
;
; CATEGORY:              STAT
;
; CALLING SEQUENCE:      ps = PowerSpec( series [,xaxis] [,/HAMMING] )
;
; INPUTS:                series : eine 1-dimensionale Zeitreihe (Zeitaufloesung 1 BIN) mit mind. 10 Elementen
;
; OPTIONAL INPUTS:       ---
;
; KEYWORD PARAMETERS:    HAMMING : vor der Berechnung des Spektrums wird mit der Hamming-Funktion gefenstert (siehe IDL-Hilfe)
;
; OUTPUTS:               ps      : das berechnete Powerspektrum
;
; OPTIONAL OUTPUTS:      xaxis   : gibt die zu ps entsprechenden Frequenzwerte zurueck
;
; COMMON BLOCKS:         ---
;
; SIDE EFFECTS:          Falls xaxis uebergeben wird, wird es neu gesetzt
;
; RESTRICTIONS:          series muss mind. 10 Elemente enthalten
;
; PROCEDURE:             ---
;
; EXAMPLE:          
;                        f1 = 3
;                        f2 = 30
;                        f3 = 13
;                        
;                        series = 0.1*sin(findgen(1000)/1000.*2*!Pi*f1)
;                        series = series + 0.05*sin(findgen(1000)/1000.*2*!Pi*f2)
;                        series = series + 0.07*sin(findgen(1000)/1000.*2*!Pi*f3)
;                        
;                        Window,/FREE
;                        !P.Multi = [0,1,2,0,0]
;                        
;                        Plot, series, TITLE='Time Series'
;                        
;                        ps = PowerSpec(series, xaxis)
;                        Plot, xaxis(0:40), ps(0:40), TITLE='Powerspektrum', XTITLE='Frequency / Hz', YTITLE='Power'
;
;
;
;
; MODIFICATION HISTORY:
;
;       Tue Aug 19 20:58:57 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schon vorher bestehende Funktion dokumentiert und in den CVS-Baum hinzugefuegt
;
;-
FUNCTION PowerSpec, series, xaxis, hamming=HAMMING
   
   IF (N_PARAMS() GT 2) OR (N_Params() LT 1) THEN Message, 'wrong number of arguments'
   IF (Size(series))(0) NE 1                 THEN Message, 'wrong format for signal'
   
   N = N_Elements(series)
   IF (N LT 10) THEN BEGIN
      Print, 'PowerSpec WARNING: time series to short'
      RETURN, -1
   END
      
   SamplingPeriod = 0.001       ; 1 ms 
   SamplingFreq   = 1.0 / SamplingPeriod
   FreqRes        = SamplingFreq / N

   Median  = Total(series) / N
   Series0 = series - Median  ; times series without constant offset 

   IF Keyword_Set(hamming) THEN BEGIN
      HammingWin  = Hanning(N, ALPHA=0.54)  ;generate hamming window
      HammingNorm = Total(HammingWin^2) / N ;normalization for hamming-window, normed power
      Series0 = (Series0 * HammingWin)
   END ELSE BEGIN
      HammingNorm = 1.0
   END
   
   PSpec = FFT(Series0,-1, /DOUBLE)
   PSpec = ABS( PSpec*CONJ(PSpec) ) * N / HammingNorm
   PSpec = 2*PSpec(0:N/2-1) ; use the symmetry
   PSpec(0) = PSpec(0) + Median^2

   ; generate x-axis
   xaxis = FIndGen(N_Elements(PSpec))*FreqRes

   RETURN, PSpec
END
