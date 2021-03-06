;+
; NAME:
;  RestoreDW()
;
; AIM: Restore DW structure.
;
; PURPOSE:            Ist ein Zusatz zur IDL-Routine RESTORE fuer DelayWeigh-Structuren.
;                     Diesen haben naemlich dynamische Tags, die nicht so ohne weiteres 
;                     gespeichert werden koennen. Diese Routine speichert sie zwar nicht, 
;                     sondern baut die entsprechenden Tags neu auf.
;
; CATEGORY:
;  Simulation / Connections
;
; CALLING SEQUENCE:   Handle_DW = RestoreDW (Saved_DW)
;
; INPUTS:             Saved_DW : Eine zuvor mit <A HREF="#SAVEDW">SaveDW</A> und SAVE 
;                                 abgespeicherte und anschliessend mit RESTORE wieder 
;                                 eingelesene DelayWeigh-Struktur
; OUTPUTS:            Handle_DW : Ein Handle auf die DelayWeigh-Struktur zur Weiter-
;                                  benutzung in der NASE-Simulation.
;
; SIDE EFFECTS:       Saved_DW ist nach dem Aufruf undefiniert.
;
; EXAMPLE: Speichern: SaveableMatrix = SaveDW(Matrixhandle)
;                     Save, SaveableMatrix, FILENAME='ewige_blumenkraft'
;                     
;          und dann wieder einlesen:
;                     Restore, 'ewige_blumenkraft'
;                     Matrixhandle = RestoreDW(SaveableMatrix)           
;
; SEE ALSO: <A HREF="#SAVEDW">SaveDW</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.6  2000/09/25 16:49:13  thiel
;         AIMS added.
;
;     Revision 2.5  1998/02/05 13:16:03  saam
;           + Gewichte und Delays als Listen
;           + keine direkten Zugriffe auf DW-Strukturen
;           + verbesserte Handle-Handling :->
;           + vereinfachte Lernroutinen
;           + einige Tests bestanden
;
;     Revision 2.4  1997/12/17 11:00:38  saam
;           Bug im verzoegerten Teil: SpikeQueue wurde nicht neu
;           initialisiert
;
;     Revision 2.3  1997/12/12 12:59:28  thiel
;            RestoreDW ist jetzt analog zu SaveDW eine Funktion.
;
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

FUNCTION RestoreDW, DW

   IF Info(DW) NE 'DW_WEIGHT' AND Info(DW) NE 'DW_DELAY_WEIGHT' THEN Message,'DW[_DELAY]_WEIGHT structure expected, but got '+Info(DW)+' !'
   _DW = Handle_Create(!MH, VALUE=DW, /NO_COPY)
   DW2SDW, _DW
   RETURN, _DW

END
