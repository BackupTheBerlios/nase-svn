;+
; NAME:   freeconsole.pro
;
;
; PURPOSE:  frees console-structure
;
;
; CATEGORY:  mind graphic
;
;
; CALLING SEQUENCE:  freeconsole, MyCons
;
; 
; INPUTS:      MyCons  : Console-structure
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
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
; EXAMPLE:
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


PRO freeconsole, _console

Handle_Value,_console,status,/no_copy

Widget_Control,status.cons,/destroy
Widget_Control,status.timewid,/destroy
Handle_Value,_console,status,/no_copy,/set
Handle_Free,_console
END
