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
;     Revision 1.5  2000/05/16 16:28:15  saam
;           fixed two IDL3.6 problems
;
;     Revision 1.4  2000/04/06 09:40:58  saam
;           killed useless debugging message
;
;     Revision 1.3  2000/01/14 14:10:38  alshaikh
;           bugfix
;
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

IF (IN.TYPE EQ 11) THEN  BEGIN 
; free filters
   number_filter =  IN.number_filter
   
   pattern = 0.0
   FOR i=0, number_filter-1 DO BEGIN
       IF N_Elements(IN.temps) EQ 1 THEN _t = IN.temps ELSE _t = IN.temps(i) ;fix IDL3.6 problems!
       IF N_Elements(IN.filters) EQ 1 THEN Handle_Value,IN.filters,act_filter ELSE Handle_Value,IN.filters(i),act_filter ;fix IDL3.6 problems!
       pattern = CALL_FUNCTION(act_filter.NAME,MODE=2,temp_vals=_t) 
       IF pattern EQ 0 THEN print,'done'
   ENDFOR 
END 
   
   IF (IN.TYPE EQ 3) THEN Eject, IN.VID, /NOLABEL, /SHUTUP
   IF ExtraSet(IN, 'RECLUN') THEN Eject, IN.RECLUN, /NOLABEL, /SHUTUP
   
   Handle_Value, _IN, IN, /NO_COPY, /SET

   IF Handle_Info(_IN) THEN Handle_Free, _IN

END
