;+
; NAME: schuelerwuergshop_INITDISPLAY
;
; PURPOSE: Teilprogramm zur Demonstration der Benutzung von <A HREF="../#FACEIT">FaceIt</A>.
;          *_INITDISPLAY dient der Initialisierung der graphischen Darstellung
;          einer Simulation. Hier wird festgelegt, welche graphischen Elemente
;          (Widgets) die Simulationsoberfäche enthält und wie diese 
;          positioniert sind.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: GRAPHICS / WIDGETS / FACEIT_DEMO
;
; CALLING SEQUENCE: schuelerwuergshop_INITDISPLAY, dataptr, displayptr, w_userbase
;
; INPUTS: dataptr : Ein Pointer auf eine Struktur, die alle notwendigen
;                   Simulationsdaten enhält. Diese werden mit <A HREF="#schuelerwuergshop_INITDATA">*_INIDATA</A>
;                   festgelegt.
;         displayptr : Ein Pointer auf eine Struktur, die die WidgetIDs der 
;                      benutzerdefinierten Widgets enthält. Der Pointer wird 
;                      von <A HREF="../#FACEIT">FaceIt</A> geliefert. 
;                      *_INITDISPLAY füllt die Struktur, auf die displayptr 
;                      zeigt, mit den IDs der gewünschten Widgets. Art der 
;                      benutzten Widgets und Reihenfolge des Aufrufs bestimmen
;                      über das Aussehen der fertigen graphischen Oberfläche.
;                      Zum Vorgehen dabei siehe den Programmtext.
;         w_userbase : Das von <A HREF="../#FACEIT">FaceIt</A> zur Verfügung gestellte Parent-Widget, das
;                      alle anderen benutzereigenen Widgets aufnimmt. Die
;                      Anordnung der direkten Kind-Widgets in w_userbase 
;                      erfolgt untereinander (/COLUMN-Schlüsselwort in 
;                      Widget_Base).
;
; (SIDE) EFFECTS: *displayptr sollte nach dem Durchlauf von *_INITDISPLAY die
;                 Widget-IDs aller wichtigen graphischen Elemente enthalten.
;                 Wichtige graphische Elemente sind dabei solche, die 
;                 Ereignisse produzieren (anhand ihrer ID kann man später
;                 die Ereignisse den Widgets zuordnen) oder die zum 
;                 Darstellen von Daten benutzt werden sollen.
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; PROCEDURE:
;
; EXAMPLE: FaceIt, 'haus2'
;
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#schuelerwuergshop_INITDATA">schuelerwuergshop_INITDATA</A> , <A HREF="../#WIDGET_SHOWIT">Widget_ShowIt</A> 
;           und IDL-Online-Hilfe über 'Widgets'.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/02/17 17:41:46  kupper
;        Fuer die lieben Schueler.
;
;        Revision 1.3  1999/09/20 16:35:56  kupper
;        copy from schuelerwuergshop now okay.
;
;        Revision 1.2  1999/09/20 16:20:01  kupper
;        Copied from schuelerwuergshop.
;
;        Revision 1.1  1999/09/14 15:02:16  kupper
;        Initial revision
;
;-



PRO schuelerwuergshop_INITDISPLAY, dataptr, displayptr, w_userbase

   Message, /INFO, "Initializing Display."


