;+
; NAME:                 ProceedLayer_5
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_5 uebergeben
;                       
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_5, Layer
;
; INPUTS:               Layer         : eine durch InitLayer_5 initialisierte Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para5         = InitPara_5(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_5(5,5, para5)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_5, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer_5, InputLayer
;                       Print, 'Output: ', Out2Vector(InputLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.1  1998/02/09 16:03:20  gabriel
;            Ein neuer TYP mit NMDA- und Feeding TP 2. Ordnung-Synapsen
;
;       Revision 1.6  1997/09/19 16:35:26  thiel
;              Umfangreiche Umbenennung: von spass2vector nach SpassBeiseite
;                                        von vector2spass nach Spassmacher
;
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
PRO ProceedLayer_5, Layer
COMMON common_random, seed


   IF Layer.decr THEN BEGIN
      Layer.F1 = Layer.F1 * Layer.para.df
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.N = Layer.N * Layer.para.dn
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
   END

   Handle_Value, Layer.O, oldOut
   IF oldOut(0) GT 0 THEN BEGIN
      oldOut = oldOut(2:oldOut(0)+1)
      Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs
   END

   
   Layer.M = Layer.F*(1.+Layer.L+Layer.N)-Layer.I
   
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)


   result = WHERE(Layer.M GE (Layer.S + Layer.Para.th0), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN newOut = [newOut, result]
   Handle_Value, Layer.O, newOut, /SET

   Layer.decr = 1
END
