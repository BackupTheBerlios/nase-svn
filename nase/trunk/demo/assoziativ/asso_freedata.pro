;+
; NAME: asso_freedata
;
;
; AIM: Module of assoziativ.pro (see also: FaceIt)
;
; PURPOSE: siehe assoziativ.pro
;
;
; MODIFICATION HISTORY:
;
;-
;
;     $Log$
;     Revision 1.2  2000/09/27 12:14:06  alshaikh
;           added aim
;
;     Revision 1.1  1999/10/14 12:37:42  alshaikh
;           initial version
;
;
;
PRO asso_FREEDATA, dataptr

   Message, /INFO, "-Aufraeumen"
   
   FreeLayer, (*dataptr).l1
   FreeLayer, (*dataptr).l2
   
   FreeDW, (*dataptr).CON_asso_asso_feed
   FreeDW, (*dataptr).CON_asso_asso_inhib
   FreeDW, (*dataptr).CON_inp_asso
   FreeDW, (*dataptr).CON_inp_inp
   
END                             
