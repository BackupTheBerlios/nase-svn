;+
; NAME:
;  InputLayer_LIF
;
; VERSION:
;  $Id$
;
; AIM:
;  Transfer input to Leaky Integrate and Fire Neuron synapses of given layer. 
;
; PURPOSE:
;  Add input to Leaky Integrate and Fire Neuron synapses of given
;  layer. Multiple calls of <*>InputLayer_LIF</*> during one
;  simulation timestep are allowed, in this case, inputs are added
;  until the new layer output state is computed by <A>ProceedLayer_LIF</A>.
;  The call of <*>InputLayer_LIF</*> may be substituted by calling the
;  wrapper procedure <A>InputLayer</A>.
;
; CATEGORY:
;  Input
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* InputLayer_LIF, layer_hdl 
;*                  [,FEEDING=...] [,LINKING=...] [,INHIBITION=...]
;*                  [,NOISE=...]
;
; INPUTS: 
;  layer_hdl:: A handle pointing to a layer structure initialized
;              by <A>InitLayer_LIF</A>.
;
; INPUT KEYWORDS:
;  FEEDING:: Sparse vector added to the feeding potential (see
;            <A>Spassmacher()</A>). 
;  LINKING:: Sparse vector added to the linking potential (see
;            <A>Spassmacher()</A>).
;  INHIBITION:: Sparse vector added to the inhibition potential (see
;               <A>Spassmacher()</A>).
;  NOISE:: Multiplicative noise acting on the feeding potential.
;
; COMMON BLOCKS:
;  common_random
;
; SIDE EFFECTS:
;  The synapse potentials are changed according to the input.
;
; RESTRICTIONS:
;  The validity of the input is not checked to increase efficiency.
;
; PROCEDURE:
;  1. Decrement potentials.<BR>
;  2. Add new input.<BR>
;
; EXAMPLE:
;* InputLayer_LIF, demolayer, FEEDING=Spassmacher([2.,5.,3.])
; See also <A>DemoSim</A> for general use of <A>InputLayer</A>.
;
; SEE ALSO:
;  <A>InputLayer</A>, <A>InitPara_LIF()</A>, <A>InitLayer_LIF()</A>,
;  <A>ProceedLayer_LIF</A>, <A>Spassmacher()</A>. 
;
;-



PRO InputLayer_LIF, _Layer, FEEDING=feeding, LINKING=linking $
                    , INHIBITION=inhibition, NOISE=noise

   COMMON COMMON_random, seed

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         IF Set(NOISE) THEN BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))*(1+noise*RandomN(seed, Feeding(0,0)))
         END ELSE BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
         END
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
;         IF Keyword_Set(CORRECT) THEN BEGIN
;            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))*(1.-Layer.para.dl)
;         END ELSE BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
;         END
      END
   END
         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
;         IF Keyword_Set(CORRECT) THEN BEGIN
;            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))*(1.-Layer.para.di)
;         END ELSE BEGIN            
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))
;         END
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET

END
