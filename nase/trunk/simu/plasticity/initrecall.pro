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
;       Fri Sep 12 11:39:40 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       $Revision$
;		
;               Tags Target_S und Source_S fuer Groesse von Ziel- und Quell-Layer hinzugef"ugt
;               Daher braucht DelayWeigh nun keinen Source-Cluster mehr

;       Thu Sep 4 15:32:25 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Es werden nun sowohl neuronenspezifische als auch synapsenspez. Lernpotentiale behandelt
;
;       Thu Sep 4 11:24:28 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Schoepfung
;
;-

FUNCTION InitRecall, S, WIDTH=width, HEIGHT=height, LINEAR=linear, EXPO=expo, ALPHA=alpha, $
                     NOACCUMULATION=noaccumulation, SUSTAIN=sustain, SAMPLEPERIOD=sampleperiod

   Default, SAMPLEPERIOD, 0.001
   Default, NOACCUMULATION, 0
   Default, SUSTAIN, 0

   deltat = SAMPLEPERIOD*1000.

   IF KeyWord_Set(Linear) + Keyword_Set(expo) + Keyword_Set(alpha) NE 1 THEN Message, 'you must specify exactly one decay-function'

   If N_Params() eq 1 then begin ;S wurde angegeben
      IF Info(S) EQ 'SDW_DELAY_WEIGHT' THEN BEGIN
         size = WeightCount(S)
      END ELSE BEGIN
         IF Info(S) EQ 'LAYER' THEN BEGIN
            size = LayerSize(S)
         END ELSE BEGIN
            Message, 'expected SDW_DELAY_WEIGHT or LAYER structur, but got '+Info(S)+' !'
         END
      END
   Endif else Begin             ;S wurde nicht angegeben
      If not (Keyword_Set(WIDTH) and Keyword_Set(HEIGHT) ) then Message, 'please specify a Structure or WIDTH/HEIGHT' $ 
      else size = width*height
   EndElse

   IF Keyword_Set(expo) THEN BEGIN
      IF N_Elements(expo) NE 2 THEN Message, 'amplification and time-constant expected with keyword expo'
      IF expo(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
      IF expo(1) LE 0.0        THEN Message, 'time-constant <= 0 senseless'

      LP = { info     : 'e'     ,$
             v        : expo(0) ,$
             dec      : exp(-deltat/expo(1)) ,$
             values   : FltArr( size ) ,$
             noacc    : NOACCUMULATION ,$
             last     : -1l, $
             sust     : SUSTAIN }
      
      RETURN, Handle_Create(VALUE=LP, /NO_COPY)
   END

   IF Keyword_Set(alpha) THEN BEGIN
      IF N_Elements(alpha) NE 3 THEN Message, 'amplification and 2 time-constants expected with keyword alpha'
      IF alpha(0) LE 0.0         THEN Message, 'amplification <= 0 senseless'
      IF alpha(1) LE 0.0         THEN Message, 'time-constant <= 0 senseless'
      IF alpha(2) LE 0.0         THEN Message, 'time-constant <= 0 senseless'

      LP = { info     : 'a'     ,$
             v        : alpha(0)/(exp(-alog(alpha(2)/alpha(1))*alpha(1)/(alpha(2)-alpha(1)))-exp(-alog(alpha(2)/alpha(1))*alpha(2)/(alpha(2)-alpha(1)))),$
             dec1     : exp(-deltat/alpha(1)) ,$
             dec2     : exp(-deltat/alpha(2)) ,$
             leak1    : FltArr( size ) ,$
             leak2    : FltArr( size ) ,$
             values   : FltArr( size ) ,$
             noacc    : NOACCUMULATION ,$
             last     : -1l, $
             sust     : SUSTAIN }
      RETURN, Handle_Create(VALUE=LP, /NO_COPY)
   END


   IF Keyword_Set(linear) THEN BEGIN
      IF N_Elements(linear) NE 2 THEN Message, 'amplification and decrement expected with keyword linear'
      IF linear(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
      IF linear(1) GT linear(0)  THEN Message, 'decrement > amplification senseless'
      
      LP = { info   : 'l'     ,$
             v      : linear(0) ,$
             dec    : deltat*linear(1) ,$
             values : FltArr( size ), $
             noacc  : NOACCUMULATION ,$
             last   : -1l ,$
             sust   : SUSTAIN }

      RETURN, Handle_Create(VALUE=LP, /NO_COPY)
   END

   
END
