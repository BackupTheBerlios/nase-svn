;+
; NAME: asso_reset
;
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:37:44  alshaikh
;           initial version
;
;
;-
PRO asso_RESET, dataptr, displayptr

   asso_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'asso_data'})
   asso_InitData, dataptr

   asso_ResetSliders, dataptr, displayptr

Message, /INFO, "modul reset ausgefuehrt."
END ; asso_RESET 
