;+
; NAME: ProceedLayer_10
;
; PURPOSE: Führt einen Simulationsschritt für eine Schicht aus Neuronen
;          vom Typ 10 (Poissonneuronen) durch. Die Feuerwahrscheinlichkeit
;          für diesen Zeitschritt ist dabei die Summe aus einer festen, mit
;          <A HREF="#INITLAYER_10">InitLayer_10</A> bestimmten, und einer
;          dynamischen, durch <A HREF="#INPUTLAYER_10">InputLayer_10</A> festgelegten
;          Wahrscheinlichkeit. Die Feuerwahrscheinlichkeit kann also durch 
;          Spikes anderer Neuronen verändert werden. Ohne diese dynamische
;          Wahrscheinlichkeit hat die Routine den gleichen Effekt wie 
;          <A HREF="../input/#POISSONINPUT">PoissonInput</A>.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: ProceedLayer_10, Layer
;
; INPUTS: Layer : eine durch <A HREF="#INITLAYER_10">InitLayer_10</A> initialisierte Layer
;
; COMMON BLOCKS: common_random
;
; EXAMPLE:
;          para1 = InitPara_1(tauf=10.0)
;          InputLayer = InitLayer_1(PROBAILITY=[0.5,0.7], para1)
;          FeedingIn = Spassmacher(0.1 + RandomN(seed, InputLayer.w*InputLayer.h))
;          InputLayer_10, InputLayer, FEEDING=FeedingIn
;          ProceedLayer_10, InputLayer
;          Print, 'Output: ', LayerSpikes(InputLayer)
;
;
; SEE ALSO: <A HREF="#INITPARA_10">InitPara_10</A>, <A HREF="#INITLAYER_10">InitLayer_10</A>, <A HREF="#INPUTLAYER_10">InputLayer_10</A>,
;           <A HREF="../input/#POISSONINPUT">PoissonInput</A>
;-
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.2  2000/09/27 15:59:41  saam
;       service commit fixing several doc header violations
;
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;
;
; 
PRO ProceedLayer_10, _layer, _EXTRA=_extra

   COMMON common_random, seed

   Handle_Value, _layer, layer, /NO_COPY

   IF layer.decr THEN BEGIN
      layer.F = layer.F * layer.para.df
   END


   r = RandomU(seed, layer.w*layer.h)

   result = WHERE(r LE (layer.S+layer.F), count)

   newout = [count, layer.w * layer.h]
   IF count NE 0 THEN newout = [newout, result]

   Handle_Value, layer.o, newout, /SET

   layer.decr = 1

   Handle_Value, _layer, layer, /NO_COPY, /SET

END
