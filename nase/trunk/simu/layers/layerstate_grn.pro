;+
; NAME:
;  LayerState_GRN
;
; VERSION:
;  $Id$
;
; AIM:
;  Return or set current state of Graded Response Neurons in a given layer.
;
; PURPOSE:
;  <C>LayerState_GRN</C> can be used to determine internal membrane
;  potentials and output states of graded response
;  neurons. It can also set the feeding and linking potentials of
;  these neurons. Graded response
;  neurons generate 
;  a continuous output activation as opposed to pulse coding
;  neurons. The way in which their membrane potentials are transformed
;  into their output is determined by a so called transfer
;  function. Most commonly used are sigmoidal, piecewise linear or
;  threshold transfer functions.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* LayerState_GRN, layer, [,/DIMENSIONS] $
;*               [,OUTPUT=...][,POTENTIAL=...]
;*               [,SETFEEDING=...][,SETLINKING=...]
;
; INPUTS:
;  layer:: A handle on a layer of graded response neuron, initialized
;          by <A>InitLayer_GRN()</A>.
;
; INPUT KEYWORDS:
;  DIMENSIONS:: Turn this switch on to obtain the output and
;               potentials of <*>layer</*> in its original rectangular
;               dimensions. Otherwise, a one dimensional array is
;               returned.
;  SETFEEDING, SETLINKING:: Values passed with these keywords are used
;                           to set the respective potentials. The
;                           internal decrement flag is then set to zero to
;                           avoid decreasing of the desired values. By
;                           calling <A>ProceedLayer_GRN</A> right
;                           after setting the potentials, the
;                           corresponding output state is
;                           computed. This is useful during
;                           initialization of the
;                           potentials. <*>SETFEEDING/-LINKING</*> may
;                           either be supplied in one- or
;                           twodimensional format.
;
; OPTIONAL OUTPUTS:
;  OUTPUT:: The output activation of the neurons in <*>layer</*>,
;           i.e. the membrane potentials passed through the transfer
;           function. 
;  POTENTIAL:: The membrane potentials of the neurons in <*>layer</*>.
;
; PROCEDURE:
;  Dereferencing of handle and a little reforming.
;
; EXAMPLE:
;  The example shows a neuron whose output is twice its
;  positive input while negative input is set to zero: 
;* ug=FltArr(100)
;* og=FltArr(100)
;*
;* tf = {func:'grntf_threshlinear', tfpara:{slope:2.0, threshold:0.0}}
;* p = InitPara_GRN(tf, TAUF=0., TAUL=0.)
;*
;* lg = InitLayer(WIDTH=1, HEIGHT=1, TYPE=p)
;* 
;* FOR t=0,99 DO BEGIN
;*    feed=RandomN(seed)
;*    InputLayer, lg, FEEDING=Spassmacher(feed)
;*    ProceedLayer, lg
;*    LayerState_GRN, lg, potential=p, output=o
;*    ug(t)=p
;*    og(t)=o
;* ENDFOR
;* 
;* FreeLayer, lg
;*
;* OPlotMaximumFirst,[[ug],[og]],LINESTYLE=-1,COLOR=[RGB('yellow'),RGB('blue')]
;
; SEE ALSO:
;  <A>LayerData</A>, <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>,
;  <A>InputLayer_GRN</A>, <A>ProceedLayer_GRN()</A>,
;  <A>GRNTF_ThreshLinear()</A>.
;-



PRO LayerState_GRN, _L, DIMENSIONS=DIMENSIONS $
                    , OUTPUT=output, POTENTIAL=potential $
                    , SETFEEDING=setfeeding, SETLINKING=setlinking

   Handle_Value, _L, L, /NO_COPY
   
   IF Set(SETFEEDING) THEN BEGIN
      l.f = Reform(setfeeding, l.w*l.h, /OVERWRITE)
      l.decr = 0
   ENDIF

   IF Set(SETLINKING) THEN BEGIN
      l.l = Reform(setlinking, l.w*l.h, /OVERWRITE)
      l.decr = 0
   ENDIF

   output = SpassBeiseite(Handle_Val(l.o))
   potential = l.m 

   IF Keyword_Set(DIMENSIONS) THEN BEGIN
      output = Reform(output, l.h, l.w, /OVERWRITE)
      potential = Reform(potential, l.h, l.w, /OVERWRITE)
   ENDIF

   Handle_Value, _L, L, /NO_COPY, /SET

END
