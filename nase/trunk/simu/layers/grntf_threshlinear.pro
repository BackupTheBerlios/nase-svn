;+
; NAME:
;  GRNTF_ThreshLinear()
;
; VERSION:
;  $Id$
;
; AIM:
;  Transfer function for Graded Response Neurons: Linear above threshold. 
;
; PURPOSE:
;  <C>GRNTF_ThreshLinear()</C> can be used as a transfer function for
;  graded response neurons. It results in a linear transfer as long as
;  the input to the neuron is above a given threshold. Otherwise, a
;  value of 0 is returned. Graded response neurons generate
;  a continuous output activation as opposed to pulse coding
;  neurons. The way in which their membrane potentials are transformed
;  into their output is determined by a so called transfer
;  function. Most commonly used are sigmoidal, piecewise linear or
;  threshold transfer functions.<BR>
;  <C>GRNTF_ThreshLinear()</C> is normally not used by itself, but by
;  <A>ProceedLayer_GRN</A>, and it has to be specified during
;  initialization of a given layer, i.e. as an argument of
;  <A>InitPara_GRN()</A>. 
; 
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* result =  GRNTF_ThreshLinear(m, tfpara)
;
; INPUTS:
;  m:: The argument of the function, the membrane potential or
;      activation in neural terms.
;  tfpara:: A structure containing two tags: <*>slope</*> and
;           <*>threshold</*>.
;  tfpara.slope:: Factor by which <*>m</*> is multiplied to obtain the
;                 output that is above threshold.
;  tfpara.threshold:: Values of <*>m*slope</*> below <*>threshold</*>
;                     are clipped to <*>0</*>.
;-
; OUTPUTS:
;  result:: <*>tfpara.slope*(m-tfpara.threshold) > 0</*>, or in other
;           words <*>tfpara.slope*[(m-tfpara.threshold)*Heaviside(m-tfpara.threshold)]</*>.
;  
; PROCEDURE:
;  Cut off part of input that is below threshold, then multiply by slope.
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
;  <A>InitPara_GRN()</A>, <A>InitLayer_GRN()</A>,
;  <A>InputLayer_GRN</A>, <A>ProceedLayer_GRN()</A>, <A>LayerState_GRN()</A>.
;-



FUNCTION grntf_threshlinear, m, tfpara

   Return, tfpara.slope*(m-tfpara.threshold) > 0

END
