;+
; NAME:                 ProceedLayer_1
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_1 uebergeben
;                       
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_1, Layer
;
; INPUTS:               Layer         : eine durch InitLayer_1 initialisierte Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para1         = InitPara_1(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_1(5,5, para1)
;                       FeedingIn     = Vector2Spass(10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_1, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer_1, InputLayer
;                       Print, 'Output: ', Out2Vector(InputLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.5  1997/09/17 10:25:54  saam
;       Listen&Listen in den Trunk gemerged
;
;
;       Thu Sep 11 18:50:07 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       Revision: 1.3.2.6 
;                       Verarbeitung der Inputs in die Routine InputLayer_1 ausgelagert
;                       O-Tag in Layer-Struktur ist ein Handle, angepasst
;
;		        initial
;                       version, Mirko Saam, 22.7.97 Ergaenzung um
;                       Rauschen des Membranpotentials, Mirko Saam,
;                       25.7.97 Schwelle wird jetzt erst im naechsten
;                       Zeitschritt erhoeht, Mirko Saam, 29.7.97
;                       LinkingIn und InhibitionIn sind jetzt
;                       optional. Rüdiger, 22. August '97
;- 
PRO ProceedLayer_1, Layer
COMMON common_random, seed


   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
   END

   Handle_Value, Layer.O, oldOut
   IF oldOut(0) GT 0 THEN BEGIN
      oldOut = oldOut(2:oldOut(0)+1)
      Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs
   END

   
   Layer.M = Layer.F*(1.+Layer.L)-Layer.I
   
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)


   result = WHERE(Layer.M GE (Layer.S + Layer.Para.th0), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN newOut = [newOut, result]
   Handle_Value, Layer.O, newOut, /SET

   Layer.decr = 1
END
