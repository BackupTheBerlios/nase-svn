;+
; NAME:
;  ProceedLayer_GRN
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute output of Graded Response Neurons in current timestep.
;
; PURPOSE:
;  <C>ProceedLayer_GRN</C> is ued to compute the output values of a
;  layer of graded response neurons in the current simulation timestep.
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
;  <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>, <A>InputLayer_GRN</A>.
;-



PRO ProceedLayer_GRN, _Layer, _EXTRA=_extra

COMMON common_random, seed

   Handle_Value, _layer, layer, /NO_COPY
   Handle_Value, layer.o, oldout

   IF layer.decr THEN BEGIN
      layer.f = layer.f * layer.para.df
      layer.l = layer.l * layer.para.dl
   END

   layer.m = layer.f*(layer.l+1.)

   IF layer.para.sigma GT 0.0 THEN $
    layer.m = layer.m + layer.para.sigma*RandomN(seed, layer.w, layer.h)
   
   rate = Call_FUNCTION(layer.para.transfunc.func, layer.m $
                        , layer.para.transfunc.slope $
                        , layer.para.transfunc.threshold)

   iposrate = Where(rate, count)

   ;--- Spassmacher:
   newout = FltArr(2, 1+count)
   newout(*, 0) = [count, layer.w*layer.h]
   IF count NE 0 THEN BEGIN
      newout(0,1:*) = iposrate
      newout(1,1:*) = rate(iposrate)
   ENDIF

   layer.decr = 1

   Handle_Value, layer.o, newout, /SET
   Handle_Value, _layer, layer, /NO_COPY, /SET


END
