;+
; NAME:              CloseSheet
;
; PURPOSE:           Schliesst ein mit OpenSheet geoeffnetes Sheet. Das bedeutet,
;                    dass das PS-File geschlossen wird.
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  CloseSheet, Sheet
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
;     Revision 2.2  1997/12/02 10:08:07  saam
;           Sheets merken sich nun ihren persoenlichen
;           !P.Multi-Zustand; zusaetzlicher Tag: multi
;
;     Revision 2.1  1997/11/13 13:03:28  saam
;           Creation
;
;
;-
PRO CloseSheet, sheet

   IF sheet.type EQ 'ps' THEN BEGIN
      IF  sheet.open THEN BEGIN
         Device, /CLOSE
         Set_Plot, 'X'
         sheet.open = 0
      END ELSE Print, 'CloseSheet: Sheet is not open!' 

      newMulti = !P.Multi
      !P.Multi =  sheet.multi
      sheet.multi = newMulti
      
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      Set_Plot, 'X'
   END

END
