;+
; NAME:                 ProceedLayer_2
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_2 uebergeben
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_2, Layer
;
; INPUTS:               Layer         : ein durch InitLayer_2 initialisierter Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para2         = InitPara_2(tauf=10.0, vs=1.0)
;                       MyLayer    = InitLayer_2(5,5, para2)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, MyLayer.w*MyLayer.h))
;                       InputLayer_2, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_2, MyLayer
;                       Print, 'Output: ', Out2Vector(MyLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.5  1997/10/14 16:33:11  kupper
;              Sparse-Version durch �bernahme vom schon sparsen proceedlayer_1
;     
;
;                       initial version, Mirko Saam, 22.7.97
;                       Ergaenzung um Rauschen des Membranpotentials, Mirko Saam, 25.7.97
;                       Schwelle wird jetzt erst im naechsten Zeitschritt erhoeht, Mirko Saam, 29.7.97
;                       LinkingIn und InhibitionIn sind jetzt
;                       optional. R�diger, 22. August '97
;                       Random-Commonblock zugef�gt, R�diger, 5.Sept 97
;
;- 
PRO ProceedLayer_2, Layer
common common_random, seed

   IF Layer.decr THEN BEGIN
   Layer.F = Layer.F * Layer.para.df
   Layer.L = Layer.L * Layer.para.dl
   Layer.I = Layer.I * Layer.para.di
   Layer.R = Layer.R * Layer.para.dr
   Layer.S = Layer.S * Layer.para.ds
   END
   
   Handle_Value, Layer.O, oldOut
   IF oldOut(0) GT 0 THEN BEGIN
      oldOut = oldOut(2:oldOut(0)+1)
   Layer.R(oldOut) = Layer.R(oldOut) + Layer.para.vr
   Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs
   END

   Layer.M = Layer.F*(1.+Layer.L)-Layer.I

   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)


   result  = WHERE(Layer.M GE (Layer.R + Layer.S + Layer.Para.th0), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN newOut = [newOut, result]
   Handle_Value, Layer.O, newOut, /SET
   
   Layer.decr = 1
END
