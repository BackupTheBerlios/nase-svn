;+
; NAME:     LRinithebblp2.pro
;
;
; PURPOSE:   InitRecall-wrap, consistent with MIND learning concept
;
;
; CATEGORY:  MIND LEARN
;
;
; CALLING SEQUENCE:   LP = Lrinithebblp2( {Struc | HEIGHT=Höhe, WIDTH=Breite} 
;                                       { [,LINEAR='['Amplitude, Decrement']'] | 
;                                         [,EXPO='['Amplitude, Zeitkonstante']'] 
;                                         [,ALPHA='[Amplitude, Zeitkonstante1, Zeitkonstante2]'] } 
;                                      [/NOACCUMULATION]
;                                      [/SUSTAIN]
;
;                                        
; INPUTS:             UNverzoegerte Verbindungen:
;                               Struc: Layer            (mit Init_Layer? initialisiert)
;                  
;                     ODER:  Hoehe und Breite explizit in HEIGHT,WIDTH 
;                            (wobei eigentlich nur das Produkt entscheidend ist, also 
;                            die Anzahl der Lernpotentiale)
;
; KEYWORD PARAMETERS: 
;                     LINEAR:         linearer Abfall des Lernpotentials mit Decrement, ein 
;                                       eintreffender Spike erhoeht das Potential um Amplitude
;                     EXPO:           exponentieller Abfall des Lernpotentials mit der 
;                                       Zeitkonstante, ein eintreffender Spike erhoeht das
;                                       Potential um Amplitude
;                     ALPHA:          Tiefpass 2ter Ordnung als Lernpotential mit der 
;                                       , ein eintreffender Spike erhoeht das Potential um Amplitude
;                     NOACCUMULATION: Das Potential wird bei Eintreffen eines Spikes
;                                       nicht um Amplitude erhoeht, sondern nur
;                                       auf Amplitude gesetzt. Dadurch wird ein 
;                                       Aufsummieren des Lernpotentials bei starker
;                                       praesynaptischer Aktivitaet verhindert. Trotzdem
;                                       'merkt' scih das Lernpotential, wie lange
;                                       der letzte praesynaptische Spike zurueckliegt.
;                     SUSTAIN:        Beginnt das Abklingen des Lernpotentials um einen
;                                       Zeitschritt verzoegert, um absolut gleichzeitiges
;                                       Lernen und um einen Zeitschritt verzoegertes (kausales)
;                                       Lernen gleich zu gewichten.
;                     SAMPLEPERIOD:   die Dauer eines Simulationszeitschritts, Default: 0.001s
;
; OUTPUTS:            LP: die initialisierte Lernpotential-Struktur zur weiteren Behandlung mit TotalRecall
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/01/26 10:40:28  alshaikh
;           +initial version
;           +doesn't work with delays
;           +no fancy header
;
;
;-

FUNCTION lrinithebblp2,LW=Lw,_EXTRA=e

win = initrecall(LW,_EXTRA=e)

return, win
END 
