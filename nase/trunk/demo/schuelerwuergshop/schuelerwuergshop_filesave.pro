;+
; NAME: schuelerwuergshop_FILESAVE
;
; AIM: Module of <A>schuelerwuergshop</A>  (see also  <A>faceit</A>)
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>. 
;          Dessen Menüeintrag 'File.Save' ruft diese Routine auf. Der Benutzer
;          kann damit bei Bedarf Simulationsdaten speichern.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: schuelerwuergshop_FILESAVE, dataptr, group
;
; INPUTS: dataptr: Ein Pointer, der auf die Simulationsdatenstruktur zeigt und
;                  den Zugriff auf die zu speichernden Daten ermöglicht.
;         group: Die WidgetID des aufrufenden Widgets. Dieses dient als Eltern-
;                Widget für die PickFile-Dialogbox. Für den Benutzer ist dieser
;                Parameter bedeutungslos.
;
; RESTRICTIONS: Die gesamte FaceIt-Architektur ist erst unter IDL Version 5 
;               lauffähig.
;
; PROCEDURE: 1. Zurückkehren, falls ein Fehler auftritt.
;            2. Dateinamen mit IDL-Widget DIALOG_PICKFILE aussuchen.
;            3. Unter diesem Dateinamen mit SAVE die gewünschten Daten ablegen.
;               Im Beispiel wird die Kopplungsstärke der Verbindungen und die
;               DW-Struktur gespeichert. 
;
; EXAMPLE:  FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A> und die IDL-Online-Hilfe über
;           'Dialog_Pickfile' und 'Save'. 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/28 12:29:37  alshaikh
;              added AIM
;
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:01:48  kupper
;        Initial revision
;
;-



PRO schuelerwuergshop_FILESAVE, dataptr, group

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
