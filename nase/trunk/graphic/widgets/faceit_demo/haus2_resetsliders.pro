;+
; NAME: haus2_RESETSLIDERS
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>.
;          haus2_RESETSLIDERS ist eine Routine, die der Übersichtlichkeit 
;          halber aus <A HREF="#FACEIT">haus2_RESET</A> ausgelagert wurde. Sie ist also zum 
;          Funktionieren einer eigenen Simulation nicht unbedingt erforderlich.
;          Hier werden nach einem Reset die Slider auf ihre aktuellen Werte 
;          gesetzt.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_RESETSLIDERS, dataptr, displayptr
;
; INPUTS:dataptr, displayptr
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



PRO haus2_RESETSLIDERS, dataptr, displayptr

   Widget_Control, (*displayptr).w_nparvs, SET_VALUE=(*dataptr).prepara.vs
   Widget_Control, (*displayptr).w_npartaus, SET_VALUE=(*dataptr).prepara.taus
   Widget_Control, (*displayptr).w_extinpampl, SET_VALUE=(*dataptr).extinpampl
   Widget_Control, (*displayptr).w_extinpperiod, SET_VALUE=(*dataptr).extinpperiod
   Widget_Control, (*displayptr).w_couplampl, SET_VALUE=(*dataptr).couplampl
    
END
