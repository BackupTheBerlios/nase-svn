;+
; NAME:               TvSclLegend
;
; PURPOSE:            Erzeugt eine horizontale oder vertikale Legende fuer 
;                     TvScl-Darstellungen unabhaengig fuer X-Windows(256 COLOR/TRUE COLOR) 
;                     und Postscript (BW/COLOR)
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   TvSclLegend, xnorm, ynorm [,/HORIZONTAL] [,/VERTICAL] 
;                     [,/LEFT] [,/RIGHT] [,/TOP] [,/BOTTOM]
;                     [,MAX=max] [,MID=mid] [,MIN=min]
;                     [,STRETCH=stretch] [,H_STRETCH=h_stretch] [,V_STRETCH=v_stretch]
;                     [,/NEG_COLORS] 
;
; INPUTS:             xnorm: x-Position des Zentrums der Legende in Normalkoordinaten
;                     ynorm: y-Position des Zentrums der Legende in Normalkoordinaten
;
; KEYWORD PARAMETERS: HORIZONTAL ,
;                     VERTICAL   : horizontale oder vertikale Legende
;                                  (Def.: HORIZONTAL)
;                     LEFT/RIGHT : bei vertikaler Legende kann Beschriftung links oder
;                                  rechts erfolgen (Def.: RIGHT)
;                     TOP/BOTTOM : bei horizontaler Legende kann Beschriftung oben oder
;                                  unten erfolgen (Def.: BOTTOM)
;                     MAX/MID/MIN: Beschriftung des maximalen, mittleren und minimalen
;                                  Legendenwertes als String oder Zahl 
;                                  (Def.: MAX=1, MID='', MIN=0)
;                     STRETCH    ,
;                     H_STRETH   ,
;                     V_STRETCH  : Dehnungsfaktoren fuer die gesamte , horizontale
;                                  und vertikale Ausdehnung der Legende (Def.: alles 1.0)
;                     NEG_COLORS : invertiert die gesamte Farbpalette zur Darstellung auf
;                                  SW-Postscript
;
; EXAMPLE:
;           TvSclLegend, 0.5, 0.5
;           TvSclLegend, 0.2, 0.2, MAX=10, MIN=-10, MID='Null', /VERTICAL, /TOP 
;
;        
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/11/05 10:04:06  saam
;           man war das ne Arbeit; diese Procedure
;           ist NICHT vom Himmel gefallen
;
;
;-
PRO TvSclLegend, xnorm, ynorm $
                 ,HORIZONTAL=horizontal, VERTICAL=vertical $
                 ,STRETCH=stretch, V_STRETCH=v_stretch, H_STRETCH=h_stretch $
                 ,MAX=max, MID=mid, MIN=min $
                 ,LEFT=left, RIGHT=right, TOP=top, BOTTOM=bottom $
                 ,NEG_COLORS = neg_colors

   
   Default, stretch  , 1.0
   Default, v_stretch, 1.0
   Default, h_stretch, 1.0

   Default, max, 1.0
   Default, mid, ''
   Default, min, 0.0

   type = Size(max)
   IF type(type(0)+1) NE 7 THEN max = STRCOMPRESS(STRING(max, FORMAT='(G0.0)'), /REMOVE_ALL)

   type = Size(mid)
   IF type(type(0)+1) NE 7 THEN mid = STRCOMPRESS(STRING(mid, FORMAT='(G0.0)'), /REMOVE_ALL)
   
   type = Size(min)
   IF type(type(0)+1) NE 7 THEN min = STRCOMPRESS(STRING(min, FORMAT='(G0.0)'), /REMOVE_ALL)


   xpos = xnorm * !D.X_Size
   ypos = ynorm * !D.Y_Size


   bg = GetBGColor()
   sc =  RGB(255-bg(0), 255-bg(1), 255-bg(2), /NOALLOC)

   IF Keyword_Set(VERTICAL) THEN BEGIN
      x_cm = 0.5
      y_cm = 2.5

      xsize =  LONG(x_cm*!D.X_PX_CM*stretch*h_stretch)
      ysize =  LONG(y_cm*!D.Y_PX_CM*stretch*v_stretch)
      
      colorarray = FindGen(ysize)
      colorarray = Transpose(Rebin(colorarray, ysize, xsize))

      IF Keyword_Set(NEG_COLORS) THEN BEGIN
         colorarray = MAX(colorarray) - colorarray
         sc = !D.N_COLORS-sc-1
      END
      
      IF !D.Name NE 'PS' THEN Device, BYPASS_TRANSLATION=0
      TVScl, colorarray, xpos/!D.X_PX_CM-x_cm/2, ypos/!D.Y_PX_CM-y_cm/2, XSIZE=x_cm, YSIZE=y_cm, /CENTIMETERS
      IF !D.Name NE 'PS' THEN Device, /BYPASS_TRANSLATION

      PlotS, [xpos-xsize/2, xpos+xsize/2, xpos+xsize/2,xpos-xsize/2,xpos-xsize/2], [ypos-ysize/2,ypos-ysize/2,ypos+ysize/2,ypos+ysize/2,ypos-ysize/2], COLOR=sc, /DEVICE

      
      IF Keyword_Set(LEFT) THEN BEGIN
         XYOuts, xpos-xsize/2-!D.X_CH_SIZE/2, ypos-ysize/2-!D.Y_CH_SIZE/2, STRCOMPRESS(STRING(min), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=1.0
         XYOuts, xpos-xsize/2-!D.X_CH_SIZE/2, ypos        -!D.Y_CH_SIZE/2, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=1.0
         XYOuts, xpos-xsize/2-!D.X_CH_SIZE/2, ypos+ysize/2-!D.Y_CH_SIZE/2, STRCOMPRESS(STRING(max), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=1.0
      END ELSE BEGIN
         XYOuts, xpos+xsize/2+!D.X_CH_SIZE/2, ypos-ysize/2-!D.Y_CH_SIZE/2, STRCOMPRESS(STRING(min), /REMOVE_ALL), /DEVICE, COLOR=sc
         XYOuts, xpos+xsize/2+!D.X_CH_SIZE/2, ypos        -!D.Y_CH_SIZE/2, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /DEVICE, COLOR=sc
         XYOuts, xpos+xsize/2+!D.X_CH_SIZE/2, ypos+ysize/2-!D.Y_CH_SIZE/2, STRCOMPRESS(STRING(max), /REMOVE_ALL), /DEVICE, COLOR=sc
      END         
   END ELSE BEGIN   
      x_cm = 2.5
      y_cm = 0.5

      xsize = LONG(x_cm*!D.X_PX_CM*stretch*h_stretch)
      ysize = LONG(y_cm*!D.Y_PX_CM*stretch*v_stretch)
      
      colorarray = FindGen(xsize)
      colorarray = Rebin(colorarray, xsize, ysize)

      IF Keyword_Set(NEG_COLORS) THEN BEGIN
         colorarray = MAX(colorarray) - colorarray
         sc = !D.N_Colors-sc-1
      END

      Device, BYPASS_TRANSLATION=0
      TVScl, colorarray,  xpos/!D.X_PX_CM-x_cm/2, ypos/!D.Y_PX_CM-y_cm/2, XSIZE=x_cm, YSIZE=y_cm, /CENTIMETERS 
      Device, /BYPASS_TRANSLATION
      
      PlotS, [xpos-xsize/2, xpos+xsize/2, xpos+xsize/2,xpos-xsize/2,xpos-xsize/2], [ypos-ysize/2,ypos-ysize/2,ypos+ysize/2,ypos+ysize/2,ypos-ysize/2], COLOR=sc, /DEVICE

      IF Keyword_Set(TOP) THEN BEGIN
         XYOuts, xpos-xsize/2, ypos+ysize/2+!D.Y_CH_SIZE/5, STRCOMPRESS(STRING(min), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=0.5
         XYOuts, xpos        , ypos+ysize/2+!D.Y_CH_SIZE/5, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=0.5
         XYOuts, xpos+xsize/2, ypos+ysize/2+!D.Y_CH_SIZE/5, STRCOMPRESS(STRING(max), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=0.5
      END ELSE BEGIN
         XYOuts, xpos-xsize/2, ypos-ysize/2-!D.Y_CH_SIZE, STRCOMPRESS(STRING(min), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=0.5
         XYOuts, xpos        , ypos-ysize/2-!D.Y_CH_SIZE, STRCOMPRESS(STRING(mid), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=0.5
         XYOuts, xpos+xsize/2, ypos-ysize/2-!D.Y_CH_SIZE, STRCOMPRESS(STRING(max), /REMOVE_ALL), /DEVICE, COLOR=sc, ALIGNMENT=0.5
      END
   END

END


;FOR i=0,16 DO BEGIN
;   IF !D.Name NE 'PS' THEN device, BYPASS_TRANSLATION=0
;   loadct, i
;   IF !D.Name NE 'PS' THEN device, /BYPASS_TRANSLATION
;   tvscllegend, 0.5, 0.5
;   dummy = get_kbrd(1)
;END


END
