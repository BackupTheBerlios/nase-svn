;+
; NAME:              OpenSheet
;
; PURPOSE:           Oeffnet ein mit DefineSheet definiertes Sheet. Das bedeutet,
;                    dass das Fenster aktiviert oder geoeffnet bzw das PS-File
;                    geoeffnet wird.
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  OpenSheet, Sheet
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
;     Revision 2.9  1998/03/19 14:50:30  saam
;           common block like in define-sheet
;
;     Revision 2.8  1998/03/19 10:45:57  saam
;           now uses ScrollIt and remembers destroyed windows
;           resize events have no effect
;
;     Revision 2.7  1998/03/18 10:48:55  kupper
;            Kleiner Bug: Opensheet hat das Plot_Device nicht auf PS gesetzt, wenn
;             ein zuvor schonmal geöffnetes PS-heet wieder geöffnet wurde.
;
;     Revision 2.6  1998/03/12 19:45:20  kupper
;            Color-Postscripts werden jetzt richtig behandelt -
;             die Verwendung von Sheets vorrausgesetzt.
;
;     Revision 2.5  1998/01/29 15:52:04  saam
;           PlotS died with NULL-device if plot wasn't used before
;          !P.Multi also...
;
;     Revision 2.4  1998/01/21 21:57:26  saam
;           es werden nun ALLE (!!!) Window-Parameter
;           gesichert.
;
;     Revision 2.3  1997/12/02 10:08:08  saam
;           Sheets merken sich nun ihren persoenlichen
;           !P.Multi-Zustand; zusaetzlicher Tag: multi
;
;     Revision 2.2  1997/11/26 09:28:48  saam
;           Weiss leider nicht mehr, was veraendert wurde
;
;     Revision 2.1  1997/11/13 13:03:30  saam
;           Creation
;
;
;-
PRO _sheetkilled, id

   COMMON ___SHEET_KILLS, sk

   Widget_Control, id, GET_UVAL=uval
   
   IF sk(uval.Window_ID) NE 0 THEN Message, 'Sheet already killed !'
   IF uval.Window_ID GT 128 THEN Message, 'WinID > 128 !'

   sk(uval.Window_ID) = 1
END




PRO OpenSheet, sheet

   COMMON ___SHEET_KILLS, sk

   IF sheet.type EQ 'X' THEN BEGIN
      Set_Plot, 'X'

      ; does window already exist?? then set it active
      exists = 0
      IF sheet.winid NE -2 THEN BEGIN
         IF sk(sheet.winid) EQ 0 THEN UWSet, sheet.winid, exists
      END
      
      ; create a new window
      IF NOT exists THEN BEGIN
         IF (SIZE(sheet.extra))(0) EQ 0 THEN BEGIN
            sheet.winid = ScrollIt(GET_BASE=tid, KILL_NOTIFY='_sheetkilled')
         END ELSE BEGIN
            sheet.winid = ScrollIt(Get_BASE=tid, KILL_NOTIFY='_sheetkilled', _EXTRA=sheet.extra)
         END
         sheet.widid = tid
         sk(sheet.winid) = 0
      END
      old = !P
      !P = sheet.p
      sheet.p = old
      old = !X
      !X = sheet.x
      sheet.x = old
      old = !Y 
      !Y = sheet.y
      sheet.y = old
      old = !Z
      !Z = sheet.z
      sheet.z = old

   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      Set_Plot, 'ps'
      IF NOT sheet.open THEN BEGIN
         sheet.open = 1
         Set_Plot, 'ps'

         file = sheet.filename
         IF sheet.inc NE 0 THEN BEGIN
            file = file + '_' + STRCOMPRESS(STRING(sheet.inc), /REMOVE_ALL)
            sheet.inc = sheet.inc + 1
         END
         IF sheet.eps THEN file = file+'.eps' ELSE file = file+'.ps'

         IF (SIZE(sheet.extra))(0) EQ 0 THEN BEGIN
            Device, FILENAME=file, ENCAPSULATED=sheet.eps, COLOR=sheet.color
         END ELSE BEGIN
            Device, FILENAME=file, ENCAPSULATED=sheet.eps, COLOR=sheet.color, _EXTRA=sheet.extra
         END
      END ELSE Message, /INFORM, 'OpenSheet: PS-Sheet already open!'
      
      old = !P
      !P = sheet.p
      sheet.p = old
      old = !X
      !X = sheet.x
      sheet.x = old
      old = !Y 
      !Y = sheet.y
      sheet.y = old
      old = !Z
      !Z = sheet.z
      sheet.z = old
      
      !PSGREY = NOT(sheet.color)
      
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      Set_Plot, 'NULL'
      Plot, Indgen(10) ; to establish a coordinate system, that PlotS will work
   END ELSE Message, 'no initialized sheet???'


END
