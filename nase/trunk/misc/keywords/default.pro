
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
;                            Aufruf: Defualt (Variable, Defaultwert)
;
;                            Ist die übergebene Variable undefiniert, so wird sie mit dem Defaultwert initialisiert.
;                            Ist sie definiert, so passiert nichts.
;
;------------------------------------------------------------------------

Pro default, Var, Value

        if n_elements(Var) eq 0 then Var = Value
        
END
