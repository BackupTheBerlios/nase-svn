;+
; NAME:                 ProceedLayer_3
;
; PURPOSE:              nimmt gewichtete Spikes entgegen, simuliert einen Zeitschritt und gibt die resultierende Spikes als 
;                       Funktionsergebnis zurueck
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Out = ProceedLayer_3( Layer, FeedingIn [,LinkingIn [,InihibitionIn]] )
;
; INPUTS:               Layer         : eine durch initlayer_3 initialisierte Layer
;                       FeedingIn     : Input-Vektor fuer Feeding-Potential der Dimension Layer.w * Layer.h
;                       LinkingIn     : Input-Vektor fuer Linking-Potential der Dimension Layer.w * Layer.h
;                       InhibitionIn  : Input-Vektor fuer Inihibition-Potential der Dimension Layer.w * Layer.h
;
; OUTPUTS:              Out  : Vektor vom Typ Int und Dimension Layer.w * Layer.h, der die resultierenden Spikes enthaelt
;
; EXAMPLE:
;                       parameter     = InitPara_3(tauf=10.0, vs=1.0, taup=30.0)
;                       InputLayer    = InitLayer_3(5,5, parameter)
;                       FeedingIn     = 10.0 + RandomN(seed, InputLayer.w*InputLayer.h)
;                       LinkingIn     = DblArr(InputLayer.w*InputLayer.h)
;                       InhibitionIn  = DblArr(InputLayer.w*InputLayer.h)
;                       Out           = ProceedLayer_3(InputLayer, FeedingIn, LinkingIn, InhibitionIn)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.7  1998/11/08 15:53:18  saam
;             neuron type disabled cause it out of date, use type 1
;             with a Recall-Structure instead
;
;
;                       initial version, Mirko Saam, 22.7.97
;                       Ergaenzung um Rauschen des Membranpotentials, Mirko Saam, 25.7.97
;                       Schwelle wird jetzt erst im naechsten Zeitschritt erhoeht, Mirko Saam, 29.7.97
;                       Zusaetzlich Lernpotential (realisiert als Leckintegrator) Andreas. 29. Juli 97
;                       geaenderter Ablauf, LP wird sofort erhoeht. Andreas. 30. Juli '97
;                       LinkingIn und InhibitionIn sind jetzt optional. Rüdiger, 22. August '97
;                       Common_Random-Block zugefügt, Rüdiger, 5.9.97
;- 

FUNCTION ProceedLayer_3, Layer, FeedingIn, LinkingIn, InhibitionIn

   Message, "NeuronType3 is not needed any more"

;common common_random, seed

;   Default, LinkingIn, fltarr(LayerSize(Layer))
;   Default, InhibitionIn, fltarr(LayerSize(Layer))

;   Layer.F = Layer.F * Layer.para.df
;   Layer.L = Layer.L * Layer.para.dl
;   Layer.I = Layer.I * Layer.para.di
;   Layer.S = Layer.S * Layer.para.ds
;   Layer.P = Layer.p * Layer.para.dp
   
;   Layer.F = Layer.F + FeedingIn
;   Layer.L = Layer.L + LinkingIn
;   Layer.I = Layer.I + InhibitionIn
;   Layer.S = Layer.S + Layer.O*Layer.para.Vs
      
;   Layer.M = Layer.F*(1.+Layer.L)-Layer.I + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)
;   Layer.O(*) = 0

;   ; do some spike noise by temporarily incresing membrane potential
;   spikenoise = WHERE(RandomU(seed, Layer.w*Layer.h) LT Layer.para.sn, c)
;   IF c NE 0 THEN Layer.M(spikenoise) = Layer.M(spikenoise)+Layer.Para.th0*1.05

;   spike  = WHERE(Layer.M GE (Layer.S + Layer.Para.th0), count) 
;   IF (count NE 0) THEN BEGIN
;      Layer.O(spike) = 1
;   END

;   ;-----Das Lernpotential wird im gleichen Zeitschritt erhoeht wie der
;   ;-----Output selbst, das ist praktischer fuer die Lernregel
;   Layer.P = Layer.P + Layer.O*Layer.para.Vp
   
;   RETURN, Layer.O

END
