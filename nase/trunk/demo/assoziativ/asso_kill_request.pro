;+
; NAME: asso_kill_request
;
;
; AIM: Module of assoziativ.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;-
;
;     $Log$
;     Revision 1.3  2000/09/28 11:49:39  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 12:14:07  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:43  alshaikh
;           initial version
;
;
;
FUNCTION asso_KILL_REQUEST, dataptr, displayptr
   Message, /INFO, "Cleaning up."
   ; Free NASE-structures in separate routine:
   asso_FreeData, dataptr
   Message, /INFO, "Finished!"
   ; Return 1 (TRUE) to allow destruction to be continued:
   Return, 1 
Message, /INFO, "modul kill request ausgefuehrt."
END 
