;+
; NAME: haus2_RESET
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>.
;          Falls notwendig, k�nnen hier Aktionen bestimmt werden, die bei
;          Bet�tigung des RESET-Buttons ausgef�hrt werden sollen. So k�nnen 
;          etwa die Simualtionsparameter auf ihre urspr�nglichen Werte gesetzt
;          werden o�.
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen W�nschen 
;          abzuwandeln.
;
; PURPOSE:
;          PRO <A HREF="#HAUS2_RESET">name_RESET</A>, dataptr, displayptr, w_userbase
;             Falls notwendig, k�nnen hier Aktionen bestimmt werden, die bei
;             Bet�tigung des RESET-Buttons ausgef�hrt werden sollen.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_RESET, dataptr, displayptr
;
; INPUTS:, dataptr, displayptr
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
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

PRO haus2_RESET, dataptr, displayptr

   haus2_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'haus2_data'})
   haus2_InitData, dataptr
   haus2_ResetSliders, dataptr, displayptr

END ; haus2_RESET 
