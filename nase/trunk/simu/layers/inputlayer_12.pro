;+
; NAME:
;  InputLayer_12
;
; VERSION:
;  $Id$
;
; AIM:
;   Transfer input to Marburg Model Neuron synapses of given layer. 
;
; PURPOSE:
;   Transfer input to Marburg Model Neuron synapses of given layer. 
;
; CATEGORY:
;  Layers
;  MIND
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*  InputLayer_12, Layer [,FEEDING=feeding] [,LINKING=linking] [,INHIBITION=inhibition]
;                                       [,SHUNTING=shunting]  [,/CORRECT]  
;
; INPUTS:  see <a>InputLayer_1</a>
;                  additionaly theres a new potential : shunting,
;                                                       which acts on
;                                                       the feeding-timeconstant
;
; OPTIONAL INPUTS:
;
;
; INPUT KEYWORDS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
;
; PROCEDURE:
;
;
; EXAMPLE:
;*
;* >
;
; SEE ALSO:
;
;-

PRO InputLayer_12, _Layer, FEEDING=feeding, LINKING=linking, INHIBITION=inhibition, SHUNTING=shunting, CORRECT=correct

   Handle_Value, _Layer, Layer, /NO_COPY

   mydf = exp(-1./(Layer.para.tauf * sqrt((1-Layer.X) > 0.00001)))
   IF Layer.decr THEN BEGIN
      Layer.F = Layer.F * mydf
      Layer.L = Layer.L * Layer.para.dl
      Layer.I = Layer.I * Layer.para.di
      Layer.S = Layer.S * Layer.para.ds
      Layer.X = Layer.X *Layer.para.dx
      Layer.decr = 0
   END

   IF Set(feeding) THEN BEGIN
      IF Feeding(0,0) GT 0 THEN BEGIN
         neurons = Feeding(0,1:Feeding(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))*(1.-mydf)
         END ELSE BEGIN
            Layer.F(neurons) = Layer.F(neurons) + Feeding(1,1:Feeding(0,0))
         END
      END
   END

   IF Set(linking) THEN BEGIN
      IF Linking(0,0) GT 0 THEN BEGIN
         neurons = Linking(0,1:Linking(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))*(1.-Layer.para.dl)
         END ELSE BEGIN
            Layer.L(neurons) = Layer.L(neurons) + Linking(1,1:Linking(0,0))
         END
      END
   END


 IF Set(shunting) THEN BEGIN
      IF shunting(0,0) GT 0 THEN BEGIN
         neurons = shunting(0,1:shunting(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.X(neurons) = Layer.X(neurons) + shunting(1,1:shunting(0,0))*(1.-Layer.para.dx)
         END ELSE BEGIN
            Layer.X(neurons) = Layer.X(neurons) + shunting(1,1:shunting(0,0))
         END
      END
   END


         
   IF Set(inhibition) THEN BEGIN
      IF Inhibition(0,0) GT 0 THEN BEGIN
         neurons = Inhibition(0,1:Inhibition(0,0))
         IF Keyword_Set(CORRECT) THEN BEGIN
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))*(1.-Layer.para.di)
         END ELSE BEGIN            
            Layer.I(neurons) = Layer.I(neurons) + Inhibition(1,1:Inhibition(0,0))
         END
      END
   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET

END
