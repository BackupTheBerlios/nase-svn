;+
; NAME:               InitRecall
;
; PURPOSE:            InitRecall erzeugt eine Struktur bestehend aus ja einem Lernpotential pro Synapse, die 
;                     mit TotalRecall 'upgedated' werden. Es kann zwischen mehreren Abklingfunktionen 
;                     ausgewaehlt werden. Diese Routine wird nur fuer verzoegerte Verbindungen benoetigt, sonst
;                     erfuellt der Neuronentyp 3 eine aequivalente Aufgabe.
;
; CATEGORY:           LEARNING
;
; CALLING SEQUENCE:   LP = InitRecall( DelMat { [,LINEAR='['Amplitude, Decrement']'] | [,EXPO='['Amplitude, Zeitkonstante']'] } 
;
; INPUTS:             DelMat: eine mit InitDW initialisierte Gewichtsstruktur
;
; OPTIONAL INPUTS:    ---
;
; KEYWORD PARAMETERS: 
;                     LINEAR: linearer Abfall des Lernpotentials mit Decrement, ein eintreffender Spike erhoeht das Potential um Amplitude
;                     EXPO  : exponentieller Abfall des Lernpotentials mit der Zeitkonstante, ein eintreffender Spike erhoeht das
;                               Potential um Amplitude
;
; OUTPUTS:            LP: die initialisierte Lernpotential-Struktur zur weiteren Behandlung mit TotalRecall
;
; OPTIONAL OUTPUTS:   ---
;
; COMMON BLOCKS:      ---
;
; SIDE EFFECTS:       ---
; 
; RESTRICTIONS:       ---
;
; PROCEDURE:          ---
;
; EXAMPLE:
;                     LP = InitRecall( DelMat, LINEAR=[5.0, 0.5]) 
;                     LP = InitRecall( DelMat, EXPO=[1.0, 10.0])
;
; MODIFICATION HISTORY:
;
;       Thu Sep 4 11:24:28 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;		Urversion erstellt
;
;-

FUNCTION InitRecall, DelMat, LINEAR=linear, EXPO=expo
   IF Keyword_Set(expo) THEN BEGIN
      IF N_Elements(expo) NE 2 THEN Message, 'amplification and time-constant expected with keyword expo'
      IF expo(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
      IF expo(1) LE 0.0        THEN Message, 'time-constant <= 0 senseless'

      LP = { type   : 'e'     ,$
             v      : expo(0) ,$
             dec    : exp(-1./expo(1)) ,$
             values : FltArr( DelMat.target_w*DelMat.target_h, DelMat.source_w*DelMat.source_h )  }

      RETURN, LP
   END


   IF Keyword_Set(linear) THEN BEGIN
      IF N_Elements(linear) NE 2 THEN Message, 'amplification and decrement expected with keyword linear'
      IF linear(0) LE 0.0        THEN Message, 'amplification <= 0 senseless'
      IF linear(1) GT linear(0)  THEN Message, 'decrement > amplification senseless'
      
      LP = { type   : 'l'     ,$
             v      : linear(0) ,$
             dec    : linear(1) ,$
             values : FltArr( DelMat.target_w*DelMat.target_h, DelMat.source_w*DelMat.source_h )  }
      
      RETURN, LP
   END

   Message, 'you must specify one decay-function'
   
END
