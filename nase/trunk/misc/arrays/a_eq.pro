;+
; NAME: A_EQ
;
; AIM: checks if two variables/arrays are identical
;
; PURPOSE: Vergleich von zwei Variablen, insbes. von Arrays
;
; CATEGORY: misc
;
; CALLING SEQUENCE: Erg = A_EQ (Arr1, Arr2)
;
; INPUTS: Arr1, Arr2: bel. Arrays
;
; OUTPUTS: Erg: Boolean
;;
; EXAMPLE: if A_EQ (A, B) then print, "sind gleich!"
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/25 09:12:54  saam
;        * added AIM tag
;        * update header for some files
;        * fixed some hyperlinks
;
;        Revision 1.1  1997/10/08 15:22:39  kupper
;               Schöpfung!
;               (Hoffentlich gibts das nicht eh schon...)
;
;-

Function A_EQ, a, b
   TRUE  = (1 eq 1)
   FALSE = (1 eq 0)
   
   if n_elements(a) ne n_elements(b) then return, FALSE
   return, total(a ne b) eq 0
End
