;+
; NAME: Contains()
;
; PURPOSE: Prüft einen String auf Vorkommen eines Substrings
;          Insbesondere bei Info-Tags zu verwenden (s. Beispiel)
;          Dafür gibt es inzwischen sogar noch komfortabler die
;          Routine <A HREF="../#TESTINFO">TestInfo</A>.
;
; CATEGORY: Misc
;
; CALLING SEQUENCE: Result = Contains (String, Pattern [,/IGNORECASE | ,/WATCHCASE])
;
; INPUTS: String:  String, der durchsucht werden soll
;         Pattern: String, nach dem gesucht werden soll
;
; KEYWORD PARAMETERS: IGNORECASE: Wenn gesetzt, werden Strings 
;                                 vorm Vergleich in Großbuchstaben konvertiert.
;                                 DIES IST SEIT VERSION 1.3 DEFAULT!
;                     WATCHCASE : Das Gegenteil von IGNORECASE: Beim
;                                 Vergeleich wird Gross-/Kleinschreibung beachtet.
;
; OUTPUTS: Result: Boolean
;
; EXAMPLE: If Contains(Struct.Info, 'Foobar') then print, 'Struct is of Foobar-Type!'
;
; SEE ALSO: <A HREF="../#TESTINFO">TestInfo</A>
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  1998/01/28 16:46:46  kupper
;               /IGNORECASE ist jetzt Default!
;               CASE-Schlüsselwort hinzugefügt.
;
;        Revision 1.2  1998/01/28 13:56:30  kupper
;               Nur Hyperlink auf die neue TestInfo-Routine hinzugefügt.
;
;        Revision 1.1  1997/10/21 13:23:55  kupper
;               Schöpfung.
;
;-

Function Contains, string, pattern, IGNORECASE=ignorecase, WATCHCASE=watchcase

   TRUE  = (1 eq 1)
   FALSE = (1 eq 0)

   If not Keyword_Set(WATCHCASE) then begin
      if StrPos(StrUpCase(string), StrUpCase(pattern)) ge 0 then return, TRUE else return, FALSE
   endif else begin
      if StrPos(string, pattern) ge 0 then return, TRUE else return, FALSE
   endelse
   
End
