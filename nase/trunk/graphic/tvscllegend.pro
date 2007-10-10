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
;*  [,TITLE=...] [,/SAMESIDE]
;*  [,RANGE=...]
;*  [,/HORIZONTAL] [,/VERTICAL] 
;*  [,/LEFT] [,/RIGHT] 
;*  [,/CEILING] [,/BOTTOM]
;*  [,/NOSCALE]
;*  [,STRETCH=...] [,H_STRETCH=...] [,V_STRETCH=...]
;*  [,NORM_X_SIZE=...] [, NORM_Y_SIZE=...]
;*  [,/[X|Y]CENTER]
;*  [,/CLIPPEDABOVE], [/CLIPPEDBELOW]
;
; INPUTS:
;  xnorm:: X-position of the legend rectangle's lower left corner in normal
;          coordinates. The legend rectangle includes the color code
;          image and its min, mid and max annotations, but not its
;          optional title. Thus, <*>xnorm</*> takes into account if
;          annotations are put on the left by using the <*>/LEFT</*>
;          switch. If the <*>[X]CENTER</*> keywords are used,
;          <*>xnorm</*> gives 
;          the x-position of the color code image's center, regardless
;          of any annotation. 
;  ynorm:: Y-position of legend rectangle's lower left corner in
;          normal coordinates. The legend rectangle includes the color code
;          image and its min, mid and max annotations, but not its
;          optional title. Thus, <*>ynorm</*> takes into account if
;          annotations are put to the top by using the <*>/CEILING</*>
;          switch. If the <*>[Y]CENTER</*> keywords are used,
;          <*>ynorm</*> gives 
;          the y-position of the color code image's center, regardless
;          of any annotation. 
;
; INPUT KEYWORDS:
;  CHARSIZE:: Factor determining the charsize relative to the standard
;             size (default: <*>!P.CHARSIZE</*>).
;  RANGE:: Set this keyword to a two-element array, containing the
;          lowest and the highest color index to use for the legend
;          color range. If omitted, the legend will span the whole
;          color table (<*>[0,!TopColor]</*>).
;  MAX,MID,MIN:: Strings or numbers used as labels for maximum, middle
;                and minimum legend value (default: <*>MIN=Range[0]</*>, <*>MID=''</*>, <*>MAX=Range[1]</*>)
;  COLOR:: Color used for drawing the legend's frame and labels. If <*>COLOR</*>
;          is not set, it defaults to the standard foreground color
;          (see <A>Foreground</A>).
;  HORIZONTAL, VERTICAL:: Horizontal or vertical legend (default:
;                         horizontal).
;  LEFT, RIGHT:: Vertical legends may be labeled on left or right side
;                (default: right).
;  SAMESIDE :: usually the title of the legend is placed opposite the
;              legend labels; with this option the title is placed at
;              the same side. At present, this option does only work
;              for the <*>LEFT/RIGHT</*> switch, not for
;              <*>CEILING/BOTTOM</*>.  
;  CEILING, BOTTOM:: Horizontal legends may be labeled on top or
;                    bottom (default: bottom).
;  NOSCALE:: Legend will not be scaled analogous to diplaying data
;            with the <*>TV</*> command. To give correct results,
;            <*>MIN</*> and <*>MAX</*> MUST BE SET!
;  TITLE:: labels the legend with a title string, that is placed at
;          the opposite side as the minimal and maximal numbers and is
;          aligned at the long side of the legend. As usual in IDL,
;          the <*>CHARSIZE</*> is increased by a factor of 1.2.
;  STRETCH, H_STRETCH, V_STRETCH, [X|Y]CENTER, NORM_X_SIZE, NORM_Y_SIZE:: See <A>UTVScl</A>. <B>Warning:</B> Due to the
;                <A>ExtraSet()</A>
;                procedure, setting <*>[X|Y]CENTER=0</*> does not have
;                the desired effect. You rather have to remove the
;                <*>[X|Y]CENTER</*> keywords from the call to unset them. 
;  CLIPPEDABOVE:: Set to display a square at the upper end of legend
;                 showing the color for values above the scaling range.
;  CLIPPEDBELOW:: Set to display a square at the lower end of legend
;                 showing the color for values below the scaling range.
;  
; EXAMPLE:
;* Plot, IndGen(10),/NODATA
;* TvSclLegend, 0.4, 0.1, NORM_Y_SIZE=0.75, MAX=10, MIN=-10, MID='Null', /VERTICAL, /LEFT
;
; SEE ALSO: 
;  <A>PTVS</A>, <A>PTV</A>, <A>UTvScl</A>.
;
;-

PRO TvSclLegend, _xnorm, _ynorm $
                 ,TITLE=title $
                 ,HORIZONTAL=horizontal, VERTICAL=vertical $
                 ,MAX=ma, MID=mid, MIN=mi $
                 ,LEFT=left, RIGHT=right, CEILING=ceiling, BOTTOM=bottom $
                 , SAMESIDE=sameside $
                 ,CHARSIZE=_Charsize, COLOR=color $
                 ,RANGE=Range $
                 ,NOSCALE=NOSCALE $
                 , NORM_X_SIZE=norm_x_size, NORM_Y_SIZE=norm_y_size $
                 , XCENTER=xcenter, YCENTER=ycenter $
                 ,CLIPPEDABOVE=clippedabove, CLIPPEDBELOW=clippedbelow $
                 ,_EXTRA=e
   
   
   IF !D.NAME EQ 'NULL' THEN RETURN
   
   IF N_PARAMS() GE 1 THEN Default, xnorm, _xnorm ELSE Default, xnorm, 0.5
   IF N_PARAMS() GE 2 THEN Default, ynorm, _ynorm ELSE Default, ynorm, 0.5
   Default, range, [0, !TopColor]
   Default,   ma, range[1]
   Default,   mid, ''
   Default,   mi, range[0]
   Default, _Charsize, !P.CHARSIZE
   CHARSIZE = _CHARSIZE;*sqrt(1./MAX([1.,(!P.MULTI(1)), (!P.MULTI(2))])) 
   Default, COLOR, GetForeground()
   Default, SAMESIDE, 0
   Default, xcenter, 0
   Default, ycenter, 0
   

   ; average character size in normal coordinated
   x_ch_size = !D.X_CH_SIZE*Charsize / FLOAT(!D.X_SIZE)
   y_ch_size = !D.Y_CH_SIZE*Charsize / FLOAT(!D.Y_SIZE)


   ;; format the legend text
   type = Size(ma)
   IF type(type(0)+1) NE 7 THEN max = STRCOMPRESS(STRING(ma, FORMAT='(G0.0)'), /REMOVE_ALL) ELSE max = ma
   type = Size(mid)
   IF type(type(0)+1) NE 7 THEN mid = STRCOMPRESS(STRING(mid, FORMAT='(G0.0)'), /REMOVE_ALL)
   type = Size(mi)
   IF type(type(0)+1) NE 7 THEN min = STRCOMPRESS(STRING(mi, FORMAT='(G0.0)'), /REMOVE_ALL) ELSE min = mi
   
   ;; if center is set, the legend color array is centered to xnorm, ynorm
   ;; 
   IF NOT ExtraSet(e, 'CENTER') THEN BEGIN
      IF NOT ExtraSet(e, 'XCENTER') THEN BEGIN
         ;; determine space that is needed left to the legend for the text
         IF Keyword_Set(LEFT) THEN $
          xnorm=xnorm + (0.5+MAX(STRLEN([max,mid,min])))*x_ch_size 
      END
      IF NOT ExtraSet(e, 'YCENTER') THEN BEGIN
         ;; determine space that is needed at the bottom of the legend
         IF not Keyword_Set(CEILING) THEN $
          ynorm=ynorm + y_ch_size ;; add space for the annotation
      END
   END

   norm_length = 0.8
   aspect_ratio = 0.2
   IF Keyword_Set(VERTICAL) THEN BEGIN
      y_pix = (range[1]-range[0])+1
      x_pix = y_pix * aspect_ratio
      Default, norm_y_size, norm_length
      colorarray = FindGen(y_pix)
      colorarray = rebin(Transpose(Temporary(colorarray)), x_pix, y_pix)
   END ELSE BEGIN
      x_pix = (range[1]-range[0])+1
      y_pix = x_pix * aspect_ratio
      Default, norm_x_size, norm_length
      colorarray = FindGen(x_pix)
      colorarray = rebin(Temporary(colorarray), x_pix, y_pix)
   END      
   

   IF Keyword_Set(NOSCALE) THEN BEGIN
      Scl, colorarray, range
   ENDif

   legend_dims = FltArr(4)

   UTvScl, /NOSCALE, colorarray, xnorm, ynorm $
    , NORM_X_SIZE=norm_x_size, NORM_Y_SIZE=norm_y_size $
    , DIMENSIONS=legend_dims $
    , XCENTER=xcenter, YCENTER=ycenter, _EXTRA=e

   xpos  = legend_dims[0]
   ypos  = legend_dims[1]
   xsize = legend_dims[2]
   ysize = legend_dims[3]

   ;; draw a frame around the colors
   PlotS, [xpos,xpos+xsize, xpos+xsize,xpos,xpos] $
    , [ypos,ypos,ypos+ysize,ypos+ysize,ypos] $
    , COLOR=color, /NORMAL $
    , LINESTYLE=0, THICK=1.0

   ;; draw rectangles for "above" and "below"
   If Keyword_Set(VERTICAL) then begin
      if keyword_set(CLIPPEDBELOW) then begin
         sxpos = xpos
         sypos = ypos-0.05
         sxsize = xsize
         sysize = 0.03
         Polyfill, [sxpos,sxpos+sxsize, sxpos+sxsize,sxpos,sxpos] $
                   , [sypos,sypos,sypos+sysize,sypos+sysize,sypos] $
                   , COLOR=rgb(!BELOWCOLORNAME), /NORMAL
         PlotS, [sxpos,sxpos+sxsize, sxpos+sxsize,sxpos,sxpos] $
                , [sypos,sypos,sypos+sysize,sypos+sysize,sypos] $
                , COLOR=color, /NORMAL $
                , LINESTYLE=0, THICK=1.0
      endif
      if keyword_set(CLIPPEDABOVE) then begin
         sxpos = xpos
         sypos = ypos+ysize+0.02
         sxsize = xsize
         sysize = 0.03
         Polyfill, [sxpos,sxpos+sxsize, sxpos+sxsize,sxpos,sxpos] $
                   , [sypos,sypos,sypos+sysize,sypos+sysize,sypos] $
                   , COLOR=rgb(!ABOVECOLORNAME), /NORMAL
         Plots, [Sxpos,Sxpos+Sxsize, Sxpos+Sxsize,Sxpos,Sxpos] $
                , [Sypos,Sypos,Sypos+Sysize,Sypos+Sysize,Sypos] $
                , Color=Color, /Normal $
                , Linestyle=0, Thick=1.0
      Endif
   Endif Else Begin
      If Keyword_Set(Clippedbelow) Then Begin
         Sxpos = Xpos-0.05
         Sypos = Ypos
         Sxsize = 0.03
         Sysize = Ysize
         Polyfill, [Sxpos,Sxpos+Sxsize, Sxpos+Sxsize,Sxpos,Sxpos] $
                   , [Sypos,Sypos,Sypos+Sysize,Sypos+Sysize,Sypos] $
                   , Color=Rgb(!Belowcolorname), /Normal
         Plots, [Sxpos,Sxpos+Sxsize, Sxpos+Sxsize,Sxpos,Sxpos] $
                , [Sypos,Sypos,Sypos+Sysize,Sypos+Sysize,Sypos] $
                , Color=Color, /Normal $
                , Linestyle=0, Thick=1.0
      Endif
      If Keyword_Set(Clippedabove) Then Begin
         Sxpos = Xpos+Xsize+0.02
         Sypos = Ypos
         Sxsize = 0.03
         Sysize = Ysize
         Polyfill, [Sxpos,Sxpos+Sxsize, Sxpos+Sxsize,Sxpos,Sxpos] $
                   , [Sypos,Sypos,Sypos+Sysize,Sypos+Sysize,Sypos] $
                   , Color=Rgb(!Abovecolorname), /Normal
         Plots, [Sxpos,Sxpos+Sxsize, Sxpos+Sxsize,Sxpos,Sxpos] $
                , [Sypos,Sypos,Sypos+Sysize,Sypos+Sysize,Sypos] $
                , Color=Color, /Normal $
                , Linestyle=0, Thick=1.0
      Endif
   Endelse



   ;; for a reason no-one can know, XYOutS does not know the keyword
   ;; linestyle, although it draws lines. So we have to do it by hand:
   ;; save state of graphics device:
   SaveGD, gd
   !P.Linestyle = 0

   IF Keyword_Set(VERTICAL) THEN BEGIN
      IF Keyword_Set(LEFT) THEN BEGIN
         XYOuts, xpos-X_CH_SIZE/2., ypos        -Y_CH_SIZE/2., STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=1.0, CHARSIZE=Charsize
         XYOuts, xpos-X_CH_SIZE/2., ypos+ysize/2-Y_CH_SIZE/2., STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=1.0, CHARSIZE=Charsize
         XYOuts, xpos-X_CH_SIZE/2., ypos+ysize  -Y_CH_SIZE/2., STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=color, ALIGNMENT=1.0, CHARSIZE=Charsize
         IF Set(TITLE) THEN $
          XYOuts, xpos+xsize*(-1*sameside+1)+(-3*sameside+1)*0.6*Y_CH_SIZE $
          , ypos+0.5*ysize, title, /NORMAL, COLOR=color, ALIGNMENT=0.5 $
          , CHARSIZE=1.2*Charsize, ORIENTATION=-90
      END ELSE BEGIN
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos        -Y_CH_SIZE/2., STRCOMPRESS(STRING(min), /REMOVE_ALL), /NORMAL, COLOR=color, CHARSIZE=Charsize
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos+ysize/2-Y_CH_SIZE/2., STRCOMPRESS(STRING(mid), /REMOVE_ALL), /NORMAL, COLOR=color, CHARSIZE=Charsize
         XYOuts, xpos+xsize+X_CH_SIZE/2., ypos+ysize  -Y_CH_SIZE/2., STRCOMPRESS(STRING(max), /REMOVE_ALL), /NORMAL, COLOR=color, CHARSIZE=Charsize
         IF Set(TITLE) THEN $
          XYOuts, xpos+xsize*sameside+(3*sameside-2)*0.6*Y_CH_SIZE $
          , ypos+0.5*ysize, title, /NORMAL, COLOR=color, ALIGNMENT=0.5 $
          , CHARSIZE=1.2*Charsize, ORIENTATION=-90
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
   ENDELSE

   ;; restore state of graphics device
   RestoreGD, gd
END


