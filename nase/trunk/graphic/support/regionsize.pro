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
;  window and its surrounding annotation area.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*s=RegionSize([/NORMAL | /DEVICE])
;
; INPUT KEYWORDS:
;  NORMAL:: size will be returned in normal coordinates. This is
;           the default.
;  DEVICE:: size will be returned in device coordinates.
;  
;
; OUTPUTS:
;  s:: a two-element array containing width and height of the plot
;      region in normal or device coordinates
;
; PROCEDURE:
;*+ get window size<BR>
;*+ divide by number of horizontal/vertical windows
;*+ optionally convert to device coordinates
;  
; EXAMPLE:
;*print, RegionSize()
;
; SEE ALSO:
;  <A>Region</A>
;
;-

FUNCTION RegionSize, NORMAL=normal, DEVICE=device

   mm = !P.MULTI
                                ; fix IDL nonsense
   mm(1) = MAX([1,mm(1)])
   mm(2) = MAX([1,mm(2)])

                                ; size of visible window in pixel
   ps = DOUBLE([!D.X_VSIZE, !D.Y_VSIZE]) 

                                ; respect multiple plots
   ps(0) = FIX(ps(0) / DOUBLE(mm(1)))
   ps(1) = FIX(ps(1) / DOUBLE(mm(2)))



   IF NOT KEYWORD_SET(DEVICE) THEN BEGIN
       v= UConvert_Coord([0,ps(0)], [0,ps(1)], /DEVICE, /TO_NORMAL)
       ps = (v(*,1)-v(*,0))
   END
   RETURN, ps
   
END
