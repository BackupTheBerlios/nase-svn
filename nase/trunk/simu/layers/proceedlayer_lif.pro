;+
; NAME:
;  ProceedLayer_LIF
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute output of Leaky Integrate and Fire Neurons in current timestep.
;
; PURPOSE:
;  Compute output of Leaky Integrate and Fire Neurons in current
;  timestep. Spikes are generated if the membrane potential exceeds a
;  fixed threshold. After spike generation, the membrane potential is
;  reset by setting feeding, linking and inhibition to 0.
;*  m = f * (1 + l) - i
;*  o = m GE th0 
;  Input to the neurons has to be transmitted before calling
;  <*>ProceedLayer_LIF</*> using the <A>InputLayer_LIF</A>
;  procedure.<BR>
;  The call of <*>ProceedLayer_LIF</*> may be substituted by calling the
;  wrapper procedure <A>ProceedLayer</A>.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* ProceedLayer_LIF, layer_hdl
;
; INPUTS:
;  layer_hdl:: A handle pointing to a layer structure initialized
;              by <A>InitLayer_LIF</A>.
;
; COMMON BLOCKS:
;  common_random
;
; SIDE EFFECTS:
;  The potentials and the output state of <*>layer_hdl</*> are changed.
;
; PROCEDURE:
;  1. Decrement input potentials if not already done.<BR>
;  2. Compute membrane potential.<BR>
;  3. Compare to threshold.<BR>
;  4. Generate new output.
;
; EXAMPLE:
;* ProceedLayer_LIF, demolayer
; See also <A>DemoSim</A> for general use of <A>ProceedLayer</A>.
;
; SEE ALSO:
;  <A>ProceedLayer</A>, <A>InitPara_LIF()</A>, <A>InitLayer_LIF()</A>,
;  <A>InputLayer_LIF</A>. 
;
;-



PRO ProceedLayer_LIF, _Layer, _EXTRA=_extra;, CORRECT=correct

COMMON common_random, seed

   Handle_Value, _Layer, Layer, /NO_COPY

   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * Layer.para.df
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
   END

   Handle_Value, Layer.O, oldOut
   IF oldOut(0) GT 0 THEN BEGIN
      oldOut = oldOut(2:oldOut(0)+1)
      Layer.F(oldOut) = 0.
      Layer.L(oldOut) = 0.
      Layer.I(oldOut) = 0.
   END

   
   Layer.M = Layer.F*(1.+Layer.L)-Layer.I
   
   IF Layer.para.sigma GT 0.0 THEN Layer.M = Layer.M + Layer.para.sigma*RandomN(seed, Layer.w, Layer.h)
   

   ; do some spike noise by temporarily incresing membrane potential
;   spikenoise = WHERE(RandomU(seed, Layer.w*Layer.h) LT Layer.para.sn, c)
;   IF c NE 0 THEN Layer.M(spikenoise) = Layer.M(spikenoise)+Layer.Para.th0*1.05

   result = WHERE(Layer.M GE (Layer.Para.th0), count) 

   newOut = [count, Layer.w * Layer.h]
   IF count NE 0 THEN newOut = [newOut, result]
   Handle_Value, Layer.O, newOut, /SET

   Layer.decr = 1

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
END
