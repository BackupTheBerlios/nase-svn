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
;     Revision 1.2  2000/01/14 10:26:58  alshaikh
;           NEW: 'EXTERN' input
;
;     Revision 1.1  1999/12/10 10:03:57  saam
;           * converted from freeninput
;
;
;-
PRO FreeInput, _IN

   Handle_Value, _IN, IN, /NO_COPY

 
; free filters
   number_filter =  IN.number_filter
   
   pattern = 0.0
   FOR i=0, number_filter-1 DO BEGIN
      Handle_Value,IN.filters(i),act_filter 
      pattern = CALL_FUNCTION(act_filter.NAME,MODE=2) 
      print,'INPUT:Filter ->',act_filter.NAME,'<- stopped'
   ENDFOR 
   
   IF (IN.TYPE EQ 3) THEN Eject, IN.VID, /NOLABEL, /SHUTUP
   IF ExtraSet(IN, 'RECLUN') THEN Eject, IN.RECLUN, /NOLABEL, /SHUTUP
   
   Handle_Value, _IN, IN, /NO_COPY, /SET



   IF Handle_Info(_IN) THEN Handle_Free, _IN

END
