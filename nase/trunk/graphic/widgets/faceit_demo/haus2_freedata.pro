;+
; NAME: haus2_FREEDATA
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="..#FACEIT">FaceIt</A>. 
;          haus2_FREEDATA gibt die von der Simulation benötigten NASE-
;          Strukturen frei.
;
;          haus2_FREEDATA ist zum Funktionieren einer FaceIt-Simulation nicht
;          notwendig, wurde jedoch zur Verbesserung der Übersichtlichkeit aus 
;          der <A HREF="#HAUS2_KILL_REQUEST">haus2_KILL_REQUEST</A>-Routine 
;          ausgelagert.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO 
;
; CALLING SEQUENCE: haus2_FREEDATA, dataptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enthält.
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; PROCEDURE: Freigeben der von der Simulation benutzten Layer- und DW-
;            Strukturen.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="../../../simu/layers/#FREELAYER">FreeLayer</A>,  <A HREF="../../../simu/connections/#FREEDW">FreeDW</A>,
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/09/03 14:24:46  thiel
;            Better docu.
;
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-

PRO haus2_FREEDATA, dataptr

   Message, /INFO, "Freeing data structures."

   FreeLayer, (*dataptr).pre
   FreeDW, (*dataptr).CON_pre_pre

END ; haus2_FREEDATA
