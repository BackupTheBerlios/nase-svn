;+
; NAME:              OpenSheet
;
; PURPOSE:           Öffnet ein mit DefineSheet definiertes Sheet. Das bedeutet,
;                    dass das Fenster aktiviert oder geoeffnet bzw das PS-File
;                    geoeffnet wird.
;
; CATEGORY:          GRAPHIC
;
; CALLING SEQUENCE:  OpenSheet, Sheet [,Multi-Index]
;
; INPUTS:            Sheet: eine mit DefineSheet definierte Sheet-Struktur
;
; OPTIONAL INPUTS:   Multi-Index: Bei MultiSheets (s. MULTI-Option von <A HREF="#DEFINESHEET">DefineSheet()</A>)
;                                 der Index des "Sheetchens", das geöffnet werden soll. Befindet sich das MultiSheet
;                                 noch nicht auf dem Bildschirm, so wird es dargestellt.
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
;           <A HREF="#DEFINESHEET">DefineSheet()</A>, <A HREF="#CLOSESHEET">CloseSheet</A>,<A HREF="#DESTROYSHEET">DestroySheet</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.21  2000/07/07 13:38:49  gabriel
;          !REVERTPSCOLORS=0 for color postscript
;
;     Revision 2.20  1999/10/29 11:49:16  kupper
;     Setting Colortables using UTVSCL is VERY SLOW over the net, when
;     a TRUE_COLOR-Display is used.
;     Reason? (The DEVICE, BYPASS_TRANLATION-Commands???)
;
;     Revision 2.19  1999/10/28 16:16:03  kupper
;     Color-Management with sheets was not correct on a
;     true-color-display.
;     (Table was not set when the sheet was opened).
;     We now do different things for pseudocolor and
;     truecolor-displays, to make them "feel" alike... (hopefully).
;
;     Revision 2.18  1999/08/16 16:47:08  thiel
;         Change to activate File-Watching.
;
;     Revision 2.17  1999/07/28 08:14:07  saam
;          return on error
;
;     Revision 2.16  1999/06/15 17:36:39  kupper
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
;     Revision 2.15  1999/06/01 13:41:29  kupper
;     Scrollit wurde um die GET_DRAWID und PRIVATE_COLORS-Option erweitert.
;     Definesheet, opensheet und closesheet unterstützen nun das abspeichern
;     privater Colormaps.
;
;     Revision 2.14  1999/02/12 15:22:52  saam
;           sheets are mutated to handles
;
;     Revision 2.13  1998/06/18 14:56:14  kupper
;            nur Hyperlink nach Umstellung der Verzeichnisstruktur angepasst.
;
;     Revision 2.12  1998/06/03 10:30:55  saam
;           now ps works with multi
;
;     Revision 2.11  1998/05/18 18:25:11  kupper
;            Multi-Sheets implementiert!
;
;     Revision 2.10  1998/03/20 16:45:22  thiel
;            Weitere 3.6/4-Inkompatibilitaet beim
;            GET_BASE-Aufruf behoben.
;
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

;PRO _sheetkilled, id            ;This is only called for Top-Level-Sheets,
;                                ;not for Sheets that belong to a Parent Widget.

;   COMMON ___SHEET_KILLS, sk

;   Widget_Control, id, GET_UVAL=uval;Get user-value of scrollit-draw-widget.
   
;   IF uval.Window_ID GT 128 THEN Message, 'WinID > 128 !'
;   IF sk(uval.Window_ID) NE 0 THEN Message, 'Sheet already killed !'

;   sk(uval.Window_ID) = 1
;END


PRO OpenSheet, __sheet, multi_nr, SETCOL=setcol

   COMMON ___SHEET_KILLS, sk

   On_Error, 2
   Default, setcol, 1

   Handle_Value, __sheet, _sheet, /NO_COPY

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet

   IF sheet.type EQ 'X' THEN BEGIN
      Set_Plot, 'X'

      ; does window already exist?? then set it active
      exists = 0
;      IF sheet.winid NE -2 THEN BEGIN
      IF sheet.DrawID NE -2 THEN BEGIN
