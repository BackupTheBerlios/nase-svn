;+
; NAME: haus2_KILL_REQUEST
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>.
;          Die hierin enthaltenen Befehle werden vor der Zerstörung des
;          FaceIt-Widgets ausgeführt, zB kann hier mit den NASE-Routinen 
;           <A HREF="../../../simu/layers/#FREELAYER">FreeLayer</A>,  <A HREF="../../../simu/connections/#FREEDW">FreeDW</A> ua dynamisch belegter Speicher freigegeben werden.
;          Ein Freigeben der Datenstrukturen (*dataptr) und (*displayptr) 
;          selbst wird von FaceIt durchgeführt.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: result = haus2_KILL_REQUEST, datatptr, diplayptr
;
; INPUTS: dataptr: Ein Pointer auf eine Struktur, die alle notwendigen
;                  Simulationsdaten (Parameter, NASE-Strukturen wie Layer und
;                  DWs) enthält.
;         diplayptr: Ein Zeiger auf die Struktur, die die WidgetIDs der 
;                    graphischen Elemente und andere wichtige graphische
;                    Daten enthält (zB Handles auf NASE-Plotcilloscopes oä).
;
; OUTPUTS: result: 1 (TRUE), falls die Simulation zerstört werden darf. 
;                  0 (FALSE), für den Fall, daß aus irgendeinem Grund ein 
;                     Beenden der Simulation verhindert werden soll. 
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; PROCEDURE: Im Beispiel wird die Hilfsroutine <A HREF="#HAUS2_FREEDATA">haus2_FreeData</A> aufgerufen, die
;            die NASE-Strukturen freigibt. Dann werden auch das Plot- und das
;            Trainspottingsscope gelöscht.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="../../../simu/layers/#FREELAYER">FreeLayer</A>,  <A HREF="../../../simu/connections/#FREEDW">FreeDW</A>,
;           <A HREF="../../plotcilloscope/#FREEPLOTCILLOSCOPE">FreePlotcilloscope</A>, <A HREF="../../plotcilloscope/#FREETRAINSPOTTINGSCOPE">FreeTrainspottingscope</A>.
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



FUNCTION haus2_KILL_REQUEST, dataptr, displayptr

   Message, /INFO, "Cleaning up."

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   
   ; Free NASE-structures in separate routine:
   haus2_FreeData, dataptr

   ; Free plotcilloscope and trainspottingscope
   FreePlotcilloscope, (*displayptr).pcs
   FreeTrainspottingscope, (*displayptr).tss

   Message, /INFO, "Finished!"

   ; Return 1 (TRUE) to allow destruction to be continued:
   Return, 1 

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; haus2_KILL_REQUEST
