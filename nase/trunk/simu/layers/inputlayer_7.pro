;+
; NAME:
;  InputLayer_7
;
; VERSION:
;  $Id$
;
; AIM:
;  Transfer input to Two Feeding Inhibition Neuron synapses of given layer.
;
; PURPOSE:
;  By calling <C>InputLayer_7</C>, input currents can be transferred
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
;* InputLayer_7, layer [,FEEDING1=...][,FEEDING2=...]
;*                     [,LINKING=...] 
;*                     [,INHIBITION1=...][,INHIBITION2=...]
;*                     [,/CORRECT]
;
; INPUTS:
;  layer:: A layer structure of Standard Marburg Model Neurons,
;          initialized by <A>InitLayer_7()</A>.
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
;  to <C>InputLayer_7</C>. If not, decrease, then add new feedning,
;  linking, inhibition. 
;
; EXAMPLE:
;* para1 = InitPara_1(TAUF1=10.0, TAUF2=100.0, VS=1.0)
;* layer = InitLayer_1(WIDTH=5, HEIGHT=5, TYPE=para1)
;* feedinginput = Spassmacher(10.0 + RandomN(seed, LayerSize(layer)))
;* InputLayer_7, layer, FEEDING1=feedinginput, FEEDING2=feedinginput
;* ProceedLayer_7, layer
;*>
;
; SEE ALSO:
;  <A>InputLayer</A>, <A>InitPara_7()</A>, <A>InitLayer_7()</A>,
;  <A>ProceedLayer_7</A>, <A>FreeLayer</A>, <A>Spassmacher()</A>.
;-



;+
; NAME:
;  InputLayer_7
;
; AIM:
;  Transfer input to synapses of given layer. 
;
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe Spassmacher) auf die Neuronenpotentiale und klingt
;                      diese vorher ab. Ein mehrmaliger Aufruf von InputLayer_7 ist moeglich.
;                      Danach sollte man auf jeden Fall ProceedLayer_7 aufrufen.
;
; CATEGORY:            SIMU
;
; CALLING SEQUENCE:    InputLayer_7, Layer [,FEEDING1=feeding1] [,FEEDING2=feeding2] [,LINKING=linking] [,INHIBITION1=inhibition1]  [,INHIBITION2=inhibition2] 
;                                          [,/CORRECT]  
;
; INPUTS:              Layer : eine mit InitLayer_7 erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding1, feeding2, linking, inhibition1, inhibition2: Sparse-Vektor, der auf das entsprechende Potential addiert wird
;                      CORRECT: Die Iterationsformel fuer den Leaky-Integrator erster Ordnung
;                               lautet korrekterweise: 
;                                           F(t+1)=F(t)*exp(-1/tau)+V/tau
;                               Das tau wird aber oft vergessen, was sehr stoerend sein kann, denn
;                               die Normierung bleibt so nicht erhalten. Das Keyword CORRECT fuehrt diese
;                               Division explizit aus.
;                      
; SIDE EFFECTS:        wie so oft wird die Layer-Struktur veraendert
;
; RESTRICTIONS:        keine Ueberpuefung der Gueltigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;                       para7         = InitPara_7(tauf1=10.0, vs=1.0)
;                       MyLayer       = InitLayer_7(5,5, para7)
;                       FeedingIn     = Vector2Sparse( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_7, MyLayer, FEEDING1=FeedingIn
;                       ProceedLayer_7, InputLayer
;
; MODIFICATION HISTORY:
;
;       Thu Sep 11 18:36:59 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       Revision: $Revision$
;
;		Schoepfung und Tests
;               Entstanden aus einem Teil von ProceedLayer_1
;
;-
PRO InputLayer_7, _Layer, FEEDING1=feeding1, FEEDING2=feeding2, LINKING=linking, INHIBITION1=inhibition1,INHIBITION2=inhibition2, CORRECT=correct

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
            Layer.F1(neurons) = Layer.F1(neurons) + Feeding1(1,1:Feeding1(0,0))*(1.-Layer.para.df1)
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








