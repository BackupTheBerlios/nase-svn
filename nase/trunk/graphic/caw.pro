;+
; NAME: 
;  CAW
;
; VERSION:
;  $Id$
;
; AIM:
;  closes all IDL windows and destroys all widgets
;  
; PURPOSE:
;  This routine closes all open windows and resets the widget system,
;  which destroys all widgets.   
;  
; CATEGORY:
;  Graphic
;  Windows
;
; CALLING SEQUENCE:
;*CAW
;
; EXAMPLE:
;*;closes all open 
;*CAW
;
; SEE ALSO:
;  <C>WDelete</C>, <C>WIDGET_CONTROL</C>
;-
PRO CAW
WIDGET_CONTROL, /RESET
while (!D.Window GE 0) do WDelete, !D.Window
END
