;+
; NAME:
;  LayerData
;
; VERSION:
;  $Id$
;
; AIM:
;  Return information about state of given layer.
;
; PURPOSE:
;  Obtain information about the state of neurons in a given
;  layer. All data is returned via keywords, e.g. synapse and membrane
;  potentials, threshold or parameters. To determine width and height
;  of layers, <A>LayerWidth()</A> and <A>LayerHeight()</A> should be
;  used because they work faster.
;
; CATEGORY:
;  Layers
;  NASE 
;  Simulation
;
; CALLING SEQUENCE: 
;*  LayerData, layer [,TYPE=Type]
;*                   [,WIDTH=Width] [,HEIGHT=Height]
;*                   [,PARAMETERS=Parameters] 
;*                   [,FEEDING=Feeding] 
;*                   [,FFEEDING1=ffeeding1][,SFEEDING=sfeeding] 
;*                   [,LINKING=linking][,ILINKING=ilinking]  
;*                   [,INHIBITION=Inhibition]
;*                   [,SNHIBITION=sinhibition][,FINHIBITION=finhibition]
;*                   [,POTENTIAL=Potential]
;*                   [,THRESHOLD=threshold] 
;*                   [,STHRESHOLD=slow_threshold]
;*                   [,OUTPUT=Output]
;
; INPUTS:
;  layer:: Structure initialized by <A>InitLayer</A>.
;
; OPTIONAL OUTPUTS: 
;  type:: Type of neurons in this layer (string).
;  width, height:: Dimensions of layer (integer).
;  parameters:: Parameters as described by the InitPara function used
;               to create the layer.
;  feeding:: State of corresponding 
;  ffeeding1, sfeeding:: leaky integrators
;  linking, ilinking:: (doublearray[HeightxWidth]) 
;  inhibition, sinhibition, finhibition::
; 
;  potential:: Membrane potentials (doublearray[HeightxWidth])
;              In case the layer is of type '8' (four compartment) neurons,
;              potential returns a FltArr(width,height,5) of the
;              following structure:
;              Potential(*,*,0) = n  (Recovery) 
;              Potential(*,*,1) = Vs  (Soma)
;              Potential(*,*,2) = V3  (Dendrite 3) 
;              Potential(*,*,3) = V2  (Dendrite 2)
;              Potential(*,*,4) = V1  (Dendrit 1)
;
;  threshold:: State of threshold. This is the sum of offset and
;              one or two dynamic parts (DoubleArray[HeightxWidth]).
;
;  slow_threshold:: The state of the slow part of the dynamic
;                   threshold can be obtained separately
;                   (DoubleArray[HeightxWidth]).
;
;  output:: Output spikes (ByteArray[HeightxWidth]), they can also be
;           obtained seperately by <A>LayerSpikes</A>.
;
; EXAMPLE:
;* LP = InitPara_1()
;* L = InitLayer(5,5,TYPE=LP)
;* LayerData, L, FEEDING=MyFeeding, POTENTIAL=MyMembranpotential
;* Print, myfeeding
;
; SEE ALSO:
;  <A HREF=InitPara_1>InitPara_i</A> (i=1..11), <A>InitLayer</A>,
;  <A>LayerWidth</A>, <A>LayerHeight</A>, <A>LayerSize</A>,
;  <A>LayerSpikes</A>. 
;-



PRO LayerData, _Layer, $
               TYPE=type, $
               WIDTH=width, HEIGHT=height, PARAMETERS=parameters $
               , FEEDING=feeding $
               , FFEEDING1=ffeeding, SFEEDING=sfeeding $
               , LINKING=linking $
               , ILINKING=ilinking $
               , INHIBITION=inhibition, $
               FINHIBITION=finihibition, SINHIBITION=sinhibition,$
               POTENTIAL=potential, $
               SCHWELLE=schwelle, LSCHWELLE=lschwelle $
               , THRESHOLD=threshold, STHRESHOLD=sthreshold, $
               OUTPUT=output

   TestInfo, _Layer, "Layer"
   Handle_Value, _Layer, Layer, /NO_COPY
   

   ; same for ALL TYPES
   type       = Layer.Type
   width      = Layer.W
   height     = Layer.H
   n = width*height
   parameters = Layer.Para


   ;--- handle Potential
   CASE layer.type OF
      '8' : IF n GT 1 THEN potential = Reform(layer.V, layer.h, layer.w, 5) $
                       ELSE potential = layer.V
      '9' : BEGIN
         layer.cells->Info, GET_POTENTIALS = potential
