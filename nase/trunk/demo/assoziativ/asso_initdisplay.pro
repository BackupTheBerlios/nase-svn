;+
; NAME: asso_initdisplay
;
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:37:43  alshaikh
;           initial version
;
;
;-
PRO asso_INITDISPLAY, dataptr, displayptr, w_userbase
 
 
W_Title = Widget_Base(W_UserBase, /COL, /BASE_ALIGN_TOP)

W_ntitle1 =  Widget_Label(W_Title, VALUE='Demonstrationsprogramm zur Funktionsweise eines Assoziativspeichers')
W_ntitle2 =  Widget_Label(W_Title, VALUE='Es wurden 3 Muster gelernt...') 
 


; Definiert den Bereich fuer die Widgets, welche mit Schieberegler steuerbar sind
   W_Sliders = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_CENTER)  

; Feeding- und Inhibitionsstaerke der Speicher-Neuronen   
   W_ncoup = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=2) 
   W_ncouplabel = Widget_Label(W_ncoup, VALUE='Kopplungsstaerken')
   W_nkopplinhib = CW_FSLIDER2(W_ncoup, DRAG=0, $
                          MINIMUM=0.01, MAXIMUM=3, STEPWIDTH=0.01, VALUE=(*dataptr).kinhib, $
                          FORMAT='("Inhibition ",F4.2)' )
   W_nkopplfeed = CW_FSLIDER2(W_ncoup, DRAG=0, $
                            MINIMUM=0.1, MAXIMUM=4, STEPWIDTH=0.1, VALUE=(*dataptr).kfeed, $
                            FORMAT='("Feeding ",F4.1)' )



; Neuronen-Parameter Sliders
W_npar = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME=3)
W_nparlabel = Widget_Label(W_npar, VALUE='Schwellenparameter')
W_nparvs = CW_FSLIDER2(W_npar, DRAG=0, $
			MINIMUM=0., MAXIMUM=20., STEPWIDTH=0.1, VALUE=(*dataptr).prepara2.vs, $
			FORMAT='("Verstaerkung V_s/ms ",F4.1)' )


W_npartaus = CW_FSLIDER2(W_npar, DRAG=0, $
			MINIMUM=1., MAXIMUM=80., STEPWIDTH=1, VALUE=(*dataptr).prepara2.taus, $
			FORMAT='("Zeitkonstante tau_s/ms ",F4.1)' )


W_nparth0 = CW_FSLIDER2(W_npar, DRAG=0, $
			MINIMUM=0., MAXIMUM=2., STEPWIDTH=.1, VALUE=(*dataptr).prepara2.th0, $
			FORMAT='("Ruheschwelle theta_0/ms ",F4.1)' )



; Wahl des vorgegebenen Musters

W_pattern = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME =3)
W_patternlabel = Widget_Label(W_pattern, VALUE='Mustervorgabe')
W_patternnr = CW_FSLIDER2(W_pattern, DRAG=0, $
			MINIMUM=1, MAXIMUM=7, STEPWIDTH=1, VALUE=(*dataptr).pattern_number, $
			FORMAT='("Muster",F4.1)' )





; Anzeige der gelernten Muster
W_learned = Widget_Base(W_Sliders, /COL, /BASE_ALIGN_CENTER, FRAME =3)
W_learnedlabel = Widget_Label(W_learned, VALUE='Gelernte Muster')
w_muster1  = Widget_ShowIT(W_learned,XSize=50, YSize=50, /PRIVATE_COLORS)
w_muster2  = Widget_ShowIT(W_learned,XSize=50, YSize=50, /PRIVATE_COLORS)
w_muster3  = Widget_ShowIT(W_learned,XSize=50, YSize=50, /PRIVATE_COLORS)



 
W_graphs   = Widget_Base(W_UserBase, /ROW, /BASE_ALIGN_CENTER)
W_inhaltgraphs  = Widget_Base(W_graphs, /ROW, /BASE_ALIGN_CENTER, FRAME=2)

left_wid =  widget_base(W_inhaltgraphs, /COL, /BASE_ALIGN_TOP)
right_wid =  widget_base(W_inhaltgraphs, /COL, /BASE_ALIGN_TOP)


