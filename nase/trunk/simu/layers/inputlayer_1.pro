;+
; NAME:
;  InputLayer_1
;
; AIM:
;  Transfer input to Standard Marburg Model Neuron synapses of given layer. 
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe <A HREF="#SPASSMACHER">Spassmacher</A>) 
;                      auf die Neuronenpotentiale und klingt diese vorher ab. 
;                      Ein mehrmaliger Aufruf von InputLayer_1 ist möglich.
;                      Danach sollte man auf jeden Fall <A HREF="#PROCEEDLAYER_1">ProceedLayer_1</A>
;                      aufrufen.
;
; CATEGORY:            SIMULATION / LAYERS
;
; CALLING SEQUENCE:    InputLayer_1, Layer [,FEEDING=feeding] [,LINKING=linking] [,INHIBITION=inhibition]
;                                          [,/CORRECT]  
;
; INPUTS:              Layer : eine mit <A HREF="#INITLAYER_1">InitLayer_1</A> erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, linking, inhibition : Sparse-Vektor, der auf 
;                          das entsprechende Potential addiert wird
;                      CORRECT: Die Iterationsformel fuer einen Leckintegrator
;                               erster Ordnung lautet korrekterweise: 
;                                  F(t+dt)=F(t)*exp(-dt/tau)+Input*V*(1-exp(-dt/tau))
;                               Die Multiplikation des Inputs mit dem Faktor
;                               (1-exp(-1/tau)) wird aber in der gängigen
;                               algorithmischen Formulierung des MMN weg-
;                               gelassen. Dies kann störend sein, denn
;                               diese Formulierung ist nicht invariant
;                               gegenüber einer Änderung der Zeitauflösung.
;                               Das Keyword CORRECT führt die Multiplikation
;                               mit (1-exp(-1/tau)) explizit aus.
;                                
; SIDE EFFECTS:        wie so oft wird die Layer-Struktur verändert
;
; RESTRICTIONS:        keine Überpuefung der Gültigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;                       para1         = InitPara_1(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_1(WIDTH=5,HEIGHT=5, TYPE=para1)
;                       FeedingIn     = Spassmacher( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_1, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer_1, InputLayer
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.6  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 2.5  1999/04/20 12:51:38  thiel
;              /CORRECT-Behandlung correctiert.
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
PRO InputLayer_1, _Layer, FEEDING=feeding, LINKING=linking, INHIBITION=inhibition, CORRECT=correct

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
