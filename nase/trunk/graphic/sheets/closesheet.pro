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
; PURPOSE:           Schliesst ein mit OpenSheet geoeffnetes Sheet. Das bedeutet,
;                    dass das PS-File geschlossen wird. Auﬂerdem
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
; CATEGORY:
;  Graphic
;  Windows
;
; CALLING SEQUENCE:
;*CloseSheet, Sheet [,Multi-Index] [,SAVE_COLORS=0]
;
; INPUTS:            Sheet:: eine mit DefineSheet definierte Sheet-Struktur
;
; OPTIONAL INPUTS:  Multi-Index:: Bei MultiSheets (s. MULTI-Option von <A HREF="#DEFINESHEET">DefineSheet()</A>)
;                                 der Index des "Sheetchens", das
;                                 geschlossen werden soll.
;
; INPUT KEYWORDS:         SAVE_COLORS:: Default: gesetzt.
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
; OPTIONAL OUTPUTS:
;  FILE:: contains the filepath to file that has just been closed, when
;         using postscript sheet and is an empty string else.
;
; EXAMPLE:
;*sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;*OpenSheet, sheety
;*Plot, Indgen(200)
;*CloseSheet, sheety
;*dummy = Get_Kbrd(1)
;*DestroySheet, sheety
;
; SEE ALSO: <A>ScrollIt</A>,
;           <A>DefineSheet</A>, <A>OpenSheet</A>, <A>DestroySheet</A>
;-

PRO CloseSheet, __sheet, multi_nr, SAVE_COLORS=save_colors, FILE=file 

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
          FILE = sheet.curfile ; return the filename to the user if he likes to
          sheet.curfile=''
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
