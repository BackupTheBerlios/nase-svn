;+
; NAME:                 FreeLayer_2
;
; PURPOSE:              Gibt eine Neuronenschicht vom Typ 2 frei 
;                           (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 2ZK)
;
; CATEGORY:             SIMULATION LAYERS
;
; CALLING SEQUENCE:     FreeLayer_2, L
;
; INPUTS:               L: eine mit InitLayer_1 initialisierte Layer-Struktur
;
; EXAMPLE:              para1 = InitPara_2(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_2(height=5, width=5, type=para1)
;                       FreeLayer_2, Layer
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.3  1998/02/18 15:20:03  saam
;             falsche Typueberpruefung
;
;       Revision 2.2  1998/01/26 13:22:41  saam
;             ...von wegen
;
;       Revision 2.1  1998/01/26 13:02:00  saam
;             eine leichte Geburt
;
;
;-

PRO FreeLayer_2, L

   IF NOT Set(L) THEN Message, 'invalid layer structure'
   IF N_Params() NE 1 THEN Message, 'syntax error: check parameters'
   
   
   IF Contains(L.info, 'LAYER') AND Contains(L.Type, '2') THEN BEGIN
      IF Handle_Info(L.o) THEN Handle_Free, L.o ELSE Message, 'i dont understand'
   END ELSE Message, 'invalid layer structure'
   
END 
