;+
; NAME:              DestroySheet
;
; AIM:
;  Free dynamic memory allocated by a sheet structure. For window
;  sheets also close window. 
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
; SEE ALSO: <A HREF="../#SCROLLIT">ScrollIt()</A>,
;           <A HREF="#DEFINESHEET">DefineSheet()</A>, <A HREF="#OPENSHEET">OpenSheet</A>,<A HREF="#CLOSESHEET">CloseSheet</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.9  2000/10/01 14:51:35  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.8  1999/06/15 17:36:39  kupper
;     Umfangreiche Aenderungen an ScrollIt und den Sheets. Ziel: ScrollIts
;     und Sheets koennen nun als Kind-Widgets in beliebige Widget-Applikationen
;     eingebaut werden. Die Modifikationen machten es notwendig, den
;     WinID-Eintrag aus der Sheetstruktur zu streichen, da diese erst nach der
;     Realisierung der Widget-Hierarchie bestimmt werden kann.
;     Die GetWinId-Funktion fragt nun die Fensternummer direkt ueber
;     WIDGET_CONTROL ab.
;     Ebenso wurde die __sheetkilled-Prozedur aus OpenSheet entfernt, da
;     ueber einen WIDGET_INFO-Aufruf einfacher abgefragt werden kann, ob ein
;     Widget noch valide ist. Der Code von OpenSheet und DefineSheet wurde
;     entsprechend angepasst.
;     Dennoch sind eventuelle Unstimmigkeiten mit dem frueheren Verhalten
;     nicht voellig auszuschliessen.
;
;     Revision 2.7  1999/02/12 15:22:52  saam
;           sheets are mutated to handles
;
;     Revision 2.6  1998/06/18 15:01:11  kupper
;            Hyperlings geupgedatet nach Veraenderigung der Verzeichnischtrugdur.
;
;     Revision 2.5  1998/05/20 18:10:58  kupper
;            Kleiner Bug bei Multi-Sheets.
;
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
PRO DestroySheet, __sheet, multi_nr

   Handle_Value, __sheet, _sheet, /NO_COPY

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet(0)

   IF sheet.type EQ 'X' THEN BEGIN
      ;UWSet, sheet.winid, exists
      ;IF exists THEN WIDGET_CONTROL, sheet.widid, /DESTROY    
      ;sheet.winid = -2
      IF Widget_Info(sheet.widid, /VALID_ID) THEN WIDGET_CONTROL, sheet.widid, /DESTROY
      sheet.widid = -2
   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      IF sheet.open THEN CloseSheet, sheet
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      CloseSheet, sheet
   END

   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet(0) = sheet

   Handle_Value, __sheet, _sheet, /NO_COPY, /SET
   Handle_Free, __sheet

END
