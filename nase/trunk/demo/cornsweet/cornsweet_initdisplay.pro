;+
; NAME: cornsweet_initdisplay
;
;
; PURPOSE:
;
;
; CATEGORY:
;
;
; CALLING SEQUENCE:
;
; 
; INPUTS:
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/02/16 10:20:35  alshaikh
;           initial version
;
;
;-

PRO cornsweet_INITDISPLAY, dataptr, displayptr, w_userbase

   Message, /INFO, "Initializing Display."


;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   ; Put your own Widgets here:

   ; Sliders for parameter selection:
   ; w_sliders is only an empty base which is later filled by a row of
   ; other widgets. It is the topmost widget in w_userbase. 
   W_Sliders = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_TOP)

   W_linkpar = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_linkparlabel = Widget_Label(W_linkpar, VALUE='Linking Parameters')

   W_linkparRange = CW_FSLIDER2(W_linkpar, DRAG=0, $
                          MINIMUM=0, MAXIMUM=20, STEPWIDTH=1, VALUE=(*dataptr).linkparrange, $
                          FORMAT='("Range",F4.0)' )

   W_linkparAmpl = CW_FSLIDER2(W_linkpar, DRAG=0, $
                            MINIMUM=0, MAXIMUM=2, STEPWIDTH=0.01, VALUE=(*dataptr).linkparampl, $
                            FORMAT='("Strenght",F4.2)' )

  
   W_extinp = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_extinplabel = Widget_Label(W_extinp, VALUE='External Input')
   W_exttemp =  Widget_Base(W_extinp, /ROW, /BASE_ALIGN_CENTER, FRAME=2) 
   W_extinp1 = Widget_Base(W_exttemp, /COL, /BASE_ALIGN_CENTER, FRAME=2) 
   W_extinp2 = Widget_Base(W_exttemp, /COL, /BASE_ALIGN_CENTER, FRAME=2) 

   W_extinpampl = CW_FSLIDER2(W_extinp1, DRAG=0, $
                           MINIMUM=0., MAXIMUM=1., STEPWIDTH=0.01, VALUE=(*dataptr).extinpampl, $
                           FORMAT='("Amplitude ",F4.2)' )

   W_extinpOffset = CW_FSLIDER2(W_extinp1, DRAG=0, $
                           MINIMUM=0., MAXIMUM=1.0, STEPWIDTH=0.01, VALUE=(*dataptr).extinpoffset, $
                           FORMAT='("Offset",F4.2)' )

   W_extinpLeft = CW_FSLIDER2(W_extinp2, DRAG=0, $
                           MINIMUM=3, MAXIMUM=95, STEPWIDTH=1, VALUE=(*dataptr).extinpleft, $
                           FORMAT='("Position",F4.0)' )
   W_extinptau = CW_FSLIDER2(W_extinp2, DRAG=0, $
                           MINIMUM=1.0, MAXIMUM=40.0, STEPWIDTH=0.5, VALUE=(*dataptr).extinptau, $
                           FORMAT='("Exp. Backoff",F4.1)' )



  
   W_graphs   = Widget_Base(W_UserBase, /COL, /BASE_ALIGN_CENTER)


   ; w_spikegraphs contains two ShowIt-Widgets arranged in a row.
   W_spikegraphs  = Widget_Base(W_graphs, /ROW, /BASE_ALIGN_CENTER, FRAME=2)

   
  
   InPlot =  Widget_ShowIT(W_spikegraphs, XSize=250, YSize=200, /PRIVATE_COLORS)

 
   OutPlot =  Widget_ShowIT(W_spikegraphs, XSize=250, YSize=200, /PRIVATE_COLORS)

 
   trainschpott = Widget_ShowIT(W_graphs, XSize=500, YSize=200, /PRIVATE_COLORS, FRAME=2)

   ; Now fill the (*displaptr)-struct with the IDs of all important widgets.
   ; It is not necessary to have the widgets here whose IDs won't be used 
   ; later. You have to include only those widgets that generate events
   ; or that are used to plot into them later. Normally you dont have to 
   ; include all those base-widgets.
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'W_linkparrange', W_linkparrange, $
      'W_linkparampl', W_linkparampl, $
      'W_extinpampl', W_extinpampl, $
      'W_extinpoffset', W_extinpoffset, $
      'W_extinpleft', W_extinpleft, $
      'W_extinptau', W_extinptau, $

;      'W_couplampl', W_couplampl, $
      'inplot' , inplot, $
      'outplot', outplot, $
      'trainschpott', trainschpott $
   )


   ; By now, your Widget-Hierarchy should be complete and ready to be realized!

   SelectNASETable

   ; Now plot the first images inside the widgets:
   ; To do this, open the ShowIt-widgets and execute some graphic-routines:
   ; The first call to ShowIt_Open realizes the showit-widget, and because
   ; it is contained in your hierarchy, all other widgets are also immediately
   ; realized. At this point the whole FaceIt-Window becomes visible.

   

   ShowIt_Open, (*displayptr).inplot
  
   plot, (*dataptr).inpattern,title='Input Pattern'
   ShowIt_Close, (*displayptr).inplot, SAVE_COLORS=1
   
   ; SAVE_COLORS=1 forces the active colortable to be saved together with this
   ; widget. If you do not change it later, the widget will keep this
   ; colortable from now on.


   ShowIt_Open, (*displayptr).trainschpott
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'tss', InitTrainspottingScope(NEURONS=(*dataptr).length, $
                                    TIME=500, $
                                    TITLE='Spiketrains') $
   )
   ShowIt_Close, (*displayptr).trainschpott, SAVE_COLORS=1

 ShowIt_Open, (*displayptr).outplot
  
   plot, (*dataptr).outpattern,title='Mean Output Frequency [Hz]'
   ShowIt_Close, (*displayptr).outplot, SAVE_COLORS=1


 window,0,/Pixmap, XSize=250, YSize=200   
  

;--- NO CHANGES NECESSARY BELOW THIS LINE.  :)

  
END ; cornsweet_INITDISPLAY 
