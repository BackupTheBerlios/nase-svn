;+
; NAME:
;  CIndex2RGB
;
; VERSION:
;  $Id$
;
; AIM:
;  returns RGB values for given color indices
;
; PURPOSE:
;  Returns the red, green and blue values for given color table
;  indices. 
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE:    
;*rgb = CIndex2RGB(cindex)
;
; INPUTS:
;  cindex:: index or array of indices to the color palette
;
; OUTPUTS:
;  rgb:: (3,n)-array containing the red, green and blue values
;        for the respective color index/indices in the first dimension.
;
; EXAMPLE:
;*print, CIndex2RGB(234)
;-

FUNCTION CIndex2RGB, cindex
   On_Error,2 

   IF (MAX(cindex) GT !D.Table_Size-1) OR (MIN(cindex) LT 0) THEN Console, "color index out of range", /FATAL

   default, DECOMPOSED, 0
   IF !D.Name EQ ScreenDevice() then DEVICE, GET_DECOMPOSED=DECOMPOSED
   IF !D.Name EQ ScreenDevice() AND $ 
    !D.N_COLORS EQ 16777216 AND $
    DECOMPOSED EQ 1 THEN BEGIN
      b = cindex / 65536 
      g = (cindex MOD 65536)/256
      r = cindex MOD 256
      RETURN, [r,g,b]
   END ELSE BEGIN
       ; this is copied and adapted from the former getcolorindex
       cm = intarr(256,3) 
       TvLCT, cm, /GET  
       cm = TRANSPOSE(cm)
   
       snr = SIZE(cindex)
       IF (snr(0) GT 0) THEN RETURN, REFORM(cm(*,cindex), [3, snr(1:snr(0))]) $
                        ELSE RETURN, cm(*, cindex)
   END
END
