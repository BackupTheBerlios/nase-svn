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
;     Revision 2.1  1997/11/13 13:03:30  saam
;           Creation
;
;
;-
PRO OpenSheet, sheet

   IF sheet.type EQ 'X' THEN BEGIN
      Set_Plot, 'X'

      ; does window already exist?? then set it active
      UWSet, sheet.winid, exists
      
      ; create a new window
      IF NOT exists THEN BEGIN
         IF (SIZE(sheet.extra))(0) EQ 0 THEN BEGIN
            Window, /FREE
         END ELSE BEGIN
            Window, /FREE, _EXTRA=sheet.extra
         END
         sheet.winid = !D.Window
      END


   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      IF NOT sheet.open THEN BEGIN
         sheet.open = 1
         Set_Plot, 'ps'

         file = sheet.filename
         IF sheet.inc NE 0 THEN BEGIN
            file = file + '_' + STRCOMPRESS(STRING(sheet.inc), /REMOVE_ALL)
            sheet.inc = sheet.inc + 1
         END
         IF sheet.eps THEN file = file+'.eps' ELSE file = file+'.ps'

         IF sheet.extra EQ -1 THEN BEGIN
            Device, FILENAME=file, ENCAPSULATED=sheet.eps
         END ELSE BEGIN
            Device, FILENAME=file, ENCAPSULATED=sheet.eps, _EXTRA=sheet.extra
         END
      END ELSE Print, 'OpenSheet: Sheet already open!'
      
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      Set_Plot, 'NULL'
   END ELSE Message, 'no initialized sheet???'


END
