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
;                        [ /MSG, /WARNING, /FATAL, LEVEL=level ]
;
; 
; INPUTS:         console_struct  : contains relevant data
;                 MESSAGE         : message
;
;               
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS: 
;                     /MSG            : status = MeSsaGe ... no further action (/MSG=LEVEL10)
;                     /WARNING        : status = warning-message               (/WARNING=LEVEL20) 
;                     /FATAL          : Fatal Error -> quit                    (/FATAL=LEVEL30)
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
;                  Console, MyCons, 'hi there',/MSG
;                  ConsoleTime,MyCons,30,30.0
;                  ...
;                  Freeconsole, MyCons 
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/01/27 15:38:09  alshaikh
;           keywords LEVEL,THRESHOLD,TOLERANCE
;
;     Revision 2.1  2000/01/26 17:03:36  alshaikh
;           initial version
;
;
;-



PRO console, _console, _message, MSG=msg,WARNING=warning,FATAL=fatal,LEVEL=level

Default, Msg , 1  ; Message Mode
Default, warning,0
Default, fatal,0
Default, level,10

   help, calls=m
   m = m(1)
   pos1 = strpos(m,'/', /REVERSE_SEARCH) 
   _called_by =  strmid(m,pos1+1,strpos(m,'.pro')-pos1-1)


IF msg EQ 1 THEN level = 10
IF warning EQ 1 THEN level = 20 
IF fatal EQ 1 THEN level = 30

   Handle_Value,_console,status,/no_copy

   IF level GE status.threshold THEN begin

      status.viz(status.act) = '('+str(level)+')'+strupcase(_called_by)+':'+_message
      ;iF warning EQ 1 THEN status.viz(status.act) = 'WARNING FROM '+ status.viz(status.act)
      ;if fatal EQ 1 THEN  status.viz(status.act) = 'FATAL ERROR FROM '+ status.viz(status.act) 
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
      
   END 
   
   IF level GE status.tolerance THEN stop
   

   Handle_Value,_console,status,/no_copy,/set
end
