;+
; NAME:
;  LayerState_GRN
;
; VERSION:
;  $Id$
;
; AIM:
;  Return current state of Graded Response Neurons in a given layer.
;
; PURPOSE:
;  <C>LayerState_GRN</C> can be used to determine internal potentials
;  and output state of graded response neurons.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
;*result = FunctionName( par [,optpar] [,/SWITCH] [,KEYWORD=...] )
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>,
;  <A>InputLayer_GRN</A>, <A>ProceedLayer_GRN()</A>,
;  <A>GRNTF_ThreshLinear()</A>.
;-



PRO LayerState_GRN, _L, DIMENSIONS=DIMENSIONS $
                    , OUTPUT=output, POTENTIAL=potential

   Handle_Value, _L, L, /NO_COPY
   
   o = SpassBeiseite(Handle_Val(l.o))
;   potential = l.m
   
   IF Keyword_Set(DIMENSIONS) THEN o = REFORM(O, L.h, L.w, /OVERWRITE)
   
   potential = l.m
   output = o

   Handle_Value, _L, L, /NO_COPY, /SET

END
