;+
; NAME: Set()
;
; AIM:  checks if a variable is defined
;
;
; PURPOSE: Fragt ab, ob eine Variable definiert ist.
;          Diese Funktion kann anstelle der IDL-Function KEYWORD_SET()
;          verwendet werden, wenn 0 ein erlaubte Wert für die
;          betreffende Variable ist (dann liefert KEYWORD_SET()
;          nämlich FALSE zurück!)
;
;
;
; CATEGORY: Basic
;
;
;
; CALLING SEQUENCE: Result = SET ( Variable )
;
;
; 
; INPUTS: Variable: eine beliebige Variable
;
;
;
; OPTIONAL INPUTS: ---
;
;
;	
; KEYWORD PARAMETERS: ---
;
;
;
; OUTPUTS: Result: TRUE, wenn Variable definiert (gesetzt) ist
;                  FALSE sonst
;
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: ----
;
;
;
; SIDE EFFECTS: ---
;
;
;
; RESTRICTIONS: ---
;
;
;
; PROCEDURE: ---
;
;
;
; EXAMPLE: If Set ( Mein_Keyword ) then print, 'Das Schlüsselwort
;                                               wurde beim Aufruf angegeben!'
;
;
;
; MODIFICATION HISTORY:
;
;       Mon Jul 28 16:41:11 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion erstellt.
;
;-

Function Set, Variable

return, (n_elements (Variable) ne 0)

end
