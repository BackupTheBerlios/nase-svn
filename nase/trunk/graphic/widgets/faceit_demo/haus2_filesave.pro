;+
; NAME: haus2_FILESAVE
;
; AIM:
;  Save the current state of the simultion for later resumption.
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>. 
;          Dessen Men�eintrag 'File.Save' ruft diese Routine auf. Der Benutzer
;          kann damit bei Bedarf Simulationsdaten speichern.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen W�nschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: haus2_FILESAVE, dataptr, group
;
; INPUTS: dataptr: Ein Pointer, der auf die Simulationsdatenstruktur zeigt und
;                  den Zugriff auf die zu speichernden Daten erm�glicht.
;         group: Die WidgetID des aufrufenden Widgets. Dieses dient als Eltern-
;                Widget f�r die PickFile-Dialogbox. F�r den Benutzer ist dieser
;                Parameter bedeutungslos.
;
; RESTRICTIONS: Die gesamte FaceIt-Architektur ist erst unter IDL Version 5 
;               lauff�hig.
;
; PROCEDURE: 1. Zur�ckkehren, falls ein Fehler auftritt.
;            2. Dateinamen mit IDL-Widget DIALOG_PICKFILE aussuchen.
;            3. Unter diesem Dateinamen mit SAVE die gew�nschten Daten ablegen.
;               Im Beispiel wird die Kopplungsst�rke der Verbindungen und die
;               DW-Struktur gespeichert. 
;
; EXAMPLE:  FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A> und die IDL-Online-Hilfe �ber
;           'Dialog_Pickfile' und 'Save'. 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/10/01 14:52:11  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.2  1999/09/02 14:38:18  thiel
;            Improved documentation.
;
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-



PRO haus2_FILESAVE, dataptr, group

   ; Move to label 'skip' if IO-error occurs: 
   ON_IOERROR, skip

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

   ; Get name of file to write from DIALOG_PICKFILE-Widget:
   ; (See IDL-online-help for more options of this routine.)
   filename = DIALOG_PICKFILE(/WRITE, FILTER='*.dat', $
      TITLE='haus2. Select File', GROUP=group)

   ; Do nothing if the filename is empty because user pressed CANCEL-button.
   ; Else convert data if necessary and call IDL-save-routine:
   IF filename NE '' THEN BEGIN

      save_couplampl = (*dataptr).couplampl
      save_con_pre_pre = SaveDW((*dataptr).con_pre_pre)
   
      Save, FILENAME=filename, $
       save_couplampl, $
       save_con_pre_pre

;--- NO CHANGES NECESSARY BELOW THIS LINE.

      Message, /INFO, 'Saving data structures in file '+filename
   ENDIF ELSE $
      Message, /INFO, 'Nothing saved.' 
    
   GOTO, done

   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR
         Message, /INFO, 'Nothing saved.' 

   done: 


END
