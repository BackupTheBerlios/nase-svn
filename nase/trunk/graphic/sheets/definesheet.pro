;+
; NAME:
;  DefineSheet
;
; VERSION:
;  $Id$
; 
; AIM:
;  Define a structure for device independent graphics output.
;
; PURPOSE:
;  Definiert ein Window-,PS-Sheet oder Null-Sheet.
;  Diese Routine und ihre Verwandten OpenSheet, CloseSheet, DestroySheet dienen als
;  Ersatz fuer Window-, Set_Plot- und Device-Aufrufe und sollen eine äquivalente 
;  Behandlungsweise von Window- und PS-Output ermoeglichen. DefineSheet definiert das
;  Ausgabemedium (mit Optionen). Moechte man einen Bildschirm-Plot nun als PS in ein
;  File schicken muss man nur diesen Aufruf aendern, alles andere bleibt gleich.
;  Benutzt man dann noch die U-Routinen (UTvScl, ULoadCt,...) dann ist man voellig
;  device-unabhaengig.
;  Ein Sheet speichert außerdem wichtige Plotparameter (wie !X, !Y, !P, ...)
;  intern ab, so daß diese beim späteren Öffnen eines Sheets wieder restauriert werden.
;  Ab Revision 2.13 speichern die Sheets zusätzlich zu den Plotparametern auch
;  die verwendetet Farbtabelle ab.
;  Ab Revision 2.15 koennen Sheets auch Kind-Widgets in Widget-Applikationen sein.
;
; CATEGORY:
;  Graphic
;  Windows
;
; CALLING SEQUENCE:   
;*Sheet = DefineSheet( [ Parent ]
;*                     [{,/WINDOW | ,/PS| ,/NULL}] [,MULTI=Multi_Array]
;*                     [,/INCREMENTAL] [,/VERBOSE]
;*                     [,/PRIVATE_COLORS]
;*                     (,OPTIONS)* )
;
; OPTIONAL INPUTS: 
;  Parent:: Eine Widget-ID des Widgets, dessen Kind das 
;           neue Sheet-Widget werden soll.
;
; INPUT KEYWORDS: 
;  WINDOW::     Das Sheet wird auf dem Bildschirm dargestellt
;  PS::         Das Sheet wird als PS in ein File gespeichert.
;  NULL::       Das Sheet unterdrueckt jegliche Ausgabe
;  MULTI::      Nur sinnvoll bei WINDOW. Mehrere "Sheetchen" in einem Fensterrahmen.
;               Beschreibung des MULTI-Parameters s. <A HREF="../#SCROLLIT">ScrollIt()</A>.
;               Wenn angegeben, ist das Ergebnis von DefineSheet ein MultiSheet (Array von Sheets).
;  INCREMENTAL:: Nur sinnvoll bei PS. Mit CloseSheet wird das entsprechende
;                File geschlossen. Malt man nun mehrmals in ein Sheet gibt es 
;                zwei Moeglichkeit auf PS damit umzugehen. Entweder wird das
;                alte File immer wieder ueberschrieben, oder ein neues File
;                wird angelegt. Dies macht die Option INCREMENTAL; der Filename
;                wird dabei um einen laufenden Index erweitert.
;  VERBOSE::    DefineSheet wird gespraechig...
;  PRIVATE_COLORS:: Nur sinnvoll bei Windows. 
;                   Diese Option wird an ScrollIt weitergereicht. Das Sheet, bzw.
;                   jedes Sheetchen, verarbeitet dann Tracking-Events, dh, die Farbtabelle
;                   wird richtig gesetzt, wenn der Mauszeiger in das Widget weist.
;                   Das speichern der
;                   privaten Colormap wird von closesheet erledigt.
;                   Dieses Schlüsselwort wird auf nicht-Pseudocolor-Displays (TrueColor,
;                   DirectColor) ignoriert.
;  OPTIONS::    Alle Optionen die das jeweilige Device versteht sind erlaubt.
;  X-Fenster: siehe Hilfe von Window oder <A HREF="#SCROLLIT">ScrollIt()</A>, z.B.
;            [XY]Title, [XY]Pos, [XY]Size, RETAIN, TITLE, COLORS,
;            [XY]DrawSize
;  PS::          siehe Hilfe von Device, z.B.
;          /ENCAPSULATED, BITS_PER_PIXEL, /COLOR, FILENAME
;
; OUTPUTS:            Sheet:: eine Struktur, die alle Sheet-Informationen enthaelt und an OpenSheet,
;                            CloseSheet und DestroySheet uebergeben wird.
;
; RESTRICTIONS: Man beachte, dass das
;               Hinzufuegen eines Sheets/ScrollIts zu einer
;               bereits realisierten Widget-Hierarchie in der
;               aktuellen IDL-Version (5.0.2) unter KDE zu einem
;               astreinen IDL-Absturz fuehrt!
;
;
; EXAMPLE:
;*window_sheet = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500, COLORS=256)
;*ps_sheet1    = DefineSheet( /PS, /VERBOSE, /ENCAPSULATED, FILENAME='test')
;*ps_sheet2    = DefineSheet( /PS, /VERBOSE, /INCREMENTAL, FILENAME='test2')
;*
;*sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;*OpenSheet, sheety
;*Plot, Indgen(200)
;*CloseSheet, sheety
;*dummy = Get_Kbrd(1)
;*DestroySheet, sheety
;
; SEE ALSO: <A>ScrollIt</A>, <A>OpenSheet</A>, <A>CloseSheet</A>, <A>DestroySheet</A>
;
;-
FUNCTION DefineSheet, Parent, NULL=null, WINDOW=window, PS=ps, FILENAME=filename, INCREMENTAL=incremental, ENCAPSULATED=encapsulated, COLOR=color $
                      ,VERBOSE=verbose, MULTI=multi, PRIVATE_COLORS=private_colors, _EXTRA=e

   COMMON Random_Seed, seed
   COMMON ___SHEET_KILLS, sk

   Default, Parent, -1
   Default, multi, 0
   Default, private_colors, 0

   IF NOT SET(sk) THEN BEGIN
      sk = BytArr(128)
   END

   IF NOT Keyword_Set(PS) AND NOT Keyword_Set(WINDOW) AND NOT Keyword_SET(NULL) THEN Window = 1
   Default, e, -1

   IF Keyword_Set(WINDOW) THEN BEGIN
      
      IF Keyword_Set(VERBOSE) THEN Print, 'Defining a new Window.'
      
      sheet = { type  : 'X'   ,$;;meaning it is a window (X or WIN Device)
                $               ;no longer in here, since scrollits may
                $               ;not be realized at once:
                $               ;winid : -2l    ,$
                widid : -2l    ,$
                drawid: -2l    ,$ ;The id of the draw widget for saving of palette!
                p     : !P    ,$
                x     : !X    ,$
                y     : !Y    ,$
                z     : !Z    ,$
                multi : multi ,$
                extra : e     ,$ 
                private_colors : private_colors, $
                parent: Parent}
      

   END ELSE IF Keyword_Set(PS) THEN BEGIN

      Default, incremental, 0
      Default, encapsulated, 0
      Default, color, 1

      IF NOT Keyword_Set(FILENAME) THEN filename = 'sheet_'+STRING([BYTE(97+25*RANDOMU(seed,10))])
      
      IF Keyword_Set(VERBOSE) THEN BEGIN
         Print, 'Defining a new Postscript:'
         IF encapsulated THEN ty = 'eps' ELSE ty = 'ps'
         IF incremental  THEN tz = ', incremental' ELSE tz = ''
         Print, '   Type:     ', ty, tz
         Print, '   Filename: ', filename+'.'+ty
      END

      IF TypeOf(E) EQ "STRUCT" THEN BEGIN
          IF NOT ExtraSet(e, "BITS_PER_PIXEL") THEN SetTag, e, "BITS_PER_PIXEL", 8
      END ELSE BEGIN
          e = {BITS_PER_PIXEL : 8}
      END
      uSet_Plot, 'ps'      
      sheet = { type     : 'ps'         ,$
                filename : filename     ,$ ;contains the filepath prototype 
                curfile  : ''           ,$ ;stores the current filename if there is one  
                inc      : incremental  ,$
                eps      : encapsulated ,$
                color    : color        ,$
                p        : !P           ,$
                x        : !X           ,$
                y        : !Y           ,$
                z        : !Z           ,$
                multi    : multi        ,$
                extra    : e            ,$
                open     : 0 }
      uSet_Plot, ScreenDevice()

   END ELSE IF Keyword_Set(NULL) THEN BEGIN
     
      sheet = { type : 'NULL' }
      
   END

   If keyword_set(multi) then sheet = replicate(sheet, multi(0))

   ;;create Handle on sheet:
   sheethandle =  Handle_Create(VALUE=sheet)
   
   ;;Child-Window-Sheets must be opened once to become part of the Parent widget!
   If Keyword_set(WINDOW) and (Parent ne -1) then begin
      If Keyword_set(VERBOSE) then print, "Adding Sheet to Parent Widget."
      If keyword_set(MULTI) then begin
         opensheet, sheethandle, 0
         closesheet, sheethandle, 0
      Endif else begin
         opensheet, sheethandle
         closesheet, sheethandle
      Endelse
   EndIf
   
   RETURN, sheethandle
END
