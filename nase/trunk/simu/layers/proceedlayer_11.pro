;+
; NAME:                 ProceedLayer_11
;
; PURPOSE:              fuehrt einen Zeitschritt durch (Schwellenvergleich), der Input fuer die Layer wird 
;                       mit der Procedure InputLayer_11 uebergeben
;                       
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     ProceedLayer_11, Layer
;
; INPUTS:               Layer         : eine durch InitLayer_11 initialisierte Layer
;
; COMMON BLOCKS:        common_random
;
; EXAMPLE:
;                       para11         = InitPara_11(tauf=10.0, vs=1.0)
;                       InputLayer    = InitLayer_1(5,5, para1)
;                       FeedingIn     = Spassmacher(10.0 + RandomN(seed, InputLayer.w*InputLayer.h))
;                       InputLayer_11, InputLayer, FEEDING=FeedingIn
;                       ProceedLayer_11, InputLayer
;                       Print, 'Output: ', Out2Vector(InputLayer.O)
;
;
; MODIFICATION HISTORY: 
;
;        $Log$
;        Revision 2.1  2000/06/06 15:02:33  alshaikh
;              new layertype 11
;
;- 
PRO ProceedLayer_11, _Layer, CORRECT=correct
COMMON common_random, seed

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L1= Layer.L1 * Layer.para.dl1
      Layer.L2= Layer.L2 * Layer.para.dl2
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
   END

   Handle_Value, Layer.O, oldOut
   IF oldOut(0) GT 0 THEN BEGIN
      oldOut = oldOut(2:oldOut(0)+1)
      IF Keyword_Set(CORRECT) THEN BEGIN
         Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs/Layer.para.taus
      END ELSE BEGIN
         Layer.S(oldOut) = Layer.S(oldOut) + Layer.para.vs
      END
   END

   
   	
   Layer.M = Layer.F*(1.+((Layer.L1-Layer.L2)>0))-Layer.I


   
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)

   ; do some spike noise by temporarily incresing membrane potential
   spikenoise = WHERE(RandomU(seed, Layer.w*Layer.h) LT Layer.para.sn, c)
   IF c NE 0 THEN Layer.M(spikenoise) = Layer.M(spikenoise)+Layer.Para.th0*1.05

   result = WHERE(Layer.M GE (Layer.S + Layer.Para.th0), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN newOut = [newOut, result]
   Handle_Value, Layer.O, newOut, /SET

   Layer.decr = 1

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
END
