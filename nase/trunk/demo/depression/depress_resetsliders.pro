;+
; NAME: depress_resetsliders
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

PRO depress_RESETSLIDERS, dataptr, displayptr
print,'resetsliders'
   Widget_Control, (*displayptr).w_nparvs, SET_VALUE=(*dataptr).prepara.vs
   Widget_Control, (*displayptr).w_npartaus, SET_VALUE=(*dataptr).prepara.taus
   Widget_Control, (*displayptr).w_nparth0, SET_VALUE=(*dataptr).prepara.th0
   Widget_Control, (*displayptr).w_ndepress_tau_rec, SET_VALUE=(*dataptr).tau_rec
   Widget_Control, (*displayptr).w_ndepress_U_se, SET_VALUE=(*dataptr).U_se
   Widget_Control, (*displayptr).w_next_frq1, SET_VALUE=(*dataptr).frequency1
   Widget_Control, (*displayptr).w_next_frq2, SET_VALUE=(*dataptr).frequency2
   Widget_Control, (*displayptr).w_nmode_mode, SET_VALUE=(*dataptr).mode
  
    
END
