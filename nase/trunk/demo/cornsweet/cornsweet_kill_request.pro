;+
; NAME: cornsweet_kill_request
;
;; AIM : Module of cornsweet.pro (see also: FaceIt)
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
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/27 15:08:05  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:36  alshaikh
;           initial version
;
;
;

FUNCTION cornsweet_KILL_REQUEST, dataptr, displayptr

   Message, /INFO, "Cleaning up."

;--- CHANGE THE FOLLOWING PART TO BUILD YOUR OWN SIUMLATION: 
   
   ; Free NASE-structures in separate routine:
   cornsweet_FreeData, dataptr

  
   FreeTrainspottingscope, (*displayptr).tss

   Message, /INFO, "Finished!"

   ; Return 1 (TRUE) to allow destruction to be continued:
   Return, 1 

;--- NO CHANGES NECESSARY BELOW THIS LINE.


END ; cornsweet_KILL_REQUEST
