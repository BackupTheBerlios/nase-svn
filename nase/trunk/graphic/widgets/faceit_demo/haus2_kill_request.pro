;+
; NAME: haus2_KILL_REQUEST
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>.
;          Die hierin enthaltenen Befehle werden vor der Zerstörung des
;           FaceIt-Widgets ausgeführt. ZB können hier Datenstrukturen 
;          freigegeben werden.
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_KILL_REQUEST, datatptr, diplayptr
;
; INPUTS: datatptr, diplayptr
;
; OUTPUTS: 1 (True)
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



FUNCTION haus2_KILL_REQUEST, dataptr, displayptr
   ;;------------------> Cleanup
   Message, /INFO, "Cleaning up."

   haus2_FreeData, dataptr

   FreePlotcilloscope, (*displayptr).pcs
   FreeTrainspottingscope, (*displayptr).tss

   Print, "Finished!"

   Return, (1 eq 1)             ;TRUE
END ; haus2_KILL_REQUEST