;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   ; Put your own Widgets here:

   W_RFType  = CW_BGroup(W_UserBase,       ["concentric", "oriented: 0°","oriented: 45°", "oriented: 90°"], $
                                             BUTTON_UVALUE=[   -1,          0,          45,          90    ], $
                                             /EXCLUSIVE, SET_VALUE=0, $ ;Index of set Button (does 0 work anyway??)
                                             FONT=MySmallFont, $
                                             FRAME=2, $
                                             LABEL_TOP="RETINA RF-Type", $
                                             /NO_RELEASE, $
                                             ROW=1 $
                                            )
   W_Upper   = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_CENTER)
   W_Sliders = Widget_Base(W_Upper, /COLUMN, /BASE_ALIGN_CENTER) 
   W_ImageSet= CW_BGroup(W_Sliders,["'a'", "disc", "gauss"], $
                         /RETURN_NAME, $
                         BUTTON_UVALUE=["schuelerwuergshop_ImageSet_a", "schuelerwuergshop_ImageSet_disc", "schuelerwuergshop_ImageSet_gauss"], $
                         /EXCLUSIVE, SET_VALUE=0, $ ;Index of set Button (does 0 work anyway??)
                         FRAME=0, $
                         LABEL_TOP="Image set", $
                         /NO_RELEASE, $
                         ROW=1 $
                         )
   W_Brightness  = CW_FSLIDER2(W_Sliders, /DRAG, /VERTICAL, $
                           MINIMUM=0, MAXIMUM=1, STEPWIDTH=0.01, VALUE=(*dataptr).Image_Brightness, $
                           FORMAT='("Image brightness: ",F4.2)' )
   W_Image   = CW_FSLIDER2(W_Sliders, DRAG=1, /VERTICAL, $
                           MINIMUM=1, MAXIMUM=(*dataptr).number_of_images, STEPWIDTH=1, VALUE=(*dataptr).current_image, $
                           FORMAT='("Image size: ",I2)' )
   W_Coupling = CW_BGroup(W_Sliders, "Coupling", $
                            /NONEXCLUSIVE, $
                            SET_VALUE=1 $
                           )


   ; Now fill the (*displaptr)-struct with the IDs of all important widgets.
   ; It is not necessary to have the widgets here whose IDs won't be used 
   ; later. You have to include only those widgets that generate events
   ; or that are used to plot into them later. Normally you dont have to 
   ; include all those base-widgets.
   *displayptr = Create_Struct( *displayptr, $
                       "W_ImageSet" , W_ImageSet, $
                       "W_RFtype"   , W_RFType, $
                       "W_Brightness"   , W_Brightness, $
                       "W_Image"    , W_Image, $
                       "W_coupling" , W_coupling, $
                       "layersheet" , definesheet(W_Upper, /WINDOW, /PRIVATE_COLORS, MULTI=[6, 3, 2], TITLE="Layers",   XSize=250,   YSize=200), $
                       "INPUTtv"    , 3, $
                       "RETINAintv" , 4, $
                       "RETINAouttv", 5, $
                       "CONTROLtv"  , 1, $
                       "RFtv"       , 0 $;, $
$;                       "RFScantv"   , 2, $
$;                       "CORTEXsheet", definesheet(W_UserBase, /WINDOW, /PRIVATE_COLORS, MULTI=[2, 1, 2], TITLE="CORTEX Output", XSize=400, YSize=150), $
$;                       "CORTEXPlot" , 0, $
$;                       "CORTEXTrain", 1 $
   )


   ; By now, your Widget-Hierarchy should be complete and ready to be realized!

   SelectNASETable

   ; Now plot the first images inside the widgets:
   ; To do this, open the ShowIt-widgets and execute some graphic-routines:
   ; The first call to ShowIt_Open realizes the showit-widget, and because
   ; it is contained in your hierarchy, all other widgets are also immediately
   ; realized. At this point the whole FaceIt-Window becomes visible.

; ANBEI: Hier sollte ich besser die neuen ShowIts benutzen!

   opensheet, (*displayptr).layersheet, (*displayptr).CONTROLtv
   PlotTvScl,  /NASE, intarr(2, 2)
   PlotTvScl, /NASE, GetWeight((*dataptr).RETINAtoRETINA, S_ROW=(*dataptr).RetinaHeight/2, S_COL=(*dataptr).RetinaWidth/2), TITLE="Coupling Profile", xrange=[-(*dataptr).RETINAWidth/2, (*dataptr).RETINAWidth/2], yrange=[-(*dataptr).RETINAHeight/2, (*dataptr).RETINAHeight/2], /LEGEND, LEGMARGIN=0.1
;   PlotTvScl, /NASE, (*dataptr).CONTROLPF, TITLE="Coupling Profile", xrange=[-(*dataptr).RETINAWidth/2, (*dataptr).RETINAWidth/2], yrange=[-(*dataptr).RETINAHeight/2, (*dataptr).RETINAHeight/2], /LEGEND, LEGMARGIN=0.1
   closesheet, (*displayptr).layersheet, (*displayptr).CONTROLtv

   opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
   loadct, 0
   ;PlotTvScl, /NASE, intarr(2, 2)
   PlotTv, /NASE, 255*(*dataptr).Image_brightness*(*dataptr).images[*, *, (*dataptr).current_image], Title="Input Pattern", xrange=[-(*dataptr).RETINAWidth/2, (*dataptr).RETINAWidth/2], yrange=[-(*dataptr).RETINAHeight/2, (*dataptr).RETINAHeight/2], /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1, PLOTCOL=255
   closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv
   