;         FOR i=0,layer.w*layer.h-1 DO $
;          potential(i,*)=layer.cells(i)->State()
         IF n GT 1 THEN potential = Reform(potential, layer.h, layer.w, 5)
         END
      ELSE: IF n GT 1 THEN potential  = REFORM(Layer.M, Layer.H, Layer.W) $
                      ELSE potential = Layer.M
   ENDCASE


;---  handle FEEDING
   CASE Layer.TYPE OF
      '6' : IF n GT 1 THEN feeding  = REFORM(Layer.para.corrAmpF*(Layer.F2-Layer.F1), Layer.H, Layer.W) ELSE  feeding  = Layer.para.corrAmpF*(Layer.F2-Layer.F1)
      '7' : BEGIN
         IF n GT 1 THEN BEGIN
            ffeeding = REFORM(Layer.F1, Layer.H, Layer.W)
            sfeeding = REFORM(Layer.F2, Layer.H, Layer.W)   
         END ELSE BEGIN
            ffeeding = Layer.F1
            sfeeding = Layer.F2
         END
      END
      '8' : feeding = !NONE
      '9' : feeding = !NONE
      ELSE: IF n GT 1 THEN feeding = REFORM(Layer.F, Layer.H, Layer.W) ELSE feeding = Layer.F
   ENDCASE


;--- handle LINKING
   CASE Layer.TYPE OF
      '11': BEGIN 
         IF n GT 1 THEN linking = REFORM(Layer.L1, Layer.H, Layer.W) ELSE linking = Layer.Layer.L1
         IF n GT 1 THEN ilinking = REFORM(Layer.L2, Layer.H, Layer.W) ELSE ilinking = Layer.Layer.L2
      END 


      '6' : IF n GT 1 THEN linking = REFORM(Layer.para.corrAmpL*(Layer.L2-Layer.L1), Layer.H, Layer.W) ELSE linking = Layer.para.corrAmpL*(Layer.L2-Layer.L1)
      '8' : linking = !NONE
      '9' : linking = !NONE
      ELSE: IF n GT 1 THEN linking = REFORM(Layer.L, Layer.H, Layer.W) ELSE linking = Layer.L
   ENDCASE
   

;--- handle INHIBITION
   CASE Layer.TYPE OF
      '7' : BEGIN
         IF n GT 1 THEN BEGIN 
            finhibition = REFORM(Layer.I1, Layer.H, Layer.W) 
            sinhibition = REFORM(Layer.I2, Layer.H, Layer.W)
         END ELSE BEGIN
            finhibition = Layer.I1 
            sinhibition = Layer.I2
         END
      END
      '8' : inhibition = !NONE
      '9' : inhibition = !NONE
     ELSE: IF n GT 1 THEN inhibition = REFORM(Layer.I, Layer.H, Layer.W) ELSE inhibition = Layer.I
   ENDCASE
   

;--- handle THRESHOLD
   CASE Layer.TYPE OF
      '2' : IF n GT 1 $
       THEN threshold=REFORM(Layer.R+Layer.S+Layer.Para.th0,Layer.H,Layer.W) $
       ELSE threshold=Layer.R+Layer.S+Layer.Para.th0
      '6' : IF n GT 1 $
       THEN threshold=REFORM(Layer.R+Layer.S+Layer.Para.th0,Layer.H,Layer.W) $
       ELSE threshold=Layer.R+Layer.S+Layer.Para.th0
      '8' : threshold = !NONE
      '9' : threshold = !NONE
      'lif' : threshold = layer.para.th0
      ELSE: IF n GT 1 THEN $
       threshold = REFORM(layer.S+layer.para.th0, Layer.H, Layer.W) $
      ELSE threshold = layer.S+layer.para.th0
   ENDCASE
   schwelle = threshold         ; use new english keywords but be compatible
      


   ; handle SPECIAL TAGS
   IF (Layer.Type EQ '2') OR (Layer.Type EQ '6') THEN BEGIN
      IF n GT 1 THEN $
       sthreshold = Reform(Layer.R, Layer.H, Layer.W) $
      ELSE sthreshold = Layer.R
      lschwelle = sthreshold    ; use new english keywords but be compatible 
   END

;--- Type 3 (learning potential neuron) was obsolete has been removed 
;   IF Layer.Type EQ '3' THEN BEGIN
;      IF n GT 1 THEN lernpotential = Reform(Layer.P, Layer.H, Layer.W) ELSE lernpotential = Layer.P
;   END

   Handle_Value, _Layer, Layer, /NO_COPY, /SET
   output = LayerSpikes(_Layer, /DIMENSIONS)

END



