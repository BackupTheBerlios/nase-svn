;+
; NAME: haus2_INITDISPLAY
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
; CALLING SEQUENCE: haus2_INITDISPLAY, dataptr, displayptr, w_userbase
;
; INPUTS: dataptr : Ein Pointer auf eine Struktur, die alle notwendigen
;                   Simulationsdaten enhält. Diese werden mit <A HREF="#HAUS2_INITDATA">*_INIDATA</A>
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
; SEE ALSO: <A HREF="../#FACEIT">FaceIt</A>, <A HREF="#HAUS2_INITDATA">haus2_INITDATA</A> , <A HREF="../#WIDGET_SHOWIT">Widget_ShowIt</A> 
;           und IDL-Online-Hilfe über 'Widgets'.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  1999/09/02 14:38:19  thiel
;            Improved documentation.
;
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-


PRO haus2_INITDISPLAY, dataptr, displayptr, w_userbase

   Message, /INFO, "Initializing Display."


;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   ; Put your own Widgets here:

   ; Sliders for parameter selection:
   ; w_sliders is only an empty base which is later filled by a row of
   ; other widgets. It is the topmost widget in w_userbase. 
   W_Sliders = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_TOP)

   ; Neuron threshold parameter sliders:
   ; w_npar is also only a container, it is filled by a label widget (this
   ; contains text), and two sliders. Those are arranged in a column.
   W_npar = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_nparlabel = Widget_Label(W_npar, VALUE='Threshold of Neurons')

   W_nparvs = CW_FSLIDER2(W_npar, DRAG=0, $
                          MINIMUM=0., MAXIMUM=20., STEPWIDTH=0.1, VALUE=(*dataptr).prepara.vs, $
                          FORMAT='("V_s ",F4.1)' )

   W_npartaus = CW_FSLIDER2(W_npar, DRAG=0, $
                            MINIMUM=1, MAXIMUM=100, STEPWIDTH=1, VALUE=(*dataptr).prepara.taus, $
                            FORMAT='("tau_s/ms ",F4.0)' )

   ; External input parameter sliders:
   ; Another container, w_extinp, placed inside w_sliders, on the right of 
   ; w_npar (because w_sliders is a row). w_extinp also consists of a label
   ; and two sliders:
   W_extinp = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_extinplabel = Widget_Label(W_extinp, VALUE='External Input')

   W_extinpampl = CW_FSLIDER2(W_extinp, DRAG=0, $
                           MINIMUM=0., MAXIMUM=5., STEPWIDTH=0.1, VALUE=(*dataptr).extinpampl, $
                           FORMAT='("Amplitude ",F3.1)' )

   W_extinpperiod = CW_FSLIDER2(W_extinp, DRAG=0, $
                           MINIMUM=1, MAXIMUM=100, STEPWIDTH=1, VALUE=(*dataptr).extinpperiod, $
                           FORMAT='("Period/ms ",F4.0)' )

   ; Intra-layer Coupling slider:
   W_coupl = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_coupllabel = Widget_Label(W_coupl, VALUE='Intra-layer Coupling')

   W_couplampl = CW_FSLIDER2(W_coupl, DRAG=0, $
                           MINIMUM=0., MAXIMUM=20., STEPWIDTH=0.1, VALUE=(*dataptr).couplampl, $
                           FORMAT='("Amplitude ",F4.1,"/no. of neurons")')

   ; Graphs = Plots and Trainspottings:
   ; w_graphs is a big widget placed inside w_userbase and below w_sliders
   ; (remember that w_userbase is a column). w_graphs is a column too.
   W_graphs   = Widget_Base(W_UserBase, /COL, /BASE_ALIGN_CENTER)


   ; w_spikegraphs contains two ShowIt-Widgets arranged in a row.
   W_spikegraphs  = Widget_Base(W_graphs, /ROW, /BASE_ALIGN_CENTER, FRAME=2)

   
   ; 'spiketv' is a ShowIt-Widget that is to display the spikes occuring
   ; in the simulated network.
   spikestv  = Widget_ShowIT(W_spikegraphs, XSize=275, YSize=275, /PRIVATE_COLORS)
   ; 'spiktrain' will later contain a trainspottingsscope
   spiketrain  = Widget_ShowIT(W_spikegraphs, XSize=275, YSize=275, /PRIVATE_COLORS)

   ; Below the two spike-widgets theres enough space for a plotcilloscope:
   plotcillo = Widget_ShowIT(W_graphs, XSize=550, YSize=275, /PRIVATE_COLORS, FRAME=2)


   ; Now fill the (*displaptr)-struct with the IDs of all important widgets.
   ; It is not necessary to have the widgets here whose IDs won't be used 
   ; later. You have to include only those widgets that generate events
   ; or that are used to plot into them later. Normally you dont have to 
   ; include all those base-widgets.
   *displayptr = Create_Struct( *displayptr, $
      'W_nparvs', W_nparvs, $
      'W_npartaus', W_npartaus, $
      'W_extinpampl', W_extinpampl, $
      'W_extinpperiod', W_extinpperiod, $
      'W_couplampl', W_couplampl, $
      'spikestv' , spikestv, $
      'spiketrain', spiketrain, $
      'plotcillo', plotcillo $
   )


   ; By now, your Widget-Hierarchy should be complete and ready to be realized!

   SelectNASETable

   ; Now plot the first images inside the widgets:
   ; To do this, open the ShowIt-widgets and execute some graphic-routines:
   ; The first call to ShowIt_Open realizes the showit-widget, and because
   ; it is contained in your hierarchy, all other widgets are also immediately
   ; realized. At this point the whole FaceIt-Window becomes visible.

   ShowIt_Open, (*displayptr).spikestv
   preout = LayerSpikes((*dataptr).pre, /DIMENSIONS)
   PlotTVScl, /NASE, preout, TITLE="Spikes in Layer", PLOTCOL=255
   ShowIt_Close, (*displayptr).spikestv, SAVE_COLORS=1
   
   ; SAVE_COLORS=1 forces the active colortable to be saved together with this
   ; widget. If you do not change it later, the widget will keep this
   ; colortable from now on.


   ShowIt_Open, (*displayptr).spiketrain
   *displayptr = Create_Struct( *displayptr, $
      'tss', InitTrainspottingScope(NEURONS=(*dataptr).prew*(*dataptr).preh, $
                                    TIME=100, $
                                    TITLE='Spiketrains') $
   )
   ShowIt_Close, (*displayptr).spiketrain, SAVE_COLORS=1

   
   ShowIt_Open, (*displayptr).plotcillo
   *displayptr = Create_Struct( *displayptr, $
      'pcs', InitPlotcilloScope(RAYS=2, $
                                TIME=100, $
                                TITLE='Potential and threshold of center neuron') $
                     )
   ShowIt_Close, (*displayptr).plotcillo, SAVE_COLORS=1


;--- NO CHANGES NECESSARY BELOW THIS LINE.  :)

  
END ; haus2_INITDISPLAY 
