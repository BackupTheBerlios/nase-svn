;+
; NAME:
;  GetForeground()
;
; VERSION:
;  $Id$
;
; AIM:
;  get current foreground color index
;
; PURPOSE: 
;  This procedure gets the foreground (plotting) color. It should be
;  used instead of directly accessing <*>!P.COLOR</*>. To get the
;  corresponding RGB values, please use <A>CIndex2RGB</A>.
;
; CATEGORY:
;  Color
;
; CALLING SEQUENCE:
;*idx=GetForeground()
;
; OUTPUTS:
;  idx:: color index (0..255) specifying the foreground color
;
; EXAMPLE:
;*plot, indgen(10), COLOR=GetForeground()
;
;*print, CIndex2RGB(GetForeground())
;*; 255
;*; 255
;*; 255
;
;
; SEE ALSO:
;  <A>CIndex2RGB</A>, <A>GetBackground</A>, <A>Foreground</A>, <A>Background</A>,
;  <A>RGB</A>, <A>Color</A>, or look for a document describing the
;  NASE color management. 
;
;-

FUNCTION GetForeground

RETURN, !P.COLOR

End
