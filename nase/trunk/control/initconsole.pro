;+
; NAME:  InitConsole.pro
;
;
; PURPOSE:  Initializes Console-structure 
;
;
; CATEGORY: MIND GRAPHIC
;
;
; CALLING SEQUENCE:  MyCons = InitConsole([MODE=mode],[LENGTH=length])
;
; 
; INPUTS:            MODE    :  specifies display :
;                               MODE = 'nowin'  ... console=print  (Default)
;                               MODE = 'win'    ... opens text-widget 
;                    LENGTH  :  Length of remembered lines       (Default=200)    
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:     Console-structure MyCons
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
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
; EXAMPLE: MyCons = initconsole(MODE='win',LENGTH=30)
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
;     Revision 2.1  2000/01/26 17:03:35  alshaikh
;           initial version
;
;
;
;-


FUNCTION initconsole,MODE=_mode,LENGTH=length

Default, _mode, 'nowin'
Default, length, 200

IF _mode EQ 'nowin' THEN mode = 0
IF _mode EQ 'win' THEN mode = 1

viz = strarr(length)

IF mode EQ 1 THEN BEGIN 
   base = widget_base(title='console log',/column)
   cons = widget_text(base,xsize=80,ysize=15,/scroll,value=viz)
   timewid = widget_text(base,xsize=80,ysize=1,value='no init yet')
   widget_control,base,/realize  
END ELSE BEGIN
   base =  0
   cons =  0
   timewid = 0
END 

h = { $
     cons : cons ,$
     timewid : timewid, $
     acttime_steps : 0l ,$
     acttime_ms : 0.0,$
     act   : 0 ,$
     mode : mode ,$
     length : length, $
     viz   : viz $
    }
 result = Handle_Create(!MH, VALUE=h,/no_copy)

return, result
end
