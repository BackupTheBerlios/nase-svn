;+
; NAME:
;  InputLayer_14
;
; VERSION:
;
; AIM:
;  Transfer input to Two Feeding Inhibition Neuron synapses of given layer.
;
; PURPOSE:
;  By calling <C>InputLayer_14</C>, input currents can be transferred
;  to the synapses of neurons constituting a layer of Two Feeding
;  Inhibition Neurons. These neurons possess two feeding and two
;  inhibitory synapses, which may have different time
;  constants. Different types of synapses (feeding, linking, and
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
;* InputLayer_14, layer [,FEEDING1=...][,FEEDING2=...]
;*                     [,LINKING=...] 
;*                     [,INHIBITION1=...][,INHIBITION2=...]
;*                     [,/CORRECT]
;
; INPUTS:
;  layer:: A layer structure of Standard Marburg Model Neurons,
;          initialized by <A>InitLayer_14()</A>.
;
; INPUT KEYWORDS:
;  FEEDING1, FEEDING2, LINKING, INHIBITION1, 
;  INHIBITION2:: <A NREF=spassmacher>Sparse</A> 
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
;  Check if potentials have possibly been decreased by preceeding call
;  to <C>InputLayer_14</C>. If not, decrease, then add new feedning,
;  linking, inhibition. 
;
; EXAMPLE:
;* para1 = InitPara_1(TAUF1=10.0, TAUF2=100.0, VS=1.0)
;* layer = InitLayer_1(WIDTH=5, HEIGHT=5, TYPE=para1)
;* feedinginput = Spassmacher(10.0 + RandomN(seed, LayerSize(layer)))
;* InputLayer_14, layer, FEEDING1=feedinginput, FEEDING2=feedinginput
;* ProceedLayer_14, layer
;*>
;
; SEE ALSO:
;  <A>InputLayer</A>, <A>InitPara_14()</A>, <A>InitLayer_7()</A>,
;  <A>ProceedLayer_14</A>, <A>FreeLayer</A>, <A>Spassmacher()</A>.
;-



PRO InputLayer_14, _Layer $
                  , FEEDING1=feeding1, FEEDING2=feeding2 $
                  , LINKING=linking $
                  , INHIBITION1=inhibition1, INHIBITION2=inhibition2 $
                  , CORRECT=correct

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F1 = Layer.F1 * Layer.para.df1
      Layer.F2 = Layer.F2 * Layer.para.df2
      Layer.L = Layer.L * Layer.para.dl
      Layer.I1 = Layer.I1 * Layer.para.di1
      Layer.I2 = Layer.I2 * Layer.para.di2
      Layer.S = Layer.S * Layer.para.ds
      Layer.R = Layer.R * Layer.para.dr
      Layer.decr = 0
   END

   IF Set(feeding1) THEN BEGIN
      IF Feeding1(0,0) GT 0 THEN BEGIN
         neurons = Feeding1(0,1:Feeding1(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F1(neurons) = Layer.F1(neurons) + $
             Feeding1(1,1:Feeding1(0,0))*(1.-Layer.para.df1)
         END ELSE BEGIN
            Layer.F1(neurons) = Layer.F1(neurons) + Feeding1(1,1:Feeding1(0,0))
         END
      END
   END

   IF Set(feeding2) THEN BEGIN
      IF Feeding2(0,0) GT 0 THEN BEGIN
         neurons = Feeding2(0,1:Feeding2(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F2(neurons) = Layer.F2(neurons) + $
             Feeding2(1,1:Feeding2(0,0))*(1.-Layer.para.df2)
         END ELSE BEGIN
            Layer.F2(neurons) = Layer.F2(neurons) + Feeding2(1,1:Feeding2(0,0))
         END
      END
   END



   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.L(neurons) = Layer.L(neurons) + $
             Linking(1,1:Linking(0,0))*(1.-Layer.para.dl)
         END ELSE BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
         END
      END
   END
         
   IF Set(inhibition1) THEN BEGIN
      IF Inhibition1(0,0) GT 0 THEN BEGIN
         neurons = Inhibition1(0,1:Inhibition1(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I1(neurons) = Layer.I1(neurons) + $
             Inhibition1(1,1:Inhibition1(0,0))*(1.-Layer.para.di1)
         END ELSE BEGIN
            Layer.I1(neurons) = Layer.I1(neurons) + Inhibition1(1,1:Inhibition1(0,0))
         END
      END
   END


   IF Set(inhibition2) THEN BEGIN
      IF Inhibition2(0,0) GT 0 THEN BEGIN
         neurons = Inhibition2(0,1:Inhibition2(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I2(neurons) = Layer.I2(neurons) + $
             Inhibition2(1,1:Inhibition2(0,0))*(1.-Layer.para.di2)
         END ELSE BEGIN
            Layer.I2(neurons) = Layer.I2(neurons) + Inhibition2(1,1:Inhibition2(0,0))
         END
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
END








