;+
; NAME:               InitRecall
;
; PURPOSE:            InitRecall initialisiert Lernpotentiale fuer unverzoegerte und verzoegerte Gewichtsstrukturen.
;                     Im unverzoegerten Fall wird jedem Neuron, im verzeogerten Fall jeder Verbindung ein Lernpotential
;                     zugewiesen. Die Lernpotentiale werden mit TotalRecall 'upgedated' werden. Es kann zwischen mehreren 
;                     Abklingfunktionen ausgewaehlt werden.
;                     
;
; CATEGORY:           LEARNING
;
; CALLING SEQUENCE:   LP = InitRecall( Struc { [,LINEAR='['Amplitude, Decrement']'] | [,EXPO='['Amplitude, Zeitkonstante']'] } 
;
; INPUTS:             UNverzoegerte Verbindungen:
;                               Struc: Layer            (mit Init_Layer? initialisiert)
;                     verzoegerte Verbindungen:
;                               Struc: Gewichtsstruktur (mit InitDW erzeugt)
;
; KEYWORD PARAMETERS: 
;                     LINEAR: linearer Abfall des Lernpotentials mit Decrement, ein eintreffender Spike erhoeht das Potential um Amplitude
;                     EXPO  : exponentieller Abfall des Lernpotentials mit der Zeitkonstante, ein eintreffender Spike erhoeht das
;                               Potential um Amplitude
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

FUNCTION InitRecall, _Struc, LINEAR=linear, EXPO=expo

   Handle_Value, _Struc, Struc, /NO_COPY

   IF KeyWord_Set(Linear) + Keyword_Set(expo) NE 1 THEN Message, 'you must specify exactly one decay-function'

   IF Struc.info EQ 'DW_DELAY_WEIGHT' OR Struc.info EQ 'DW_WEIGHT' THEN BEGIN
      xsize = Struc.target_w*Struc.target_h
      ysize = Struc.source_w*Struc.source_h
   END ELSE BEGIN
      IF Struc.Info EQ 'LAYER' THEN BEGIN
         xsize = Struc.w
         ysize = Struc.h
      END ELSE BEGIN
         Message, 'first argument has to be a delayweigh- or a cluster-structure'
      END
   END
   
   IF Keyword_Set(expo) THEN BEGIN
      IF N_Elements(expo) NE 2 THEN Message, 'amplification and time-constant expected with keyword expo'
      IF expo(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
      IF expo(1) LE 0.0        THEN Message, 'time-constant <= 0 senseless'

      LP = { info     : 'e'     ,$
             v        : expo(0) ,$
             dec      : exp(-1./expo(1)) ,$
             values   : FltArr( xsize, ysize ),$
             source_s : xsize,$
             target_s : ysize}

      Handle_Value, _Struc, Struc, /NO_COPY, /SET
      RETURN, Handle_Create(VALUE=LP, /NO_COPY)
   END


   IF Keyword_Set(linear) THEN BEGIN
      IF N_Elements(linear) NE 2 THEN Message, 'amplification and decrement expected with keyword linear'
      IF linear(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
      IF linear(1) GT linear(0)  THEN Message, 'decrement > amplification senseless'
      
      LP = { info   : 'l'     ,$
             v      : linear(0) ,$
             dec    : linear(1) ,$
             values : FltArr( xsize, ysize ),$
             source_s : xsize,$
             target_s : ysize}
      
      Handle_Value, _Struc, Struc, /NO_COPY, /SET
      RETURN, Handle_Create(VALUE=LP, /NO_COPY)
   END

   
END
