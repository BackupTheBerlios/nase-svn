;+
; NAME:                InputLayer_2
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe Spassmacher) auf die Neuronenpotentiale und klingt
;                      diese vorher ab. Ein mehrmaliger Aufruf von InputLayer_2 ist moeglich.
;                      Danach sollte man auf jeden Fall ProceedLayer_2 aufrufen.
;
; CATEGORY:            SIMU
;
; CALLING SEQUENCE:    InputLayer_2, Layer [,FEEDING=feeding] [,LINKING=linking] [,INHIBITION=inhibition]   
;
; INPUTS:              Layer : eine mit InitLayer_2 erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, linking, inhibition : Sparse-Vektor, der auf das entsprechende Potential addiert wird
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
;       Thu Sep 11 18:36:59 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       Revision: $Revision$
;
;		Schoepfung und Tests
;               Entstanden aus einem Teil von ProceedLayer_1
;
;-
PRO InputLayer_2, Layer, FEEDING=feeding, LINKING=linking, INHIBITION=inhibition

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
         Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
      END
   END
         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))
      END
   END


END
