;+
; NAME:
;  InitPara_GRN()
;
; VERSION:
;  $Id$
;
; AIM:
;  Define parameter values for layer of Graded Response Neurons.
;
; PURPOSE:
;  <C>InitPara_GRN()</C> is used to set the parameter values for a
;  layer of graded response neurons. Graded response neurons generate
;  a continuous output activation as opposed to pulse coding
;  neurons. The way in which their membrane potentials are transformed
;  into their output is determined by a so called transfer
;  function. Most commonly used are sigmoidal, piecewise linear or
;  threshold transfer functions. It is possible to create any desired
;  transfer function, as long as it obeys to certain rules, see
;  <*>transfunc</*> below and <A>GRNTF_Threshlinear</A> as an
;  example. 
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* para = InitPara_GRN( transfunc [,TAUF=...][,TAUL=...]
;*                   [,SIGMA=...][,NOISYSTART=...] )
;
; INPUTS:
;  transfunc:: A structure containing the necessary information about
;              the transfer function that shall be used to compute the neurons'
;              output activations from their membrane
;              potentials. <*>transfunc</*> must contain a string
;              describing the name of the function and a structure in
;              which the parameters of the function are passed. 
;* tf = {func:'GRNTF_myfunc', tfpara:{pa1:2.0, pa2:3.0}}
;              The first argument of <*>GRNTF_myfunc</*> has to be
;              the mebrane potential, the second one the structure
;              containing function parameters. Further arguments are not
;              allowed. See e.g. <A>GRNTF_ThreshLinear()</A>.
;
; INPUT KEYWORDS:
;  TAUF:: Feeding potential decay time constant. Set <*>TAUF=0</*> to
;         avoid summation (i.e. lowpass filtering) of feeding
;         input. Default: 10.BIN
;  TAUL:: Linking potential decay time constant. Set <*>TAUL=0</*> to
;         avoid summation (i.e. lowpass filtering) of linking
;         input. Default: 10.BIN
;  SIGMA:: Standard deviation of noise added to the neurons' membrane
;          potentials during each simulation step. Default: 0.
;  NOISYSTART:: Amplitude of random values used to initialize the
;               feeding and linking potentials. This can be useful to
;               avoid onset artifacts. Default: 0.
;
; OUTPUTS:
;  para:: Parameter structure including the following tags:
;*        { info: 'PARA', $
;*          type: 'GRN', $
;*          transfunc: transfunc, $
;*          df: df, $
;*          dl: dl, $
;*          tauf: Float(tauf), $
;*          taul: Float(taul), $
;*          sigma: sigma, $
;*          ns: noisystart }
;
; PROCEDURE:
;  Set some defaults, compute decrement from exp-function and generate
;  structure.
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
;  <A>InitLayer_GRN()</A>, <A>InputLayer_GRN()</A>,
;  <A>ProceedLayer_GRN()</A>, <A>LayerState_GRN()</A>
;  <A>GRNTF_ThreshLinear()</A>.
;-

FUNCTION InitPara_GRN, transfunc, TAUF=tauf, TAUL=taul $
                       , SIGMA=sigma, NOISYSTART=noisystart

   Default, tauf, 10.0
   Default, taul, 10.0
   Default, sigma, 0.0
   Default, noisystart, 0.0

   IF NOT Set(transfunc) THEN Console, /FATAL, 'Missing transfer function.'

   IF tauf EQ 0.0 THEN df = 0.0 ELSE df = Exp(-1.0/tauf)
   IF taul EQ 0.0 THEN dl = 0.0 ELSE dl = Exp(-1.0/taul)

   Para = { info: 'PARA', $
	    type: 'GRN', $
            transfunc: transfunc, $
            df: df, $
            dl: dl, $
            tauf: Float(tauf), $
            taul: Float(taul), $
            sigma: sigma, $
            ns: noisystart }

   Return, Para

END 
