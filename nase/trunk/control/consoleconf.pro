;+
; NAME: 
;  ConsoleConf
;
; VERSION:
;  $Id$
;
; AIM:
;  Changes various properties of the <A>CONSOLE</A>
;  
; PURPOSE:
;  This Routine changes a new <A>CONSOLE</A>-Threshold, i.e. the LEVEL-value
;  below which <A>CONSOLE</A> output is ignored.
;  
; CATEGORY:
;*  ExecutionControl
;*  Help
;*  IO
;*  MIND
;*  NASE 
;*  Widgets
;
; CALLING SEQUENCE:
;*  ConsoleThreshold [,con] [,THRESHOLD=...] [,TOLERANCE=...]
;*                    [FILENAME=...] [/FILEON | /FILEOFF]
;
; OPTIONAL INPUTS:
;   con:: An initialized <A>CONSOLE</A>-structure. If no con is
;         specified, the !CONSOLE-console is taken (which was
;         initialized on IDL-startup)
;  
; INPUT KEYWORDS:
;   THRESHOLD:: Sets a new threshold value. Messages with priority less than
;               THRESHOLD are supressed.
;   TOLERANCE:: Sets a new tolerance value. Messages with priority
;               greater than TOLERANCE interrupt program execution.
;   FILENAME :: Set a new filename for writing the console output to.
;               Screen logging is unaffected from this operation.
;               If there is already an active file, it will be closed
;               and the new output is written into FILENAME. The keyword
;               FILEON is set automatically, if FILENAME is specified.
;   FILEON   :: Start writing the console output into a file. If no 
;               FILENAME has ever been given to the console, it will
;               log into "console.log"
;   FILEOFF  :: Start writing the console output into a file. 
;               
; SIDE EFFECTS:
;   con (or !CONSOLE) properties are changed
;  
;
; EXAMPLE:
;*  o=initconsole()
;*  consoleconf,o,THRESHOLD=7
;*  >(10)CONSOLECONF:Setting threshold to 7
;*  console,"HALLO",level=9
;*  >(9)$MAIN$:HALLO
;*  console,"HUHU",level=3
;*  >
;
; SEE ALSO:
;  <A>InitConsole</A>, <A>Console</A>, <A>FreeConsole</A>, <A>ConsoleTime</A>
;  
;-

PRO ConsoleConf,  __console, THRESHOLD=threshold, TOLERANCE=tolerance, FILENAME=filename, FILEON=fileon, FILEOFF=fileoff
   
   ON_ERROR, 2
   
   assert, Keyword_Set(FILEON)+Keyword_Set(FILEOFF) LE 1, 'specify either FILEON or FILEOFF';
   IF Set(FILENAME) THEN FILEON = 1 ; turn on file logging automatically

   CASE N_Params() OF
      0: _console = !CONSOLE
      1: _console = __console
      
      ELSE: CONSOLE, 'Wrong arguments', /FATAL
   END 
   


   IF Set(THRESHOLD) THEN SetHTag, _console, "threshold", threshold
   IF Set(TOLERANCE) THEN SetHTag, _console, "tolerance", tolerance
   IF Set(FILENAME) THEN BEGIN
       ; is logging already on?
       logfile = GetHTag(_console, 'logfile')
       IF logfile NE !NONE THEN BEGIN
           UClose, logfile 
           logfile = !NONE
       END
       SetHTag, _console, 'logfile', logfile
       SetHTag, _console, 'filename', filename
   END
   Default, FILENAME, GetHTag(_CONSOLE, "filename")
   IF Keyword_Set(FILEON)  THEN BEGIN
       IF GetHTag(_console, 'logfile') EQ !NONE THEN BEGIN
           logfile = UOpenW(FILENAME)            
           SetHTag, _CONSOLE, "logfile", logfile ; not in the same line, because UOpenW uses CONSOLE
       END ELSE Console, _console, 'file logging already enabled...ignoring request'
   END
   IF Keyword_Set(FILEOFF) THEN BEGIN
       IF GetHTag(_console, 'logfile') EQ !NONE THEN Console, _console, 'file logging already disabled...ignoring request' ELSE BEGIN
           UClose, GetHTag(_console, 'logfile')
           SetHTag, _console, 'logfile', !NONE
       END
   END

   tol = GetHTag(_console, "tolerance")
   IF Set(THRESHOLD) THEN CONSOLE, _console, 'setting threshold to '+str(threshold), LEVEL=tol-1
   IF Set(TOLERANCE) THEN CONSOLE, _console, 'setting tolerance to '+str(tolerance), LEVEL=tol-1
   IF Set(FILEON)    THEN CONSOLE, _console, 'logging console output to '+FILENAME,  LEVEL=tol-1
   IF Set(FILEOFF)   THEN CONSOLE, _console, 'stopped logging console output to '+FILENAME,  LEVEL=tol-1
   
END
