;+
; NAME:               DefineSheet
;
; PURPOSE:            Definiert ein Window-,PS-Sheet oder Null-Sheet.
;                     Diese Routine und ihre Verwandten OpenSheet, CloseSheet, DestroySheet dienen als
;                     Ersatz fuer Window-, Set_Plot- und Device-Aufrufe und sollen eine "aquivalente 
;                     Behandlungsweise von Window- und PS-Output ermoeglichen. DefineSheet definiert das
;                     Ausgabemedium (mit Optionen). Moechte man einen Bildschirm-Plot nun als PS in ein
;                     File schicken muss man nur diesen Aufruf aendern, alles andere bleibt gleich.
;                     Benutzt man dann noch die U-Routinen (UTvScl, ULoadCt,...) dann ist man voellig
;                     device-unabhaengig.
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   Sheet = DefineSheet( [{,/WINDOW | ,/PS| ,/NULL}] [,MULTI=Multi_Array]
;                                          [,/INCREMENTAL] [,/VERBOSE] (,OPTIONS)*
;
; KEYWORD PARAMETERS: WINDOW     : Das Sheet wird auf dem Bildschirm dargestellt
;                     PS         : Das Sheet wird als PS in ein File gespeichert.
;                     NULL       : Das Sheet unterdrueckt jegliche Ausgabe
;                     MULTI      : Nur sinnvoll bei WINDOW. Mehrere "Sheetchen" in einem Fensterrahmen.
;                                  Beschreibung des MULTI-Parameters s. <A HREF="#SCROLLIT">ScrollIt()</A>.
;                                  Wenn angegeben, ist das Ergebnis von DefineSheet ein MultiSheet (Array von Sheets).
;                     INCREMENTAL: Nur sinnvoll bei PS. Mit CloseSheet wird das entsprechende
;                                  File geschlossen. Malt man nun mehrmals in ein Sheet gibt es 
;                                  zwei Moeglichkeit auf PS damit umzugehen. Entweder wird das
;                                  alte File immer wieder ueberschrieben, oder ein neues File
;                                  wird angelegt. Dies macht die Option INCREMENTAL; der Filename
;                                  wird dabei um einen laufenden Index erweitert.
;                     VERBOSE    : DefineSheet wird gespraechig...
;                     OPTIONS    : Alle Optionen die das jeweilige Device versteht sind erlaubt.
;                                  X-Fenster: siehe Hilfe von Window oder <A HREF="#SCROLLIT">ScrollIt()</A>, z.B.
;                                              [XY]Title, [XY]Pos, [XY]Size, RETAIN, TITLE, COLORS,
;                                              [XY]DrawSize
;                                  PS       : siehe Hilfe von Device, z.B.
;                                              /ENCAPSULATED, BITS_PER_PIXEL, /COLOR, FILENAME
;
; OUTPUTS:            Sheet: eine Struktur, die alle Sheet-Informationen enthaelt und an OpenSheet,
;                            CloseSheet und DestroySheet uebergeben wird.
;
; EXAMPLE:
;                     window_sheet = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500, COLORS=256)
;                     ps_sheet1    = DefineSheet( /PS, /VERBOSE, /ENCAPSULATED, FILENAME='test')
;                     ps_sheet2    = DefineSheet( /PS, /VERBOSE, /INCREMENTAL, FILENAME='test2')
;
;                     sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;                     OpenSheet, sheety
;                     Plot, Indgen(200)
;                     CloseSheet, sheety
;                     dummy = Get_Kbrd(1)
;                     DestroySheet, sheety
;
; SEE ALSO: <A HREF="#SCROLLIT">ScrollIt()</A>,
;           <A HREF="#OPENSHEET">OpenSheet</A>, <A HREF="#CLOSESHEET">CloseSheet</A>,<A HREF="#DESTROYSHEET">DestroySheet</A>.
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.8  1998/05/18 18:25:10  kupper
;            Multi-Sheets implementiert!
;
;     Revision 2.7  1998/03/19 10:45:56  saam
;           now uses ScrollIt and remembers destroyed windows
;           resize events have no effect
;
;     Revision 2.6  1998/03/12 19:45:20  kupper
;            Color-Postscripts werden jetzt richtig behandelt -
;             die Verwendung von Sheets vorrausgesetzt.
;
;     Revision 2.5  1998/03/12 11:39:58  saam
;           Bug with window creation in idl5
;
;     Revision 2.4  1998/01/26 13:10:54  thiel
;            Erzeugt jetzt hoffentlich keine leeren Seiten mehr.
;
;     Revision 2.3  1998/01/21 21:57:25  saam
;           es werden nun ALLE (!!!) Window-Parameter
;           gesichert.
;
;     Revision 2.2  1997/12/02 10:08:08  saam
;           Sheets merken sich nun ihren persoenlichen
;           !P.Multi-Zustand; zusaetzlicher Tag: multi
;
;     Revision 2.1  1997/11/13 13:03:29  saam
;           Creation
;
;
;-
FUNCTION DefineSheet, NULL=null, WINDOW=window, PS=ps, FILENAME=filename, INCREMENTAL=incremental, ENCAPSULATED=encapsulated, COLOR=color $
                      ,VERBOSE=verbose, MULTI=multi, _EXTRA=e

   COMMON Random_Seed, seed
   COMMON ___SHEET_KILLS, sk

   Default, multi, 0

   IF NOT SET(sk) THEN BEGIN
      sk = BytArr(128)
   END

   IF NOT Keyword_Set(PS) AND NOT Keyword_Set(WINDOW) AND NOT Keyword_SET(NULL) THEN Window = 1
   Default, e, -1

   IF Keyword_Set(WINDOW) THEN BEGIN
      
      IF Keyword_Set(VERBOSE) THEN Print, 'Defining a new Window.'
      
      sheet = { type  : 'X'   ,$
                winid : -2l    ,$
                widid : -2l    ,$
                p     : !P    ,$
                x     : !X    ,$
                y     : !Y    ,$
                z     : !Z    ,$
                multi : multi ,$
                extra : e     }

      If keyword_set(multi) then sheet = replicate(sheet, multi(0))


   END ELSE IF Keyword_Set(PS) THEN BEGIN

      Default, incremental, 0
      Default, encapsulated, 0
      Default, color, 0

      IF NOT Keyword_Set(FILENAME) THEN filename = 'sheet_'+STRING([BYTE(97+25*RANDOMU(seed,10))])

      IF Keyword_Set(VERBOSE) THEN BEGIN
         Print, 'Defining a new Postscript:'
         IF encapsulated THEN ty = 'eps' ELSE ty = 'ps'
         IF incremental  THEN tz = ', incremental' ELSE tz = ''
         Print, '   Type:     ', ty, tz
         Print, '   Filename: ', filename+'.'+ty
      END
      
      Set_Plot, 'ps'      
      sheet = { type     : 'ps'         ,$
                filename : filename     ,$
                inc      : incremental  ,$
                eps      : encapsulated ,$
                color    : color        ,$
                p        : !P           ,$
                x        : !X           ,$
                y        : !Y           ,$
                z        : !Z           ,$
                extra    : e            ,$                
                open     : 0            }
      Set_Plot, 'X'

   END ELSE IF Keyword_Set(NULL) THEN BEGIN
     
      sheet = { type : 'NULL' }
      
   END


   RETURN, sheet
END
