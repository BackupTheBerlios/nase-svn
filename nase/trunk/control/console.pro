;+
; NAME:               CONSOLE
;
; PURPOSE:            console for messages, warnings, fatal errors...
;                     provides an unified message-mechanism for ALL mind-routines
;                     You can use console even without the init
;                     routine. In this case a standard text console 
;                     is used. It is initialized during nase startup
;                     and saved in the system variable !CONSOLE. You
;                     may change this variable to use your own console
;                     for standard output.
;
; CATEGORY:           NASE CONTROL
;
; CALLING SEQUENCE:   console [,console_struct] , message,
;                        [ ,/UP ]
;                        [ ,/MSG | ,/WARNING | ,/FATAL | ,LEVEL=level ]
;
; INPUTS:             console_struct  : the console, where the message 
;                                       should go; if omitted the
;                                       standard console in !CONSOLE is used
;                     message         : the message to be displayed
;
; KEYWORD PARAMETERS: 
;                     FATAL    : Fatal Error -> quit                    (/FATAL=LEVEL30)
;                     MSG      : status = MeSsaGe ... no further action (/MSG=LEVEL10)
;                     UP       : moves cursor one line up before printing
;                     WARNING  : status = warning-message               (/WARNING=LEVEL20) 
;
; OUTPUTS:            console_struct is updated 
;
; EXAMPLE:            MyCons = initconsole(MODE='win',LENGTH=30)
;                     Console, MyCons, 'hi there',/MSG
;                     ConsoleTime,MyCons,30,30.0
;                     Freeconsole, MyCons 
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.4  2000/03/28 12:55:07  saam
;           docu updated, again
;
;     Revision 2.3  2000/03/28 12:48:04  saam
;           + return on ERROR
;           + docu updated (out of date!)
;           + new keyword UP
;           + can use a standard console, now
;
;     Revision 2.2  2000/01/27 15:38:09  alshaikh
;           keywords LEVEL,THRESHOLD,TOLERANCE
;
;     Revision 2.1  2000/01/26 17:03:36  alshaikh
;           initial version
;
;
;

PRO Console, _console, _message, MSG=msg,WARNING=warning,FATAL=fatal,LEVEL=level, UP=up

ON_ERROR,2 

Default, Msg , 1                ; Message Mode
Default, warning,0
Default, fatal,0
Default, level,10

CASE N_Params() OF
    1: BEGIN                    ;use standard console
        _message=_console
        _console=!CONSOLE
    END 
    2: ___XXXX=!NONE            ;do nothing
    ELSE: Message, 'invalid argument count'
END 



help, calls=m
m = m(1)
pos1 = strpos(m,'/', /REVERSE_SEARCH) 
_called_by =  strmid(m,pos1+1,strpos(m,'.pro')-pos1-1)


IF msg EQ 1 THEN level = 10
IF warning EQ 1 THEN level = 20 
IF fatal EQ 1 THEN level = 30

Handle_Value,_console,status,/no_copy

IF level GE status.threshold THEN begin
    

    yell = '('+str(level)+')'+strupcase(_called_by)+':'+_message
    

    IF Keyword_Set(UP) THEN status.act=status.act - 1
    status.viz(status.act) = yell
    status.act =  status.act + 1

    IF status.act GE status.length THEN BEGIN 
        FOR i=0, status.length-2 DO BEGIN
            status.viz(i) = status.viz(i+1)
        ENDFOR 
        status.viz(status.length-1) =  ' '
        status.act =  status.length-1
    ENDIF 
    
    CASE status.mode OF
        0: print, status.viz(status.act-1)
        1: Widget_Control,status.cons,set_value=status.viz 
    END
    
END 

IF level GE status.tolerance THEN stop
Handle_Value,_console,status,/no_copy,/set

END
