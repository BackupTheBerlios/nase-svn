;+
; NAME:
;  InputLayer_GRN
;
; VERSION:
;  $Id$
;
; AIM:
;  Transfer input to Graded Response Neuron synapses of given layer.
;
; PURPOSE:
;  <C>InputLayer_GRN</C> can be used to transfer inputs to the
;  synapses of a layer of graded response neurons. Graded response
;  neurons generate 
;  a continuous output activation as opposed to pulse coding
;  neurons. The way in which their membrane potentials are transformed
;  into their output is determined by a so called transfer
;  function. Most commonly used are sigmoidal, piecewise linear or
;  threshold transfer functions.<BR>
;  Input can be added to seperate synapses of different type,
;  e.g. feeding or linking synapses. If multiple inputs need to be
;  passed to the same synapse type during one simulation timestep,
;  <C>InputLayer_GRN</C> has to be called several times. Before adding
;  the input, decay of the synapse potentials is performed, but only
;  once per simulation step.<BR>
;  It is also possible to use <A>InputLayer</A> instead, since this
;  routine is able to automatically determine the correct neuron type.
;
; CATEGORY:
;  Input
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* InputLayer_GRN, layer [,FEEDING=...][,LINKING=...][,NOISE=...]
;
; INPUTS:
;  layer:: Handle on a graded response neuron layer structure,
;          initialized by <A>InitLayer_GRN()</A>. 
;
; INPUT KEYWORDS:
;  FEEDING:: Sparse version of the input that is added to the feeding
;            potentials of the neurons in <*>layer</*>. If you need to
;            transform your input to sparse notation, call
;            <A>Spassmacher()</A>.
;  LINKING:: Sparse version of the input that is added to the linking
;            potentials of the neurons in <*>layer</*>. If you need to
;            transform your input to sparse notation, call
;            <A>Spassmacher()</A>.
;  NOISE:: Amplitude of gaussian noise that acts multiplicatively on the
;          feeding and linking inputs <I>before</I> they are added to
;          the respective potentials. E.g. 
;*          layer.f=layer.f+feeding*(1+noise*RandomN)
;          Default: 0.
; /CORRECT:: Numerically solve leaky integrator differential equations
;            using the Exponential Euler Method. This has the
;            advantage of being invariant when changing time
;            resolution and gives a steady state that is independent
;            of the leaky intergator's time constant.
;
; COMMON BLOCKS:
;  common_random
;
; SIDE EFFECTS:
;  Actually, this is not a <I>side</I> effect but the purpose of the routine:
;  The potentials in the given layer structure are updated with the
;  respective inputs.
;
; RESTRICTIONS:
;  The validity of the input is not checked for the sake of simulation
;  speed.
;
; PROCEDURE:
;  + Deacy potentials if this has not yet been done.<BR>
;  + Add feeding input.<BR>
;  + Add linking input.<BR>
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
;* FreeLayer, lg
;*
;* OPlotMaximumFirst,[[ug],[og]],LINESTYLE=-1,COLOR=[RGB('yellow'),RGB('blue')]
;
; SEE ALSO:
;  <A>InputLayer</A>, <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>,
;  <A>ProceedLayer_GRN</A>, <A>LayerState_GRN</A>, <A>Spassmacher()</A>.
;-

PRO InputLayer_GRN, _Layer, FEEDING=feeding, LINKING=linking $
                    , NOISE=noise, CORRECT=correct

   Default, noise, 0
   Default, correct, 0

   COMMON COMMON_random, seed

   Handle_Value, _layer, layer, /NO_COPY

   IF layer.decr THEN BEGIN
      layer.f = layer.f * layer.para.df
      layer.l = layer.l * layer.para.dl
      layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF feeding(0,0) GT 0 THEN BEGIN
         neurons = feeding(0,1:feeding(0,0))
         ;; arithmetic if-clauses:
         ;; if NOISE eq 0. then multiplication with 1 takes place,
         ;; if CORRECT eq 0 then second factor has no effect
         layer.f(neurons) = layer.f(neurons) + $
          feeding(1,1:feeding(0,0)) * $
          (1.+noise*RandomN(seed, feeding(0,0))) * $
          (1.-correct*layer.para.df)
      ENDIF ;; feeding(0,0) GT 0
   ENDIF ;; Set(feeding)
   
   IF Set(linking) THEN BEGIN
      IF linking(0,0) GT 0 THEN BEGIN
         neurons = linking(0,1:linking(0,0))
         layer.l(neurons) = layer.l(neurons) + $
          linking(1,1:linking(0,0)) * $
          (1.+noise*RandomN(seed, linking(0,0)))* $
          (1.-correct*layer.para.dl)
      ENDIF ;; linking(0,0) GT 0
   ENDIF ;; Set(linking)

   Handle_Value, _layer, layer, /NO_COPY, /SET


END
