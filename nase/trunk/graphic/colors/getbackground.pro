;+
; NAME:
;  GetBackground()
;
; VERSION:
;  $Id$
;
; AIM:
;  get current background color index
;
; PURPOSE: 
;  This procedure gets the background color. It should be
;  used instead of directly accessing <*>!P.BACKGROUND</*>. To get the
;  corresponding RGB values, please use <A>CIndex2RGB</A>.
;
; CATEGORY:
;  Color
;
; CALLING SEQUENCE:
;*idx=GetBackground()
;
; OUTPUTS:
;  idx:: color index (0..255) specifying the background color
;
; EXAMPLE:
;*plot, indgen(10), COLOR=GetBackground()
;
;*print, CIndex2RGB(GetBackground())
;*; 0
;*; 0
;*; 0
;
;
; SEE ALSO:
;  <A>CIndex2RGB</A>, <A>GetForeground</A>, <A>Foreground</A>, <A>Background</A>,
;  <A>RGB</A>, <A>Color</A>, or look for a document describing the
;  NASE color management. 
;
;-

FUNCTION GetBackground

RETURN, !P.BACKGROUND

End
