;+
; NAME: depress_reset
;
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:31:14  alshaikh
;           initial version
;
;
;-

PRO depress_RESET, dataptr, displayptr

;--- THE FOLLOWING WILL DO FINE IN MOST CASES.
;--- HOWEVER, IF THERE IS A MORE EFFICIENT WAY TO RESET
;--- YOUR SIMULATION, CHANGE IT. 

   depress_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'depress_data'})
   depress_InitData, dataptr

   depress_ResetSliders, dataptr, displayptr

;--- NO CHANGES NECESSARY BELOW THIS LINE.

END ; depress_RESET 
