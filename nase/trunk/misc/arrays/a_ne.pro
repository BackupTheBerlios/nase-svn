;+
; NAME: A_NE ()
;
; PURPOSE: Vergleich von zwei Variablen, insbes. von Arrays
;
; CATEGORY: misc
;
; CALLING SEQUENCE: Erg = A_NE (Arr1, Arr2)
;
; INPUTS: Arr1, Arr2: bel. Arrays
;
; OUTPUTS: Erg: Boolean
;;
; EXAMPLE: if A_NE (A, B) then print, "sind nicht gleich!"
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/10/08 15:22:39  kupper
;               Schöpfung!
;               (Hoffentlich gibts das nicht eh schon...)
;
;-

Function A_NE, a, b
   return, not( A_EQ(a, b) )
End
