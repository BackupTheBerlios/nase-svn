;+
; NAME:
;  Str()
;
; AIM:
;  Removes all leading and trailing white spaces from a string.
;
; PURPOSE: 
;  This routine is a simple wrapper for <C>String()</C>. Additionally to
;  the functionality of <C>String()</C> it removes all leading and
;  trailing white spaces. It also knows about the NASE-specific
;  Variable <C>!NONE</C> and prints it properly.
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
;*IDL/NASE> Print, "twentythree..."+Str(23)+"!"
;*twentythree...23!
;
; while call of <C>String()</C> results in:
;*IDL/NASE> Print, "twentythree..."+string(23)+"!"
;*twentythree...      23!
;
; Behaviour using <C>!NONE</C>:
;*IDL/NASE> Print, String([0,1,2,!NONE])
;*      0.00000       1.00000       2.00000      -999999.
;
;*IDL/NASE> Print, Str([0,1,2,!NONE])
;*0.00000 1.00000 2.00000 !NONE
;
; SEE ALSO: 
;  IDL's <C>String()</C>
;
;-

Function Str, var, _extra=_EXTRA

   On_Error, 2

   type = Size(var, /TNAME)
   IF type NE 'STRING' THEN nidx = Where(var EQ !NONE, c) ELSE c = 0

   If Keyword_Set(_EXTRA) then $
    outstring = strtrim(string(var, _EXTRA=_extra), 2) else $
    outstring = strtrim(string(var), 2)

   IF c NE 0 THEN outstring(nidx) = '!NONE'

   Return,  outstring

END
