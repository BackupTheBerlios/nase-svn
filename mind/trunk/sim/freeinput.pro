;+
; NAME:
;  FreeInput
;
; VERSION:
;  $Id$
;
; AIM:
;  Cleans up memory and files used by the input (used by <A>Sim</A>)
;
; PURPOSE:
;  Frees dynamic data structures used by <A>Input</A>. This routine
;  is called from <A>Sim</A>. It makes nearly no sense to call it directly.
;
; CATEGORY:
;  Input
;  Internal
;  MIND
;  Simulation  
;
; SEE ALSO: <A>Sim</A>, <A>InitInput</A>, <A>Input</A>
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