;   opensheet, (*displayptr).layersheet, (*displayptr).RFScantv
;   PlotTvScl, /NASE, intarr(2, 2), COLORMODE=-1
;   closesheet, (*displayptr).layersheet, (*displayptr).RFScantv

   SelectNaseTable              ;$, /EXPONENTIAL

   opensheet, (*displayptr).layersheet, (*displayptr).RFtv
   PlotTvScl, /NASE, intarr(2, 2)-1
   PlotTvScl, CUBIC=-0.5, /MINUS_ONE, /NASE, (*dataptr).RETINARF, TITLE="RETINA-RF", xrange=[-(*dataptr).GaborSize/2, (*dataptr).GaborSize/2], yrange=[-(*dataptr).GaborSize/2, (*dataptr).GaborSize/2], /LEGEND, LEGMARGIN=0.1
   closesheet, (*displayptr).layersheet, (*displayptr).RFtv

   opensheet, (*displayptr).layersheet, (*displayptr).RETINAintv
   PlotTvScl, /NASE, intarr(2, 2)-1
   closesheet, (*displayptr).layersheet, (*displayptr).RETINAintv
   
   SelectNaseTable
   
   opensheet, (*displayptr).layersheet, (*displayptr).RETINAouttv
   uloadct, 0
   closesheet, (*displayptr).layersheet, (*displayptr).RETINAouttv




   (*dataptr).CurrentInput = (*dataptr).Image_brightness*(*dataptr).images[*, *, (*dataptr).current_image]
   (*dataptr).CurrentRETINAin = CONVOL((*dataptr).CurrentInput, (*dataptr).GaborAmplitude*(*dataptr).RETINARF, /EDGE_WRAP)

   opensheet, (*displayptr).layersheet, (*displayptr).INPUTtv
   PlotTV, /NASE, SETCOL=0, 255*(*dataptr).CurrentInput, TITLE="Input Pattern", /LEGEND, LEGMARGIN=0.1, LEG_MIN=0, LEG_MAX=1, PLOTCOL=255
   closesheet, (*displayptr).layersheet, (*displayptr).INPUTtv, SAVE_COLORS=0
   
   opensheet, (*displayptr).layersheet, (*displayptr).RETINAintv
   PlotTVScl, /NASE, SETCOL=0, (*dataptr).CurrentRETINAin, TITLE="RETINA In", /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
   closesheet, (*displayptr).layersheet, (*displayptr).RETINAintv, SAVE_COLORS=0

   RETINAout = LayerSpikes((*dataptr).RETINA, /DIMENSIONS)
   RETINAout[0] = 1
   opensheet,  (*displayptr).layersheet, (*displayptr).RETINAouttv
   PlotTVScl, GET_INFO=PlotTvInfo, /NASE, SETCOL=0, RETINAout, TITLE="RETINA Out", /LEGEND, LEGMARGIN=0.1, PLOTCOL=255
   closesheet, (*displayptr).layersheet, (*displayptr).RETINAouttv, SAVE_COLORS=0
   *displayptr = Create_Struct( *displayptr, $
                       "RETINAout_PlotTvInfo" , PlotTvInfo $
                              )


;   opensheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXPlot
;   *displayptr = Create_Struct( *displayptr, $
;                      "CORTEXp" , initplotcilloscope    (RAYS=2, TITLE="CORTEX Potential and Threshold", TIME=100) $
;                    )
;   closesheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXPlot

;   opensheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXTrain
;   *displayptr = Create_Struct( *displayptr, $
;                      "CORTEXt" , inittrainspottingscope(NEURONS=1, TITLE="CORTEX Spike Output", TIME=100) $
;                    )
;   closesheet, (*displayptr).CORTEXsheet, (*displayptr).CORTEXTrain

;   Message, /INFO, "initializing RF-Cine"
;   *dataptr = Create_Struct( *dataptr, $
;                      "RFScan_p" , PTR_NEW( RFScan_Init(WIDTH=(*dataptr).INPUTWidth, HEIGHT=(*dataptr).INPUTHeight, $
;                                                        OUTLAYER=(*dataptr).CORTEX, $
;                                                        /OBSERVE_SPIKES, $
;                                                        $; AUTO_RANDOMDOTS=DotProb $
;                                                        $; gauss_2d((*displayptr).INPUTHeight, (*displayptr).INPUTWidth, HWB = 0.1*(*displayptr).GaborWavelength) $
;                                                        cuttorus (fltarr((*dataptr).INPUTHeight, (*dataptr).INPUTWidth)+1, 0.2*(*dataptr).GaborWavelength) $
;                                                       ) ) $
;                     )

;--- NO CHANGES NECESSARY BELOW THIS LINE.  :)

  
END ; schuelerwuergshop_INITDISPLAY 
