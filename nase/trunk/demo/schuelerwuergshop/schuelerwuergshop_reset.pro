;+
; NAME: schuelerwuergshop_RESET
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
; CALLING SEQUENCE: schuelerwuergshop_RESET, dataptr, displayptr
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
; PROCEDURE: Im Beispiel wird die Hilfsroutine <A HREF="#schuelerwuergshop_FREEDATA">schuelerwuergshop_FreeData</A> aufgerufen, die
;            die NASE-Strukturen freigibt. Dann wird die (*dataptr)-Struktur
;            mit <A HREF="#schuelerwuergshop_INITDATA">schuelerwuergshop_InitData</A> neu erzeugt und die Hilfsroutine 
;            <A HREF="#schuelerwuergshop_RESETSLIDERS">schuelerwuergshop_ResetSliders</A> aktualisiert die Einstellungen der 
;            Schieberegler.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#schuelerwuergshop_FREEDATA">schuelerwuergshop_FreeData</A>, <A HREF="#schuelerwuergshop_INITDATA">schuelerwuergshop_InitData</A>, 
;           <A HREF="#schuelerwuergshop_RESETSLIDERS">schuelerwuergshop_ResetSliders</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:02:24  kupper
;        Initial revision
;
;-

PRO schuelerwuergshop_RESET, dataptr, displayptr

   schuelerwuergshop_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'schuelerwuergshop_data'})
   schuelerwuergshop_InitData, dataptr
   schuelerwuergshop_ResetSliders, dataptr, displayptr

END ; schuelerwuergshop_RESET 
