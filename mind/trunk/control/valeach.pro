;+
; NAME:                 ValEach()
;
; AIM:                  return parameter values used in loops
;  
; PURPOSE:              When variing parameters systematically via
;                       the ForEach mechanism, most times you want to
;                       evaluate your data in dependence of the
;                       parameter values. ValEach returns the values
;                       used for all or specific loops. 
;                       
; CATEGORY:             MIND CONTROL LOOPS
;  
; CALLING SEQUENCE:     val = ValEach( [LSKIP=lskip] [LCONST=lconst] )
;  
; KEYWORD PARAMETERS:   LSKIP : various loops in a hierarchie can be
;                               skipped, this is
;                               especially useful for metaroutines that
;                               evaluate data accross multiple iterations.
;                               You can specify a scalar or an array of
;                               loop indices to be skipped (1 denotes
;                               the most inner loop).
;                               negative values mean: skip all but this
;                               index. Note that the loop is completely
;                               omitted (including the filename). See
;                               also LCONST.
;                       LCONST: While LSKIP skips various loops, LCONST
;                               just assumes a constant value for them
;                               (the one they currently have). The
;                               Syntax is the same as for LSKIP. 
;  
; OUTPUTS:              val : array of parameter values
;  
; COMMON BLOCKS:        ATTENTION
;  
; SEE ALSO:             ForEach
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/09/29 08:10:28  saam
;        added the AIM tag
;
;        Revision 1.1  2000/06/21 09:01:36  saam
;              + used e.g., by AVG in explore
;
;-

FUNCTION ValEach, LSKIP=_lskip, LCONST=_lconst

   COMMON ATTENTION

   ; scan AP for loop instructions __?
   TST = ExtraDiff(AP, '__TV', /SUBSTRING, /LEAVE) ; temporary 
   TSN = ExtraDiff(AP, '__TN', /SUBSTRING, /LEAVE)
   loopc = N_Tags(TST)

   RES = !NONE

   IF Set(_LSKIP) OR Set(_LCONST) THEN BEGIN
       IF Set(_LSKIP) THEN BEGIN            
           IF ((N_Elements(_LSKIP) GT 1) AND (MIN(_LSKIP) LT 1)) THEN Console, 'LSKIP: inverse syntax with multiple arguments ??', /FATAL
           IF (_LSKIP(0) LT 0) THEN BEGIN
               LSKIP=Indgen(loopc)+1
               LSKIP=Diffset(LSKIP, -_LSKIP)
           END ELSE LSKIP = _LSKIP
       END ELSE lskip=!NONE

       IF Set(_LCONST) THEN BEGIN            
           IF ((N_Elements(_LCONST) GT 1) AND (MIN(_LCONST) LT 1)) THEN Console, 'LCONST: inverse syntax with multiple arguments ??', /FATAL
           IF (_LCONST(0) LT 0) THEN BEGIN
               LCONST=Indgen(loopc)+1
               LCONST=Diffset(LCONST, -_LCONST)
           END ELSE LCONST = _LCONST
       END ELSE lconst=!NONE


       FOR i = 0, loopc-1 DO BEGIN
           IF (NOT Inset(loopc-i, lconst)) AND (NOT Inset(loopc-i, lskip)) THEN BEGIN
               IF (Res(0) EQ !NONE) THEN Res = TST.(i) ELSE RES = [RES, TST.(i)]
           END 
       END
   END 




   RETURN, RES   
END
