

FUNCTION asso_SIMULATE, dataptr


   
case ((*dataptr).pattern_number) OF

   1: I_l1_f = spassmacher(reform((*dataptr).muster1,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
   2: I_l1_f = spassmacher(reform((*dataptr).muster2,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
   3: I_l1_f = spassmacher(reform((*dataptr).muster3,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
   4: I_l1_f = spassmacher(reform((*dataptr).muster1_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
   5: I_l1_f = spassmacher(reform((*dataptr).muster2_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
   6: I_l1_f = spassmacher(reform((*dataptr).muster3_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
   7: I_l1_f = spassmacher(reform((*dataptr).muster4_e,(*dataptr).anz_neuro*(*dataptr).anz_neuro))

 ELSE : I_l1_f = spassmacher(reform((*dataptr).muster1,(*dataptr).anz_neuro*(*dataptr).anz_neuro))
 ENDCASE


I_l1_l =  Delayweigh((*dataptr).con_inp_inp, layerout((*dataptr).l1))
I_l2_f1 = Delayweigh((*dataptr).con_inp_asso, layerout((*dataptr).l1))
I_l2_f2 = Delayweigh((*dataptr).con_asso_asso_feed, layerout((*dataptr).l2))
I_l2_i =  Delayweigh((*dataptr).con_asso_asso_inhib, layerout((*dataptr).l2))


inputlayer, (*dataptr).l1, feeding=I_l1_f, linking=I_l1_l
inputlayer, (*dataptr).l2, feeding=I_l2_f1, inhibition=I_l2_i
inputlayer, (*dataptr).l2, feeding=I_l2_f2
proceedlayer, (*dataptr).l1
proceedlayer, (*dataptr).l2

   
   ; Increment counter and reset if period is over:
   (*dataptr).counter = ((*dataptr).counter+1) ; mod (*dataptr).extinpperiod
   
   ; Allow continuation of simulation:
   Return, 1 ; TRUE

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; asso_SIMULATE
