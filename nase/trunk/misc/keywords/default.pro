;+
; NAME: Default
;
; PURPOSE:  Defaultwert für optionalen Parameter einer Prozedur oder Funktion setzen
;
; CATEGORY: miscellaneous
;
; CALLING SEQUENCE: Default, Variable, Defaultwert
;
; INPUTS: Variable, Defaultwert:  Ist die übergebene Variable undefiniert, so wird sie mit dem Defaultwert initialisiert.
;                                 Ist sie definiert, so passiert nichts.
;
; EXAMPLE: Default, Titel, 'The unforgettable Firing'
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  1997/11/04 12:25:07  kupper
;               Nur Dokumentation in den Header geschrieben!
;
;
;               Seit Version 1.2 kann sowohl die erste als
;                auch die zweite Variable undefiniert
;                sein, ohne daß ein Fehler auftritt.
;-

Pro default, Var, Value

        if (n_elements(Var) eq 0) and (n_elements(Value) ne 0) then Var = Value
        
END
