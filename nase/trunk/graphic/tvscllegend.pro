;+
; NAME:
;  TVSclLegend
;
; VERSION:
;  $Id$
;
; AIM:
;  Display a legend indicating color coding, compatible to
;  <*>TVScl</*> routine.
;
; PURPOSE:
;  Generate horizontal or vertical legend indicating the color coding
;  in <*>TVScl</*> displays, independent of the plotting device.
;
; CATEGORY:
;  Color
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;* TvSclLegend, xnorm, ynorm 
;*  [,CHARSIZE=...]
;*  [,MAX=...] [,MID=...] [,MIN=...]
;*  [,COLOR=...]
;*  [,RANGE=...]
;*  [,/HORIZONTAL] [,/VERTICAL] 
;*  [,/LEFT] [,/RIGHT] 
;*  [,/CEILING] [,/BOTTOM]
;*  [,/NOSCALE]
;*  [,STRETCH=...] [,H_STRETCH=...] [,V_STRETCH=...]
;*  [,/CENTER]
;
; INPUTS:
;  xnorm:: X-position of legend's center in normal coordinates.
;  ynorm:: Y-position of legend's center in normal coordinates.
;
; INPUT KEYWORDS:
;  CHARSIZE:: Factor determining the charsize relative to the standard
;             size (1.0).
;  MAX,MID,MIN:: Strings or numbers used as labels for maximum, middle
;                and minimum legend value (default: <*>MAX=255</*>, <*>MID=''</*>, <*>MIN=0</*>)
;  COLOR:: Color used for drawing the legend's frame. If <*>COLOR</*>
;          is not set, a suitable color is chosen.
;  RANGE:: Set this keyword to a two-element array, containing the
;          lowest and the highest color index to use for the legend
;          color range. If omitted, the legend will span the whole
;          color table.
;  HORIZONTAL, VERTICAL:: Horizontal or vertical legend (default:
;                         horizontal).
;  LEFT, RIGHT:: Vertical legends may be labeled on left or right side
;                (default: right).
;  CEILING, BOTTOM:: Horizontal legends may be labeled on top or
;                    bottom (default: bottom).
;  NOSCALE:: Legend will not be scaled analogous to diplaying data
;            with the <*>TV</*> command. To give correct results,
;            <*>MIN</*> and <*>MAX</*> MUST BE SET!
;  STRETCH, H_STRETCH, V_STRETCH, CENTER:: See <A>UTVScl</A>.
;
; EXAMPLE:
;* TvSclLegend, 0.5, 0.5, /CENTER
;* TvSclLegend, 0.2, 0.2, MAX=10, MIN=-10, MID='Null', /VERTICAL, /LEFT 
;
; SEE ALSO: 
;  <A>UTvScl</A>.
;
;-
;       
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.17  2001/01/22 14:02:36  kupper
;     Changed color management to meet guidelines formed during the first
;     NASE workshop, fall 2000.
;     Pre-Checkin due to technical reasons. Headers not yet englishified...
;
;     Revision 2.16  2000/12/04 10:40:06  saam
;     replaced outdate getbgcolor call
;     updated doc header
;
;     Revision 2.15  2000/11/28 16:27:11  thiel
;         Just minor change in header.
;
;     Revision 2.14  2000/11/28 16:21:34  thiel
;         Header translation and debugging.
;
;     Revision 2.13  2000/11/02 14:04:26  gabriel
;          doc header modified; fgcolor bug eliminated
;
;     Revision 2.12  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.11  2000/09/08 12:45:00  kupper
;     Added RANGE keyword.
;
;     Revision 2.10  1999/06/06 14:44:33  kupper
;     Added documentation for COLOR-Keyword.
;
;     Revision 2.9  1998/06/10 13:44:49  kupper
;            Mal wieder Postscript-Farbverwirrung
;
;     Revision 2.8  1998/03/16 14:40:43  kupper
;            Schlüsselwort TOP ersetzt durch CEILING für Kompatibilität mit TVScl
;
;     Revision 2.7  1997/12/17 15:31:43  saam
;           Keyword NOSCALE ergaenzt
;
;     Revision 2.6  1997/11/27 13:28:05  thiel
;            Option CHARSIZE hinzugefuegt.
;
;     Revision 2.5  1997/11/13 13:15:16  saam
;           Device Null wird nun unterstuetzt
;
;     Revision 2.4  1997/11/11 16:56:43  saam
;           Bug im Example der Docu
;
;     Revision 2.3  1997/11/11 16:53:56  saam
;           Fehler bei Rahmen mit BW-PS korrigiert
;
;     Revision 2.2  1997/11/06 14:57:20  saam
;           statt eigenem TvScl wird nun UTvScl benutzt
;           NEG_COLORS-Option wird durch SysVar !REVERTPSCOLORS geregelt
;           Argumente von UTvScl werden weitergereicht
;
;     Revision 2.1  1997/11/05 10:04:06  saam
;           man war das ne Arbeit; diese Procedure
;           ist NICHT vom Himmel gefallen
;



PRO TvSclLegend, xnorm, ynorm $
                 ,HORIZONTAL=horizontal, VERTICAL=vertical $
                 ,MAX=max, MID=mid, MIN=min $
                 ,LEFT=left, RIGHT=right, CEILING=ceiling, BOTTOM=bottom $
                 ,CHARSIZE=Charsize, COLOR=color $
                 ,RANGE=Range $
                 ,NOSCALE=NOSCALE, _EXTRA = e
   
   
   IF !D.NAME EQ 'NULL' THEN RETURN
   
   Default, xnorm, 0.5
   Default, ynorm, 0.5
   Default,   max, 255
   Default,   mid, ''
   Default,   min, 0.0
   Default, Charsize, 1.0

   

   If Keyword_Set(COLOR) then sc = COLOR else sc = !P.COLOR

   IF Keyword_Set(VERTICAL) THEN BEGIN
      x_pix =  20
      y_pix = 100
      colorarray = FindGen(y_pix)
      colorarray = Rebin(Transpose(Temporary(colorarray)), x_pix, y_pix)
   END ELSE BEGIN
      x_pix = 100
      y_pix =  20
      colorarray = FindGen(x_pix)
      colorarray = Rebin(Temporary(colorarray), x_pix, y_pix)
   END      
   

   IF Keyword_Set(NOSCALE) THEN BEGIN
;      colorarray = (colorarray / MAX(colorarray))*(max-min)+min
      Scl, colorarray, [min, max]
      UTv, colorarray, xnorm, ynorm, legend_dims, _EXTRA=e
   ENDif ELSE BEGIN
      If Keyword_Set(RANGE) then begin
         UTv, Scl(colorarray, Range), xnorm, ynorm, legend_dims, _EXTRA=e
      endif else begin
         UTvScl, colorarray, xnorm, ynorm, legend_dims, _EXTRA=e
      ENDelse
   endelse
   

   type = Size(max)
   IF type(type(0)+1) NE 7 THEN max = STRCOMPRESS(STRING(max, FORMAT='(G0.0)'), /REMOVE_ALL)
   type = Size(mid)
   IF type(type(0)+1) NE 7 THEN mid = STRCOMPRESS(STRING(mid, FORMAT='(G0.0)'), /REMOVE_ALL)
   type = Size(min)
   IF type(type(0)+1) NE 7 THEN min = STRCOMPRESS(STRING(min, FORMAT='(G0.0)'), /REMOVE_ALL)
   
   
   xpos  = legend_dims(0)
   ypos  = legend_dims(1)
   xsize = legend_dims(2)
   ysize = legend_dims(3)
   x_ch_size = !D.X_CH_SIZE*Charsize / FLOAT(!D.X_SIZE)
   y_ch_size = !D.Y_CH_SIZE*Charsize / FLOAT(!D.Y_SIZE)
   
   
   ; draw a frame around the colors
   PlotS, [xpos, xpos+xsize, xpos+xsize,xpos,xpos], [ypos,ypos,ypos+ysize,ypos+ysize,ypos], COLOR=sc, /NORMAL
   
   IF Keyword_Set(VERTICAL) THEN BEGIN
      IF Keyword_Set(LEFT) THEN BEGIN
         XYOuts, xpos-X_CH_SIZE/2., ypos        -Y_CH_SIZE/2., STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=1.0, CHARSIZE=Charsize
         XYOuts, xpos-X_CH_SIZE/2., ypos+ysize/2-Y_CH_SIZE/2., STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=1.0, CHARSIZE=Charsize
         XYOuts, xpos-X_CH_SIZE/2., ypos+ysize  -Y_CH_SIZE/2., STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=1.0, CHARSIZE=Charsize
      END ELSE BEGIN
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos        -Y_CH_SIZE/2., STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=sc, CHARSIZE=Charsize
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos+ysize/2-Y_CH_SIZE/2., STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=sc, CHARSIZE=Charsize
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos+ysize  -Y_CH_SIZE/2., STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=sc, CHARSIZE=Charsize
      END         
   END ELSE BEGIN
      IF Keyword_Set(CEILING) THEN BEGIN
         XYOuts, xpos        , ypos+ysize+Y_CH_SIZE/5, STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize/2, ypos+ysize+Y_CH_SIZE/5, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize  , ypos+ysize+Y_CH_SIZE/5, STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=0.5, CHARSIZE=Charsize
      END ELSE BEGIN
         XYOuts, xpos        , ypos-Y_CH_SIZE, STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize/2, ypos-Y_CH_SIZE, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize  , ypos-Y_CH_SIZE, STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=sc, ALIGNMENT=0.5, CHARSIZE=Charsize
      END
   END
END


