;+
; NAME:
;  ResetRecall
;
; AIM: Reset learning potentials contained in Recall structure.
;
; PURPOSE: Resetten der Lernpotentiale in einer LP-Struktur
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE: ResetRecall, LP
;
; INPUTS: LP: Eine mit <A HREF="#INITRECALL">InitRecall()</A> initialisierte LP-Struktur.
;
; PROCEDURE: Der Value-Tag der Struktur wird auf Null gesetzt.
;
; EXAMPLE: LAYER = InitLayer_1(...)
;          LP = InitRecall( LAYER, EXPO=[1.0, 10.0])
;          <...Schlimmulation...>
;          ResetRecall, LP              ; totale Amnesie aller Neuronen
;          <...weitere Schlimmulation...>
;
; SEE ALSO: <A HREF="#INITRECALL">InitRecall()</A>, <A HREF="#TOTALRECALL">TotalRecall</A>, <A HREF="#FREERECALL">FreeRecall</A>.
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/26 15:13:43  thiel
;            AIMS added.
;
;        Revision 2.1  1998/04/08 18:31:07  kupper
;               Schöpfung.
;


Pro ResetRecall, LP

   If (info(LP) ne "l") and (info(LP) ne "e") then message, 'Dies ist keine Lernpotential-Struktur!'

   Handle_Value, LP, struct, /NO_COPY
   struct.values = 0
   Handle_Value, LP, struct, /SET, /NO_COPY

End
