;+
; NAME: haus2_FILEOPEN
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>. 
;          Diese Routine wird vom Menüpunkt 'File.Open' aufgerufen. Hier
;          können zuvor gespeicherte Simulationsdaten eingelesen werden.
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_FILEOPEN, dataptr, displayptr, group
;
; INPUTS:dataptr, displayptr, group
;             (Der 'group'-Parameter dient dem Dateiauswahl-Widget als Eltern-
;             teil, ist für den Benutzer uninteressant.)
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



PRO haus2_FILEOPEN, dataptr, displayptr, group

   ON_IOERROR, skip

   filename = DIALOG_PICKFILE(/READ, FILTER='*.dat', $
      TITLE='haus2. Select File', $
      PATH=!DATAPATH, GROUP=group, /MUST_EXIST)


   Restore, filename 

   (*dataptr).couplampl = save_couplampl
   (*dataptr).con_pre_pre = RestoreDW(save_con_pre_pre)
   
   Message, /INFO, 'Restoring data structures from file '+filename

   haus2_ResetSliders, dataptr, displayptr

   GOTO, done

   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR

   done: 

END
