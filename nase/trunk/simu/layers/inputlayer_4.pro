;+
; NAME:                InputLayer_4
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe Spassmacher) auf die Neuronenpotentiale und klingt
;                      diese vorher ab. Ein mehrmaliger Aufruf von InputLayer_4 ist moeglich.
;                      Danach sollte man auf jeden Fall ProceedLayer_4 aufrufen.
;
; CATEGORY:            SIMU
;
; CALLING SEQUENCE:    InputLayer_4, Layer [,FEEDING=feeding] [,LINKING=linking] [,INHIBITION=inhibition]   
;
; INPUTS:              Layer : eine mit InitLayer_4 erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, linking, inhibition : Sparse-Vektor, der auf das entsprechende Potential addiert wird
;                      
; SIDE EFFECTS:        wie so oft wird die Layer-Struktur veraendert
;
; RESTRICTIONS:        keine Ueberpuefung der Gueltigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;                       para4         = InitPara_4(tauf=10.0, vs=1.0, oversampling=10, refperiod=1)
;                       MyLayer       = InitLayer_4(5,5, para2)
;                       FeedingIn     = Vector2Sparse( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_4, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_4, InputLayer
;
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 2.1  1998/02/05 13:47:33  saam
;            Cool
;
;
;-
PRO InputLayer_4, Layer, FEEDING=feeding, LINKING=linking, INHIBITION=inhibition

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
         Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))*(1.-Layer.para.df)
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))*(1.-Layer.para.dl)
      END
   END
         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))*(1.-Layer.para.di)
      END
   END


END
