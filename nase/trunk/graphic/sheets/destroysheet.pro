;+
; NAME:              DestroySheet
;
; PURPOSE:           Loescht ein Sheet. Das bedeutet,
;                    dass das Fenster geschlossen wird.
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  DestroySheet, Sheet
;
; INPUTS:            Sheet: eine mit DefineSheet definierte Sheet-Struktur
;
; EXAMPLE:
;                    sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;                    OpenSheet, sheety
;                    Plot, Indgen(200)
;                    CloseSheet, sheety
;                    dummy = Get_Kbrd(1)
;                    DestroySheet, sheety
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/03/19 10:45:57  saam
;           now uses ScrollIt and remembers destroyed windows
;           resize events have no effect
;
;     Revision 2.1  1997/11/13 13:03:30  saam
;           Creation
;
;
;-
PRO DestroySheet, sheet

   IF sheet.type EQ 'X' THEN BEGIN
      UWSet, sheet.winid, exists
      IF exists THEN WIDGET_CONTROL, sheet.widid, /DESTROY    
   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      IF sheet.open THEN CloseSheet, sheet
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      CloseSheet, sheet
   END
   sheet.winid = -2
   sheet.widid = -2
END
