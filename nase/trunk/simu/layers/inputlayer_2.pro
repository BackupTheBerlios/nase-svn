;+
; NAME:
;  InputLayer_2
;
; AIM:
;  Transfer input to Adaptive Marburg Model Neuron synapses of given layer. 
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe Spassmacher) auf die Neuronenpotentiale und klingt
;                      diese vorher ab. Ein mehrmaliger Aufruf von InputLayer_2 ist moeglich.
;                      Danach sollte man auf jeden Fall ProceedLayer_2 aufrufen.
;
; CATEGORY:            SIMU
;
; CALLING SEQUENCE:    InputLayer_2, Layer [,FEEDING=feeding] [,LINKING=linking] [,INHIBITION=inhibition]   
;                                          [,/CORRECT]  
;
; INPUTS:              Layer : eine mit InitLayer_2 erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, linking, inhibition : Sparse-Vektor, der auf das entsprechende Potential addiert wird
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
;                       para2         = InitPara_2(tauf=10.0, vs=1.0)
;                       MyLayer       = InitLayer_2(5,5, para2)
;                       FeedingIn     = Vector2Sparse( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_2, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_2, InputLayer
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.5  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 2.4  1998/11/08 17:27:18  saam
;             the layer-structure is now a handle
;
;
;       Thu Sep 11 18:36:59 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;		Schoepfung und Tests
;               Entstanden aus einem Teil von ProceedLayer_1
;
;-
PRO InputLayer_2, _Layer, FEEDING=feeding, LINKING=linking, INHIBITION=inhibition, CORRECT=correct

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
      Layer.R = Layer.R * Layer.para.dr
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))/Layer.para.tauf
         END ELSE BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
         END
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))/Layer.para.taul
         END ELSE BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
         END
      END
   END
         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))/Layer.para.taui
         END ELSE BEGIN
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))
         END
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET

END
