;+
; NAME:               TvSclLegend
;
; AIM:
;  Display a legend indicating color coding, compatible to TvScl routine.
;
; PURPOSE:            Erzeugt eine horizontale oder vertikale Legende fuer 
;                     TvScl-Darstellungen unabhaengig fuer X-Windows(256 COLOR/TRUE COLOR) 
;                     und Postscript (BW/COLOR)
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   TvSclLegend, xnorm, ynorm 
;                                  [, CHARSIZE=Schriftgroesse]
;                                  [,/HORIZONTAL] [,/VERTICAL] 
;                                  [,/LEFT] [,/RIGHT] [,/CEILING] [,/BOTTOM]
;                                  [,MAX=max] [,MID=mid] [,MIN=min]
;                                  [,/NOSCALE] [,COLOR=color]
;
;                     alle Argumente von UTvScl werden ebenfalls akzeptiert, i.w.
;                                  [,/CENTER]
;                                  [,STRETCH=stretch] [,H_STRETCH=h_stretch] [,V_STRETCH=v_stretch]
;
; INPUTS:             xnorm: x-Position des Zentrums der Legende in Normalkoordinaten
;                     ynorm: y-Position des Zentrums der Legende in Normalkoordinaten
;
; OPTIONAL INPUTS: Schriftgroesse: Faktor, der die Schriftgroesse in Bezug auf die
;                                  Standardgroesse (1.0) angibt
;
; KEYWORD PARAMETERS: HORIZONTAL ,
;                     VERTICAL   : horizontale oder vertikale Legende
;                                  (Def.: HORIZONTAL)
;                     LEFT/RIGHT : bei vertikaler Legende kann Beschriftung links oder
;                                  rechts erfolgen (Def.: RIGHT)
;                     CEILING/BOTTOM : bei horizontaler Legende kann Beschriftung oben oder
;                                  unten erfolgen (Def.: BOTTOM)
;                     MAX/MID/MIN: Beschriftung des maximalen, mittleren und minimalen
;                                  Legendenwertes als String oder Zahl 
;                                  (Def.: MAX=255, MID='', MIN=0)
;                     RANGE      : Set this keyword to a two-element
;                                  array, containing the lowest and
;                                  the highest color index to use for
;                                  the legend color range. If omitted,
;                                  the legend will span the whole
;                                  color table.
;                     NOSCALE    : die Legende wird analog zu Tv nicht skaliert; fuer
;                                  eine korrekte Darstellung MUESSEN(!!!!) die Keywords
;                                  MIN und MAX uebergeben werden.
;                     COLOR      : Farbe des Rahmens. Wenn nicht
;                                  angegeben, wird eine moeglichst
;                                  passende Farbe ermittelt.
;
; EXAMPLE:
;           TvSclLegend, 0.5, 0.5, /CENTER
;           TvSclLegend, 0.2, 0.2, MAX=10, MIN=-10, MID='Null', /VERTICAL, /LEFT 
;
;        
; MODIFICATION HISTORY:
;
;     $Log$
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
;
;-
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

   
;   bg = GetBGColor()
;   ; if device is PS and REVERTPS is on 
;   save_rpsc = !REVERTPSCOLORS
;   !REVERTPSCOLORS = 0
;   sc =  RGB(255-bg(0), 255-bg(1), 255-bg(2), /NOALLOC)
;   !REVERTPSCOLORS = save_rpsc

   If Keyword_Set(COLOR) then sc = COLOR else begin
                                ;-----Optimale Farbe fuer die Achsen ermitteln:
      bg = GetBGColor()
                                ; if device is !PSGREY and !REVERTPS is on 
      If !PSGREY then begin
         save_rpsc = !REVERTPSCOLORS
         !REVERTPSCOLORS = 0
      EndIf
      sc =  RGB(255-bg(0), 255-bg(1), 255-bg(2), /NOALLOC)
      If !PSGREY then !REVERTPSCOLORS = save_rpsc
   endelse

   IF Keyword_Set(VERTICAL) THEN BEGIN
      x_pix =  20
      y_pix = 100
      colorarray = FindGen(y_pix)
      colorarray = Transpose(Rebin(colorarray, y_pix, x_pix))
   END ELSE BEGIN
      x_pix = 100
      y_pix =  20
      colorarray = FindGen(x_pix)
      colorarray = Rebin(colorarray, x_pix, y_pix)
   END      
   

   IF Keyword_Set(NOSCALE) THEN BEGIN
      colorarray = (colorarray / MAX(colorarray))*(max-min)+min
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


