;+
; NAME:
;  FreeConsole
;
; VERSION:
;  $Id$
;
; AIM:
;  frees <A>console</A>-structure
;
; PURPOSE:
;  frees console-structure
;
; CATEGORY:
;  Help
;  IO
;  NASE
;  Widgets
;
; CALLING SEQUENCE:
;*FreeConsole, MyCons
;
; INPUTS:
;  MyCons:: Console-structure
;
; EXAMPLE:
;*MyCons = initconsole(MODE='win',LENGTH=30)
;*Console, MyCons, 'hi there',/MSG
;*ConsoleTime,MyCons,30,30.0
;*Freeconsole, MyCons
;
; SEE ALSO:
;  <A>Console</A>, <A>InitConsole</A>, <A>ConsoleConf</A>, <A>ConsoleTime</A>
;-

PRO freeconsole, _console

Handle_Value,_console,status,/no_copy

IF status.mode EQ 1 THEN BEGIN
   If Widget_Info(/Valid_Id, status.base) then begin
      Widget_Control,status.base,/destroy
   endif else begin
      Message, /Informational, "Console Widget does not exist any " + $
        "more. Freeing rest of structure."
   endelse
END

FreeQueue, status.viz

Handle_Free,_console

END
