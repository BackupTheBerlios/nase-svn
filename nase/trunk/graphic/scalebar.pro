;+
; NAME:
;  Scalebar
;
; VERSION:
;  $Id$
;
; AIM:
;  plots a scalebar into an existing plot
;
; PURPOSE:
;  Positions a horizontal or vertical scalebar into an existing plot
;  using the current  plot scaling. The bar is labeled with its actual
;  length or with arbitrary text.
;  
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*Scalebar,v, x, y  [,TEXT=...]
;*                  [,/HORIZONTAL | ,/VERTICAL] 
;*                  [,/DATA | ,/NORMAL]
;*                  [,/BOTTOM | ,/VCENTER | ,/TOP]  
;*                  [,_EXTRA=e]
;
; INPUTS:
;  v   :: length of the scale bar (in data coordinates)
;  x,y :: position of the scalebar in normal or data
;         coordinates (using <*>/NORMAL</*> or <*>DATA</*>). This is
;         in general the center position of the bar, but see options.
;
; INPUT KEYWORDS:
;  TEXT       :: label scalebar with alternative text or scalars  
;  HORIZONTAL :: plots a horizontal scalebar
;  VERTICAL   :: plots a vertical scalebar (default)
;  DATA       :: <*>x</*> and <*>y</*> are interpreted as data
;                coordinates (Default)
;  NORMAL     :: <*>x</*> and <*>y</*> are interpreted as normal
;                coordinates 
;  BOTTOM,VCENTER,TOP :: setting one of these these keywords changes the
;                vertical alignment of the bar relative to the specified
;                position <*>y</*>. <*>/VCENTER</*> is the default.
;
; EXAMPLE:
;* plot, sin(2*!Pi*findgen(2000)/500), yrange=[-2,2]
;* scalebar, 0.5, 0.8, 0.4, /NORMAL
;* scalebar, 500, 1000,-1.3, text='T', /horizontal
;
;-


PRO Scalebar, v, _x, _y, TEXT=_text, VALUE=value, HORIZONTAL=horizontal, VERTICAL=vertical, DATA=data, NORMAL=normal, $
              CHARSIZE=charsize, $
              TOP=top, BOTTOM=bottom, VCENTER=vcenter, _EXTRA=e

Default, v, 1.
Default, _x, 0.1
Default, _y, 0.1
Default, vw, 0.05  ; width of limiting bars (percent of bar length)
Default, CHARSIZE, 1.
Default, text, string(format="(G0)", v) 
IF Keyword_Set(TOP)+Keyword_Set(VCENTER)+Keyword_Set(BOTTOM) LT 1 THEN VCENTER=1
IF Keyword_Set(TOP)+Keyword_Set(VCENTER)+Keyword_Set(BOTTOM) GT 1 THEN Console, 'please use only one option BOTTOM/VCENTER/TOP', /FATAL 

IF Set(_text) THEN BEGIN
    IF TypeOf(_text) NE "STRING" THEN text = string(format="(G0)", _text) ELSE text=_text
END

IF Set(HORIZONTAL)+Set(VERTICAL) EQ 0 THEN VERTICAL=1  ; default is a vertical scalebar
IF Set(DATA)+Set(NORMAL) EQ 0 THEN DATA=1              ; default is data coordinates for positioning


; convert v to normal coordinates
_D = (UCONVERT_COORD([0,v], [0,v], /DATA, /TO_NORMAL))
Dy = _D(1,1)-_D(1,0)
Dx = _D(0,1)-_D(0,0)

; convert position to normal coordinates
IF Keyword_Set(DATA) THEN BEGIN
    tmp = UConvert_Coord([_x,_y], /TO_NORMAL, /DATA)
    x = tmp(0) 
    y = tmp(1) 
END ELSE BEGIN
    x = _x
    y = _y
END

CASE 1 OF
    Keyword_Set(TOP)    : y = y - Dy 
    Keyword_Set(VCENTER): y = y - Dy/2. 
    Keyword_Set(BOTTOM) : y = y 
END  



S = CHARSIZE*UConvert_coord(!D.X_CH_SIZE, !D.Y_CH_SIZE, /DEVICE, /TO_NORMAL)

IF Keyword_Set(HORIZONTAL) THEN BEGIN
    plots, [x-Dx/2.,x+Dx/2.], [y, y], /NORMAL, _EXTRA=e 
    plots, [x-Dx/2.,x-Dx/2.], [y-Dx*vw, y+Dx*vw], /NORMAL, _EXTRA=e 
    plots, [x+Dx/2.,x+Dx/2.], [y-Dx*vw, y+Dx*vw], /NORMAL, _EXTRA=e 
    XYouts, x, y-Dx*vw-S(1)/2.,  /NORMAL, text, ALIGNMENT=0.5, CHARSIZE=charsize, _EXTRA=e 
END ELSE BEGIN 
    plots, [x,x]            , [y, y+Dy]   , /NORMAL, _EXTRA=e 
    plots, [x-Dy*vw,x+Dy*vw], [y, y]      , /NORMAL, _EXTRA=e 
    plots, [x-Dy*vw,x+Dy*vw], [y+Dy, y+Dy], /NORMAL, _EXTRA=e 
    XYouts, x+S(0)/2., y+Dy/2.-S(1)/2.,  /NORMAL, text, CHARSIZE=charsize, _EXTRA=e 
END


END