W_lefttitle = Widget_label(left_wid,VALUE='Eingangssignal')
inputwid  = Widget_ShowIT(left_wid, XSize=80, YSize=80, /PRIVATE_COLORS)
W_righttitle = Widget_label(right_wid,VALUE='Ausgangssignal')
outputwid  = Widget_ShowIT(right_wid, XSize=80, YSize=80, /PRIVATE_COLORS)

W_spikegraphs = Widget_Base(W_userbase, /COL, /BASE_ALIGN_CENTER)
W_inhaltspike = Widget_Base(W_graphs, /ROW, /BASE_ALIGN_CENTER, FRAME=2)
left_spike_wid =  widget_base(W_inhaltgraphs, /COL, /BASE_ALIGN_TOP)
right_spike_wid =  widget_base(W_inhaltgraphs, /COL, /BASE_ALIGN_TOP)


W_left_spike_title = Widget_label(left_spike_wid,VALUE='Potential und Schwelle (Neuron #1)')
left_spikewid  = Widget_ShowIT(left_spike_wid, XSize=200, YSize=150, /PRIVATE_COLORS)
W_right_spike_title = Widget_label(right_spike_wid,VALUE='Potential und Schwelle (Neuron #2)')
right_spikewid  = Widget_ShowIT(right_spike_wid, XSize=200, YSize=150, /PRIVATE_COLORS)



*displayptr = Create_Struct( TEMPORARY(*displayptr), $
                             'inputwid', inputwid, $
                             'outputwid', outputwid, $
                             'left_spikewid', left_spikewid, $
                             'right_spikewid', right_spikewid, $
                             'w_muster1', w_muster1, $
                             'w_muster2', w_muster2, $
                             'w_muster3', w_muster3, $
                             


                                ; 'feedwid', feedwid, $
'W_nkopplinhib',W_nkopplinhib, $
 'W_nkopplfeed',W_nkopplfeed, $
 'W_nparvs', W_nparvs, $
 'W_npartaus', W_npartaus, $
 'W_nparth0', W_nparth0, $
 'W_patternnr', W_patternnr $


               )

   SelectNASETable
 ; Now plot the first images inside the widgets:
   
   ShowIt_Open, (*displayptr).inputwid
   preout = LayerSpikes((*dataptr).l1, /DIMENSIONS)
   PlotTVScl, /NASE, preout, TITLE="", charsize=0.1, PLOTCOL=255
   ShowIt_Close, (*displayptr).inputwid, SAVE_COLORS=1
   
   ShowIt_Open, (*displayptr).outputwid
   preinput = LayerSpikes((*dataptr).l2, /DIMENSIONS)
   PlotTVScl, /NASE, preinput, TITLE="", charsize=0.1, PLOTCOL=255
   ShowIt_Close, (*displayptr).outputwid, SAVE_COLORS=1

   ShowIt_Open, (*displayptr).w_muster1
   PlotTVScl, /NASE, (*dataptr).muster1, TITLE="", charsize=0.1, PLOTCOL=255
   ShowIt_Close, (*displayptr).w_muster1, SAVE_COLORS=1

 ShowIt_Open, (*displayptr).w_muster2
 PlotTVScl, /NASE, (*dataptr).muster2, TITLE="", charsize=0.1, PLOTCOL=255
 ShowIt_Close, (*displayptr).w_muster2, SAVE_COLORS=1
 
 ShowIt_Open, (*displayptr).w_muster3
 PlotTVScl, /NASE, (*dataptr).muster3, TITLE="", charsize=0.1, PLOTCOL=255
 ShowIt_Close, (*displayptr).w_muster3, SAVE_COLORS=1


 ShowIt_Open, (*displayptr).left_spikewid
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'pcs1', InitPlotcilloScope(RAYS=2, $
                                TIME=50, YMIN=0,SCALE=[0.1,0.3], $
                                TITLE='') $
                     )
   ShowIt_Close, (*displayptr).left_spikewid, SAVE_COLORS=1

  ShowIt_Close, (*displayptr).right_spikewid, SAVE_COLORS=1
 ShowIt_Open, (*displayptr).right_spikewid
   *displayptr = Create_Struct( TEMPORARY(*displayptr), $
      'pcs2', InitPlotcilloScope(RAYS=2, $
                                TIME=50, SCALE=[0.1,0.3], $
                                TITLE='') $
                     )
   ShowIt_Close, (*displayptr).right_spikewid, SAVE_COLORS=1



END ; asso_iNITDISPLAY 
