;+
; NAME: Fermi()
;
; AIM: The fermi function.
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
;                     Die Steigung an der Stelle x=0 beträgt 1/(4T).
;                     Default: T=1.0
;
; OUTPUT: Wert aus dem Intervall (0, 1)
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
;        Revision 2.3  2000/07/21 12:49:45  kupper
;        Added comment on slope to header.
;
;        Revision 2.2  1999/11/19 16:27:28  kupper
;        Completed header.
;
;        Revision 2.1  1999/11/19 16:26:12  kupper
;        einfach und ergreifend.
;
;-

Function Fermi, x, T
   default, T, 1
   return, 1 / (1+exp(-x/float(T)))
End
