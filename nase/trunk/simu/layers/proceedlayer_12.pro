;+
; NAME:
;  ProceedLayer_12
;
; VERSION:
;  $Id$
;
; AIM:
;   Compute output of Standard Marburg Model Neurons with shunting
;   inhibition in current timestep.
;
; PURPOSE:
;   Compute output of Standard Marburg Model Neurons with shunting
;   inhibition in current timestep.
;
; CATEGORY:
;  Layers
;  MIND
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* ProceedLayer_12, Layer
;
; INPUTS:
;   Layer         : eine durch InitLayer_12 initialisierte Layer
;
; EXAMPLE:
;*
;* >
;
; SEE ALSO:
;
;-



PRO ProceedLayer_12, _Layer, CORRECT=correct
COMMON common_random, seed

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      mydf = exp(-1./(Layer.para.tauf * sqrt((1-(Layer.X)) > 0.0)))
      Layer.F = Layer.F * mydf
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
      Layer.X = Layer.X*Layer.para.dx
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

   Layer.M = (Layer.F*(1.+Layer.L)-Layer.I)
   
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