;         IF sk(winid) EQ 0 THEN begin ;Sheet is not killed
         If Widget_Info(sheet.DrawID, /VALID_ID) then begin;Sheet is not killed
            Widget_Control, sheet.DrawID, /REALIZE
            Widget_Control, sheet.DrawID, GET_VAL=winid
            UWSet, winid, exists
         Endif
      END
      ; create a new window
      IF NOT exists THEN BEGIN
         tid = 23               ;muss fuer IDL 3.6 vor dem GET_BASE-Aufruf definiert werden, Wert ist egal.
         did = 23               ;muss fuer IDL 3.6 vor dem GET_BASE-Aufruf definiert werden, Wert ist egal.
         If not set(multi_nr) then begin
            IF (SIZE(sheet.extra))(0) EQ 0 THEN BEGIN
               If (sheet.parent ne -1) $
                then dummy = ScrollIt(sheet.parent, GET_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did) $
               else dummy = ScrollIt(GET_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did);, KILL_NOTIFY='_sheetkilled')
            END ELSE BEGIN
               If (sheet.parent ne -1) $
                then dummy = ScrollIt(sheet.parent, Get_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did, _EXTRA=sheet.extra) $
               else dummy = ScrollIt(Get_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did, _EXTRA=sheet.extra);, KILL_NOTIFY='_sheetkilled')
            END
            sheet.widid = tid
            sheet.DrawID = did
            If (sheet.parent eq -1) then begin ;Sheet is already realized, get winid for _sheetkilled
               Widget_Control, sheet.DrawID, GET_VALUE=winid
;               sk(winid) = 0
            Endif 
         Endif else begin       ;multi
            IF (SIZE(sheet.extra))(0) EQ 0 THEN BEGIN
               If (sheet.parent ne -1) $
                then dummy = ScrollIt(sheet.parent, GET_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did, MULTI=sheet.multi) $
               else dummy = ScrollIt(GET_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did, MULTI=sheet.multi);, KILL_NOTIFY='_sheetkilled')
            END ELSE BEGIN
               If (sheet.parent ne -1) $
                then dummy = ScrollIt(sheet.parent, Get_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did, MULTI=sheet.multi, _EXTRA=sheet.extra) $
               else dummy = ScrollIt(Get_BASE=tid, PRIVATE_COLORS=sheet.private_colors, GET_DRAWID=did, MULTI=sheet.multi, _EXTRA=sheet.extra);, KILL_NOTIFY='_sheetkilled')
            END
            for i=1, sheet.multi(0) do begin
               _sheet(i-1).widid = tid
               ;_sheet(i-1).winid = winids(i-1)
               _sheet(i-1).drawid = did(i-1)
;               If (sheet.parent eq -1) then begin ;Sheet is already realized, get winid for _sheetkilled
;                  Widget_Control, _sheet(i-1).drawid, GET_VALUE=winid
;                  sk(winid) = 0
;               Endif 
            Endfor 
            sheet = _sheet(multi_nr)
         Endelse                ;multi
      END                       ;create new
      Widget_Control, sheet.DrawId, GET_VALUE=winid
      UWset, winid
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

      If keyword_set(SETCOL) and not(PseudoColor_Visual()) then begin
                                ;we've got a True-Color-Display, so
                                ;we have to set the private color table:
         WIDGET_CONTROL, sheet.DrawId, GET_UVALUE=draw_uval
         UTVLCT, draw_uval.MyPalette.R, draw_uval.MyPalette.G, draw_uval.MyPalette.B 
      End

   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      Set_Plot, 'ps'
      IF NOT sheet.open THEN BEGIN
         sheet.open = 1
         Set_Plot, 'ps'

         file = sheet.filename
         IF Set(Multi_Nr) THEN file = file + '_' + STRCOMPRESS(Multi_nr, /REMOVE_ALL)

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

      ; color tables shouldn't be reverted
      !REVERTPSCOLORS = NOT(sheet.color)

   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      Set_Plot, 'NULL'
      Plot, Indgen(10) ; to establish a coordinate system, that PlotS will work
   END ELSE Message, 'no initialized sheet???'

   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet = sheet

   Handle_Value, __sheet, _sheet, /NO_COPY, /SET

END
