;+
; NAME:              DestroySheet
;
; PURPOSE:           Loescht ein Sheet. Das bedeutet,
;                    dass das Fenster geschlossen wird.
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  DestroySheet, Sheet [,Multi-Index]
;
; INPUTS:            Sheet: eine mit DefineSheet definierte Sheet-Struktur
;
; OPTIONAL INPUTS:   Multi-Index: Bei MultiSheets (s. MULTI-Option von <A HREF="#DEFINESHEET">DefineSheet()</A>)
;                                 kann hier der Index des "Sheetchens" 
;                                 angegeben werden, das geschlossen
;                                 werden soll.
;                                 Da aber in jedem Fall das gesamte
;                                 Multisheet mitsamt allen "Sheetchen" 
;                                 vom Bildschirm verschwindet, kann
;                                 die Angabe des Index auch unterbleiben.
;
; EXAMPLE:
;                    sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;                    OpenSheet, sheety
;                    Plot, Indgen(200)
;                    CloseSheet, sheety
;                    dummy = Get_Kbrd(1)
;                    DestroySheet, sheety
;
; SEE ALSO: <A HREF="#SCROLLIT">ScrollIt()</A>,
;           <A HREF="#DEFINESHEET">DefineSheet()</A>, <A HREF="#OPENSHEET">OpenSheet</A>,<A HREF="#CLOSESHEET">CloseSheet</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  1998/05/18 18:25:11  kupper
;            Multi-Sheets implementiert!
;
;     Revision 2.3  1998/04/19 13:17:46  saam
;           tried to set windid even for ps- or null-sheets
;
;     Revision 2.2  1998/03/19 10:45:57  saam
;           now uses ScrollIt and remembers destroyed windows
;           resize events have no effect
;
;     Revision 2.1  1997/11/13 13:03:30  saam
;           Creation
;
;
;-
PRO DestroySheet, _sheet, multi_nr

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet(0)

   IF sheet.type EQ 'X' THEN BEGIN
      UWSet, sheet.winid, exists
      IF exists THEN WIDGET_CONTROL, sheet.widid, /DESTROY    
      sheet.winid = -2
      sheet.widid = -2
   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      IF sheet.open THEN CloseSheet, sheet
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      CloseSheet, sheet
   END

   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet = sheet

END
