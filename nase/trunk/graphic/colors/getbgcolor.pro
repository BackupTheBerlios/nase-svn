;+
; NAME:
;  GetBGColor()
;
; AIM:
;  outdated !! use CIndex2RGB(getBackground()) instead 
;
;-

FUNCTION GetBGColor

   Console, "outdated!! please use CIndex2RGB(GetBackground()) instead!!", /WARN 
   RETURN, CIndex2RGB(getBackground()) 

END
