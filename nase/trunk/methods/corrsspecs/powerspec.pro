;+
; NAME:                  PowerSpec
;
; PURPOSE:               Berechnet das Powerspektrum aus einer Zeitreihe
;                        + Zeitreihe muss eine Aufloesung von 1 BIN haben 
;                           (bei Marburger Modellneuronen eh nur moeglich!)
;                        + gefenstert wird delaultmaessig nicht, optional 
;                           ist ein Hamming-Fenster moeglich 
;
; CATEGORY:              STATISTICS
;
; CALLING SEQUENCE:      ps = PowerSpec( series [,xaxis] [,/HAMMING][,/DOUBLE]        $
;                                        [,PHASE=phase] [,TRUNC_PHASE=trunc_phase][,KERNEL=kernel])
;
; INPUTS:                series : eine 1-dimensionale Zeitreihe (Zeitaufloesung 1 BIN) 
;                                  mit mind. 10 Elementen
;
; KEYWORD PARAMETERS:    HAMMING:     vor der Berechnung des Spektrums wird mit der 
;                                     Hamming-Funktion gefenstert (siehe IDL-Hilfe)
;                        DOUBLE:      rechnet mit doppelter Genauigkeit (dies ist
;                                     erst ab IDL-Version 4.0 moeglich)
;                        TRUNC_PHASE: Phasenbeitraege werden fuer Werte <= (TRUNC_PHASE (in Prozent) * MAX(ps))
;                                     auf Null gesetzt.
;                        KERNEL:      Filterkernel zum Smoothen des CrossSpectrums, empfehlenswert bei 
;                                     KEYWORD PHASE
;
;
; OUTPUTS:               ps      : das berechnete Powerspektrum
;
; OPTIONAL OUTPUTS:      xaxis   : gibt die zu ps entsprechenden Frequenzwerte zurueck
;                        phase  : gibt die zu ps entsprechende Phasenwinkel zu den Frequenzwerten zuruek
;
;
; SIDE EFFECTS:          Falls xaxis uebergeben wird, wird es neu gesetzt
;
; RESTRICTIONS:          series muss mind. 10 Elemente enthalten
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
; $Log$
; Revision 1.6  1998/01/27 18:45:09  gabriel
;      Smooth Kernel Keyword neu
;
; Revision 1.5  1998/01/27 11:29:49  gabriel
;      ruft jetzt crosspower auf
;
; Revision 1.4  1998/01/07 15:03:18  thiel
;        Jetzt auch mit $Log: powerspec.pro,v $
;        Jetzt auch mit Revision 1.5  1998/01/27 11:29:49  gabriel
;        Jetzt auch mit      ruft jetzt crosspower auf
;        Jetzt auch mit im Header.
;
;
;       Tue Aug 19 20:58:57 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schon vorher bestehende Funktion dokumentiert und in den CVS-Baum hinzugefuegt
;
;-




FUNCTION PowerSpec, series, xaxis, hamming=HAMMING, DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE,KERNEL=kernel
 
 PSpec = crosspower( series, series, xaxis, hamming=HAMMING,$
                     DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE,KERNEL=kernel)

 Return,PSpec
END
