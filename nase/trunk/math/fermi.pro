;+
; NAME: Fermi()
;
; PURPOSE: Fermi-Funktion, eine sigmoide Funktion
;
; CATEGORY: math, simu
;
; CALLING SEQUENCE: result = Fermi ( x [, T] )
;
; INPUTS: x: Wert aus dem Intervall (-oo, +oo)
;
; OPTIONAL INPUTS: T: Temperatur. Je höher die Temperator, desto 
;                     "weicher" die Schwelle.
;                     Für T->0 nähert sich die Funktion mehr und 
;                     mehr einer Stufen-(Heavyside-)Funktion an.
;                     Für T=0 ist das Ergebnis undefiniert.
;                     Default: T=1.0
;
; RESTRICTIONS: T ne 0
;
; PROCEDURE: straightforward: return, 1 / (1+exp(-x/float(T)))
;
; EXAMPLE: a=indgen(11)-5
;          plot, a, Fermi(a)
;
; SEE ALSO:
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1999/11/19 16:26:12  kupper
;        einfach und ergreifend.
;
;-

Function Fermi, x, T
   default, T, 1
   return, 1 / (1+exp(-x/float(T)))
End
