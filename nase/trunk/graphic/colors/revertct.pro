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
   
   MCT = intarr(!TOPCOLOR+1,3) 
   UTvLCT, MCT, /GET 
   MCT=MCT(0:!TOPCOLOR,*)
   MCT = Reverse(TEMPORARY(MCT),1)
   UTvLCT,  MCT

End
