;+
; NAME: cornsweet_freedata
;
; AIM : Module of cornsweet.pro  (see also  <A>faceit</A>)
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
; MODIFICATION HISTORY:
;
;
;-
;     $Log$
;     Revision 1.3  2000/09/28 12:06:29  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 15:08:04  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:35  alshaikh
;           initial version
;
;
;

PRO cornsweet_FREEDATA, dataptr

   Message, /INFO, "Freeing data structures."

   FreeLayer, (*dataptr).pre
   FreeDW, (*dataptr).CON_pre_pre

END ; cornsweet_FREEDATA
