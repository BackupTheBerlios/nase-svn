;+
; NAME:               InitRecall
;
; PURPOSE:            InitRecall initialisiert Lernpotentiale fuer 
;                     unverzoegerte und verzoegerte Gewichtsstrukturen.
;                     Im unverzoegerten Fall wird jedem Neuron, im 
;                     verzoegerten Fall jeder Verbindung ein Lernpotential
;                     zugewiesen, das z.B. fuer die Lernregel <A HREF="#LEARNHEBBLP">LearnHebbLP</A>
;                     gebraucht wird.
;                     Die Lernpotentiale werden mit <A HREF="#TOTALRECALL">TotalRecall</A>
;                     'upgedated' (geupdated). Es kann zwischen mehreren 
;                     Abklingfunktionen ausgewaehlt werden.
;                     
;
; CATEGORY:           SIMULATION / PLASTICITY
;
; CALLING SEQUENCE:   LP = InitRecall( {Struc | HEIGHT=Höhe, WIDTH=Breite} 
;                                       { [,LINEAR='['Amplitude, Decrement']'] | 
;                                         [,EXPO='['Amplitude, Zeitkonstante']'] |
;                                         [,ALPHA='[Amplitude, Zeitkonstante1, Zeitkonstante2]'] } 
;                                      [/NOACCUMULATION]
;                                      [/SUSTAIN]
;
; INPUTS:             UNverzoegerte Verbindungen:
;                               Struc: Layer            (mit Init_Layer? initialisiert)
;                     verzoegerte Verbindungen:
;                               Struc: Gewichtsstruktur (mit InitDW erzeugt)
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
; EXAMPLE:
;                     CONN = InitDW(....)
;                     LP = InitRecall( CONN, LINEAR=[5.0, 0.5]) 
;
;                     LAYER = InitLayer_1(...)
;                     LP = InitRecall( LAYER, EXPO=[1.0, 10.0])
;
; SEE ALSO: <A HREF="#TOTALRECALL">TotalRecall</A>, <A HREF="#LEARNHEBBLP">LearnHebbLP</A>
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.1  1999/07/21 15:03:42  saam
;             + no docu yet
;
;
;-

FUNCTION InitPrecall, DW, LW, deltaMax=deltaMax, deltaMin=deltaMin


   
   IF Info(DW) NE 'SDW_DELAY_WEIGHT' AND Info(DW) NE 'SDW_WEIGHT' THEN Message, 'Delay-Weight structure expected, but got a '+Info(DW)
   
   IF Set(LW) THEN BEGIN
      deltaMin = LW(0)
      deltaMax = LW(1)
   END ELSE BEGIN
      IF NOT Set(deltaMin) THEN Message, 'Learning Window OR deltaMin have to be specified'
      IF NOT Set(deltaMax) THEN Message, 'Learning Window OR deltaMax have to be specified'
   END


   postSize = LONG(DWDim(DW, /TW))*LONG(DWDIM(DW, /TH))
   
   IF Info(DW) EQ 'SDW_WEIGHT' THEN preSize = LONG(DWDim(DW, /SW))*LONG(DWDIM(DW, /SH)) ELSE preSize = WeightCount(DW)

   
   PC = { info      : 'precall',$
          time      : 0l       ,$
          pre       : Make_Array(  preSize, /LONG, VALUE=!NONEl) ,$
          post      : Make_Array( postSize, /LONG, VALUE=!NONEl) ,$
          deltamin  : deltaMin                                   ,$
          deltamax  : deltaMax                                   ,$
          postpre   : -1l } ;this will become a handle
   
   RETURN, Handle_Create(!MH, VALUE=PC, /NO_COPY)

END
