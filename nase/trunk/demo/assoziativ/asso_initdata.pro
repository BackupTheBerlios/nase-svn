;+
; NAME: asso_initdata
;
;
; AIM: Module of assoziativ.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe assoziativ.pro
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.3  2000/09/28 11:49:39  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 12:14:07  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:42  alshaikh
;           initial version
;
;
;
PRO asso_INITDATA, dataptr


; alle verwendeten muster...
; muster 1-3 werden gelernt
; muster 1-3 und 1_e bis 4_e koennen praesentiert werden

muster0 =  [  [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0] ]

muster1 =  [  [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,1,0,0,0,0,0], $
              [0,0,0,1,0,1,0,0,0,0], $
              [0,0,1,0,0,0,1,0,0,0], $
              [0,1,0,0,0,0,0,1,0,0], $
              [1,1,1,1,1,1,1,1,1,0], $
              [0,0,0,0,0,0,0,0,0,0] ]

muster2 =  [  [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [1,1,1,1,1,1,1,1,1,0], $
              [1,0,0,0,0,0,0,0,1,0], $
              [1,0,0,0,0,0,0,0,1,0], $
              [1,0,0,0,0,0,0,0,1,0], $
              [1,0,0,0,0,0,0,0,1,0], $
              [1,0,0,0,0,0,0,0,1,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0] ]

muster3 =  [  [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,1,0,0,0,0,0], $
              [0,0,0,1,1,1,0,0,0,0], $
              [0,0,1,1,1,1,1,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0], $
              [0,0,0,0,0,0,0,0,0,0] ]


muster1_e =  [  [1,0,0,0,0,0,0,0,0,1], $
                [0,0,0,0,0,1,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,1,0,0,0,0,0], $
                [0,0,0,0,0,1,0,0,0,0], $
                [0,0,0,0,0,0,1,0,0,0], $
                [0,1,0,0,0,0,0,1,0,0], $
                [1,1,1,1,1,0,1,1,1,0], $
                [0,0,0,0,0,0,0,0,0,0] ]

muster2_e =  [  [0,0,0,0,0,1,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,1,1,1,1,1,0], $
                [0,0,0,0,0,0,0,0,1,0], $
                [1,0,0,0,0,0,0,0,1,0], $
                [1,0,0,0,0,0,0,0,1,0], $
                [1,0,0,0,1,0,0,0,0,0], $
                [1,0,0,0,0,0,0,0,1,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0] ]

muster3_e =  [  [0,0,1,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,1,0,0,0,0,0], $
                [0,0,0,1,0,1,0,0,0,0], $
                [0,0,1,1,1,1,1,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,1,0] ]


muster4_e =  [  [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,0,0,0,0,0,0], $
                [0,0,0,0,1,0,0,0,0,0], $
                [0,0,0,1,1,1,0,0,0,0], $
                [0,0,1,1,1,1,1,0,0,0], $
                [0,1,1,1,1,1,1,1,0,0], $
                [1,1,1,1,1,1,1,1,1,0], $
                [0,0,0,0,0,0,0,0,0,0] ]



      *dataptr = Create_Struct(TEMPORARY(*dataptr), $
                            'anz_neuro' , 10, $, ; width and height of neuron layer
                            'extinpampl' , 1.1, $ ; amplitude of external input
                            'durchl',100,$ ; anzahl der Durchlaeufe
                            'counter' , 0l,$ ; counter for determining elapsed time
                            'kinhib',1., $ ; Kopplungsstaerke - Inhibition
                            'kfeed',1., $ ; Kopplungsstaerke - Feeding
                            'pattern_number',1, $ ; Nummer des aktuellen Vorgabe-Patterns    
                            'muster1', muster1, $ ; muster allen routinen zur verfuegung
                            'muster2', muster2, $ ; stellen !!!
                            'muster3', muster3, $
                            'muster1_e', muster1_e, $
                            'muster2_e', muster2_e, $
                            'muster3_e', muster3_e, $
                            'muster4_e', muster4_e, $
                            'spike_pos', [44,21,64,44,26,63,44] $
                                                         
      )

; eingangs-neuronenschicht   
   *dataptr = Create_Struct( TEMPORARY(*dataptr), $
                             'prepara1', InitPara_1(tauf=1.0, taul=1.0,taui=1.0,Vs=10.0, $
                                                    taus=5.,th0=0.2,sigma=0.00) )

; speicher-neuronenschicht   
   *dataptr = Create_Struct( TEMPORARY(*dataptr), $
                             'prepara2', InitPara_1(tauf=1.0, taul=1.0,taui=1.0,Vs=10.3, $
                                                    taus=3.0,th0=0.4,sigma=0.01) )

   *dataptr = Create_Struct( *dataptr, $
                             'l1', InitLayer(WIDTH=(*dataptr).anz_neuro, HEIGHT=(*dataptr).anz_neuro, $
                                             TYPE=(*dataptr).prepara1), $
                             
   'l2', InitLayer(WIDTH=(*dataptr).anz_neuro, HEIGHT=(*dataptr).anz_neuro, $
                   TYPE=(*dataptr).prepara2), $
    
; the output of the layer in the previous timestep:
   'lastout', LonArr((*dataptr).anz_neuro,(*dataptr).anz_neuro), $               
    'lastfeed', LonArr((*dataptr).anz_neuro,(*dataptr).anz_neuro), $                
    'lastinput', LonArr((*dataptr).anz_neuro,(*dataptr).anz_neuro), $               
    'I_l1_f_const' , spassmacher(reform(muster1,((*dataptr).anz_neuro*(*dataptr).anz_neuro))), $ 
    'last_pattern',99 $
    ) 
   
   
   ; and a DW-structure for inp-inp-layer coupling:
   *dataptr = Create_Struct( *dataptr, $ 
                             'CON_inp_inp', InitDW(S_LAYER=(*dataptr).l1, T_LAYER=(*dataptr).l1, $
                                                   w_const=[0,4],/w_truncate,/w_nonself,nocon=4)  )
   
   ; and a DW-structure for inp-asso coupling:
   *dataptr = Create_Struct( *dataptr, $
                             'CON_inp_asso', InitDW(S_LAYER=(*dataptr).l1, T_LAYER=(*dataptr).l2, $
                                                    w_const=[1,1],/w_truncate,nocon=0)  )
   
   
   ; and a DW-structure for asso-asso coupling:
   *dataptr = Create_Struct( *dataptr, $
                             'CON_asso_asso_feed', InitDW(S_LAYER=(*dataptr).l2, T_LAYER=(*dataptr).l2, $
                                                          weight=0.0001) )
   
   *dataptr = Create_Struct( *dataptr, $
                             'CON_asso_asso_inhib', InitDW(S_LAYER=(*dataptr).l2, T_LAYER=(*dataptr).l2, $
                                                           weight=0.1) )       


; lernen ...
Message, /INFO, "-Lernen der vorgegebenen Muster."

rec = initrecall(height=(*dataptr).anz_neuro,width=(*dataptr).anz_neuro,EXPO=[5.0, 1])

FOR steps=1,5 DO BEGIN          ; Anzahl der Lerndurchlaeufe
   FOR n=0,400 DO BEGIN
      
      IF n LT 120 THEN I_l1_f= $
       spassmacher(reform((*dataptr).muster1,((*dataptr).anz_neuro*(*dataptr).anz_neuro)))
      
      IF ((n GT  120) AND (n LT 230)) THEN I_l1_f = $
       spassmacher(reform((*dataptr).muster2,(((*dataptr).anz_neuro)*((*dataptr).anz_neuro))))
      
      IF (n gt 230) THEN I_l1_f = $
       spassmacher(reform((*dataptr).muster3,((*dataptr).anz_neuro*(*dataptr).anz_neuro)))
      
      
      I_l1_l  =  Delayweigh((*dataptr).con_inp_inp, layerout((*dataptr).l1))
      I_l2_f1 =  Delayweigh((*dataptr).con_inp_asso, layerout((*dataptr).l1))
      I_l2_f2 =  Delayweigh((*dataptr).con_asso_asso_feed, layerout((*dataptr).l2))
      I_l2_i  =  Delayweigh((*dataptr).con_asso_asso_inhib, layerout((*dataptr).l2))
      
      totalrecall,rec,(*dataptr).con_asso_asso_feed
      learnhebblp, (*dataptr).con_asso_asso_feed, rec, target_cl=(*dataptr).l2, rate=0.01, alpha=0.10  
      inputlayer, (*dataptr).l1, feeding=I_l1_f, linking= I_l1_l
      proceedlayer, (*dataptr).l1
      
      inputlayer, (*dataptr).l2, feeding=I_l2_f1, inhibition=I_l2_i
      inputlayer, (*dataptr).l2, feeding=I_l2_f2
      proceedlayer, (*dataptr).l2
   ENDFOR
ENDFOR


wtmp = Weights((*dataptr).CON_asso_asso_feed)
maximum = max (wtmp)
wtmp = wtmp / maximum * 1.7     ; zum starten ein guter Wert ;-)
SetWeights, (*dataptr).CON_asso_asso_feed, wtmp, /NO_INIT


; aktuelles minimum und maximum der verbindnungsmatritzen bestimmen

(*dataptr).kfeed = max (Weights((*dataptr).CON_asso_asso_feed))
(*dataptr).kinhib = max (Weights((*dataptr).CON_asso_asso_inhib))





END
