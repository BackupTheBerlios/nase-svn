;+
; NAME:                 ProceedLayer_3
;
; PURPOSE:              nimmt gewichtete Spikes entgegen, simuliert einen Zeitschritt und gibt die resultierende Spikes als 
;                       Funktionsergebnis zurueck
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Out = ProceedLayer_3( Layer, FeedingIn, LinkingIn, InihibitionIn )
;
; INPUTS:               Layer         : eine durch initlayer_3 initialisierte Layer
;                       FeedingIn     : Input-Vektor fuer Feeding-Potential der Dimension Layer.w * Layer.h
;                       LinkingIn     : Input-Vektor fuer Linking-Potential der Dimension Layer.w * Layer.h
;                       InhibitionIn  : Input-Vektor fuer Inihibition-Potential der Dimension Layer.w * Layer.h
;
; OPTIONAL INPUTS:      ---      
;
; KEYWORD PARAMETERS:   ---
;
; OUTPUTS:              Out  : Vektor vom Typ Int und Dimension Layer.w * Layer.h, der die resultierenden Spikes enthaelt
;
; OPTIONAL OUTPUTS:     ---
;
; COMMON BLOCKS:        ---
;
; SIDE EFFECTS:         ---
;
; RESTRICTIONS:         ---
;
; PROCEDURE:            ---
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
; MODIFICATION HISTORY: initial version, Mirko Saam, 22.7.97
;                       Ergaenzung um Rauschen des Membranpotentials, Mirko Saam, 25.7.97
;                       Schwelle wird jetzt erst im naechsten Zeitschritt erhoeht, Mirko Saam, 29.7.97
;                       Zusaetzlich Lernpotential (reealisiert als Leckintegrator) Andreas. 29. Juli 97
;- 
FUNCTION ProceedLayer_3, Layer, FeedingIn, LinkingIn, InhibitionIn

   Layer.F = Layer.F * Layer.para.df
   Layer.L = Layer.L * Layer.para.dl
   Layer.I = Layer.I * Layer.para.di
   Layer.S = Layer.S * Layer.para.ds
   Layer.P = Layer.p * Layer.para.dp
   
   Layer.F = Layer.F + FeedingIn
   Layer.L = Layer.L + LinkingIn
   Layer.I = Layer.I + InhibitionIn
   Layer.S = Layer.S + Layer.O*Layer.para.Vs
   Layer.P = Layer.P + Layer.O*Layer.para.Vp
      

   Layer.M = Layer.F*(1.+Layer.L)-Layer.I + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)
   Layer.O(*) = 0

   spike  = WHERE(Layer.M GE (Layer.S + Layer.Para.th0), count) 
   IF (count NE 0) THEN BEGIN
      Layer.O(spike) = 1
   END
   
   RETURN, Layer.O

END
