;+
; NAME: depress_freedata
;
; AIM: Module of depress.pro  (see also  <A>faceit</A>)
;
; PURPOSE: siehe depress.pro
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/28 12:16:12  alshaikh
;           added AIM
;
;     Revision 1.1  1999/10/14 12:31:12  alshaikh
;           initial version
;
;


PRO depress_FREEDATA, dataptr

   Message, /INFO, "Freeing data structures."

   FreeLayer, (*dataptr).pre
   FreeLayer, (*dataptr).in_layer
   FreeDW, (*dataptr).CON_in_pre
   
END ; depress_FREEDATA
