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
;  Graded response neurons generate
;  a continuous output activation as opposed to pulse coding
;  neurons. The way in which their membrane potentials are transformed
;  into their output is determined by a so called transfer
;  function. Most commonly used are sigmoidal, piecewise linear or
;  threshold transfer functions.<BR>
;  It is also possible to use <A>ProceedLayer</A> instead, since this
;  routine is able to automatically determine the correct neuron type.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* ProceedLayer_GRN, layer
;
; INPUTS:
;  layer:: A handle pointing at the layer structure that has to be
;          updated. The structure is initialized by <A>InitLayer_GRN()</A>.
;
; COMMON BLOCKS:
;  common_random
;
; SIDE EFFECTS:
;  Update <*>layer.m</*> and <*>layer.o</*> to the current values. 
;
; PROCEDURE:
;  + Decrement potentials if this has not yet been done.<BR>
;  + Compute membrane potential from feeding and linking.<BR>
;  + Add noise.<BR>
;  + Pass mebrane potential through tranfer function.<BR>
;  + Compute sparse output.<BR> 
;
; EXAMPLE:
;  The example shows a neuron whose output is twice its
;  positive input while negative input is set to zero: 
;* ug=FltArr(100)
;* og=FltArr(100)
;*
;* tf = {func:'grntf_threshlinear', tfpara:{slope:2.0, threshold:0.0}}
;* p = InitPara_GRN(tf, TAUF=0., TAUL=0.)
;*
;* lg = InitLayer(WIDTH=1, HEIGHT=1, TYPE=p)
;* 
;* FOR t=0,99 DO BEGIN
;*    feed=RandomN(seed)
;*    InputLayer, lg, FEEDING=Spassmacher(feed)
;*    ProceedLayer, lg
;*    LayerState_GRN, lg, potential=p, output=o
;*    ug(t)=p
;*    og(t)=o
;* ENDFOR
;* 
;* OPlotMaximumFirst,[[ug],[og]],LINESTYLE=-1,COLOR=[RGB('yellow'),RGB('blue')]
;
; SEE ALSO:
;  <A>ProceedLayer</A>, <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>,
;  <A>InputLayer_GRN</A>, <A>LayerState_GRN()</A>,
;  <A>GRNTF_ThreshLinear()</A>.
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
   
   rate = Call_Function(layer.para.transfunc.func, layer.m $
                        , layer.para.transfunc.tfpara)

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
