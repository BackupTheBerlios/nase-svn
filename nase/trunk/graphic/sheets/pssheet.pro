;+
; NAME:
;  PSSheet()
;
; VERSION:
;  $Id$
;
; AIM:
;  Generate a sheet structure for EPS output.
;
; PURPOSE:
;  Generate a sheet structure for EPS output. The main puprpose is to
;  ensure that plots have a similar look and characters are always
;  the same size no matter how <*>!P.MULTI</*> is set. In addition,
;  postscript or truetype fonts are used instead of ugly vector fonts.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*result = PSSheet( [FILENAME=...][,MULTI=...]
;*                  [,XMARGIN=...][,YMARGIN=...]
;*                  [,XOMARGIN=...][,YOMARGIN=...]
;*                  [,XSIZE=...][,YSIZE=...]
;*                  [,CHARSIZE=...][,FONTTYPE=...]
;*                  [,PRODUCER=...] 
;*                  [,/VERBOSE] )
;
; INPUT KEYWORDS:
;  filename:: String that contains the name of the output file. Ending
;             ".eps" is added automatically. Default: 'printsheet'
;  multi:: Array for multiple plot information, see IDL's <*>!P.MULTI</*>
;          field.
;  xmargin, ymargin:: Two element arrays indicating margins around
;                     each plot, in units of charsize. Default:
;                     <*>xmargin=[7,1.5]</*>, <*>ymargin=[3,0.75]</*>.
;  xomargin, yomargin:: Two element arrays indicating outer margins
;                      around the whole sheet. Defaults:
;                      <*>xomargin=[0,0]</*>, <*>ymargin=[0,0]</*>.
;  xsize, ysize:: Size of the final EPS-Sheet, in centimeter
;                 units. Default: <*>xsize=21</*>. Default for
;                 <*>ysize</*> depends on setting of <*>MULTI</*>. For
;                 a single plot and two plots on top of each other, it
;                 is <*>0.5*(Sqrt(5.)-1)*xsize</*>. For three or more
;                 plots, it is <*>0.25*(Sqrt(5.)-1)*xsize</*> times
;                 the number of plots.
; charsize:: The size of the annotation chars. Note that this size is
;            <I>not</I> reduced as in normal IDL when more than 2
;            plots appear on the sheet. Default: 1.8.
; fonttype:: A string specifying the desired type of font used on the
;            sheet. This can either be 'tt' for truetype fonts and
;            'ps' for postscript fonts. Default: 'ps'.
; producer:: A string that is printed at the bottom left of the
;            resulting EPS sheet. If <*>producer=''</*>, nothing is
;            printed. If <*>producer='foobar'</*>, "foobar" is printed
;            together with the current system time. A special value
;            is <*>'/CALLER'</*> which prints the name of the routine that
;            called the subsequent <A>CloseSheet</A> together with
;            systime. Default: <*>/CALLER</*>.
; /VERBOSE:: Print information into the console.
; 
; OUTPUTS:
;  result:: A handle that is connected to a EPS-sheet structure.
;  
; SIDE EFFECTS:
;  Some plot attributes are changed, which may influence subsequent
;  plots on the screen.  
;
; PROCEDURE:
;  Generate a sheet handle via <A>Definesheet()</A>, after setting the
;  attributes right.
;
; EXAMPLE:
;* pssh=PSSheet(FILE='demosheet',MULTI=[0,1,3,0,0],PRODUCER='demo')
;* OpenSheet, pssh
;* Plot, IndGen(10)
;* Plot, 10-IndGen(10)
;* Plot, IndGen(10)
;* CloseSheet, pssh
;
; SEE ALSO:
;  <A>DefineSheet()</A>, <A>OpenSheet()</A>, <A>CloseSheet()</A>
;-

FUNCTION PSSheet, FILENAME=filename, MULTI=multi $
                  , XMARGIN=xmargin, YMARGIN=ymargin $
                  , XOMARGIN=xomargin, YOMARGIN=yomargin $
                  , XSIZE=xsize, YSIZE=ysize $
                  , CHARSIZE=charsize, FONTTYPE=fonttype $
                  , PRODUCER=producer $ 
                  , VERBOSE=verbose

   Default, filename, 'printsheet'
   Default, multi, [0, 1, 1, 0, 0]
   Default, xmargin, [7, 1.5]
   Default, ymargin, [3, 0.75]
   Default, xomargin, [0, 0]
   Default, yomargin, [0, 0]
   Default, producer, '/CALLER'

   Default, xsize, 21. ;; 0.75\textwidth
   ;; xsize=24.5  0.875\textwidth
   Default, charsize, 1.8 ;; This results in annotation that is as large as 
   ;; \small in 12pt if output is scaled to 0.75\textwidth 

   Default, fonttype, 'ps'

   Default, verbose, 0

   cs = charsize 

   xs = 21.

   ;; y size is the same when one or two rows are displayed, 
   ;; but is increased proportionally if more than two are displayed 
   IF multi[2] LE 2 THEN BEGIN
      ys = 0.5*(Sqrt(5.)-1)*xs
   ENDIF ELSE BEGIN
      ys = multi(2)*0.25*(Sqrt(5.)-1)*xs
   ENDELSE

   ;; undo IDL !P.MULTI change of font size if either more than two
   ;; rows or columns are to be displayed 
   IF (multi[1] GT 2) OR (multi[2] GT 2) THEN BEGIN
      cs = 2.*cs
      IF Keyword_Set(VERBOSE) THEN Console, /MSG, 'Charsize modified.'
   ENDIF 

   Default, ysize, ys

   IF Keyword_Set(VERBOSE) THEN $
    Console, /MSG, 'Sheetsize: '+Str(xsize)+', '+Str(ysize)

   __sheet = DefineSheet(/PS, FILE=filename, /ENCAPS $
                        , XSIZE=xsize, YSIZE=ysize, PRODUCER=producer $
                        , VERBOSE=verbose)

   Handle_Value, __sheet, _sheet, /NO_COPY

   _sheet.P.MULTI = multi

   CASE fonttype OF 
      'ps': _sheet.P.FONT = 0 ;; this selects PS font
      'tt': _sheet.P.FONT = 1 ;; is true type
      ELSE:  Console, /FATAL, "Either select 'ps' or 'tt' font type."
   ENDCASE
;   Device, SET_FONT='Helvetica';, /TT_FONT, seems obsolete

   _sheet.p.CHARSIZE = cs

   _sheet.X.MARGIN = xmargin
   _sheet.Y.MARGIN = ymargin
   _sheet.X.OMARGIN = xomargin
   _sheet.Y.OMARGIN = yomargin

   _sheet.P.THICK = 4.
   _sheet.X.THICK = 4.
   _sheet.Y.THICK = 4.

   Handle_Value, __sheet, _sheet, /NO_COPY, /SET

   Return, __sheet

END
