;+
; NAME:                 ProceedLayer_4
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_4 uebergeben
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_4, Layer
;
; INPUTS:               Layer         : ein durch InitLayer_4 initialisierter Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para2         = InitPara_4(tauf=10.0, vs=1.0, oversampling=10, refperiod=1)
;                       MyLayer    = InitLayer_4(5,5, para2)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, MyLayer.w*MyLayer.h))
;                       InputLayer_4, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_4, MyLayer
;                       Print, 'Output: ', Out2Vector(MyLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 2.1  1998/02/05 13:47:34  saam
;            Cool
;
;
;- 
PRO ProceedLayer_4, Layer
common common_random, seed

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.R = Layer.R * Layer.para.dr
      Layer.S = Layer.S * Layer.para.ds
   END

   firedLast = WHERE(Layer.AR EQ 1, count); neurons with abs refractory period gone
   IF count NE 0 THEN BEGIN
      Layer.R(firedLast) = Layer.R(firedLast) + Layer.para.vr*(1.-Layer.para.dr)
      Layer.S(firedLast) = Layer.S(firedLast) + Layer.para.vs*(1.-Layer.para.ds)
      Layer.AR(firedLast) = 0
   END


   Layer.M = Layer.F*(1.+Layer.L)-Layer.I
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)
   
   ; absolute refractory period if needed
   refN = WHERE(Layer.AR GT 0, count)
   IF count NE 0 THEN BEGIN
      Layer.M(refN) = 0
      Layer.AR(refN) = Layer.AR(refN)-1
   END

   result  = WHERE(Layer.M GE (Layer.R + Layer.S + Layer.Para.th0), count) 


   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN BEGIN
      newOut = [newOut, result]
      Layer.AR(result) = Layer.para.rp ; mark neurons as refractory
   END
   Handle_Value, Layer.O, newOut, /SET
   
   Layer.decr = 1
END
