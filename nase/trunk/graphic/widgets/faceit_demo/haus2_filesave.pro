;+
; NAME: haus2_FILESAVE
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>. 
;          Dessen Menüeintrag 'File.Save' ruft diese Routine auf. Der Benutzer
;          kann damit bei Bedarf Simulationsdaten speichern.
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_FILESAVE, dataptr, group
;
; INPUTS: dataptr, (group)
;
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



PRO haus2_FILESAVE, dataptr, group

 ON_IOERROR, skip

   filename = DIALOG_PICKFILE(/WRITE, FILTER='*.dat', $
      TITLE='haus2. Select File', $
       PATH=!DATAPATH, GROUP=group)


   IF filename NE '' THEN BEGIN
      save_couplampl = (*dataptr).couplampl
      save_con_pre_pre = SaveDW((*dataptr).con_pre_pre)
   

      Save, FILENAME=filename, $
       save_couplampl, $
       save_con_pre_pre

      Message, /INFO, 'Saving data structures in file '+filename
   ENDIF ELSE $
      Message, /INFO, 'Nothing saved.' 
    
   GOTO, done

   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR
         Message, /INFO, 'Nothing saved.' 

   done: 


END
