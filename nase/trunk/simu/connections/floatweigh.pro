;+
; NAME:
;  FloatWeigh()
;
; VERSION:
;  $Id$
;
; AIM: Propagate analog input values through connections given in DW structure.
; 
; PURPOSE:
;  This routine was originally planned to enable simulations with
;  analog actitvities (e.g. firing rates) instead of spikes.
;  It is now obsolete, since <A>DelayWeigh()</A> has been improved to
;  handle analog activities as well.
;
; SEE ALSO:
;  <A>DelayWeigh()</A>
;  
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2001/11/27 14:10:36  thiel
;           Obsolete. Superceeded by new DelayWeigh routine.
;
;        Revision 2.1  2000/09/25 16:49:13  thiel
;            AIMS added.
;
;




FUNCTION FloatWeigh, _DW, InHandle
   
   Console, /WARN, 'Obsolete. Use DelayWeigh instead.'

   Return, DelayWeigh(_dw, inhandle)  

END   
