;+
; NAME:              CloseSheet
;
; AIM:
;  Close a sheet after finishing the graphics output.
;
; PURPOSE:           Schliesst ein mit OpenSheet geoeffnetes Sheet. Das bedeutet,
;                    dass das PS-File geschlossen wird. Außerdem
;                    werden alle aktiven Graphik-Settings in der
;                    Sheet-Struktur gespeichert.
;
;                     Sofern bei definesheet
;                    auch /PRIVATE_COLORS angegeben wurde, 
;                    wird die aktuelle Farbtabelle ebenfalls
;                    gespeichert (und zwar im User-Value des
;                    Draw-Widgets, s. <A HREF="../#SCROLLIT">ScrollIt()</A>).
;                    (Dieses Verhalten kann im Einzelfall ueber das
;                    Schluesselwort SAVE_COLORS beeinflusst werden.)
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  CloseSheet, Sheet [,Multi-Index] [,SAVE_COLORS=0]
;
; INPUTS:            Sheet: eine mit DefineSheet definierte Sheet-Struktur
;
; OPTIONAL INPUTS:   Multi-Index: Bei MultiSheets (s. MULTI-Option von <A HREF="#DEFINESHEET">DefineSheet()</A>)
;                                 der Index des "Sheetchens", das
;                                 geschlossen werden soll.
;
; KEYWORDS:          SAVE_COLORS: Default: gesetzt.
;                                 Dieses Schluesselwort hat nur
;                                 Effekt, wenn bei <A HREF="#DEFINESHEET">DefineSheet()</A>
;                                 die Option /PRIVATE_COLORS angegeben 
;                                 wurde. Standardmaessig speichert
;                                 CloseSheet dann die jeweils aktuelle 
;                                 Farbtabelle mit den anderen
;                                 Graphikdaten in der Sheet-Struktur
;                                 ab. In einigen Faellen
;                                 (beispielsweise bei haeufigen
;                                 Graphik-Updates waehrend
;                                 interaktiver Usereingaben) ist es
;                                 wuenschenswert, dieses Verhalten zu
;                                 unterdruecken. Durch explizite
;                                 Angabe von SAVE_COLORS=0 wird die
;                                 aktuelle Farbtabelle beim Schliessen 
;                                 nicht abgespeichert. Beim naechsten
;                                 Oeffnen wird daher die zuletzt
;                                 gespeicherte Farbtabelle erneut gesetzt.
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
;     Revision 2.14  2000/11/02 09:25:07  gabriel
;          uset_plot instead of set_plot
;
;     Revision 2.13  2000/10/01 14:51:35  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.12  2000/08/31 10:23:28  kupper
;     Changed to use ScreenDevice() instead of 'X' in Set_Plot for platform independency.
;
;     Revision 2.11  2000/08/30 22:35:29  kupper
;     Changed Set_Plot, 'X' to Set_Plot, XorWIN().
;
;     Revision 2.10  1999/07/28 07:37:32  saam
;           + return on error
;
;     Revision 2.9  1999/06/16 12:51:11  kupper
;     Fixed minor programming bug caused by new .DrawID tag in PS-sheets.
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
;     Revision 2.7  1999/06/01 13:41:29  kupper
;     Scrollit wurde um die GET_DRAWID und PRIVATE_COLORS-Option erweitert.
;     Definesheet, opensheet und closesheet unterstützen nun das abspeichern
;     privater Colormaps.
;
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
PRO CloseSheet, __sheet, multi_nr, SAVE_COLORS=save_colors

   On_Error, 2
   Default, save_colors, 1

   Handle_Value, __sheet, _sheet, /NO_COPY

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet

   IF sheet.type EQ 'ps' OR sheet.type EQ 'X' THEN BEGIN ;it is PS or
                                                         ;a Window
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

   If (sheet.type EQ 'X') and keyword_set(SAVE_COLORS) then begin
                                ;get current palette and Save it in Draw-Widget's UVAL:
      WIDGET_CONTROL, sheet.DrawID, GET_UVALUE=draw_uval, /NO_COPY
      UTVLCT, /GET, Red, Green, Blue
      draw_uval.MyPalette.R = Red
      draw_uval.MyPalette.G = Green
      draw_uval.MyPalette.B = Blue
      WIDGET_CONTROL, sheet.DrawID, SET_UVALUE=draw_uval, /NO_COPY      
    
   EndIf

   IF sheet.type EQ 'ps' THEN BEGIN
      IF  sheet.open THEN BEGIN
         Device, /CLOSE
         uSet_Plot, ScreenDevice()
         sheet.open = 0
      END ELSE Print, 'CloseSheet: Sheet is not open!' 

   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      uSet_Plot, ScreenDevice()
   END
      
   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet = sheet


   Handle_Value, __sheet, _sheet, /NO_COPY, /SET

END
