;+
; NAME: asso_resetsliders
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

PRO asso_RESETSLIDERS, dataptr, displayptr

   Widget_Control, (*displayptr).w_nkopplinhib, SET_VALUE=(*dataptr).kinhib
   Widget_Control, (*displayptr).w_nkopplfeed, SET_VALUE=(*dataptr).kfeed
 Widget_Control, (*displayptr).w_npartaus, SET_VALUE=(*dataptr).prepara2.taus
   Widget_Control, (*displayptr).w_nparvs, SET_VALUE=(*dataptr).prepara2.vs
 Widget_Control, (*displayptr).w_nparth0, SET_VALUE=(*dataptr).prepara2.th0
   Widget_Control, (*displayptr).w_patternnr, SET_VALUE=(*dataptr).pattern_number
  
    
END
