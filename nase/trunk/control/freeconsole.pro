;+
; NAME:              FREECONSOLE
;
; AIM: frees <A>console</A>-structure
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
;     Revision 2.5  2000/10/11 16:48:42  kupper
;     Removed unnecessary re-setting of handle that is destroyed anyway.
;     Added FreeQueue call.
;
;     Revision 2.4  2000/09/28 13:23:55  alshaikh
;           added AIM
;
;     Revision 2.3  2000/04/03 12:13:34  saam
;           + removed side effect in console
;           + freeconsole now really closes the window
;
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
    Widget_Control,status.base,/destroy
END

FreeQueue, status.viz

Handle_Free,_console

END
