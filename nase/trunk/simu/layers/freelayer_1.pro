;+
; NAME:                 FreeLayer_1
;
; PURPOSE:              Gibt eine Neuronenschicht vom Typ 1 frei 
;                           (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 1ZK)
;
; CATEGORY:             SIMULATION LAYERS
;
; CALLING SEQUENCE:     FreeLayer_1, L
;
; INPUTS:               L: eine mit InitLayer_1 initialisierte Layer-Struktur
;
; EXAMPLE:              para1 = InitPara_1(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_1(height=5, width=5, type=para1)
;                       FreeLayer_1, Layer
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.1  1998/01/26 13:01:59  saam
;             eine leichte Geburt
;
;
;-

PRO FreeLayer_1, L

   IF NOT Set(L) THEN Message, 'invalid layer structure'
   IF N_Params() NE 1 THEN Message, 'syntax error: check parameters'
   
   
   IF Contains(L.info, 'LAYER') AND Contains(L.Type, '1') THEN BEGIN
      IF Handle_Value(L.o) THEN Handle_Free, L.o ELSE Message, 'i dont understand'
   END ELSE Message, 'invalid layer structure'
   
END 
