;+
; NAME: depress_initdisplay
;
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:31:13  alshaikh
;           initial version
;
;
;-

PRO depress_INITDISPLAY, dataptr, displayptr, w_userbase

   Message, /INFO, "Initializing Display."


;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   ; Put your own Widgets here:




   ; Sliders for parameter selection:
   ; w_sliders is only an empty base which is later filled by a row of
   ; other widgets. It is the topmost widget in w_userbase. 
   W_Sliders = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_TOP)

 
   ; schieber fuer die Schwelle :
   W_npar = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=3) 

   W_nparlabel = Widget_Label(W_npar, VALUE='Schwellenparameter')

   W_nparvs = CW_FSLIDER2(W_npar, DRAG=0, $
                          MINIMUM=0., MAXIMUM=20., STEPWIDTH=0.1, VALUE=(*dataptr).prepara.vs, $
                          FORMAT='("V_s ",F4.1)' )

   W_npartaus = CW_FSLIDER2(W_npar, DRAG=0, $
                            MINIMUM=1, MAXIMUM=99, STEPWIDTH=1, VALUE=(*dataptr).prepara.taus, $
                            FORMAT='("tau_s/ms ",F4.1)' )
   
   W_nparth0 = CW_FSLIDER2(W_npar, DRAG=0, $
                            MINIMUM=0.0, MAXIMUM=200.0, STEPWIDTH=.1, VALUE=(*dataptr).prepara.th0, $
                            FORMAT='("theta_0/a.u.",F4.0)' )

  ; depression parameters
   
   W_ndepress = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_ndepresslabel = Widget_Label(W_ndepress, VALUE='Depression')
 
   W_ndepress_tau_rec = CW_FSLIDER2(W_ndepress, DRAG=0, $
                          MINIMUM=1, MAXIMUM=400, STEPWIDTH=1, VALUE=(*dataptr).tau_rec, $
                          FORMAT='("tau_rec/ms",F4.0)' )

   W_ndepress_u_se = CW_FSLIDER2(W_ndepress, DRAG=0, $
                            MINIMUM=0.0, MAXIMUM=1.0, STEPWIDTH=.1, VALUE=(*dataptr).U_se, $
                            FORMAT='("U_se",F4.1)' )

   ; noise
   W_nnoise = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=1) 

   W_nnoiselabel = Widget_Label(W_nnoise, VALUE='Rauschen')
 
   W_nnoise_sigma = CW_FSLIDER2(W_nnoise, DRAG=0, $
                          MINIMUM=0.0, MAXIMUM=0.1, STEPWIDTH=.01, VALUE=(*dataptr).prepara.sigma, $
                          FORMAT='("sigma",F4.2)' )

   ; excitation mode
   W_nmode = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=1) 

   W_nmodelabel = Widget_Label(W_nmode, VALUE='Anregungsmodus')
 
   W_nmode_mode = CW_FSLIDER2(W_nmode, DRAG=0, $
                          MINIMUM=1, MAXIMUM=4, STEPWIDTH=1, VALUE=(*dataptr).mode, $
                          FORMAT='("Modus",F4.0)' )



 ; external input
   W_nextern = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=1) 

   W_nexternlabel = Widget_Label(W_nextern, VALUE='Eingangs-Frequenzen')
 
   W_next_frq1 = CW_FSLIDER2(W_nextern, DRAG=0, $
                          MINIMUM=1, MAXIMUM=100, STEPWIDTH=1, VALUE=(*dataptr).frequency1, $
                          FORMAT='("f1/Hz",F4.0)' )
   W_next_frq2 = CW_FSLIDER2(W_nextern, DRAG=0, $
                          MINIMUM=1, MAXIMUM=100, STEPWIDTH=1, VALUE=(*dataptr).frequency2, $
                          FORMAT='("f2/Hz",F4.0)' )

  
   ; Graphs = Plots and Trainspottings:
   ; w_graphs is a big widget placed inside w_userbase and below w_sliders
   ; (remember that w_userbase is a column). w_graphs is a column too.
   W_graphs   = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_CENTER, FRAME= 2)


   ; 'spiktrain' will later contain a trainspottingsscopes
   spiketrain_in  = Widget_ShowIT(W_graphs, XSize=300, YSize=120, /PRIVATE_COLORS)
   spiketrain_out = Widget_ShowIT(W_graphs, XSize=300, YSize=120, /PRIVATE_COLORS)


   W_graphs2 =  Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_CENTER, FRAME= 1)

   ; Below the two spike-widgets theres enough space for a plotcilloscope:
   plotcillo = Widget_ShowIT(W_graphs2, XSize=600, YSize=200, /PRIVATE_COLORS, FRAME=2)


   ; Now fill the (*displaptr)-struct with the IDs of all important widgets.
   ; It is not necessary to have the widgets here whose IDs won't be used 
   ; later. You have to include only those widgets that generate events
   ; or that are used to plot into them later. Normally you dont have to 
   ; include all those base-widgets.
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'W_nparvs', W_nparvs, $
      'W_npartaus', W_npartaus, $
      'W_nparth0', W_nparth0, $                                
      'W_ndepress_tau_rec', W_ndepress_tau_rec, $
      'W_ndepress_u_se', W_ndepress_u_se, $
      'W_next_frq1', W_next_frq1, $
      'W_next_frq2', W_next_frq2, $
      'W_nnoise_sigma', W_nnoise_sigma, $
      'W_nmode_mode', W_nmode_mode, $
      'spiketrain_in' , spiketrain_in, $
      'spiketrain_out', spiketrain_out, $
      'plotcillo', plotcillo $
   )


   ; By now, your Widget-Hierarchy should be complete and ready to be realized!

   SelectNASETable

 

   ShowIt_Open, (*displayptr).spiketrain_in
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'tss_in', InitTrainspottingScope(NEURONS=(*dataptr).prew*(*dataptr).preh, $
                                    TIME=200, $
                                    TITLE='EXTERNAL INPUT') $
   )
   ShowIt_Close, (*displayptr).spiketrain_in, SAVE_COLORS=1


 ShowIt_Open, (*displayptr).spiketrain_out
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'tss_out', InitTrainspottingScope(NEURONS=1, /nonase, $
                                    TIME=200, $
                                    TITLE='OUTPUT') $
   )
   ShowIt_Close, (*displayptr).spiketrain_out, SAVE_COLORS=1

   
   ShowIt_Open, (*displayptr).plotcillo
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'pcs', InitPlotcilloScope(RAYS=2, SCALE=[0.1,0.3], $
                                TIME=300, $
                                TITLE='POT. AND THRESHOLD OF NEURON #3') $
                     )
   ShowIt_Close, (*displayptr).plotcillo, SAVE_COLORS=1


END ; depress_iNITDISPLAY 
