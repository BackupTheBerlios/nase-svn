;+
; NAME:                InputLayer_5
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe Spassmacher) auf die Neuronenpotentiale und klingt
;                      diese vorher ab. Ein mehrmaliger Aufruf von InputLayer_1 ist moeglich.
;                      Danach sollte man auf jeden Fall ProceedLayer_1 aufrufen.
;
; CATEGORY:            SIMU
;
; CALLING SEQUENCE:    InputLayer_5, Layer [,FEEDING=feeding]  [,2TPFEEDING=2tpfeeding] $
;                      [,LINKING=linking] [,NMDA=nmda] [,INHIBITION=inhibition]   
;
; INPUTS:              Layer : eine mit InitLayer_5 erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, feeding2, linking, inhibition : 
;                      Sparse-Vektor, der auf das entsprechende Potential addiert wird
;                      
; SIDE EFFECTS:        wie so oft wird die Layer-Struktur veraendert
;
; RESTRICTIONS:        keine Ueberpuefung der Gueltigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;                       para4         = InitPara_5(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_5(5,5, para1)
;                       FeedingIn     = Vector2Sparse( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_5, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer_5, InputLayer
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.2  1998/11/08 17:27:20  saam
;             the layer-structure is now a handle
;
;
;       Thu Sep 11 18:36:59 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;
;-
PRO InputLayer_5, _Layer, FEEDING=feeding, TP2FEEDING=tp2feeding, LINKING=linking, NMDA=nmda , INHIBITION=inhibition

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F1 = Layer.F1 * Layer.para.df
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.N = Layer.N * Layer.para.dn
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
      END
   END

   IF Set(tp2feeding) THEN BEGIN
      IF tp2Feeding(0,0) GT 0 THEN BEGIN
         neurons = tp2Feeding(0,1:tp2Feeding(0,0))
         Layer.F1(neurons) = Layer.F1(neurons) + tp2Feeding(1,1:tp2Feeding(0,0))
         Layer.F(neurons) = Layer.F(neurons) + Layer.F1(neurons)
      END
   END




   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
      END
   END
         
  IF Set(nmda) THEN BEGIN
      IF nmda(0,0) GT 0 THEN BEGIN
         neurons = nmda(0,1:nmda(0,0))
         Layer.N(neurons) = Layer.N(neurons) + nmda(1,1:nmda(0,0))
      END
   END



   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
END
