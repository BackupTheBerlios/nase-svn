;+
; NAME:               DiffSet
;
; AIM:                returns the difference of two sets (arrays)
;
; PURPOSE:            Bildet die Differenzmenge aus zwei Mengen (Arrays).
;
; CATEGORY:           MISC ARRAY SET
;
; CALLING SEQUENCE:   diff = DiffSet(A, sub)
;
; INPUTS:             A  : die Menge aus der Elemente geloescht werden
;                     sub: die aus A zu entfernenden Elemente
;
; OUTPUTS:            diff : die Differenzmenge, falls leer wird !NONE
;                            zurueckgegeben
;
; EXAMPLE:
;                     print, DiffSet([1,2,3,4,5], [1,3,6,8])
;                            2       4       5
;                     IF DiffSet([1,2,3,4,5], [1,2,3,4,5,6,7,8,9]) EQ !NONE THEN print, 'Nix mehr drin'
;                     Nix mehr drin       
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/09/25 09:12:54  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.1  1998/07/21 13:21:27  saam
;           urgently needed
;
;
;-
FUNCTION DiffSet, A, sub

   nA = N_Elements(A)
   nS = N_Elements(sub)

   FOR i=0, nA-1 DO BEGIN
      IF NOT InSet(A(i), sub) THEN BEGIN
         ; ok, we've got one  Element in A that's not in sub 
         IF Set(B) THEN B = [B, A(i)] ELSE B = A(i)
      END
   END

   IF Set(B) THEN RETURN, B ELSE RETURN, !NONE


END
