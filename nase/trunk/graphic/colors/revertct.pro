;+
; NAME:
;  RevertCT
;
; VERSION:
;  $Id$
;
; AIM:
;  reverts the current color table
;
; PURPOSE:
;  Reverts the current color table in a NASE compatible way.
;                                          
; CATEGORY:
;  Color
;  NASE
;  
; CALLING SEQUENCE:
;* RevertCT
;
; SEE ALSO:
; <A>ULoadCt</A>
;
;-

Pro RevertCT
   common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

   MCT = intarr(!TOPCOLOR+1,3) 
   UTvLCT, MCT, /GET 
   MCT=MCT(0:!TOPCOLOR,*)
   MCT = Reverse(TEMPORARY(MCT),1)
   UTvLCT,  MCT

   R_CURR[0:!TOPCOLOR] = MCT[*, 0]
   G_CURR[0:!TOPCOLOR] = MCT[*, 1]
   B_CURR[0:!TOPCOLOR] = MCT[*, 2]
End
