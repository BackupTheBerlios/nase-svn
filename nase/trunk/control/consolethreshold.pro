;+
; NAME: 
;  ConsoleThreshold
;
; VERSION:
;  $Id$
;
; AIM:
;  Sets the <A>CONSOLE</A>-Threshold
;  
; PURPOSE:
;  This Routine defines a new <A>CONSOLE</A>-Threshold, i.e. the LEVEL-value
;  below which <A>CONSOLE</A> output is ignored.
;  
; CATEGORY:
;  ExecutionControl
;  Help
;  IO
;  MIND
;  NASE 
;  Widgets
;
; CALLING SEQUENCE:
;*  ConsoleThreshold [,con] [,THRESHOLD=thresh]
;
; OPTIONAL INPUTS:
;   con:: An initialized <A>CONSOLE</A>-structure. If no con is
;         specified, the !CONSOLE-console is taken (which was
;         initialized on IDL-startup
;  
; INPUT KEYWORDS:
;  THRESHOLD:: new threshold-value. if no value is specified,
;              threshold is set to default (5).
;  
; OUTPUTS:
;  con- (or !CONSOLE-)threshold is set to the specified value.
;
; SIDE EFFECTS:
;  con- (or !CONSOLE-)threshold is set to the specified value.
;  
;
; EXAMPLE:
;*  o=initconsole()
;*  consolethreshold,o,THRESHOLD=7
;*  >(10)CONSOLETHRESHOLD:Setting threshold to 7
;*  console,"HALLO",level=9
;*  >(9)$MAIN$:HALLO
;*  > console,"HUHU",level=3
;*  >
;
;  
; SEE ALSO:
;  <A>InitConsole</A>, <A>Console</A>, <A>FreeConsole</A>, <A>ConsoleTime</A>
;  
;-

PRO ConsoleThreshold,  __console, THRESHOLD=threshold
   
   ON_ERROR, 2
   
   Default, threshold, 5
   
   CASE N_Params() OF
      0: _console = !CONSOLE
      1: _console = __console
      
      ELSE: CONSOLE, 'Wrong arguments', /FATAL
   END 
   
   Handle_Value,_console,status,/no_copy
   status.threshold = threshold
   Handle_Value,_console,status,/no_copy, /SET
   
   CONSOLE, 'Setting threshold to '+str(threshold), /MSG
   
END
