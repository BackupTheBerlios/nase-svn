;+
; NAME:               LearnAP
;
; PURPOSE:            Gibt den Learn-Tag einer DW-Struktur zurueck
;
; CATEGORY:           INTERNAL
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1997/12/10 15:51:22  saam
;           Birth
;
;
;-
FUNCTION LearnAP, _DW

   Handle_Value, _DW, DW, /NO_COPY
   Handle_Value, DW.Learn, LP
   Handle_Value, _DW, DW, /NO_COPY, /SET
   RETURN, LP

END

