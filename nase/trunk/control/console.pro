;+
; NAME:
;  Console
;
; VERSION:
;  $Id$
;
; AIM: console-window for messages, warnings, fatal errors
;
; PURPOSE: console for messages, warnings, fatal errors...
;          provides an unified message-mechanism for ALL mind-routines
;          You can use console even without the init
;          routine. In this case a standard text console 
;          is used. It is initialized during nase startup
;          and saved in the system variable !CONSOLE. You
;          may change this variable to use your own console
;          for standard output.
;
; CATEGORY:
;  ExecutionControl
;  Help
;  IO
;  Strings
;  Widgets
;  Windows
;
; CALLING SEQUENCE:
;* console [,console_struct] ,message,
;*         [,/UP]
;*         [,/DEBUG|,/MSG|,/WARNING|,/FATAL|,LEVEL=...]
;*         [,PICKCALLER=...]
;
; INPUTS:
; console_struct:: the console, where the message 
;                  should go; if omitted the
;                  standard console in !CONSOLE is used
; message:: the message to be displayed
;
; KEYWORD PARAMETERS:
;
;  FATAL  :: Fatal Error -> quit (/FATAL=LEVEL30)
;  WARNING:: A warning message (/WARNING=LEVEL20)
;  MSG    :: MeSsaGe ... no further action (/MSG=LEVEL10)
;  DEBUG  :: A debug message (/DEBUG=LEVEL5)
;  
;  UP     :: moves cursor one line up before
;            printing
;
;  PICKCALLER:: Number (on the callstack) of the routine that shall be
;               displayed as the origin of the message. By default,
;               this is 0, meaning the routine that called
;               <A>Console</A>.
;
; SIDE EFFECTS:
;  console_struct is updated.
;
; RESTRICTIONS:
;  PICKCALLER needs to be positive and not larger than the depth of
;  the callstack.
;          
; EXAMPLE: 
;* MyCons = initconsole(MODE='win',LENGTH=30)
;* Console, MyCons, 'hi there',/MSG
;* ConsoleTime,MyCons,30,30.0
;* Freeconsole, MyCons
;
; SEE ALSO: <A>InitConsole</A>, <A>ConsoleThreshold</A>
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.12  2000/10/10 13:22:25  kupper
;     Put checking for level as much to front as possible.
;     Replaced "stopp" my a "message" command.
;     Not using N_Params() any more, as it doesn't work with wrappers!
;     Replaced by checks to Set().
;
;     Revision 2.11  2000/10/03 15:41:55  alshaikh
;           CALLS-bug fixed
;
;     Revision 2.10  2000/10/03 15:35:04  alshaikh
;           LEVEL-bug fixed
;
;     Revision 2.9  2000/09/28 13:23:54  alshaikh
;           added AIM
;
;     Revision 2.8  2000/06/19 12:44:56  saam
;           replaced string processing by an IDL3.6
;           conform version
;
;     Revision 2.7  2000/04/03 12:13:34  saam
;           + removed side effect in console
;           + freeconsole now really closes the window
;
;     Revision 2.6  2000/03/29 08:03:37  saam
;           stops at the callers position after fatal error
;
;     Revision 2.5  2000/03/28 15:35:52  saam
;           view is now centered at the latest messages
;
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

PRO Console, __console, _message, DEBUG=debug, MSG=msg, $
             WARNING=warning, FATAL=fatal, LEVEL=level, UP=up, $
             PICKCALLER=pickcaller 

   ON_ERROR,2 

   Default, Msg , 1             ; Message Mode
   Default, debug , 0
   Default, warning,0
   Default, fatal,0
   Default, level,-1

   if level eq -1 then begin 
      IF msg     THEN level = 10

      IF debug   THEN level = 5
      IF warning THEN level = 20 
      IF fatal   THEN level = 30
      if level eq -1 then level = 10
   endif 

   If not set(_message) then BEGIN ;;was called with only one argument
      ;;use standard console
      _message=__console
      _console=!CONSOLE
   Endif else begin ;; was called with two arguments
      _console = __console
   END

   Handle_Value,_console,status,/no_copy

   IF level LT status.threshold THEN begin
      Handle_Value,_console,status,/no_copy, /Set
      return
   endif
   


   Default, pickcaller, 0
   
   help, calls=m
   assert, pickcaller ge 0
   assert, (pickcaller+1) lt N_Elements(m) 
   m = m(pickcaller+1)

   _called_by = (split(m,' <'))(0)


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
      1: Widget_Control,status.cons,set_value=status.viz, SET_TEXT_TOP_LINE=MAX([0,status.act-10])
   END
   


   fatal = status.tolerance
   Handle_Value,_console,status,/no_copy,/set

   IF level GE fatal THEN message, "dummy", /NoPrint
                             ;;; in conjunction with on_error,2
                             ;;; this stops at the position of the
                             ;;; Console call
END
