;+
; NAME: depress_display
;
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:31:11  alshaikh
;           initial version
;
;
;-

PRO depress_DISPLAY, dataptr, displayptr


   ; Trainspottingscope and Plotcilloscope:

; Spikes der Neuronen in Schicht 1   
   ShowIt_Open, (*displayptr).spiketrain_in
   TrainSpottingScope, (*displayptr).tss_in, LayerOut((*dataptr).in_layer)
   ShowIt_Close, (*displayptr).spiketrain_in, SAVE_COLORS=0

   layerdata,(*dataptr).pre,output=out, POTENTIAL=m, SCHWELLE=theta

; Spike von Neuron #3 in Schicht 2
   ShowIt_Open, (*displayptr).spiketrain_out
   TrainSpottingScope, (*displayptr).tss_out, out(3)
   ShowIt_Close, (*displayptr).spiketrain_out, SAVE_COLORS=0


; Potential und Schwelle von Neuron # 3
   ShowIt_Open, (*displayptr).plotcillo
   Plotcilloscope, (*displayptr).pcs, [m(3),theta(3)+(*dataptr).prepara.th0]
   ShowIt_Close, (*displayptr).plotcillo, SAVE_COLORS=0

END 
