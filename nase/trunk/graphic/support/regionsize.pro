;+
; NAME:
;  RegionSize()
;
; VERSION:
;  $Id$
;
; AIM:
;  returns the size of the next plot region 
;
; PURPOSE:
;  Computes the size the of the next plot region in normal or device
;  coordinates. Conforming to IDLs definition, the region specifies
;  a rectangle enclosing the plot area, which includes the plot data
;  window and its surrounding annotation area. <C>RegionSize()</C>
;  takes the setting of <*>!P.MULTI</*> into account. 
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* s=RegionSize([/NORMAL | /DEVICE])
;
; INPUT KEYWORDS:
;  NORMAL:: Size will be returned in normal coordinates. This is
;           the default. This also gives reasonable values if no
;           window has been openend yet.
;  DEVICE:: Size will be returned in device coordinates. If no window
;           has been openend yet, this cannot be calculated.
;
; OUTPUTS:
;  s:: a two-element array containing width and height of the plot
;      region in normal or device coordinates
;
; PROCEDURE:
;*+ for /DEVICE coordinates, get window size. For normal coordinates,
;*  just set the maximum size to 1.<BR>
;*+ divide by number of horizontal/vertical windows
;
; EXAMPLE:
;*print, RegionSize()
;
; SEE ALSO:
;  <A>Region</A>
;
;-

FUNCTION RegionSize, NORMAL=normal, DEVICE=device

   On_Error, 2

   IF Keyword_Set(DEVICE) THEN BEGIN
      IF Keyword_Set(NORMAL) THEN Console, /FATAL $
       , '/NORMAL and /DEVICE cannot be set simultaneously.'
      normal = 0
   ENDIF ELSE $
    normal = 1

   mm = !P.MULTI
   ;; fix IDL nonsense
   mm[1] = Max([1,mm[1]])
   mm[2] = Max([1,mm[2]])

   IF Keyword_Set(NORMAL) THEN BEGIN
      ps = [1.d, 1.d] ;; the whole device in normal coordinates
   ENDIF ELSE BEGIN
      IF (!D.WINDOW EQ -1) AND (!D.NAME NE 'PS') THEN Console, /FATAL $
       , 'No window to determine size for.'
      ;; size of visible window in pixel
      ps = Double([!D.X_VSIZE, !D.Y_VSIZE]) 
   ENDELSE

   ;; respect multiple plots
;   ps[0] = Fix(ps[0] / Double(mm[1]))
;   ps[1] = Fix(ps[1] / Double(mm[2]))
   ps[0] = ps[0] / Double(mm[1])
   ps[1] = ps[1] / Double(mm[2])



;   IF NOT KEYWORD_SET(DEVICE) THEN BEGIN
;       v= UConvert_Coord([0,ps(0)], [0,ps(1)], /DEVICE, /TO_NORMAL)
;       ps = (v(*,1)-v(*,0))
;   END

   RETURN, ps
   
END
