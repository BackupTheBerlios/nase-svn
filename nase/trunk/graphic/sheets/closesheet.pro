;+
; NAME:              CloseSheet
;
; PURPOSE:           Schliesst ein mit OpenSheet geoeffnetes Sheet. Das bedeutet,
;                    dass das PS-File geschlossen wird.
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  CloseSheet, Sheet [,Multi-Index]
;
; INPUTS:            Sheet: eine mit DefineSheet definierte Sheet-Struktur
;
; OPTIONAL INPUTS:   Multi-Index: Bei MultiSheets (s. MULTI-Option von <A HREF="#DEFINESHEET">DefineSheet()</A>)
;                                 der Index des "Sheetchens", das geschlossen werden soll.
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
;           <A HREF="#DEFINESHEET">DefineSheet()</A>, <A HREF="#OPENSHEET">OpenSheet</A>,<A HREF="#DESTROYSHEET">DestroySheet</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.6  1999/02/12 15:22:52  saam
;           sheets are mutated to handles
;
;     Revision 2.5  1998/06/18 15:01:10  kupper
;            Hyperlings geupgedatet nach Veraenderigung der Verzeichnischtrugdur.
;
;     Revision 2.4  1998/05/18 18:25:10  kupper
;            Multi-Sheets implementiert!
;
;     Revision 2.3  1998/01/21 21:57:25  saam
;           es werden nun ALLE (!!!) Window-Parameter
;           gesichert.
;
;     Revision 2.2  1997/12/02 10:08:07  saam
;           Sheets merken sich nun ihren persoenlichen
;           !P.Multi-Zustand; zusaetzlicher Tag: multi
;
;     Revision 2.1  1997/11/13 13:03:28  saam
;           Creation
;
;
;-
PRO CloseSheet, __sheet, multi_nr

   Handle_Value, __sheet, _sheet, /NO_COPY

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet

   IF sheet.type EQ 'ps' OR sheet.type EQ 'X' THEN BEGIN 
      new = !P
      !P =  sheet.p
      sheet.p = new
      new = !X
      !X =  sheet.x
      sheet.x = new
      new = !Y
      !Y =  sheet.y 
      sheet.y = new
      new = !Z
      !Z =  sheet.z
      sheet.z = new
   END

   IF sheet.type EQ 'ps' THEN BEGIN
      IF  sheet.open THEN BEGIN
         Device, /CLOSE
         Set_Plot, 'X'
         sheet.open = 0
      END ELSE Print, 'CloseSheet: Sheet is not open!' 

   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      Set_Plot, 'X'
   END
      
   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet = sheet


   Handle_Value, __sheet, _sheet, /NO_COPY, /SET

END
