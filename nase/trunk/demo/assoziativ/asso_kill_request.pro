;+
; NAME: asso_kill_request
;
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:37:43  alshaikh
;           initial version
;
;
;-
FUNCTION asso_KILL_REQUEST, dataptr, displayptr
   Message, /INFO, "Cleaning up."
   ; Free NASE-structures in separate routine:
   asso_FreeData, dataptr
   Message, /INFO, "Finished!"
   ; Return 1 (TRUE) to allow destruction to be continued:
   Return, 1 
Message, /INFO, "modul kill request ausgefuehrt."
END 
