;+
; NAME:              FREECONSOLE
;
; PURPOSE:           frees console-structure
;
; CATEGORY:          NASE CONTROL
;
; CALLING SEQUENCE:  freeconsole, MyCons
; 
; INPUTS:            MyCons  : Console-structure
;
; EXAMPLE:           MyCons = initconsole(MODE='win',LENGTH=30)
;                    Console, MyCons, 'hi there',/MSG
;                    ConsoleTime,MyCons,30,30.0
;                    Freeconsole, MyCons 
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/03/28 12:51:09  saam
;           fixed non-working variant
;           for non-win mode
;
;     Revision 2.1  2000/01/26 17:03:36  alshaikh
;           initial version
;
;
PRO freeconsole, _console

Handle_Value,_console,status,/no_copy

IF status.mode EQ 1 THEN BEGIN
    Widget_Control,status.cons,/destroy
    Widget_Control,status.timewid,/destroy
END

Handle_Value,_console,status,/no_copy,/set
Handle_Free,_console

END
