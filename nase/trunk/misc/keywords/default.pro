
;------------------------------------------------------------------------
;
;       Name               : Default
;       Projekt            : Allgemein
;
;       Autor              : R�diger Kupper
;
;       erstellt am        : 21.7.97
;       letze Modifikation :
;
;       Funktion           : Defaultwert f�r optionalen Parameter einer Prozedur oder Funktion setzen
;
;                            Aufruf: Defualt (Variable, Defaultwert)
;
;                            Ist die �bergebene Variable undefiniert, so wird sie mit dem Defaultwert initialisiert.
;                            Ist sie definiert, so passiert nichts.
;
;------------------------------------------------------------------------

Pro default, Var, Value

        if n_elements(Var) eq 0 then Var = Value
        
END
