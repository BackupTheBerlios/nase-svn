;+
; NAME: haus2_DISPLAY
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>. 
;          Hier soll die Darstellung des Netzwerkzustands während der 
;          Simulation erfolgen. *_DISPLAY wird von FaceIt nach jedem 
;          Simulationsschritt aufgerufen, es sei denn, die Ausgabe wurde mit 
;          Hilfe des DISPLAY-Buttons deaktiviert.
;
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: haus2_DISPLAY, dataptr, displayptr
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
; PROCEDURE: Öffnen der <A HREF="../#WIDGET_SHOWIT">ShowIt-Widgets</A> und hineinmalen.
;            Anschließend die Widgets wieder schließen, ohne die Farbpalette zu
;            speichern, damit die Farben nicht flackern.
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="../#WIDGET_SHOWIT">Widget_ShowIt</A>.
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



PRO haus2_DISPLAY, dataptr, displayptr

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   
   ; Only show activity in layer with PlotTVScl if new output is different 
   ; from old one (this avoids too much flickering):
   preout = LayerSpikes((*dataptr).pre, /DIMENSIONS)
   IF NOT A_EQ(preout,(*dataptr).lastout) THEN BEGIN
      ; Open the widget to plot into:
      ShowIt_Open, (*displayptr).spikestv
      ; Do not change colortable, /SETCOL=0, colortable should be set correctly
      ; by first PlotTVScl in haus2_INITDISPLAY:
      PlotTVScl, /NASE, SETCOL=0, preout, TITLE="Spikes in Layer", PLOTCOL=255
      ; Do not save colortable, SAVE_COLORS=0:
      ShowIt_Close, (*displayptr).spikestv, SAVE_COLORS=0
      (*dataptr).lastout = preout
   ENDIF

   ; Trainspottingscope and Plotcilloscope: 
   ShowIt_Open, (*displayptr).spiketrain
   TrainSpottingScope, (*displayptr).tss, LayerOut((*dataptr).pre)
   ShowIt_Close, (*displayptr).spiketrain, SAVE_COLORS=0

   ShowIt_Open, (*displayptr).plotcillo
   LayerData, (*dataptr).pre, POTENTIAL=m, SCHWELLE=theta
   Plotcilloscope, (*displayptr).pcs, [m((*dataptr).prew*(*dataptr).preh/2),theta((*dataptr).prew*(*dataptr).preh/2)+1.0]
   ShowIt_Close, (*displayptr).plotcillo, SAVE_COLORS=0

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; haus2_DISPLAY
