;+
; NAME:  cornsweet_reset
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
;     Revision 1.1  2000/02/16 10:20:36  alshaikh
;           initial version
;
;
;-

PRO cornsweet_RESET, dataptr, displayptr

;--- THE FOLLOWING WILL DO FINE IN MOST CASES.
;--- HOWEVER, IF THERE IS A MORE EFFICIENT WAY TO RESET
;--- YOUR SIMULATION, CHANGE IT. 

   cornsweet_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'cornsweet_data'})
   cornsweet_InitData, dataptr

   cornsweet_ResetSliders, dataptr, displayptr

;--- NO CHANGES NECESSARY BELOW THIS LINE.

END ; cornsweet_RESET 
