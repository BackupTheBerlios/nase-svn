;+
; NAME: schuelerwuergshop_FILEOPEN
;
; AIM: Module of <A>schuelerwuergshop</A>  (see also  <A>faceit</A>)
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>. 
;          Diese Routine wird vom Menüpunkt 'File.Open' aufgerufen. Hier
;          können zuvor gespeicherte Simulationsdaten eingelesen werden.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: schuelerwuergshop_FILEOPEN, dataptr, displayptr, group
;
; INPUTS: dataptr: Ein Pointer, der auf die Simulationsdatenstruktur zeigt und
;                  den Änderung der Simulationsdaten ermöglicht.
;         displayptr: Ein Pointer, der aud die Displaystruktur zeigt, die die
;                     benutzereigenen WidgetIDs enthält. Dieser Pointer wird
;                     übergeben, um nach dem Laden eine Aktualisierung des
;                     Displays zu erlauben.
;         group: Die WidgetID des aufrufenden Widgets. Dieses dient als Eltern-
;                Widget für die PickFile-Dialogbox. Für den Benutzer ist dieser
;                Parameter bedeutungslos.
;
; RESTRICTIONS: Die gesamte FaceIt-Architektur ist erst unter IDL Version 5 
;               lauffähig.
;
; PROCEDURE: 1. Zurückkehren, falls ein Fehler auftritt.
;            2. Dateinamen mit IDL-Widget DIALOG_PICKFILE aussuchen.
;            3. Die unter diesem  Dateinamen abgelegten Daten mit RESTORE
;               wiederherstellen und in die Simulationsdatenstruktur 
;               schreiben. Im Beispiel wird die Kopplungsstärke der 
;               Verbindungen und die DW-Struktur eingelesen.
;            4. Graphische Darstellung aktualisieren. 
;
; EXAMPLE:  FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A> und die IDL-Online-Hilfe über
;           'Dialog_Pickfile' und 'Restore'. 
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
;        Revision 1.1  1999/09/14 15:01:45  kupper
;        Initial revision
;
;-



PRO schuelerwuergshop_FILEOPEN, dataptr, displayptr, group

   ; Move to label 'skip' if IO-error occurs: 
   ON_IOERROR, skip

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 

   ; Get name of file to read from DIALOG_PICKFILE-Widget:
   ; (See IDL-online-help for more options of this routine.)
   filename = DIALOG_PICKFILE(/READ, FILTER='*.dat', $
      TITLE='haus2. Select File', $
      GROUP=group, /MUST_EXIST)

   ; Restore data contained in chosen file:
   Restore, filename 

   ; Change datastructure:
   (*dataptr).couplampl = save_couplampl
   (*dataptr).con_pre_pre = RestoreDW(save_con_pre_pre)
   
   ; Update display with values just read:
   schuelerwuergshop_ResetSliders, dataptr, displayptr

;--- NO CHANGES NECESSARY BELOW THIS LINE.

   Message, /INFO, 'Restoring data structures from file '+filename
   GOTO, done

   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR

   done: 

END
