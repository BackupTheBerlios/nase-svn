;+
; NAME:
;   InitConsole()
;
; VERSION:
;   $Id$
; 
; AIM :
;   Initializes a new <A>console</A>-structure. 
;
; PURPOSE:
;   Initializes Console-structure. Note that most of the
;   console properties can be changed anytime using <A>ConsoleConf</A>.
;
; CATEGORY:
;   ExecutionControl
;   Help
;   IO
;   MIND
;   NASE 
;   Widgets
;
; CALLING SEQUENCE:       
;*  MyCons = InitConsole([\WIN] [,MODE=...] [,TITLE=...] [,LENGTH=...]
;*                       [,FILENAME=...]
;*                       [,THRESHOLD=...] [,TOLERANCE=...])
; 
; INPUT KEYWORDS:
;   FILENAME :: Enables additional logging into
;               a file called FILENAME. 
;   MODE     :: specifies display :
;               MODE = 'nowin'  ... console=print  (Default)
;               MODE = 'win'    ... opens text-widget 
;   LENGTH   :: Length of remembered lines       (Default=200)  
;               THRESHOLD:: Messages with priority lt THRESHOLD are supressed
;   TITLE    :: window title if Console runs in
;               window mode
;   TOLERANCE:: Messages with priority ge TOLERANCE cause STOP  
;   WIN      :: Console runs in a dedicated window
;               (same as MODE='win')                         
;
; OUTPUTS:                MyCons: Console-structure
;
; EXAMPLE:                MyCons = initconsole(MODE='win',LENGTH=30)
;                         Console, MyCons, 'hi there','TestProc',/MSG
;                         ConsoleTime,MyCons,30,30.0
;                         Freeconsole, MyCons
;
; SEE ALSO:
;   <A>Console</A>, <A>ConsoleConf</A>, <A>ConsoleTime</A>
;  
;-


FUNCTION initconsole,MODE=_mode,LENGTH=length,THRESHOLD=threshold,TOLERANCE=tolerance,TITLE=title,WIN=win, FILENAME=filename

Default, _mode, 'nowin'
Default, length, 200
Default, tolerance,30
Default, threshold,0
Default, title, 'Console'
Default, file, filename

IF _mode EQ 'nowin' THEN mode = 0
IF _mode EQ 'win' THEN mode = 1
IF Keyword_Set(WIN) THEN mode=1

viz = InitFQueue(length, "")

IF mode EQ 1 THEN BEGIN 
   base = widget_base(title=title,/column)
   cons = widget_text(base,xsize=80,ysize=15,/scroll,value=Queue(viz))
   timewid = widget_text(base,xsize=80,ysize=1,value='')
   widget_control,base,/realize  
END ELSE BEGIN
   base =  0
   cons =  0
   timewid = 0
END 

; check syntax of FILE keyword
IF NOT Set(FILE) THEN File = 'console.log' ELSE BEGIN
    IF TypeOF(File) NE 'STRING' THEN Message, 'FILE has to be a valid string'
END



h = { $
      base: base ,$
      cons : cons ,$
      timewid : timewid, $
      acttime_steps : 0l ,$
      acttime_ms : 0.0,$
      mode : mode ,$
      length : length, $
      threshold: threshold ,$
      tolerance: tolerance, $
      filename: file,$
      logfile: !NONE,$ ; this will contain the LUN
      viz   : viz $
    }
 result = Handle_Create(VALUE=h,/no_copy)

 ; turn on file logging if wanted
 IF Set(FILENAME) THEN ConsoleConf, result, /FILEON

return, result
end
