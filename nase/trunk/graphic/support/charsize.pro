;+
; NAME:
;  Charsize()
;
; VERSION:
;  $Id$
;
; AIM:
;  returns the current average charsize
;
; PURPOSE:
;  You can access the average character size by IDLs system
;  variables <*>!D.X_CH_SIZE</*> and <*>!D.Y_CH_SIZE</*>. To get the
;  actual extent you have to respect the values of <*>!P.CHARSIZE</*>,
;  and <*>!X.CHARSIZE</*> or <*>!Y.CHARSIZE</*>. <C>Charsize</C> is a
;  convenience function that does all this stuff for you.
;
; CATEGORY:
;  Fonts
;  Graphic
;
; CALLING SEQUENCE:
;*c = Charsize([/DEVICE | /DATA | /NORMAL])
;
; INPUT KEYWORDS:
;  DEVICE<BR>DATA<BR>NORMAL:: returns size in device, data or normal coordinates. <*>/DEVICE</*> is the default.
;
; OUTPUTS:
;  c :: 2-element vector containing the average character width and height
;
; EXAMPLE:
;*print, charsize(/NORMAL)
;returns the average character size in normal coordinates.
;
; SEE ALSO:
;  <A>UConvert_Coord</A>
;
;-

FUNCTION Charsize, DEVICE=device, DATA=data, NORMAL=normal

  IF Keyword_Set(DATA)+Keyword_Set(NORMAL)+Keyword_Set(DEVICE) GT 1 THEN Console, /FATAL, 'specify either /DEVICE, /DATA or /NORMAL'
  IF Keyword_Set(DATA)+Keyword_Set(NORMAL)+Keyword_Set(DEVICE) EQ 0 THEN Device=1
 

  IF Keyword_Set(DEVICE) THEN BEGIN
      cs = [!D.X_CH_SIZE, !D.Y_CH_SIZE]
  END ELSE BEGIN 
      IF Keyword_Set(NORMAL) THEN cc = UConvert_Coord([0,!D.X_CH_SIZE],[0,!D.Y_CH_SIZE], /DEVICE, /TO_NORMAL) $
                             ELSE cc = UConvert_Coord([0,!D.X_CH_SIZE],[0,!D.Y_CH_SIZE], /DEVICE, /TO_DATA)
      cs = reform(cc(*,1)-cc(*,0))
  END
  RETURN, !P.CHARSIZE*[!X.CHARSIZE, !Y.CHARSIZE]*cs

END
