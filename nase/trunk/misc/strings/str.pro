;+
; NAME:
;  Str()
;
; AIM:
;  removes all leading and trailing white spaces from a string
;
; PURPOSE: 
;  This routine is a simple wrapper for <C>String()</C>. Additionally to
;  the functionality of <C>String()</C> it removes all leading and
;  trailing white spaces
;
; CATEGORY:
;  Strings
;
; CALLING SEQUENCE: 
;  see <C>String()</C> for syntax, inputs and outputs 
;
; PROCEDURE: 
;  strtrim(string(...),2)
;
; EXAMPLE:
;* Print, "twentythree..."+str(23)+"!"
;*;twentythree...23!
;
; while call of string results in:
;* Print, "twentythree..."+string(23)+"!"
;*;twentythree...      23!
;
; SEE ALSO: 
;  <C>String()</C>
;
;-

Function Str, var, _extra=_EXTRA

   On_Error, 2

   If Keyword_Set(_EXTRA) then $
    Return, strtrim(string(var, _EXTRA=_extra), 2) else $
    Return, strtrim(string(var), 2)

End
