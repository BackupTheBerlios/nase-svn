;+
; NAME:                InputLayer_11
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe <A HREF="#SPASSMACHER">Spassmacher</A>) 
;                      auf die Neuronenpotentiale und klingt diese vorher ab. 
;                      Ein mehrmaliger Aufruf von InputLayer_1 ist möglich.
;                      Danach sollte man auf jeden Fall <A HREF="#PROCEEDLAYER_1">ProceedLayer_1</A>
;                      aufrufen.
;
; CATEGORY:            SIMULATION / LAYERS
;
; CALLING SEQUENCE:    InputLayer_11, Layer [,FEEDING=feeding]
;                   [,LINKING=linking] [,ILINKING=ilinking] [,INHIBITION=inhibition]
;                                          [,/CORRECT]  
;
; INPUTS:              Layer : eine mit <A HREF="#INITLAYER_1">InitLayer_11</A> erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, linking, ilinking, inhibition : Sparse-Vektor, der auf 
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
;                       para11        = InitPara_11(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_11(WIDTH=5,HEIGHT=5, TYPE=para11)
;                       FeedingIn     = Spassmacher( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_1, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer_1, InputLayer
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  2000/06/06 15:02:32  alshaikh
;              new layertype 11
;
;-

PRO InputLayer_11, _Layer, FEEDING=feeding, LINKING=linking, ILINKING=ilinking, $
	INHIBITION=inhibition, CORRECT=correct

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L1 = Layer.L1 * Layer.para.dl1
      Layer.L2 = Layer.L2 * Layer.para.dl2
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
            Layer.L1(neurons) = Layer.L1(neurons) + Linking(1,1:Linking(0,0))*(1.-Layer.para.dl1)
         END ELSE BEGIN
            Layer.L1(neurons) = Layer.L1(neurons) + Linking(1,1:Linking(0,0))
         END
      END
   END

IF Set(ilinking) THEN BEGIN
      IF iLinking(0,0) GT 0 THEN BEGIN
         neurons = iLinking(0,1:iLinking(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.L2(neurons) = Layer.L2(neurons) + iLinking(1,1:iLinking(0,0))*(1.-Layer.para.dl2)
         END ELSE BEGIN
            Layer.L2(neurons) = Layer.L2(neurons) + iLinking(1,1:iLinking(0,0))
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
