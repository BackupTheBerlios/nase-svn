;+
; NAME: asso_resetsliders
;
;
; AIM: Module of assoziativ.pro  (see also  <A>faceit</A>)
;
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;-
;
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

PRO asso_RESETSLIDERS, dataptr, displayptr

   Widget_Control, (*displayptr).w_nkopplinhib, SET_VALUE=(*dataptr).kinhib
   Widget_Control, (*displayptr).w_nkopplfeed, SET_VALUE=(*dataptr).kfeed
 Widget_Control, (*displayptr).w_npartaus, SET_VALUE=(*dataptr).prepara2.taus
   Widget_Control, (*displayptr).w_nparvs, SET_VALUE=(*dataptr).prepara2.vs
 Widget_Control, (*displayptr).w_nparth0, SET_VALUE=(*dataptr).prepara2.th0
   Widget_Control, (*displayptr).w_patternnr, SET_VALUE=(*dataptr).pattern_number
  
    
END
