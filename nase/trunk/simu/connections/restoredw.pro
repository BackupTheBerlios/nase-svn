;+
; NAME:               RestoreDW
;
; PURPOSE:            Ist ein Zusatz zur IDL-Routine RESTORE fuer DelayWeigh-Structuren. Diesen haben naemlich dynamische Tags,
;                     die nicht so ohne weiteres gespeichert werden koennen. Diese Routine speichert sie zwar nicht, sondern baut 
;                     die entsprechenden Tags neu auf.
;
; CATEGORY:           SIMULATION
;
; CALLING SEQUENCE:   RestoreDW, DW
;
; INPUTS:             Eine mit RESTORE eingelesene DelayWeigh-Struktur
;
; EXAMPLE:            Restore, 'MeineSimulation'
;                     RestoreDW, DW
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/09/17 10:25:55  saam
;     Listen&Listen in den Trunk gemerged
;
;     Revision 1.1.2.1  1997/09/16 13:22:22  saam
;          Schoepfung
;
;
;-
PRO RestoreDW, DW

   Init_SDW, DW

END
