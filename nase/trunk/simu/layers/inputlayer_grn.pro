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
;  synapses of a layer of graded response neurons.
;
; CATEGORY:
;  Input
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
;  <A>InitLayer_GRN()</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document



;   
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
;

PRO InputLayer_GRN, _Layer, FEEDING=feeding, LINKING=linking $
                    , NOISE=noise

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
         IF Set(NOISE) THEN BEGIN
            layer.f(neurons) = layer.f(neurons) + $
             feeding(1,1:feeding(0,0))*(1+noise*RandomN(seed, feeding(0,0)))
;            layer.f(neurons) = $
;             feeding(1,1:feeding(0,0))*(1+noise*RandomN(seed, feeding(0,0)))
         END ELSE BEGIN
            layer.f(neurons) = layer.f(neurons) + feeding(1,1:feeding(0,0))
;            layer.f(neurons) = feeding(1,1:feeding(0,0))
         END
      END
   END

   IF Set(linking) THEN BEGIN
      IF linking(0,0) GT 0 THEN BEGIN
         neurons = linking(0,1:linking(0,0))
         IF Set(NOISE) THEN BEGIN
            layer.l(neurons) = layer.l(neurons) + $
             linking(1,1:linking(0,0))*(1+noise*RandomN(seed, linking(0,0)))
;            layer.l(neurons) = $
;             linking(1,1:linking(0,0))*(1+noise*RandomN(seed, linking(0,0)))
         END ELSE BEGIN
            layer.l(neurons) = layer.l(neurons) + linking(1,1:linking(0,0))
;            layer.l(neurons) = linking(1,1:linking(0,0))
         END
      END
   END

   Handle_Value, _layer, layer, /NO_COPY, /SET


END
