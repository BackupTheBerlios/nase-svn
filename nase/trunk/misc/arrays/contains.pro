;+
; NAME: Contains()
;
; PURPOSE: Prüft einen String auf Vorkommen eines Substrings
;          Insbesondere bei Info-Tags zu verwenden (s. Beispiel)
;
; CATEGORY: Misc
;
; CALLING SEQUENCE: Result = Contains (String, Pattern [,/IGNORECASE])
;
; INPUTS: String:  String, der durchsucht werden soll
;         Pattern: String, nach dem gesucht werden soll
;
; KEYWORD PARAMETERS: IGNORECASE: Wenn gesetzt werden Strings 
;                                 vorm Vergleich in Großbuchstaben konvertiert.
;
; OUTPUTS: Result: Boolean
;;
; EXAMPLE: If Contains(Struct.Info, 'Foobar', /IGNORECASE) then print, 'Struct is of Foobar-Type!'
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/10/21 13:23:55  kupper
;               Schöpfung.
;
;-

Function Contains, string, pattern, IGNORECASE=ignorecase

   TRUE  = (1 eq 1)
   FALSE = (1 eq 0)

   If Keyword_Set(IGNORECASE) then begin
      if StrPos(StrUpCase(string), StrUpCase(pattern)) ge 0 then return, TRUE else return, FALSE
   endif else begin
      if StrPos(string, pattern) ge 0 then return, TRUE else return, FALSE
   endelse
   
End
