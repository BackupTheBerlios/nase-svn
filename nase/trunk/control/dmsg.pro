;+
; NAME: 
;   DMsg
;
; VERSION:
;   $Id$
;
; AIM:
;   Issue a debugging message.
;   
; PURPOSE:
;   This procedure uses the <A>Console</A> command with the /DEBUG
;   option to issue a debugging message. The only difference from
;   using <A>Console</A> directly is, that the <A>DMsg</A> command may
;   (almost) completely be switched off using the <A>Debugging</A>
;   procedure. Hence, it may be used even at positions critical for
;   performance time.
;   
; CATEGORY:
;*  Help
;
; CALLING SEQUENCE:
;   DMsg, messagestring
;  
; INPUTS:
;   messagestring:: The message to display.
;  
; SIDE EFFECTS:
;   Output will be suppressed, when debugging messages were turned of
;   using the <A>Debugging</A> procedure.
;  
; PROCEDURE:
;   Simply call <A>Console</A>.
;  
; EXAMPLE:
;*  IDL> Debugging, Messages=1   
;*  IDL> DMsg, "Still alive!"
;*  > "Still alive!"
;*  IDL> Debugging, Messages=0    
;*  IDL> DMsg, "Still alive!"
;*  >
;  
;-

Pro DMsg, con, message
   Console, con, message, /Debug, pickcaller=1
End
