;+
; NAME: haus2_INITDISPLAY
;
; PURPOSE: Teilprogramm zur Demonstration der Beutzung von <A HREF="#FACEIT">FaceIt</A>.
;          *_INITDISPLAY dient der Initialisierung der graphischen Darstellung
;          einer Simulation. Hier wird festegelgt, welche Widgets wie 
;          positioniert werden.
;          
;          Zum Aufbau einer eigenen Simulation empfiehlt es sich, diese Routine
;          zu kopieren, den haus2-Teil des Namens durch den der eigenen
;          Simulation zu ersetzen und die Routine nach den eigenen Wünschen 
;          abzuwandeln.
;
; CATEGORY: SIMULATION / FACEIT
;
; CALLING SEQUENCE: haus2_INITDISPLAY, dataptr, displayptr, W_UserBase
;
; INPUTS: dataptr : Ein Pointer auf eine Struktur, die alle notwendigen
;                   Simulationsdaten enhält. Diese werden mit <A HREF="'HAUS"_INITDATA">*_INIDATA</A>
;                   festgelegt.
;         displayptr : Ein Pointer auf eine Struktur, die die graphischen 
;                      Elemente (Widgets) der Simulation enthält. Dieser wird
;                      von <A HREF="#FACEIT">FaceIt</A> geliefert. Art der benutzten Widgets und 
;                      Reihenfolge des Aufrufs bestimmen über das Aussehen der 
;                      fertigen graphischen Oberfläche. Zum Vorgehen dabei
;                      siehe den Programmtext.
;         w_userbase : Das von <A HREF="#FACEIT">FaceIt</A> zur Verfügung gestellte Parent-Widget, das
;                      alle anderen benutzereigenen Widgets aufnimmt.
;
; (SIDE) EFFECTS: *displayptr sollte nach dem Durchlauf von *_INITDISPLAY die
;                 Widget-IDs aller graphischen Elemente enthalten.
;
; RESTRICTIONS: Die Benutzung der gesamten FaceIt-Architektur ist erst ab 
;               IDL 5 möglich. 
;
; EXAMPLE: Siehe Programmtext.
;
; SEE ALSO: FaceIt, haus2_INITDATA 
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1999/09/01 16:46:31  thiel
;            Moved in repository.
;
;        Revision 1.1  1999/09/01 13:38:10  thiel
;            First version of FaceIt-Demo-Routines. Doku not yet complete.
;
;-


PRO haus2_INITDISPLAY, dataptr, displayptr, W_UserBase

   ;--- Init display:
   Message, /INFO, "Initializing Display."


   ;--- Sliders for parameter selection:
   W_Sliders = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_TOP)

   ;--- Neuron threshold parameter sliders:
   W_npar = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_nparlabel = Widget_Label(W_npar, VALUE='Threshold of Neurons')

   W_nparvs = CW_FSLIDER2(W_npar, DRAG=0, $
                          MINIMUM=0., MAXIMUM=20., STEPWIDTH=0.1, VALUE=(*dataptr).prepara.vs, $
                          FORMAT='("V_s ",F4.1)' )

   W_npartaus = CW_FSLIDER2(W_npar, DRAG=0, $
                            MINIMUM=1, MAXIMUM=100, STEPWIDTH=1, VALUE=(*dataptr).prepara.taus, $
                            FORMAT='("tau_s/ms ",F4.0)' )

   ;--- External input parameter sliders:
   W_extinp = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_extinplabel = Widget_Label(W_extinp, VALUE='External Input')

   W_extinpampl = CW_FSLIDER2(W_extinp, DRAG=0, $
                           MINIMUM=0., MAXIMUM=5., STEPWIDTH=0.1, VALUE=(*dataptr).extinpampl, $
                           FORMAT='("Amplitude ",F3.1)' )

   W_extinpperiod = CW_FSLIDER2(W_extinp, DRAG=0, $
                           MINIMUM=1, MAXIMUM=100, STEPWIDTH=1, VALUE=(*dataptr).extinpperiod, $
                           FORMAT='("Period/ms ",F4.0)' )

   ;--- Intra-layer Coupling slider:
   W_coupl = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_coupllabel = Widget_Label(W_coupl, VALUE='Intra-layer Coupling')

   W_couplampl = CW_FSLIDER2(W_coupl, DRAG=0, $
                           MINIMUM=0., MAXIMUM=20., STEPWIDTH=0.1, VALUE=(*dataptr).couplampl, $
                           FORMAT='("Amplitude ",F4.1,"/no. of neurons")')

   ;--- Graphs = Plots and Trainspottings:
   W_graphs   = Widget_Base(W_UserBase, /COL, /BASE_ALIGN_CENTER)

   W_spikegraphs  = Widget_Base(W_graphs, /ROW, /BASE_ALIGN_CENTER, FRAME=2)

   spikestv  = Widget_ShowIT(W_spikegraphs, XSize=275, YSize=275, /PRIVATE_COLORS)
   spiketrain  = Widget_ShowIT(W_spikegraphs, XSize=275, YSize=275, /PRIVATE_COLORS)

   plotcillo = Widget_ShowIT(W_graphs, XSize=550, YSize=275, /PRIVATE_COLORS, FRAME=2)


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


   SelectNASETable

   ShowIt_Open, (*displayptr).spikestv
   preout = LayerSpikes((*dataptr).pre, /DIMENSIONS)
   PlotTVScl, /NASE, preout, TITLE="Spikes in Layer", PLOTCOL=255
   ShowIt_Close, (*displayptr).spikestv, SAVE_COLORS=1


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


  
END ; haus2_INITDISPLAY 
