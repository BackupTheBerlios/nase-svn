;+
; NAME:
;  DefineSheet()
;
; VERSION:
;  $Id$
; 
; AIM:
;  Define a structure for device independent graphics output.
;
; PURPOSE:
;  This routine is used to define a structure for device independent
;  graphics output, a so called sheet. Sheets come in three different
;  types: windows-, postscript- and null-sheets. The idea behind this
;  is that if the user wants his output to be written in a postscript
;  file instead of a window on the screen, only the definition of the
;  sheet type has to be modified while all other graphics output
;  routines are left unchanged. In case that graphics output has to be
;  totally suppressed, the null sheet can be used.
;  Thus, sheets are a substitution for IDL's own Window-, Set_Plot-
;  and Device-calls.<BR>
;  Sheets encapsulate their individual important plotting parameters by
;  saving the system variables !X, !Y, and !P internally.
;  For window-Sheets on a truecolor-display, the current colortable is
;  saved as well. Upon opening a sheet, the current values are saved,
;  and the sheet's private values are set. Upon closing the sheet,
;  it's private values are stored, and the values are reset to the
;  state they were before opening the sheet.<BR>
;
;  Since version 2.15, sheets may also be used as child-widgets in
;  widget applications.
;
; CATEGORY:
;  Graphic
;  Windows
;
; CALLING SEQUENCE:   
;* sheet = DefineSheet( [ parent ]
;*                     [{,/WINDOW | ,/PS [,/ENCAPSULATED] | ,/PDF ,/NULL}] [,MULTI=...]
;*                     [PRODUCER=...]
;*                     [,/INCREMENTAL] [,/VERBOSE]
;*                     [,/PRIVATE_COLORS]
;*                     (,OPTIONS)* )
;
; OPTIONAL INPUTS: 
;  parent:: An ID of the widget that is intended to become the parent
;           widget of the sheet to be created.
;
; INPUT KEYWORDS: 
;  WINDOW:: The graphics will be shown in a window on the screen.
;  PS:: The graphics will be saved as a file in postscript format.
;  ENCAPSULATED:: If specified together with PS, the postscript will be encapsulated.
;  PDF:: An encapsulated postscript will be generated, which is
;        converted to a PDF after closing. The program used for eps to
;        pdf conversion can be specified in the system variable
;        !EPS2PDF_CONVERTER. (Default value: 'epstopdf')
;  NULL:: No graphics will be shwon at all.
;  MULTI:: This is the equivalent to IDL's !P.MULTI. Several small
;          sheets can be shown inside the same window frame. This
;          option only makes sense when used with window-type
;          sheets. For detaisl on the multi-parameter see
;          <A>ScrollIt()</A>. If MULTI is set, the output of
;          <C>DefineSheet()</C> is an array of sheet handles.
;  PRODUCER:: This may be used to pass information about the routine
;             that generated the graphics to the sheet
;             structure. <A>CloseSheet</A> will then print this info
;             in the lower left corner of the sheet together with date
;             and time. <*>producer</*>
;             is allowed to be an arbitrary string, but the special
;             value '/CALLER' also exists, which prints the name of
;             the routine that called <A>CloseSheet</A> so that it is
;             easier to trace back which program generated a certain
;             graphics output. Default: <*>producer=''</*>. 
;  INCREMENTAL:: This option works in PS-type sheets. If the same
;                sheet is reopened and graphics output it repeatedly
;                sent to this sheet, INCREMENTAL actually results in
;                opening new files with an index added to the
;                filename. Otherwise, new graphics overwrite the old output.
;  VERBOSE:: <C>DefineSheet()</C> starts to babble.
;  PRIVATE_COLORS:: Set this option to have the widgets monitor
;                   tracking events, and set their private color map
;                   each time the mouse pointer enters. 
;                   This does only make sense for
;                   window-sheets. The option is passed to
;                   <A>ScrollIt()</A> and causes the sheet to compute
;                   tracking events, i.e. the colormap is set
;                   correctly each time the mouse pointer enters the
;                   sheet window. See there for further details on this keyword.
;                   On non-pseudocolor
;                   displays (TrueColor, DirectColor), this option is ignored.
;  OPTIONS:: Options that are understood by the respective device can
;            be specified here.
;  X-windows: see IDL online help on <C>Window</C> or <A>ScrollIt()</A>, e.g.
;            <*>[XY]Title</*>, <*>[XY]Pos</*>, <*>[XY]Size</*>,
;            <*>RETAIN</*>, <*>TITLE</*>, <*>COLOR</*>,
;            <*>[XY]DrawSize</*>.<BR>
;  PS: see IDL online help on <C>Device</C>, e.g.
;          <*>/ENCAPSULATED</*>, <*>BITS_PER_PIXEL</*>, <*>/COLOR</*>,
;          <*>FILENAME</*>.
;
; OUTPUTS: 
;  sheet:: Handle on a structure that contains all necessary
;          information. This handle has to be passed to <A>OpenSheet</A>,
;          <A>CloseSheet</A> und <A>DestroySheet</A> later.
;
; RESTRICTIONS:
;  Note that the addition of a sheet or scrollit-widget to an existing
;  widget hierarchy causes IDL (version 5.0.2) to crash.<BR>
;  <BR>
;  <B>Note to the developer (Ruediger):</B>Note that in addition to
;  saving colortables in the sheet structure, the underlying
;  procedure <A>Scollit()</A>, too, saves the palette in the uvalue
;  of the draw widget for managing tracking events on
;  <I>pseudocolor</I> displays. The two should (hopefully) not
;  interfere. But probably, all pseudocolor-handling should be
;  completely removed, since pseudocolor display are not commonly
;  used any longer, and support could well be dropped. This would
;  also considerably clean up the code.<BR>
;
; EXAMPLE:
;* window_sheet = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500, COLORS=256)
;* ps_sheet1    = DefineSheet( /PS, /VERBOSE, /ENCAPSULATED, FILENAME='test')
;* ps_sheet2    = DefineSheet( /PS, /VERBOSE, /INCREMENTAL, FILENAME='test2')
;*
;* sheety = DefineSheet( /WINDOW, /VERBOSE, XSIZE=300, YSIZE=100, XPOS=500)
;* OpenSheet, sheety
;* Plot, Indgen(200)
;* CloseSheet, sheety
;* dummy = Get_Kbrd(1)
;* DestroySheet, sheety
;
; SEE ALSO: <A>ScrollIt</A>, <A>OpenSheet</A>, <A>CloseSheet</A>,
;           <A>DestroySheet</A>, <A>PSSheet()</A>
;-



FUNCTION DefineSheet, Parent, NULL=null, WINDOW=window, PS=ps, PDF=pdf $
                      , FILENAME=filename, INCREMENTAL=incremental $
                      , ENCAPSULATED=encapsulated, COLOR=color $
                      ,VERBOSE=verbose, MULTI=multi, PRODUCER=producer $
                      , PRIVATE_COLORS=private_colors, _EXTRA=e

   COMMON Random_Seed, seed
   COMMON ___SHEET_KILLS, sk

   Default, Parent, -1
   Default, multi, 0
   Default, private_colors, 0
   Default, producer, ''

   ;; PDF implies generation of an eps:
   If Keyword_Set(PDF) then begin
      PS = 1
      ENCAPSULATED = 1
   EndIf

   IF NOT SET(sk) THEN BEGIN
      sk = BytArr(128)
   END

   IF NOT Keyword_Set(PS) AND NOT Keyword_Set(WINDOW) AND NOT Keyword_SET(NULL) THEN Window = 1
   Default, e, -1

   IF Keyword_Set(WINDOW) THEN BEGIN
      
      IF Keyword_Set(VERBOSE) THEN Console, /MSG, 'Defining a new window.'
      
      UTVLCT, /GET, Red, Green, Blue
      sheet = { type  : 'X'   ,$;;meaning it is a window (X or WIN Device)
                $               ;no longer in here, since scrollits may
                $               ;not be realized at once:
                $               ;winid : -2l    ,$
                widid : -2l    ,$
                drawid : -2l    ,$
                MyPalette: {R: Red, G: Green, B: Blue}, $
                p     : !P    ,$
                x     : !X    ,$
                y     : !Y    ,$
                z     : !Z    ,$
                nonecolorname:  !NONECOLORNAME, $
                abovecolorname: !ABOVECOLORNAME, $
                belowcolorname: !BELOWCOLORNAME, $
                producer: producer ,$
                multi : multi ,$
                extra : e     ,$ 
                private_colors : private_colors, $
                parent: Parent}
      

   END ELSE IF Keyword_Set(PS) THEN BEGIN

      Default, incremental, 0
      Default, encapsulated, 0
      Default, color, 1
      Default, pdf, 0

      IF NOT Keyword_Set(FILENAME) THEN filename = 'sheet_'+STRING([BYTE(97+25*RANDOMU(seed,10))])
      
      IF Keyword_Set(VERBOSE) THEN BEGIN
         Console, /MSG, 'Defining a new postscript:'
         IF encapsulated THEN ty = 'eps' ELSE ty = 'ps'
         IF incremental  THEN tz = ', incremental' ELSE tz = ''
         Console, /MSG, '   Type:     '+Str(ty)+Str(tz)
         Console, /MSG, '   Filename: '+filename+'.'+Str(ty)
         If keyword_set(PDF) then $
           Console, /MSG, "   After closing, the file will be converted " + $
                    "to PDF using this command: "+!EPS2PDF_CONVERTER
      END

      IF TypeOf(E) EQ "STRUCT" THEN BEGIN
          IF NOT ExtraSet(e, "BITS_PER_PIXEL") THEN SetTag, e, "BITS_PER_PIXEL", 8
      END ELSE BEGIN
          e = {BITS_PER_PIXEL : 8}
      END
      uSet_Plot, 'ps'      
      UTVLCT, /GET, Red, Green, Blue
      sheet = { type     : 'ps'         ,$
                filename : filename     ,$ ;contains the filepath prototype 
                curfile  : ''           ,$ ;stores the current filename if there is one  
                inc      : incremental  ,$
                eps      : encapsulated ,$
                pdf      : pdf         , $
                color    : color        ,$
                MyPalette: {R: Red, G: Green, B: Blue}, $
                p        : !P           ,$
                x        : !X           ,$
                y        : !Y           ,$
                z        : !Z           ,$
                nonecolorname:  !NONECOLORNAME, $
                abovecolorname: !ABOVECOLORNAME, $
                belowcolorname: !BELOWCOLORNAME, $
                producer: producer ,$
                multi    : multi        ,$
                extra    : e            ,$
                open     : 0 }
      uSet_Plot, ScreenDevice()

   END ELSE IF Keyword_Set(NULL) THEN BEGIN
     
      sheet = { type : 'NULL' , $
                     producer: producer       }
      
   END

   If keyword_set(multi) then sheet = replicate(sheet, multi(0))

   ;;create Handle on sheet:
   sheethandle =  Handle_Create(VALUE=sheet)
   
   ;;Child-Window-Sheets must be opened once to become part of the Parent widget!
   If Keyword_set(WINDOW) and (Parent ne -1) then begin
      If Keyword_set(VERBOSE) then $
        Console, /MSG, "Adding sheet to parent widget."
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
