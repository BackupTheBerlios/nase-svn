;+
; NAME:
;  TVSclLegend
;
; VERSION:
;  $Id$
;
; AIM:
;  Display a legend indicating color coding, compatible to
;  <A>UTVScl</A> routine.
;
; PURPOSE:
;  Generate horizontal or vertical legend indicating the color coding
;  in <A>UTVScl</A> displays, independent of the plotting device.
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
;*  [,TITLE=...]
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
;             size (default: <*>!P.CHARSIZE</*>).
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
;  TITLE:: labels the legend with a title string, that is placed at
;          the opposite side as the minimal and maximal numbers and is
;          aligned at the long side of the legend. As usual in IDL,
;          the <*>CHARSIZE</*> increased by a factor of 1.2.
;  STRETCH, H_STRETCH, V_STRETCH, CENTER:: See <A>UTVScl</A>.
;
; EXAMPLE:
;* TvSclLegend, 0.5, 0.5, /CENTER
;* TvSclLegend, 0.2, 0.2, MAX=10, MIN=-10, MID='Null', /VERTICAL, /LEFT 
;
; SEE ALSO: 
;  <A>PTVS</A>, <A>PTV</A>, <A>UTvScl</A>.
;
;-

PRO TvSclLegend, _xnorm, _ynorm $
                 ,TITLE=title $
                 ,HORIZONTAL=horizontal, VERTICAL=vertical $
                 ,MAX=max, MID=mid, MIN=min $
                 ,LEFT=left, RIGHT=right, CEILING=ceiling, BOTTOM=bottom $
                 ,CHARSIZE=_Charsize, COLOR=color $
                 ,RANGE=Range $
                 ,NOSCALE=NOSCALE $
                 ,_EXTRA=e
   
   
   IF !D.NAME EQ 'NULL' THEN RETURN
   
   IF N_PARAMS() GE 1 THEN Default, xnorm, _xnorm ELSE Default, xnorm, 0.5
   IF N_PARAMS() GE 2 THEN Default, ynorm, _ynorm ELSE Default, ynorm, 0.5
   Default,   max, 255
   Default,   mid, ''
   Default,   min, 0.0
   Default, _Charsize, !P.CHARSIZE
   CHARSIZE = _CHARSIZE*sqrt(1./MAX([1.,(!P.MULTI(1)), (!P.MULTI(2))])) 
   Default, COLOR, GetForeground()
   

   ; average character size in normal coordinated
   x_ch_size = !D.X_CH_SIZE*Charsize / FLOAT(!D.X_SIZE)
   y_ch_size = !D.Y_CH_SIZE*Charsize / FLOAT(!D.Y_SIZE)


   ;; format the legend text
   type = Size(max)
   IF type(type(0)+1) NE 7 THEN max = STRCOMPRESS(STRING(max, FORMAT='(G0.0)'), /REMOVE_ALL)
   type = Size(mid)
   IF type(type(0)+1) NE 7 THEN mid = STRCOMPRESS(STRING(mid, FORMAT='(G0.0)'), /REMOVE_ALL)
   type = Size(min)
   IF type(type(0)+1) NE 7 THEN min = STRCOMPRESS(STRING(min, FORMAT='(G0.0)'), /REMOVE_ALL)
   

   ;; if center is set, the legend colors are centered to xnorm, ynorm
   ;; 
   IF NOT ExtraSet(e, 'CENTER') THEN BEGIN
       IF NOT ExtraSet(e, 'XCENTER') THEN BEGIN
           ;; determine space that is needed left to the legend for the text
           IF Keyword_Set(LEFT) THEN xnorm=xnorm + MAX(STRLEN([max,mid,min]))*x_ch_size $
                                ELSE xnorm=xnorm + y_ch_size
       END
       IF NOT ExtraSet(e, 'YCENTER') THEN BEGIN
           ;; determine space that is needed at the bottom of the legend
           IF Keyword_Set(CEILING) THEN ynorm=ynorm + y_ch_size*1.2 $
                                   ELSE ynorm=ynorm + y_ch_size
       END
   END


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
      Scl, colorarray, [min, max]
      UTv, colorarray, xnorm, ynorm, legend_dims 
   END ELSE BEGIN
      If Keyword_Set(RANGE) then begin
          UTv, Scl(colorarray, Range), xnorm, ynorm, legend_dims
      end else begin
         UTvScl, colorarray, xnorm, ynorm, legend_dims, _EXTRA=e
      END
   end
   

   
   xpos  = legend_dims(0)
   ypos  = legend_dims(1)
   xsize = legend_dims(2)
   ysize = legend_dims(3)
   
   
   ; draw a frame around the colors
   PlotS, [xpos, xpos+xsize, xpos+xsize,xpos,xpos], [ypos,ypos,ypos+ysize,ypos+ysize,ypos], COLOR=color, /NORMAL
   
   IF Keyword_Set(VERTICAL) THEN BEGIN
      IF Keyword_Set(LEFT) THEN BEGIN
         XYOuts, xpos-X_CH_SIZE/2., ypos        -Y_CH_SIZE/2., STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=1.0, CHARSIZE=Charsize
         XYOuts, xpos-X_CH_SIZE/2., ypos+ysize/2-Y_CH_SIZE/2., STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=1.0, CHARSIZE=Charsize
         XYOuts, xpos-X_CH_SIZE/2., ypos+ysize  -Y_CH_SIZE/2., STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=1.0, CHARSIZE=Charsize
         IF Set(TITLE) THEN XYOuts, xpos+xsize+1.2*Y_CH_SIZE/4., ypos+ysize/2, title, /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=1.2*Charsize, ORIENTATION=-90
      END ELSE BEGIN
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos        -Y_CH_SIZE/2., STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=color, CHARSIZE=Charsize
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos+ysize/2-Y_CH_SIZE/2., STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=color, CHARSIZE=Charsize
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos+ysize  -Y_CH_SIZE/2., STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=color, CHARSIZE=Charsize
         IF Set(TITLE) THEN XYOuts, xpos-1.2*Y_CH_SIZE*3/4, ypos+ysize/2, title, /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=1.2*Charsize, ORIENTATION=-90
      END         
      
   END ELSE BEGIN
      IF Keyword_Set(CEILING) THEN BEGIN
         XYOuts, xpos        , ypos+ysize+Y_CH_SIZE/4, STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize/2, ypos+ysize+Y_CH_SIZE/4, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize  , ypos+ysize+Y_CH_SIZE/4, STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=Charsize
         IF Set(TITLE) THEN XYOuts, xpos+xsize/2, ypos-1.2*Y_CH_SIZE*3/4, title, /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=1.2*Charsize
      END ELSE BEGIN
         XYOuts, xpos        , ypos-Y_CH_SIZE, STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize/2, ypos-Y_CH_SIZE, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=Charsize
         XYOuts, xpos+xsize  , ypos-Y_CH_SIZE, STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=Charsize
         IF Set(TITLE) THEN XYOuts, xpos+xsize/2, ypos+ysize+1.2*Y_CH_SIZE/4, title, /NORMAL, COLOR=color, ALIGNMENT=0.5, CHARSIZE=1.2*Charsize
      END
   END
END


