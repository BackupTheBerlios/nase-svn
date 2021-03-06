;+
; NAME:
;  InputLayer_6
;
; AIM:
;  Transfer input to Second Order EPSP Neuron synapses of given layer. 
;
; PURPOSE:             Addiert Input vom Typ Sparse (siehe Spassmacher) auf die Neuronenpotentiale und klingt
;                      diese vorher ab. Ein mehrmaliger Aufruf von InputLayer_6 ist moeglich.
;                      Danach sollte man auf jeden Fall ProceedLayer_6 aufrufen. 
;                      Die Direct-Synpase addiert den Input direkt auf das Feeding-Potential ohne Umweg
;                      ueber die Synapsen.
;
; CATEGORY:            SIMU
;
; CALLING SEQUENCE:    InputLayer_6, Layer [,FEEDING=feeding] [,LINKING=linking] [,INHIBITION=inhibition] [,DIRECT=direct]
;
; INPUTS:              Layer : eine mit InitLayer_6 erzeugte Struktur
;
; KEYWORD PARAMETERS:  feeding, linking, inhibition : Sparse-Vektor, der auf das entsprechende Potential addiert wird
;                      
; SIDE EFFECTS:        wie so oft wird die Layer-Struktur veraendert
;
; RESTRICTIONS:        keine Ueberpuefung der Gueltigkeit des Inputs (Effizienz!)
;
; EXAMPLE:
;                       para4         = InitPara_6(tauf=10.0, vs=1.0, oversampling=10, refperiod=1)
;                       MyLayer       = InitLayer_6(5,5, para2)
;                       FeedingIn     = Vector2Sparse( 10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_6, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_6, InputLayer
;
; MODIFICATION HISTORY:
;
;      $Log$
;      Revision 2.4  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 2.3  1999/12/02 18:11:56  saam
;            new "SYNPASE" DIRECT
;
;      Revision 2.2  1998/11/08 17:27:20  saam
;            the layer-structure is now a handle
;
;      Revision 2.1  1998/08/23 12:19:18  saam
;            is there anything to say?
;
;
;-
PRO InputLayer_6, _Layer, FEEDING=feeding, LINKING=linking, INHIBITION=inhibition, DIRECT=direct

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F1 = Layer.F1 * (Layer.para.df)(0)
      Layer.F2 = Layer.F2 * (Layer.para.df)(1)
      Layer.L1 = Layer.L1 * (Layer.para.dl)(0)
      Layer.L2 = Layer.L2 * (Layer.para.dl)(1)
      Layer.I  = Layer.I * Layer.para.di
      Layer.S  = Layer.S * Layer.para.ds
      Layer.R  = Layer.R * Layer.para.dr
      Layer.DM(*) = 0.0d
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         Layer.F1(neurons) = Layer.F1(neurons) + Feeding(1,1:Feeding(0,0));*(1.-Layer.para.df)
         Layer.F2(neurons) = Layer.F2(neurons) + Feeding(1,1:Feeding(0,0));*(1.-Layer.para.df)
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         Layer.L1(neurons) = Layer.L1(neurons) + Linking(1,1:Linking(0,0));*(1.-Layer.para.dl)
         Layer.L2(neurons) = Layer.L2(neurons) + Linking(1,1:Linking(0,0));*(1.-Layer.para.dl)
      END
   END
         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0));*(1.-Layer.para.di)
      END
   END

   IF Set(direct) THEN BEGIN
      IF direct(0,0) GT 0 THEN BEGIN
         neurons = direct(0,1:direct(0,0))
         Layer.DM(neurons) = Layer.DM(neurons) + direct(1,1:direct(0,0));*(1.-Layer.para.di)
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET

END
