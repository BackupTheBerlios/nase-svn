;+
; NAME:
;  ProceedLayer_14
;
; AIM:
;  Compute output of Two Dendrite Neurons in current timestep.
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_14 uebergeben
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_14, Layer
;
; INPUTS:               Layer         : ein durch InitLayer_14 initialisierter Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;  ToDo!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;                       para14         = InitPara_14(tauf1=10.0, vs=1.0)
;                       MyLayer    = InitLayer_7(5,5, para14)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, MyLayer.w*MyLayer.h))
;                       InputLayer_14, MyLayer, FEEDING=FeedingIn
;                       ProceedLayer_14, MyLayer
;                       Print, 'Output: ', Out2Vector(MyLayer.O)
;
;
;-

PRO ProceedLayer_14, _Layer, CORRECT=correct
common common_random, seed

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F1 = Layer.F1 * Layer.para.df1
      Layer.F2 = Layer.F2 * Layer.para.df2
      Layer.L = Layer.L * Layer.para.dl
      Layer.I1 = Layer.I1 * Layer.para.di1
      Layer.I2 = Layer.I2 * Layer.para.di2
      Layer.R = Layer.R * Layer.para.dr
      Layer.S = Layer.S * Layer.para.ds
   END
   
   Handle_Value, Layer.O, oldOut
   IF oldOut(0) GT 0 THEN BEGIN
      oldOut = oldOut(2:oldOut(0)+1)
      IF Keyword_Set(CORRECT) THEN BEGIN
         Layer.R(oldOut) = Layer.R(oldOut) + Layer.para.vr/Layer.para.taur
         Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs/Layer.para.taus
      END ELSE BEGIN
         Layer.R(oldOut) = Layer.R(oldOut) + Layer.para.vr
         Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs
      END
   END
   
 ;  Layer.M = (Layer.F1+Layer.F2-Layer.I1)*(1.+Layer.L)-Layer.I2
  Layer.M = (Layer.F2+(1.+Layer.L)*(Layer.F1-Layer.I1)/(1+Layer.I2))
   
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)
   
   ; do some spike noise by temporarily incresing membrane potential
   spikenoise = WHERE(RandomU(seed, Layer.w*Layer.h) LT Layer.para.sn, c)
   IF c NE 0 THEN Layer.M(spikenoise) = Layer.M(spikenoise)+Layer.Para.th0*1.05

   result  = WHERE(Layer.M GE (Layer.R + Layer.S + Layer.Para.th0), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN newOut = [newOut, result]
   Handle_Value, Layer.O, newOut, /SET
   
   Layer.decr = 1

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
END



