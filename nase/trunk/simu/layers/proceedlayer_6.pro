;+
; NAME:                 ProceedLayer_6
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_6 uebergeben
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_6, Layer
;
; INPUTS:               Layer         : ein durch InitLayer_6 initialisierter Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para2         = InitPara_6(tauf=10.0, vs=1.0, oversampling=10, refperiod=1)
;                       MyLayer    = InitLayer_6(5,5, para2)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, MyLayer.w*MyLayer.h))
;                       InputLayer_6, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_6, MyLayer
;                       Print, 'Output: ', Out2Vector(MyLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 2.1  1998/08/23 12:19:18  saam
;            is there anything to say?
;
;
;- 
PRO ProceedLayer_6, Layer
   COMMON COMMON_RANDOM, seed

   IF Layer.decr THEN BEGIN
      Layer.F1 = Layer.F1 * (Layer.para.df)(0)
      Layer.F2 = Layer.F2 * (Layer.para.df)(1)
      Layer.L1 = Layer.L1 * (Layer.para.dl)(0)
      Layer.L2 = Layer.L2 * (Layer.para.dl)(1)
      Layer.I  = Layer.I * Layer.para.di
      Layer.R  = Layer.R * Layer.para.dr
      Layer.S  = Layer.S * Layer.para.ds
   END

   firedLast = WHERE(Layer.AR EQ 1, count); neurons with abs refractory period gone
   IF count NE 0 THEN BEGIN
      Layer.R(firedLast) = Layer.R(firedLast) + Layer.para.vr
      Layer.S(firedLast) = Layer.S(firedLast) + Layer.para.vs
      Layer.AR(firedLast) = 0
   END


   Layer.M = (Layer.para.corrAmpF*(Layer.F2-Layer.F1))*(1.+(Layer.para.corrAmpL*(Layer.L2-Layer.L1)))-Layer.I
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w*Layer.h)
   
   ; do some spike noise by temporarily incresing membrane potential
   spikenoise = WHERE(RandomU(seed, Layer.w*Layer.h) LT Layer.para.sn, c)
   IF c NE 0 THEN Layer.M(spikenoise) = Layer.M(spikenoise)+Layer.Para.th0*1.05
   

   ; absolute refractory period if needed
   refN = WHERE(Layer.AR GT 0, count)
   IF count NE 0 THEN BEGIN
;      Layer.M(refN) = 0
      Layer.AR(refN) = Layer.AR(refN)-1
   END


   result  = WHERE(Layer.M GE (Layer.R + Layer.S + Layer.Para.th0 + 100d*Layer.AR), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN BEGIN
      newOut = [newOut, result]
      Layer.AR(result) = Layer.para.rp ; mark neurons as refractory
   END
   Handle_Value, Layer.O, newOut, /SET
   
   Layer.decr = 1
END
