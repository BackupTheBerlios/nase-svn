;+
; NAME: depress_kill_request
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
;     Revision 1.1  1999/10/14 12:31:13  alshaikh
;           initial version
;
;
;-

FUNCTION depress_KILL_REQUEST, dataptr, displayptr

   Message, /INFO, "Cleaning up."

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   
   ; Free NASE-structures in separate routine:
   depress_FreeData, dataptr

   ; Free plotcilloscope and trainspottingscope
   FreePlotcilloscope, (*displayptr).pcs
   FreeTrainspottingscope, (*displayptr).tss_in
   FreeTrainspottingscope, (*displayptr).tss_out

   Message, /INFO, "Finished!"

   ; Return 1 (TRUE) to allow destruction to be continued:
   Return, 1 

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; depress_KILL_REQUEST
