;+
; NAME: haus2_RESET
;
; AIM:
;  Reset all simulation data and the graphical user interface.
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>.
;          Falls notwendig, können hier Aktionen bestimmt werden, die bei
;          Betätigung des RESET-Buttons ausgeführt werden sollen. So können 
;          etwa die Simulationsparameter auf ihre ursprünglichen Werte gesetzt
;          werden oä.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: haus2_RESET, dataptr, displayptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enthält.
;         diplayptr: Ein Zeiger auf die Struktur, die die WidgetIDs der 
;                    graphischen Elemente und andere wichtige graphische
;                    Daten enthält (zB Handles auf NASE-Plotcilloscopes oä).
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
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
;        Revision 1.4  2000/10/01 14:52:11  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.3  1999/09/14 13:01:07  kupper
;        Just added informative comments.
;
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

;--- THE FOLLOWING WILL DO FINE IN MOST CASES.
;--- HOWEVER, IF THERE IS A MORE EFFICIENT WAY TO RESET
;--- YOUR SIMULATION, CHANGE IT. 

   haus2_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'haus2_data'})
   haus2_InitData, dataptr

   haus2_ResetSliders, dataptr, displayptr

;--- NO CHANGES NECESSARY BELOW THIS LINE.

END ; haus2_RESET 
