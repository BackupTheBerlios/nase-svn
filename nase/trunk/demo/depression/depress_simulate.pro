;+
; NAME: depress_simulate
;
; AIM: Module of depress.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/28 12:16:13  alshaikh
;           added AIM
;
;     Revision 1.1  1999/10/14 12:31:15  alshaikh
;           initial version
;
;
;-

FUNCTION depress_SIMULATE, dataptr

COMMON COMMON_random, seed 



inparr =  fltarr((*dataptr).prew*(*dataptr).preh)
syn_anzahl = (*dataptr).preh*(*dataptr).prew
r =  randomu(seed,syn_anzahl)

; zufaellige spikes der Frequenz 'frequency1' 
IF (*dataptr).mode EQ 1 THEN begin
   index_1 =  where ( r LT((*dataptr).frequency1/1000.0) ,c1)
   IF c1 GT 0 THEN inparr(index_1) = 1
   
; haelfte der spikes zufaellig (mit frq. frequency1). die frequenz der anderen haelfte variiert
; sinusfoermig um den mittelwert (frequency2)  
END ELSE IF (*dataptr).mode EQ 2 THEN BEGIN
   index_1 =  where ( r(0:(syn_anzahl/2-1)) LT $
                      (((*dataptr).frequency2/1000)+0.02*((sin(((*dataptr).counter*8.0*3.14159)/200.0)+1)/2)),c1)
   index_2 =  where ( r(syn_anzahl/2:syn_anzahl-1) LT $
                      ((*dataptr).frequency1/1000.0),c2)+syn_anzahl/2
   IF c1 GT 0 THEN inparr(index_1) = 1
   IF c2 GT 0 THEN inparr(index_2) = 1


;eine haelfte frequency1, die ander frequency2
END ELSE IF (*dataptr).mode EQ 3 THEN BEGIN
   index_1 =  where ( r(0:(syn_anzahl/2-1)) LT ((*dataptr).frequency1/1000.0),c1)
   index_2 =  where ( r((syn_anzahl/2):(syn_anzahl-1)) LT ((*dataptr).frequency2/1000.0),c2)
   index_2 = index_2+syn_anzahl/2 
   IF c1 GT 0 THEN inparr(index_1) = 1
   IF c2 GT 0 THEN inparr(index_2) = 1


;umgekehrt wie bei 3   
END ELSE IF (*dataptr).mode EQ 4 THEN BEGIN
   index_1 =  where ( r(0:(syn_anzahl/2-1)) LT ((*dataptr).frequency1/1000.0),c1)
   index_2 =  where ( r((syn_anzahl/2):(syn_anzahl-1)) LT ((*dataptr).frequency2/1000.0),c2)
   index_1 = index_1+syn_anzahl/2
   IF c1 GT 0 THEN inparr(index_1) = 1
   IF c2 GT 0 THEN inparr(index_2) = 1
end







   ; Make sparse version of external input:
   
   feed_in = Spassmacher(REFORM(inparr,(*dataptr).prew,(*dataptr).preh))

   ; Calculate feeding input from intra-layer-connections:
   
   feed_pre = DelayWeigh((*dataptr).CON_in_pre, LayerOut((*dataptr).in_layer))
   
      
   InputLayer, (*dataptr).in_layer, FEEDING=feed_in
   ProceedLayer, (*dataptr).in_layer
   
   InputLayer, (*dataptr).pre, FEEDING=feed_pre
   ProceedLayer, (*dataptr).pre


   ; Increment counter and reset if period is over:
   (*dataptr).counter = ((*dataptr).counter+1)
   
   ; Allow continuation of simulation:
   Return, 1 ; TRUE

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; depress_SIMULATE
