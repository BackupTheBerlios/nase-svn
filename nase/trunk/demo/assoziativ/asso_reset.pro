;+
; NAME: asso_reset
;
;
; AIM: Module of assoziativ.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;
;-
;     $Log$
;     Revision 1.3  2000/09/28 11:49:40  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 12:14:07  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:44  alshaikh
;           initial version
;
;
;
PRO asso_RESET, dataptr, displayptr

   asso_FreeData, dataptr
   (*dataptr) = Create_Struct({info : 'asso_data'})
   asso_InitData, dataptr

   asso_ResetSliders, dataptr, displayptr

Message, /INFO, "modul reset ausgefuehrt."
END ; asso_RESET 
