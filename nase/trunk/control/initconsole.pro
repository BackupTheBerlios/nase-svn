;+
; NAME:                   InitConsole.pro
;
; AIM : Initializes a new <A>console</A>-structure
;
; PURPOSE:                Initializes Console-structure 
;
; CATEGORY:               MIND GRAPHIC
;
; CALLING SEQUENCE:       MyCons = InitConsole([\WIN] [,MODE=mode]
;                                    [,TITLE=title] [,LENGTH=length]
;                                    [,THRESHOLD=threshold] 
;                                    [TOLERANCE=tolerance])
; 
; KEYWORD PARAMETERS:     MODE     :  specifies display :
;                                     MODE = 'nowin'  ... console=print  (Default)
;                                     MODE = 'win'    ... opens text-widget 
;                         LENGTH   :  Length of remembered lines       (Default=200)  
;                         THRESHOLD: Messages with priority lt THRESHOLD are supressed
;                         TITLE    : window title if Console runs in
;                                    window mode
;                         TOLERANCE: Messages with priority ge TOLERANCE cause STOP  
;                         WIN      : Console runs in a dedicated window
;                                     (same as MODE='win')                         
;
; OUTPUTS:                MyCons: Console-structure
;
; EXAMPLE:                MyCons = initconsole(MODE='win',LENGTH=30)
;                         Console, MyCons, 'hi there','TestProc',/MSG
;                         ConsoleTime,MyCons,30,30.0
;                         Freeconsole, MyCons
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.6  2000/10/10 15:03:09  kupper
;     Now using Fixed String Queue for storing the messages. Much simpler
;     now. Should behave exactly the same.
;
;     Revision 2.5  2000/09/28 13:23:55  alshaikh
;           added AIM
;
;     Revision 2.4  2000/04/03 12:13:34  saam
;           + removed side effect in console
;           + freeconsole now really closes the window
;
;     Revision 2.3  2000/03/28 12:36:27  saam
;           + added WIN keyword just for comfort
;           + added TITLE keyword
;
;     Revision 2.2  2000/01/27 15:38:09  alshaikh
;           keywords LEVEL,THRESHOLD,TOLERANCE
;
;     Revision 2.1  2000/01/26 17:03:35  alshaikh
;           initial version
;
;


FUNCTION initconsole,MODE=_mode,LENGTH=length,THRESHOLD=threshold,TOLERANCE=tolerance,TITLE=title,WIN=win

Default, _mode, 'nowin'
Default, length, 200
Default, tolerance,30
Default, threshold,0
Default, title, 'Console'

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
      viz   : viz $
    }
 result = Handle_Create(VALUE=h,/no_copy)

return, result
end
