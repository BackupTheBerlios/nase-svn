;+
; NAME:
;  InitLayer_GRN()
;
; VERSION:
;  $Id$
;
; AIM:
;  Initialize layer of Graded Response Neurons.
;
; PURPOSE:
;  <C>InitLayer_GRN()</C> can be used to initialize a layer of graded
;  response neurons. Graded response neurons generate
;  a continuous output activation as opposed to pulse coding
;  neurons. The way in which their membrane potentials are transformed
;  into their output is determined by a so called transfer
;  function. Most commonly used are sigmoidal, piecewise linear or
;  threshold transfer functions.<BR>
;  It is also possible to use <A>InitLayer</A> instead, since this
;  routine is able to automatically determine the correct neuron type.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* lh = InitLayer_GRN( WIDTH=..., HEIGHT=..., TYPE=... )
;
; INPUT KEYWORDS:
;  WIDTH:: Number of neurons in a row of the layer.
;  HEIGHT:: Number of neurons in a column of the layer.
;  TYPE:: The parameter structure that contains the neurons'
;         parameters, this is obtained via <A>InitPara_GRN()</A>.
;  
; OUTPUTS:
;  lh:: Handle on a structure that consist of the following tags:
;*          {info: 'LAYER', $
;*           type: 'GRN', $
;*           w: width, $
;*           h: height, $
;*           para: type, $
;*           decr: 1, $
;*           f: type.ns*Float(RandomU(seed,width*height)), $
;*           l: type.ns*Float(RandomU(seed,width*height)), $
;*           m: FltArr(width*height), $
;*           o: handle}
;
; COMMON BLOCKS:
;  common_random
;
; PROCEDURE:
;  Just create a structure.
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
;* OPlotMaximumFirst,[[ug],[og]],LINESTYLE=-1,COLOR=[RGB('yellow'),RGB('blue')]
;
; SEE ALSO:
;  <A>InitLayer()</A>, <A>InitPara_GRN</A>, <A>InputLayer_GRN</A>,
;  <A>ProceedLayer_GRN</A>, <A>Layerstate_GRN()</A>,
;  <A>GRNTF_ThreshLinear</A>.
;-

FUNCTION InitLayer_GRN, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON common_random, seed

   IF (NOT Keyword_Set(width)) THEN Console, /FATAL, 'Keyword WIDTH expected.'
   IF (NOT Keyword_Set(height)) THEN $
    Console, /FATAL, 'Keyword HEIGHT expected.'
   IF (NOT Keyword_Set(type)) THEN Console, /FATAL, 'Keyword TYPE expected.'


   handle = Handle_Create(!MH, VALUE=[0, width*height])

   layer = {info: 'LAYER', $
            type: 'GRN', $
            w: width, $
            h: height, $
            para: type, $
            decr: 1, $ ; decides if potentials are to be decremented or not
            f: type.ns*Float(RandomU(seed,width*height)), $
            l: type.ns*Float(RandomU(seed,width*height)), $
            m: FltArr(width*height), $
            o: handle}

   
   Return, Handle_Create(!MH, VALUE=layer, /NO_COPY)

END 
