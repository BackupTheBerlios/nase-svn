;+
; NAME:
;  FreeLayer_9
;
; AIM:
;  Free memory allocated by layer of Four Compartment Object Neurons.
;
; PURPOSE:            Gibt eine Neuronenschicht beliebigen Typs frei. 
;
; CATEGORY:           SIMULATION LAYERS
;
; CALLING SEQUENCE:   FreeLayer, L
;
; INPUTS:             L: eine mit <A HREF="#INITLAYER">InitLayer</A> initialisierte Layer-Struktur
;
; PROCEDURE:          FreeLayer schaut nach dem Typ der übergebenen Parameter
;                     (aus dem type.type-String) und ruft mit CALL_PRCEDURE die
;                     jeweilige spezielle FreeLayer_i-Prozedur auf.
;
; EXAMPLE:            para1 = InitPara_1(tauf=10.0, vs=1.0)     
;                     Layer = InitLayer (height=5, width=5, type=para1)
;                     FreeLayer, Layer
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.1  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 2.4  1998/11/08 17:22:43  saam
;             frees new layer-handle for all neuron-types
;             freelayer_x is obsolete
;
;       Revision 2.3  1998/11/06 14:27:41  thiel
;              Hyperlinks.
;
;       Revision 2.2  1998/11/06 14:16:46  thiel
;            Kaputte Hyperlinks.
;
;-

PRO FreeLayer_9, _L, VARTIMESTEP=vartimestep

;   Handle_Value, _LAYER, LAYER, /NO_COPY
;   type = LAYER.TYPE
;   Handle_Value, _LAYER, LAYER, /NO_COPY,/SET
;   Call_Procedure, 'FreeLayer_'+type, _Layer
;
; at the moment all layers use same freeing mechanism

   TestInfo, _L, 'LAYER'
   Handle_Value, _L, L, /NO_COPY
   
   IF NOT Set(L) THEN Message, 'invalid layer structure'
   IF N_Params() NE 1 THEN Message, 'syntax error: check parameters'
   
   IF Handle_Info(L.o) THEN Handle_Free, L.o ELSE Message, 'i dont understand'

   Obj_Destroy, l.cells

   IF Keyword_Set(VARTIMESTEP) THEN Obj_Destroy, l.fastcells

   
   Handle_Value, _L, L, /NO_COPY, /SET
   Handle_Free, _L
   
END 
