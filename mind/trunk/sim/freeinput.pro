;+
; NAME:                FreeInput
;
; PURPOSE:             Frees dynamic data structures used by INPUT, SIMP. This routine
;                      is called from SIM. It makes nearly no sense to call it directly.
;
; CATEGORY:            MIND SIM INTERNAL
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#SIM>sim</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#INITINPUT>initinput</A>, <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#INPUT>input</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/12/10 10:03:57  saam
;           * converted from freeninput
;
;
;-
PRO FreeInput, _IN

   Handle_Value, _IN, IN, /NO_COPY

   IF (IN.TYPE EQ 3) THEN Eject, IN.VID, /NOLABEL, /SHUTUP
   IF ExtraSet(IN, 'RECLUN') THEN Eject, IN.RECLUN, /NOLABEL, /SHUTUP

   Handle_Value, _IN, IN, /NO_COPY, /SET
   IF Handle_Info(_IN) THEN Handle_Free, _IN

END
