;+
; NAME: asso_display
;
; AIM: Module of assoziativ.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe assoziativ.pro
; AIM: Module of assoziativ.pro (aakkefkef:dfrfre)
;-
; PURPOSE: siehe <A>assoziativ</A> 
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.4  2000/09/28 11:34:10  alshaikh
;           AIM part II
;
;     Revision 1.3  2000/09/27 15:59:12  saam
;     service commit fixing several doc header violations
;
;     Revision 1.2  2000/09/27 12:14:06  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:41  alshaikh
;           initial version
;
;
;

PRO asso_DISPLAY, dataptr, displayptr

; Welches Muster liegt am Eingang an ????

case ((*dataptr).pattern_number) OF

  1: preinput = spassmacher(reform((*dataptr).muster1,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
  2: preinput = spassmacher(reform((*dataptr).muster2,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
  3: preinput = spassmacher(reform((*dataptr).muster3,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
  4: preinput = spassmacher(reform((*dataptr).muster1_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
  5: preinput = spassmacher(reform((*dataptr).muster2_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
  6: preinput = spassmacher(reform((*dataptr).muster3_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
  7: preinput = spassmacher(reform((*dataptr).muster4_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))

 
 ELSE: preinput = spassmacher(reform((*dataptr).muster1,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
 ENDCASE

; im folgenden wird nur gezeichnet, wenn sich wirklich etwas veraendert hat :

; Ausgabe der Assoziativspeicher-Eingangs :

 IF NOT (((*dataptr).pattern_number) EQ ((*dataptr).last_pattern)) THEN BEGIN
    ShowIt_Open, (*displayptr).inputwid
    PlotTVScl, /NASE, SETCOL=0, reform(spassbeiseite(preinput),10,10),TITLE="Eingang", $
     charsize=0.02,PLOTCOL=255
    ShowIt_Close, (*displayptr).inputwid, SAVE_COLORS=0
    (*dataptr).last_pattern = (*dataptr).pattern_number
 ENDIF                        

; Ausgangsschicht des Assoziativspeichers
 layerdata, (*dataptr).l2,output=out
 preout = out
 IF NOT A_EQ(preout,(*dataptr).lastout) THEN BEGIN
    ShowIt_Open, (*displayptr).outputwid
    
PlotTVScl, /NASE, SETCOL=0, preout, TITLE="Ausgang",charsize=0.02, PLOTCOL=255
    ShowIt_Close, (*displayptr).outputwid, SAVE_COLORS=0
    (*dataptr).lastout = preout
 ENDIF
  
 ;Plotcilloskop
 ShowIt_Open, (*displayptr).left_spikewid
   LayerData, (*dataptr).l2, POTENTIAL=m, SCHWELLE=theta
   position = ((*dataptr).spike_pos((*dataptr).pattern_number-1))
   Plotcilloscope, (*displayptr).pcs1, [m(position),theta(position)+(*dataptr).prepara2.th0]
   ShowIt_Close, (*displayptr).left_spikewid, SAVE_COLORS=0


ShowIt_Open, (*displayptr).right_spikewid
   LayerData, (*dataptr).l2, POTENTIAL=m, SCHWELLE=theta
   position = 64 ;((*dataptr).spike_pos((*dataptr).pattern_number-1))
   Plotcilloscope, (*displayptr).pcs2, [m(position),theta(position)+(*dataptr).prepara2.th0]
   ShowIt_Close, (*displayptr).right_spikewid, SAVE_COLORS=0




END
