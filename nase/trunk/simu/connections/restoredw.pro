;+
; NAME:               RestoreDW
;
; PURPOSE:            Ist ein Zusatz zur IDL-Routine RESTORE fuer DelayWeigh-Structuren. Diesen haben naemlich dynamische Tags,
;                     die nicht so ohne weiteres gespeichert werden koennen. Diese Routine speichert sie zwar nicht, sondern baut 
;                     die entsprechenden Tags neu auf.
;
; CATEGORY:           SIMU/CONNECTIONS
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
;     Revision 2.2  1997/12/10 15:53:40  saam
;           Es werden jetzt keine Strukturen mehr uebergeben, sondern
;           nur noch Tags. Das hat den Vorteil, dass man mehrere
;           DelayWeigh-Strukturen in einem Array speichern kann,
;           was sonst nicht moeglich ist, da die Strukturen anonym sind.
;
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
   DW = Handle_Create(VALUE=DW, /NO_COPY)

END
