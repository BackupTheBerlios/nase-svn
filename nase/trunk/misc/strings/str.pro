;+
; NAME: Str()
;
; AIM: removes all leading and trailing white spaces from a string
;
; PURPOSE: Wrapper-Prozedur für String() (Standard-IDL)
;          Macht genau das gleiche wie String(), entfernt aber
;          zusätzlich alle führenden oder folgenden Leerzeichen beim Ergebnis.
;
; CATEGORY: Output
;
; CALLING SEQUENCE: s. String()
;
; INPUTS: s. String()
;
; OPTIONAL INPUTS: s. String()
;
; KEYWORD PARAMETERS: s. String()
;
; OUTPUTS: s. String()
;
; OPTIONAL OUTPUTS: s. String()
;
; PROCEDURE: strtrim(string(...),2)
;
; EXAMPLE: Print, "Dreiundzwanzig..."+str(23)+"!"
;
;          zum Vergleich: Print, "Dreiundzwanzig..."+string(23)+"!"
;
; SEE ALSO: String() (Standard-IDL)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/25 09:13:11  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 2.1  1998/03/29 16:19:47  kupper
;               Schöpfung aus Bequemlichkeit...
;
;-

Function Str, var, _extra=_EXTRA

   If Keyword_Set(_EXTRA) then $
    Return, strtrim(string(var, _EXTRA=_extra), 2) else $
    Return, strtrim(string(var), 2)

End
