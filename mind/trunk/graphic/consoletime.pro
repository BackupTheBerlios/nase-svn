;+
; NAME:  consoletime.pro
;
;
; PURPOSE:  updates console-time
;
;
; CATEGORY: MIND GRAPHIC
;
;
; CALLING SEQUENCE: consoletime, MyCons, BIN = bin, MS = ms
;
; 
; INPUTS:        MyCons : Console-structure
;                BIN    : Time in BINs 
;                MS     : Time in ms
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:        updates console
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
; EXAMPLE:   MyCons = initconsole(MODE='win',LENGTH=30)
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
;     Revision 1.1  2000/01/26 16:18:39  alshaikh
;           initial version
;
;
;-



PRO consoletime, _console, bin= bin, ms= ms

Handle_Value,_console,status,/no_copy

temp =  'BINS: '+str(bin)+'  MS: '+ str(ms)

status.acttime_steps = bin
status.acttime_ms = ms
 
IF status.mode EQ 1 THEN Widget_Control,status.timewid,set_value=temp $
   ELSE IF status.mode EQ 0 THEN print, temp


Handle_Value,_console,status,/no_copy,/set
end
