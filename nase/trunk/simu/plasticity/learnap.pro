;+
; NAME:
;  LearnAP()
;
; AIM: Return learn tag contained in DW structure. 
;
; PURPOSE:            Gibt den Learn-Tag einer DW-Struktur zurueck
;
; CATEGORY:
;  Simulation / Plasticity (Internal!)
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/09/26 15:13:43  thiel
;         AIMS added.
;
;     Revision 2.1  1997/12/10 15:51:22  saam
;           Birth
;

FUNCTION LearnAP, _DW

   Handle_Value, _DW, DW, /NO_COPY
   Handle_Value, DW.Learn, LP
   Handle_Value, _DW, DW, /NO_COPY, /SET
   RETURN, LP

END

