;+
; NAME: cornsweet_resetsliders
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
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.3  2000/09/28 12:06:30  alshaikh
;           AIM bugfixes
;
;     Revision 1.2  2000/09/27 15:08:05  alshaikh
;           AIM-tag added
;
;     Revision 1.1  2000/02/16 10:20:36  alshaikh
;           initial version
;
;
;

PRO cornsweet_RESETSLIDERS, dataptr, displayptr

   Widget_Control, (*displayptr).w_linkparrange, SET_VALUE=(*dataptr).linkparrange
   Widget_Control, (*displayptr).w_linkparampl, SET_VALUE=(*dataptr).linkparampl

   Widget_Control, (*displayptr).w_extinpampl, SET_VALUE=(*dataptr).extinpampl
   Widget_Control, (*displayptr).w_extinpoffset, SET_VALUE=(*dataptr).extinpoffset
   Widget_Control, (*displayptr).w_extinpleft, SET_VALUE=(*dataptr).extinpleft
   Widget_Control, (*displayptr).w_extinptau, SET_VALUE=(*dataptr).extinptau
    
END
