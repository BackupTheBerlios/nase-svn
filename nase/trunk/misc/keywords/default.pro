
;------------------------------------------------------------------------
;
;       Name               : Default
;       Projekt            : Allgemein
;
;       Autor              : Rüdiger Kupper
;
;       erstellt am        : 21.7.97
;       letze Modifikation :
;
;       Funktion           : Defaultwert für optionalen Parameter einer Prozedur oder Funktion setzen
;
;                            Aufruf: Default (Variable, Defaultwert)
;
;                            Ist die übergebene Variable undefiniert, so wird sie mit dem Defaultwert initialisiert.
;                            Ist sie definiert, so passiert nichts.
;
;                            Set Version 1.2 kann sowohl die erste als
;                            auch die zweite Variable undefiniert
;                            sein, ohne daß ein Fehler auftritt.
;
;------------------------------------------------------------------------

Pro default, Var, Value

        if (n_elements(Var) eq 0) and (n_elements(Value) ne 0) then Var = Value
        
END
