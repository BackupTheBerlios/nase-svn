;+
; NAME: schuelerwuergshop_DISPLAY
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
; CALLING SEQUENCE: schuelerwuergshop_DISPLAY, dataptr, displayptr
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
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.1  1999/09/14 15:01:25  kupper
;        Initial revision
;
;-


PRO schuelerwuergshop_DISPLAY, dataptr, displayptr

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   

;--- NO CHANGES NECESSARY BELOW THIS LINE.
;   opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
;   PlotTV, /NASE, SETCOL=0, 255*(*dataptr).CurrentInput, TITLE="Input Pattern", /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1, PLOTCOL=255
;   closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv, SAVE_COLORS=0
   
;   opensheet, (*displayptr).layersheet, (*displayptr).RETINAintv
;   PlotTVScl, /NASE, SETCOL=0, (*dataptr).CurrentRETINAin, TITLE="RETINA In", /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
;   closesheet, (*displayptr).layersheet, (*displayptr).RETINAintv, SAVE_COLORS=0
   
;   opensheet,  (*displayptr).layersheet, (*displayptr).RFScantv
;   RF = GetWeight((*(*dataptr).RFScan_p).RFs, T_INDEX=0)
;   RF = RF-mean(RF)
;   PlotTVScl, /NASE, SETCOL=0, COLORMODE=-1, RF, TITLE="Scanned RF", CUBIC=-0.5, /MINUS_ONE, /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
;   closesheet, (*displayptr).layersheet, (*displayptr).RFScantv, SAVE_COLORS=0      
   
   RETINAout = LayerSpikes((*dataptr).RETINA, /DIMENSIONS)
   opensheet,  (*displayptr).layersheet, (*displayptr).RETINAouttv
;   PlotTVScl, /NASE, SETCOL=0, RETINAout, TITLE="RETINA Out", /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
   PlotTVScl_update, RETINAout, (*displayptr).RETINAout_PlotTvInfo
   closesheet, (*displayptr).layersheet, (*displayptr).RETINAouttv, SAVE_COLORS=0
   
;   LayerData, (*dataptr).CORTEX, POTENTIAL=pot, SCHWELLE=sch, LSCHWELLE=lsch
;   opensheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXPlot
;   plotcilloscope, (*displayptr).CORTEXp, [pot(0), sch(0)+lsch(0)]
;   closesheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXPlot, SAVE_COLORS=0
;   opensheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXTrain
;   trainspottingscope, (*displayptr).CORTEXt, LayerOut((*dataptr).CORTEX)
;   closesheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXTrain

      
END ; schuelerwuergshop_DISPLAY
