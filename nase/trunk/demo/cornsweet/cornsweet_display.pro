;+
; NAME:  cornsweet_display
;
; AIM : Module of cornsweet.pro (see also: FaceIt)
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
;-
;
;     $Log$
;     Revision 1.2  2000/09/27 15:08:03  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:34  alshaikh
;           initial version
;
;
;

PRO cornsweet_DISPLAY, dataptr, displayptr

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 


LayerData, (*dataptr).pre, OUTPUT=out
(*dataptr).outpattern = (*dataptr).outpattern+out

      wset,0
       plot, (*dataptr).inpattern,title='Input Pattern'
       oplot, indgen((*dataptr).length)*0+(*dataptr).inpattern((*dataptr).length/2),linestyle=1
       ShowIt_Open, (*displayptr).inplot  
       Device,Copy=[0,0,250,200,0,0,0]
      ShowIt_Close, (*displayptr).inplot, SAVE_COLORS=0
 
what_to_plot = (*dataptr).outpattern/((*dataptr).passedtime > 1.0)*1000.0

wset,0
plot, what_to_plot,title='Mean Output Frequency [Hz]'
 oplot, indgen((*dataptr).length)*0+what_to_plot((*dataptr).length/2),linestyle=1 
ShowIt_Open, (*displayptr).outplot 
Device,Copy=[0,0,250,200,0,0,0]
 ShowIt_Close, (*displayptr).outplot, SAVE_COLORS=0

   ; Trainspottingscope and Plotcilloscope: 
   ShowIt_Open, (*displayptr).trainschpott
   TrainSpottingScope, (*displayptr).tss, LayerOut((*dataptr).pre)
   ShowIt_Close, (*displayptr).trainschpott, SAVE_COLORS=0


;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; cornsweet_DISPLAY
