;+
; NAME: haus2_RESET
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>.
;          Falls notwendig, k�nnen hier Aktionen bestimmt werden, die bei
;          Bet�tigung des RESET-Buttons ausgef�hrt werden sollen. So k�nnen 
;          etwa die Simulationsparameter auf ihre urspr�nglichen Werte gesetzt
;          werden o�.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen W�nschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: haus2_RESET, dataptr, displayptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enth�lt.
;         diplayptr: Ein Zeiger auf die Struktur, die die WidgetIDs der 
;                    graphischen Elemente und andere wichtige graphische
;                    Daten enth�lt (zB Handles auf NASE-Plotcilloscopes o�).
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 m�glich. 
;
; PROCEDURE: Im Beispiel wird die Hilfsroutine <A HREF="#HAUS2_FREEDATA">haus2_FreeData</A> aufgerufen, die
;            die NASE-Strukturen freigibt. Dann wird die (*dataptr)-Struktur
;            mit <A HREF="#HAUS2_INITDATA">haus2_InitData</A> neu erzeugt und die Hilfsroutine 
;            <A HREF="#HAUS2_RESETSLIDERS">haus2_ResetSliders</A> aktualisiert die Einstellungen der 
;            Schieberegler.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#HAUS2_FREEDATA">haus2_FreeData</A>, <A HREF="#HAUS2_INITDATA">haus2_InitData</A>, 
;           <A HREF="#HAUS2_RESETSLIDERS">haus2_ResetSliders</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/09/03 14:24:46  thiel
;            Better docu.
;
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
