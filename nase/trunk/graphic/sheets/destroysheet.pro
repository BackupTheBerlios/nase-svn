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
;     Revision 2.1  1997/11/13 13:03:30  saam
;           Creation
;
;
;-
PRO DestroySheet, sheet

   IF sheet.type EQ 'X' THEN BEGIN
      UWSet, sheet.winid, exists
      IF exists THEN WDelete, sheet.winid
   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      IF sheet.open THEN CloseSheet, sheet
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      CloseSheet, sheet
   END
   
END
