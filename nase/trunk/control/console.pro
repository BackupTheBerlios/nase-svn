;+
; NAME:  CONSOLE.PRO
;
;
; PURPOSE: console for messages, warnings, fatal errors...
;          provides an unified message-mechanism for ALL mind-routines
;
;
; CATEGORY: MIND GRAPHIC
;
;
; CALLING SEQUENCE:  console, console_struct, 'MESSAGE','CALLING ROUTINE',
;                        [ /MSG, /WARNING, /FATAL ]
;
; 
; INPUTS:         console_struct  : contains relevant data
;                 MESSAGE         : message
;                 CALLING ROUTINE : who produced the message?
;               
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS: 
;                     /MSG            : status = MeSsaGe ... no further action
;                     /WARNING        : status = warning-message
;                     /FATAL          : Fatal Error -> quit
;
;
;
; OUTPUTS:           console is updated 
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:  terminal
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
; EXAMPLE:         MyCons = initconsole(MODE='win',LENGTH=30)
;                  Console, MyCons, 'hi there','TestProc',/MSG
;                  ConsoleTime,MyCons,30,30.0
;                  ...
;                  Freeconsole, MyCons 
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.1  2000/01/26 17:03:36  alshaikh
;           initial version
;
;
;-



PRO console, _console, _message, _called_by, MSG=msg,WARNING=warning,FATAl=fatal

Default, Msg , 1  ; Message Mode
Default, warning,0
Default, fatal,0





IF msg EQ 1 THEN type = 1
IF warning EQ 1 THEN type = 2
IF fatal EQ 1 THEN type = 3

   Handle_Value,_console,status,/no_copy
   status.viz(status.act) = strupcase(_called_by)+':'+_message
   IF warning EQ 1 THEN status.viz(status.act) = 'WARNING FROM '+ status.viz(status.act)
   IF fatal EQ 1 THEN  status.viz(status.act) = 'FATAL ERROR FROM '+ status.viz(status.act) 
   status.act =  status.act + 1
   IF status.act GE status.length THEN BEGIN 
      FOR i=0, status.length-2 DO BEGIN
         status.viz(i) = status.viz(i+1)
      ENDFOR 
      status.viz(status.length-1) =  ' '
      status.act =  status.length-1
   ENDIF 


   IF status.mode EQ 1 THEN Widget_Control,status.cons,set_value=status.viz $
   ELSE IF status.mode EQ 0 THEN print, status.viz(status.act-1)


   IF fatal EQ 1 THEN stop


   Handle_Value,_console,status,/no_copy,/set
end
