;+
; NAME: haus2_FREEDATA
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>. 
;          haus2_FREEDATA ist zum Funktionieren einer FaceIt-Simulation nicht
;          notwendig, wurde jedoch zur Verbesserung der Übersichtlichkeit
;          aus der <A HREF="#FACEIT">haus2_KILL_REQUEST</A>-Routine 
;          ausgelagert.
;          haus2_FREEDATA gibt die von der Simulation benötigten NASE-
;          Strukturen frei.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_FREEDATA, dataptr
;
; INPUTS: dataptr
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
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

END ; all2all_FREEDATA
