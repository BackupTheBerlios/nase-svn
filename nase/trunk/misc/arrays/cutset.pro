;+
; NAME:               CutSet
;
; PURPOSE:            Bildet die Schnittmenge aus zwei Mengen (Arrays).
;
; CATEGORY:           MISC ARRAY SET
;
; CALLING SEQUENCE:   cut = CutSet(A, B)
;
; INPUTS:             A,B : die zu schneidenen Mengen (Arrays)
;
; OUTPUTS:            cut : die Schnittmenge; falls leer wird !NONE zurueckgegeben
;
; EXAMPLE:
;                     print, CutSet([1,2,3,4,5], [1,3,6,8])
;                            1      3
;                     IF DiffSet([1,2,3,4,5], [6,7,8]) EQ !NONE THEN print, 'Nix drin'
;                     Nix drin       
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/07/21 13:21:27  saam
;           urgently needed
;
;
;-
FUNCTION CutSet, A, B

   nA = N_Elements(A)
   nB = N_Elements(B)

   FOR i=0, nA-1 DO BEGIN
      IF InSet(A(i), B) THEN BEGIN
         ; ok, we've got one  Element in A that's in B 
         IF Set(R) THEN R = [R, A(i)] ELSE R = A(i)
      END
   END

   IF Set(R) THEN RETURN, R ELSE RETURN, !NONE


END
