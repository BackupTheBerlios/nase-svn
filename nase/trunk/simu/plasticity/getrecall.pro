;+
; NAME:
;  GetRecall()
;
; AIM: Determine current state of learning potentials in Recall structure.
;
; PURPOSE:            Liefert den aktuellen Zustand der Lernpotentiale 
;                     einer Recall-Struktur
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE:   LPvalues = GetRecall(LPstruc)
;
; INPUTS:             LPstruc: eine mit InitRecall initialisierte 
;                              Lernpotentialstruktur
;
; OUTPUTS:            LPvalues: die Matrix mit den aktuellen
;                               Lernpotentialen 
;
; SEE ALSO:           <A HREF="#INITRECALL">InitRecall</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/09/26 15:13:43  thiel
;         AIMS added.
;
;     Revision 2.1  1997/12/10 15:55:47  saam
;           Birth
;

FUNCTION GetRecall, _LP

   Handle_Value, _LP, LP, /NO_COPY   
   Recall = LP.values   
   Handle_Value, _LP, LP, /NO_COPY, /SET
   
   RETURN, Recall

END
