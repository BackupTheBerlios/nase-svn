



;+
; NAME:
;  CloseSheet
;
; VERSION:
;  $Id$
;
; AIM:
;  Close a sheet after finishing the graphics output.
;
; PURPOSE:
;  Schliesst ein mit <A>OpenSheet</A> geoeffnetes Sheet. Das bedeutet, dass
;  das PS-File geschlossen wird. Außerdem werden alle aktiven
;  Graphik-Settings in der Sheet-Struktur gespeichert.<BR>
;
;  Sofern bei <A>DefineSheet()</A> auch /PRIVATE_COLORS angegeben
;  wurde, wird die aktuelle Farbtabelle ebenfalls gespeichert (und
;  zwar im User-Value des Draw-Widgets, s. <A>ScrollIt()</A>). (Dieses
;  Verhalten kann im Einzelfall ueber das Schluesselwort SAVE_COLORS
;  beeinflusst werden.)
;
; CATEGORY:
;  Graphic
;  Widgets
;  Windows
;
; CALLING SEQUENCE:
;* CloseSheet, Sheet [,Multi-Index] [,/SAVE_COLORS] [,FILE=...]
;
; INPUTS:
;  Sheet:: eine mit <A>DefineSheet()</A> definierte Sheet-Struktur.
;
; OPTIONAL INPUTS:
;  Multi-Index:: Bei MultiSheets (s. MULTI-Option von
;                <A>DefineSheet()</A>) der Index des "Sheetchens", das
;                geschlossen werden soll.
;
; INPUT KEYWORDS:
;  SAVE_COLORS:: Default: gesetzt.
;                Hat nur Bedeutung für Windows-Sheets auf einem Truecolor-Display.
;                Standardmaessig
;                speichert <C>CloseSheet</C> hier die jeweils aktuelle
;                Farbtabelle mit den anderen Graphikdaten in der
;                Sheet-Struktur ab. In einigen Faellen (beispielsweise
;                bei haeufigen Graphik-Updates waehrend interaktiver
;                Usereingaben) ist es wuenschenswert, dieses Verhalten
;                zu unterdruecken. Durch explizite Angabe von
;                <*>SAVE_COLORS=0</*> wird die aktuelle Farbtabelle
;                beim Schliessen nicht abgespeichert. Beim naechsten
;                Oeffnen wird daher die zuletzt gespeicherte
;                Farbtabelle erneut gesetzt.
;
; OPTIONAL OUTPUTS:
;  FILE:: contains the filepath to file that has just been closed, when
;         using postscript sheet and is an empty string else.
;  
; PROCEDURE:
;  
;
; EXAMPLE:
;* sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;* OpenSheet, sheety
;* Plot, Indgen(200)
;* CloseSheet, sheety
;* dummy = Get_Kbrd(1)
;* DestroySheet, sheety
;
; SEE ALSO:
;  <A>ScrollIt</A>, <A>DefineSheet()</A>, <A>OpenSheet</A>, <A>DestroySheet</A>.
;-

PRO CloseSheet, __sheet, multi_nr, SAVE_COLORS=save_colors, FILE=file 

   On_Error, 2
   Default, save_colors, 1

   Handle_Value, __sheet, _sheet, /NO_COPY

   If Set(multi_nr) then sheet = _sheet(multi_nr) else sheet = _sheet

   ;; print info on producing routine in lower left corner
   IF sheet.producer NE '' THEN BEGIN
       IF sheet.producer EQ '/CALLER' THEN BEGIN
           Help, CALLS=c
           maxc = N_Elements(c)-1 ;; just in case it is called from the command line and c has only 1 element 
           calledby = (Split(c[1 < maxc],' <'))[0]
           out = calledby
       ENDIF ELSE BEGIN
           out = sheet.producer
       ENDELSE
       XYOutS, 0.5*!D.X_CH_SIZE, 1.5*!D.Y_CH_SIZE $
               , out, /DEVICE, CHARSIZE=0.75
       XYOutS, 0.5*!D.X_CH_SIZE, 0.5*!D.Y_CH_SIZE $
               , SysTime(), /DEVICE, CHARSIZE=0.75
   ENDIF


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
      new = !NONECOLORNAME
      !NONECOLORNAME = sheet.nonecolorname
      sheet.nonecolorname = new
      new = !ABOVECOLORNAME
      sheet.abovecolorname = new
      !ABOVECOLORNAME = sheet.abovecolorname
      new = !BELOWCOLORNAME
      !BELOWCOLORNAME = sheet.belowcolorname
      sheet.belowcolorname = new

   END

   If (sheet.type EQ 'X') and keyword_set(SAVE_COLORS) then begin

      WIDGET_CONTROL, sheet.DrawID, GET_UVALUE=draw_uval, /NO_COPY

                                ;get current palette and Save it in Draw-Widget's UVAL:
      UTVLCT, /GET, Red, Green, Blue
      draw_uval.MyPalette.R = Red
      draw_uval.MyPalette.G = Green
      draw_uval.MyPalette.B = Blue

                                ;reset old palette:
      UTVLCT, draw_uval.YourPalette.R, draw_uval.YourPalette.G, draw_uval.YourPalette.B
    
      WIDGET_CONTROL, sheet.DrawID, SET_UVALUE=draw_uval, /NO_COPY      

   EndIf

   IF sheet.type EQ 'ps' THEN BEGIN
      IF  sheet.open THEN BEGIN
          FILE = sheet.curfile ; return the filename to the user if he likes to
          sheet.curfile=''
          Device, /CLOSE
          uSet_Plot, ScreenDevice()
          sheet.open = 0
          ;; PDF conversion:
          If Keyword_Set(sheet.pdf) then spawn, !EPS2PDF_CONVERTER+" "+FILE
      END ELSE Print, 'CloseSheet: Sheet is not open!' 

   END ELSE IF sheet.type EQ 'NULL' THEN BEGIN
      if Interactive() then  uSet_Plot, ScreenDevice()
   END
      
   If Set(multi_nr) then _sheet(multi_nr) = sheet else _sheet = sheet

   Handle_Value, __sheet, _sheet, /NO_COPY, /SET

END
