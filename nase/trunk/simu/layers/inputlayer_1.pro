;+
; NAME:
;  InputLayer_1
;
; VERSION:
;  $Id$
;
; AIM:
;  Transfer input to Standard Marburg Model Neuron synapses of given layer.
;
; PURPOSE:
;  By calling <C>InputLayer_1</C>, input currents can be transferred
;  to the synapses of neurons constituting a layer of Standard Marburg
;  Model Neurons. Different types of synapses (feeding, linking, and
;  inhibitory) are specified using appropriate keywords. To add
;  multiple inputs to the same synapse type, call <C>InputLayer_1</C>
;  several times.<BR>
;  Input has to be in <A NREF=spassmacher>sparse</A> format, the
;  synaptic potentials are decreased before adding the specified input.
;
; CATEGORY:
;  Input
;  Layers
;  Simulation
;
; CALLING SEQUENCE:
;* InputLayer_1, layer [,FEEDING=...] [,LINKING=...] 
;*                     [,INHIBITION=...]
;*                     [,/CORRECT]
;
; INPUTS:
;  layer:: A layer structure of Standard Marburg Model Neurons,
;          initialized by <A>InitLayer_1()</A>.
;
; INPUT KEYWORDS:
;  FEEDING, LINKING, INHIBITION:: <A NREF=spassmacher>Sparse</A>
;                                 vectors intended to be added
;                                 to the respective potentials of
;                                 feeding, linking and inhibitory
;                                 synapses.
;  /CORRECT:: Solving the differential equation for a leaky integrator
;             numerically using the Exponetial Euler method yields the
;             iteration formula 
;*             F(t+dt)=F(t)*exp(-dt/tau)+Input*V*(1-exp(-dt/tau))
;             In the standard algorithm for computation of Marburg
;             Model Neuron potentials, the factor (1-exp(-dt/tau)) is
;             omitted. When changing the integration step size dt or
;             the time constant tau, the standard method yields
;             different behavior of the potetials which is sometimes
;             undesirable. Therefore, setting <C>CORRECT=1</C>
;             explicitely multiplies the input with (1-exp(-dt/tau)). 
;
; RESTRICTIONS:
;  The validity of the input is not checked due to efficiency
;  considerations.
;
; PROCEDURE:
;  Check if potentials have already been decreased by preceeding call
;  to <C>InputLayer_1</C>. If not, decrease, then add new feedning,
;  linking, inhibition. 
;
; EXAMPLE:
;* para1 = InitPara_1(TAUF=10.0, VS=1.0)
;* layer = InitLayer_1(WIDTH=5, HEIGHT=5, TYPE=para1)
;* feedinginput = Spassmacher(10.0 + RandomN(seed, LayerSize(layer)))
;* InputLayer_1, layer, FEEDING=feedinginput
;* ProceedLayer_1, layer
;*>
;
; SEE ALSO:
;  <A>InputLayer</A>, <A>InitPara_1()</A>, <A>InitLayer_1()</A>,
;  <A>ProceedLayer_1</A>, <A>FreeLayer</A>, <A>Spassmacher()</A>.
;-



PRO InputLayer_1, _Layer $
                  , FEEDING=feeding, LINKING=linking $
                  , INHIBITION=inhibition, CORRECT=correct

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))*(1.-Layer.para.df)
         END ELSE BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
         END
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))*(1.-Layer.para.dl)
         END ELSE BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
         END
      END
   END
         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))*(1.-Layer.para.di)
         END ELSE BEGIN            
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))
         END
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET

END
