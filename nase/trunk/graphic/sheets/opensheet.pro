;+
; NAME:
;  OpenSheet
;
; VERSION:
;  $Id$
; 
; AIM:
;  Opens a sheet for device-independent graphics output.
;
; PURPOSE:
;  Opens a sheet that was previously defined by
;  <A>DefineSheet()</A>. The corresponding window will be activated or
;  openend, if generating postscript output the file will be opened.
;
; CATEGORY:
;  Graphic
;  Windows
;
; CALLING SEQUENCE:  
;* OpenSheet, sheet [,multindex]
;
; INPUTS:
;  sheet:: defined sheet structure created using <A>DefineSheet</A>
;
; OPTIONAL INPUTS:   
;  multindex:: The index referring to a specific window in a multi
;               part sheet (see MULTI option of <A>DefineSheet()</A>).
;
; EXAMPLE:
;* sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;* OpenSheet, sheety
;* Plot, Indgen(200)
;* CloseSheet, sheety
;* dummy = Get_Kbrd(1)
;* DestroySheet, sheety
;
; SEE ALSO: <A>ScrollIt</A>,
;           <A>DefineSheet</A>, <A>CloseSheet</A>, <A>DestroySheet</A>.
;-

PRO OpenSheet, __sheet, multi_nr, SETCOL=setcol

   On_Error, 2
   Default, setcol, 1

   Handle_Value, __sheet, _sheet, /NO_COPY

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet

   IF sheet.type EQ 'X' THEN BEGIN ;this means it is a window (X or WIN)
     
      uSet_Plot, ScreenDevice()
     
      ; does window already exist?? then set it active
      exists = 0
      IF sheet.DrawID NE -2 THEN BEGIN
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
               _sheet(i-1).drawid = did(i-1)
            Endfor 
            sheet = _sheet(multi_nr)
         Endelse                ;multi
      END                       ;create new
      Widget_Control, sheet.DrawId, GET_VALUE=winid
      UWset, winid


      UTVLCT, /GET, Red, Green, Blue
      UTVLCT, sheet.MyPalette.R, sheet.MyPalette.G, sheet.MyPalette.B
      sheet.MyPalette = {R:Temporary(Red), G:Temporary(Green), B:Temporary(Blue)}

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

      old = !NONECOLORNAME
      !NONECOLORNAME = sheet.nonecolorname
      sheet.nonecolorname = old

      old = !ABOVECOLORNAME
      !ABOVECOLORNAME = sheet.abovecolorname
      sheet.abovecolorname = old

      old = !BELOWCOLORNAME
      !BELOWCOLORNAME = sheet.belowcolorname
      sheet.belowcolorname = old

      If keyword_set(SETCOL) and not(PseudoColor_Visual()) then begin
                                ;we've got a True-Color-Display, so
                                ;we have to set the private color
                                ;table.         
         
         WIDGET_CONTROL, sheet.DrawId, GET_UVALUE=draw_uval, /NO_COPY
         
                                ;save current palette:
         UTVLCT, /GET, Red, Green, Blue
         draw_uval.YourPalette.R = Red
         draw_uval.YourPalette.G = Green
         draw_uval.YourPalette.B = Blue

                                ;set private palette:
         UTVLCT, draw_uval.MyPalette.R, draw_uval.MyPalette.G, draw_uval.MyPalette.B

         WIDGET_CONTROL, sheet.DrawId, SET_UVALUE=draw_uval, /NO_COPY
      End

   END ELSE IF sheet.type EQ 'ps' THEN BEGIN
      uSet_Plot, 'ps'
      IF NOT sheet.open THEN BEGIN
         sheet.open = 1
         uSet_Plot, 'ps'

         file = sheet.filename
         IF Set(Multi_Nr) THEN file = file + '_' + STRCOMPRESS(Multi_nr, /REMOVE_ALL)

         IF sheet.inc NE 0 THEN BEGIN
            file = file + '_' + STRCOMPRESS(STRING(sheet.inc), /REMOVE_ALL)
            sheet.inc = sheet.inc + 1
         END
         IF sheet.eps THEN file = file+'.eps' ELSE file = file+'.ps'
         sheet.curfile = file

         IF (SIZE(sheet.extra))(0) EQ 0 THEN BEGIN
            Device, FILENAME=file, ENCAPSULATED=sheet.eps, COLOR=sheet.color
         END ELSE BEGIN
            Device, FILENAME=file, ENCAPSULATED=sheet.eps, COLOR=sheet.color, _EXTRA=sheet.extra
         END

         UTVLCT, /GET, Red, Green, Blue
         UTVLCT, sheet.MyPalette.R, sheet.MyPalette.G, sheet.MyPalette.B
         sheet.MyPalette = {R:Temporary(Red), G:Temporary(Green), B:Temporary(Blue)}

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

         old = !NONECOLORNAME
         !NONECOLORNAME = sheet.nonecolorname
         sheet.nonecolorname = old

         old = !ABOVECOLORNAME
         !ABOVECOLORNAME = sheet.abovecolorname
         sheet.abovecolorname = old

         old = !BELOWCOLORNAME
         !BELOWCOLORNAME = sheet.belowcolorname
         sheet.belowcolorname = old

         IF ((NOT !REVERTPSCOLORS) AND (TOTAL(CIndex2RGB(GetBackground()) NE [255,255,255]) NE .0)) THEN BEGIN
                                ; the user wants all colors as on the
                                ; screen in the postscript file. since
                                ; postscript always has a white
                                ; background, we plot a rectangle with
                                ; the background color by hand
             Polyfill, [0,0,1,1,0], [0,1,1,0,0], /NORMAL, COLOR=GetBackground()
             !P.MULTI(0) = MAX([1,(!P.MULTI)(1)*(!P.Multi)(2)]) ; prevent clearing of screen
         END
         
      END ELSE Console, /FATAL, 'postscript sheet is already open!'
      
      
   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      uSet_Plot, 'NULL'
      Plot, Indgen(10) ; to establish a coordinate system, that PlotS will work
   END ELSE Message, 'no initialized sheet???'

   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet = sheet

   Handle_Value, __sheet, _sheet, /NO_COPY, /SET

END
