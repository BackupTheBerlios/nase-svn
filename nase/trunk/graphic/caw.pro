;------------------------------------------------------------------------
;
;       Name               :
;       Projekt            :
;
;       Autor              : R�diger Kupper
;
;       erstellt am        : 
;       letze Modifikation :
;
;       Funktion           :
;
;------------------------------------------------------------------------

;       $Log$
;       Revision 1.2  1998/03/20 17:11:59  kupper
;              CAW hei�t jetzt auch "Close All WIDGETS".
;

PRO CAW
WIDGET_CONTROL, /RESET
while (!D.Window GE 0) do WDelete, !D.Window
END
