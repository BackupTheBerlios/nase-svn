;+
; NAME:                InputLayer_7
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
PRO InputLayer_7, Layer, FEEDING1=feeding1, FEEDING2=feeding2, LINKING=linking, INHIBITION1=inhibition1,INHIBITION2=inhibition2, CORRECT=correct

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
            Layer.F1(neurons) = Layer.F1(neurons) + Feeding1(1,1:Feeding1(0,0))/Layer.para.tauf1
         END ELSE BEGIN
            Layer.F1(neurons) = Layer.F1(neurons) + Feeding1(1,1:Feeding1(0,0))
         END
      END
   END

   IF Set(feeding2) THEN BEGIN
      IF Feeding2(0,0) GT 0 THEN BEGIN
         neurons = Feeding2(0,1:Feeding2(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F2(neurons) = Layer.F2(neurons) + Feeding2(1,1:Feeding2(0,0))/Layer.para.tauf2
         END ELSE BEGIN
            Layer.F2(neurons) = Layer.F2(neurons) + Feeding2(1,1:Feeding2(0,0))
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
         
   IF Set(inhibition1) THEN BEGIN
      IF Inhibition1(0,0) GT 0 THEN BEGIN
         neurons = Inhibition1(0,1:Inhibition1(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I1(neurons) = Layer.I1(neurons) + Inhibition1(1,1:Inhibition1(0,0))/Layer.para.taui1
         END ELSE BEGIN
            Layer.I1(neurons) = Layer.I1(neurons) + Inhibition1(1,1:Inhibition1(0,0))
         END
      END
   END


   IF Set(inhibition2) THEN BEGIN
      IF Inhibition2(0,0) GT 0 THEN BEGIN
         neurons = Inhibition2(0,1:Inhibition2(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I2(neurons) = Layer.I2(neurons) + Inhibition2(1,1:Inhibition2(0,0))/Layer.para.taui2
         END ELSE BEGIN
            Layer.I2(neurons) = Layer.I2(neurons) + Inhibition2(1,1:Inhibition2(0,0))
         END
      END
   END


END








