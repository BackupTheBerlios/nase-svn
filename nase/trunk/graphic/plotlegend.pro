;+
; NAME:
;  PlotLegend
;
; VERSION:
;  $Id$
;
; AIM:
;  Add description of different lines to a plot.
;
; PURPOSE:
;  Add description of different lines to a plot by drawing an
;  annotation containing samples of the linestyles and colors with a
;  short text next to them.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* PlotLegend, xo, yo, texts
;*            [,LCOLORS=...][,TCOLORS=...]
;*            [,LSTYLES=...][,LSPREAD=...][,LLENGTH=...]
;*            [,SSTYLES=...]
;*            [,LTGAP=...][,TBASE=...]
;*            [,/BOX]
;*            [,BCOLOR=...][,BSEP=...][,BSTYLE=...][,BTHICK=...]
;*            [/DATA]
;
; INPUTS:
;  xo:: Left corner of annotation given in normal or data
;       coordinates. See switch <*>/DATA</*>.
;  yo:: Lower corner of annotation in normal or data coordinates. See
;       switch <*>/DATA</*>. 
;  texts:: Array of strings containing the descriptions starting with
;          the lowest line.
;
; INPUT KEYWORDS:
;  LCOLORS:: Scalar or array of color indices specifying the line
;            colors. If a scalar value is given, all lines get
;            this color. Default: <A>GetForeground()</A>.
;  TCOLORS:: Scalar or array of color indices specifying the color of
;            the text. If a scalar value is given, the whole text gets
;            this color. Default: <A>GetForeground()</A>.
;  LSTYLES:: Array of linestyle indices. Default: increasing index MOD
;            6.
;  SSTYLES:: Array of symbolstyle indices. Default is to omit symbols
;            at all. 
;  LSPREAD:: Spread between text lines in multiples of
;            charsize. Default: 1.0.
;  LLENGTH:: Length of the sample lines in normal
;            coordinates. Default: 0.1.
;  LTGAP:: Space between line ends and text beginning in multiples of
;          charsize. Default: 0.5
;  TBASE:: Offset between text baseline and sample lines in multiples
;          of charsize. Default: 0.3. As charheight in IDL is defined
;          as distance from baseline to baseline, this default results
;          in lines approximatelty centered in the middle of the
;          actual text.
;  BOX:: Draw a box around the annotation. Default: off.
;  BSEP:: Separation between box and text in normal
;         cordinates. Default: 0.01.
;  BCOLOR:: Color index used for drawing the box. Default: <A>GetForeground()</A>.
;  BSTYLE:: Box linestyle. Default: 0.
;  BTHICK:: Thickness of line used for drawing the box. Default: 1.0.
;  DATA:: Tells the routine to interpret the coordinates <*>xo</*> and
;         <*>yo</*> as
;         given in data ccordinates. Otherwise, they are interpreted
;         as normal coordinates. Supplying data coordinates may be
;         useful for positioning legends inside a particular plot when
;         working with <*>!P.MULTI</*>. 
;  
; RESTRICTIONS:
;  For <C>PlotLegend</C> to function properly, the plotting device
;  must have been established, e.g. by opening a window or of course
;  by actually plotting the data to be annotated.<BR>
;  If <*>LCOLORS</*> is set, it must have one element or the same
;  number of elements than <*>texts</*>. If <*>TCOLORS</*> is set, it
;  must have either one entry or the same number of elements than
;  <*>texts</*>.<BR>
;  The height of the box in computed using the assumption that the
;  chars used are approximately 1.5 times higher than wide. As of now,
;  there seems no possibility to determine this factor, since the
;  !D.Y_CH_SIZE gives only the linespacing, not the actual height of
;  chars. 
;  
; PROCEDURE:
;  + Determine charsize for given device.<BR>
;  + Calculate line positions.<BR>
;  + Plot lines.<BR>
;  + Calculate text positions.<BR>
;  + Print the text.<BR>
;
; EXAMPLE:
;* !P.CHARSIZE=3.
;* Plot,Indgen(100)
;* PlotLegend, 0.6,0.3,['foo','bar','baz'] $
;*  ,LCOLORS=[RGB('green'),RGB('yellow'),RGB('red')],TCOLORS=RGB('blue') $
;*  ,/BOX
;
; SEE ALSO:
;  <A>TVSclLegend</A>, <A>GetForeground()</A>.
;-

PRO PlotLegend, xo, yo, texts $
                , CHARSIZE=charsize $
                , LCOLORS=lcolors, TCOLORS=tcolors $
                , LSTYLES=lstyles $
                , SSTYLES=sstyles $
                , LSPREAD=lspread $
                , LLENGTH=llength $
                , LTGAP=ltgap $
                , TBASE=tbase $
                , BOX=box $
                , BCOLOR=bcolor, BSEP=bsep, BSTYLE=bstyle, BTHICK=bthick $
, DATA=data
   
   IF Keyword_Set(DATA) THEN BEGIN
      dummy = Convert_Coord([xo, yo], /DATA, /TO_NORMAL)
      xo = dummy[0]
      yo = dummy[1]
   ENDIF

   number = N_Elements(texts)

   ;; use user's charsize if supplied and !P's if its not 0.
   IF NOT Set(CHARSIZE) THEN $
    IF (!P.CHARSIZE NE 0.) THEN charsize=!P.CHARSIZE $
   ELSE charsize=1.

   Default, box, 0

   Default, lcolors, Make_Array(number, /INTEGER, VALUE=GetForeground())
   IF N_Elements(lcolors) EQ 1 THEN $
    lcolors = Make_Array(number, /INTEGER, VALUE=lcolors)
   Default, tcolors, Make_Array(number, /INTEGER, VALUE=GetForeground())
   IF N_Elements(tcolors) EQ 1 THEN $
    tcolors = Make_Array(number, /INTEGER, VALUE=tcolors)


   Default, ltgap, 0.5          ; gap between lines and text, charsize 
   Default, lspread, 1.0        ; separation between lines, charsize
   Default, tbase, 0.3          ; textbaseline relative to lines, charsize

   ;;xycharsizes in normal coordinates:
   csn = Convert_coord([!D.X_CH_SIZE, !D.Y_CH_SIZE] $
                       , /DEVICE, /TO_NORMAL)
   xcsn = charsize*csn(0) ; take device and user's charsize
   ycsn = charsize*csn(1)


   IF (SET(sstyles)) AND NOT (SET(lstyles)) THEN BEGIN
       ; symbols, but no lines

       Default, llength, 0.01           ; space reserved for symbols, normal
       Default, lstyles, Intarr(number) ; supress lines
       ;; Calculate symbol positions
       xpos = xo
       ypos = Rebin(lspread*ycsn*Indgen(number),number)+yo+ycsn*tbase
       
   END ELSE BEGIN
       ;; theres only 6 possible linestyles
       Default, lstyles, IndGen(number) MOD 6
       ;; symstyles default to NO_SYMBOL
       Default, llength, 0.1    ; length of lines, normal
       ;; Calculate line positions
       xpos = [0.0, llength]+xo
       ypos = Rebin(lspread*ycsn*Indgen(number),number,2)+yo+ycsn*tbase
   END

   ;; Plot lines and/or symbols
   FOR i=0, number-1 DO BEGIN
       ; this damn plots either plots symbols or lines ....
       PlotS, xpos, ypos(i,*), /NORMAL, LINESTYLE=lstyles(i), COLOR=lcolors(i)
       IF Set(sstyles) THEN PlotS, xpos, ypos(i,*), /NORMAL, PSYM=sstyles(i), COLOR=lcolors(i)
   ENDFOR

   ;; Calculate text positions
   xpos = Replicate(xo+llength,number)+ltgap*xcsn
   ypos = ypos(*,0)-ycsn*tbase

   maxwidth = 0.

   ;; Write text
   FOR i=0, number-1 DO BEGIN
      XYOutS, xpos(i), ypos(i), texts(i), /NORMAL, COLOR=tcolors(i) $
       , CHARSIZE=charsize, WIDTH=twidth
      maxwidth = Max([maxwidth, twidth])
   ENDFOR

   ;; Box?
   IF Keyword_Set(BOX) THEN BEGIN

      Default, bsep, 0.01       ; separation between box and text, normal
      Default, bcolor, GetForeground()
      Default, bstyle, 0        ; box linestyle
      Default, bthick, 1.       ; box linethick

      boxcorners = [[xo-bsep $
                     ,ypos(0)-bsep] $
                    ,[xo+maxwidth+llength+ltgap*xcsn+bsep $
                      ,ypos(0)-bsep] $
                    ,[xo+maxwidth+llength+ltgap*xcsn+bsep $
                      ,Last(ypos)+bsep+1.5*xcsn] $
                    ,[xo-bsep $
                      ,Last(ypos)+bsep+1.5*xcsn] $
                    ,[xo-bsep $
                      ,ypos(0)-bsep]]

      PlotS, boxcorners, /NORMAL, COLOR=bcolor, LINESTYLE=bstyle $
       , THICK=bthick
      
   ENDIF ;; Keyword_Set(BOX)



END
