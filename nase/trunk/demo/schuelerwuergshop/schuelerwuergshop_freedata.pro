;+
; NAME: schuelerwuergshop_FREEDATA
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="..#FACEIT">FaceIt</A>. 
;          schuelerwuergshop_FREEDATA gibt die von der Simulation benötigten NASE-
;          Strukturen frei.
;
;          schuelerwuergshop_FREEDATA ist zum Funktionieren einer FaceIt-Simulation nicht
;          notwendig, wurde jedoch zur Verbesserung der Übersichtlichkeit aus 
;          der <A HREF="#schuelerwuergshop_KILL_REQUEST">schuelerwuergshop_KILL_REQUEST</A>-Routine 
;          ausgelagert.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO 
;
; CALLING SEQUENCE: schuelerwuergshop_FREEDATA, dataptr
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
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:02:08  kupper
;        Initial revision
;
;-

PRO schuelerwuergshop_FREEDATA, dataptr

   Message, /INFO, "Freeing data structures."

   freelayer, (*dataptr).RETINA
;   freelayer, (*dataptr).CORTEX
;   freeDW, (*dataptr).RETINAtoCORTEX

END ; schuelerwuergshop_FREEDATA
