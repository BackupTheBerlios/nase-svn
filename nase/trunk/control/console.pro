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
; message:: the message string to be displayed. This may be a single
;           line or a string array in the case of
;           multi-line-messages.
;
; KEYWORD PARAMETERS:
;
;  FATAL  :: Fatal Error -> quit (/FATAL=LEVEL30)
;  WARNING:: A warning message (/WARNING=LEVEL20)
;  MSG    :: MeSsaGe ... no further action (/MSG=LEVEL10)
;  DEBUG  :: A debug message (/DEBUG=LEVEL5)
;            You may want to consider using the <A>DMsg</A> command
;            instead.
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
;  If the console was a window-console, and the window has been
;  closed, it is re-created.
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
; SEE ALSO: <A>InitConsole</A>, <A>ConsoleConf</A>, <A>DMsg</A>
;
;-

PRO Console, __console, _message, DEBUG=debug, MSG=msg, $
             WARNING=warning, FATAL=fatal, LEVEL=level, UP=up, $
             PICKCALLER=pickcaller 

   ON_ERROR,2 

   Assert, Set(__console), "At least one argument expected."

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

;   Handle_Value,_console,status,/no_copy
 

   IF level LT GetHTag(_console, 'threshold') THEN return
   


   Default, pickcaller, 0
   
   help, calls=m
   assert, pickcaller ge 0
   assert, (pickcaller+1) lt N_Elements(m), "Too few elements on the callstack."
   m = m(pickcaller+1)

   _called_by = (split(m,' <'))(0)


   yell = '('+str(level)+')'+strupcase(_called_by)+': '+_message
   

   viz = getHTag(_console, 'viz')

   IF Keyword_Set(UP) THEN dummy = DeTail(viz)
   mlogfile = GetHTag(_console, 'logfile')
   For i=0, n_elements(yell)-1 do BEGIN
       IF mlogfile NE !NONE THEN begin
          PrintF, mlogfile, yell(i)
          Flush, mlogfile
       endif
       EnQueue, viz, yell(i)
   END

   mmode = GetHTag(_console, 'mode')
   if (mmode eq 1) and not $
     Widget_Info(/Valid_Id, GetHTag(_console, 'base')) then begin
      Message, /Informational, "Console window does not exist any " + $
        "more. Re-opening."
      ;; PROGRAMMER please keep in mind that the folloiwng code must
      ;; be equivalent to the code that is used inside
      ;; "initconsole.pro" for creation of the original widget. Keep
      ;; in sync!
      newbase = widget_base(title=GetHTag(_console, 'title'),/column)
      SetHTag, _console, 'base', newbase
      SetHTag, _console, 'cons', widget_text(newbase,xsize=80,ysize=15,/scroll,value=Queue(GetHTag(_console, 'viz')))
      SetHTag, _console, 'timewid', widget_text(newbase,xsize=80,ysize=1,value='')
      widget_control,newbase,/realize  
   endif

   CASE mmode OF
      0: for i=0, n_elements(yell)-1 do print, yell(i)
      1: Widget_Control,GetHTag(_console, 'cons'),set_value=queue(viz, /valid), $
       SET_TEXT_TOP_LINE=MAX([0,ContainedElements(viz, /VALID)-10])
   END
   

   SetHTag, _console, "viz", Temporary(viz)

   IF level GE GetHTag(_console, 'tolerance') THEN message, "dummy", /NoPrint
                             ;;; in conjunction with on_error,2
                             ;;; this stops at the position of the
                             ;;; Console call
END
