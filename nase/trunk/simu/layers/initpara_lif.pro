;+
; NAME:
;  InitPara_LIF()
;
; VERSION:
;  $Id$
;
; AIM:
;  Define parameter values for layer of Leaky Integrate and Fire neurons.
;
; PURPOSE:
;  Define parameter values for a layer of leaky Integrate and Fire
;  neurons with fixed treshold and feeding, linking, inhibition
;  potentials.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;* para = InitPara_LIF( [TAUF=...][,TAUL=...][,TAUI=...] 
;*                      [,TH0=...][,SIGMA=...] 
;*                      [,NOISYSTART=...][,SPIKENOISE=...] )
;
; INPUT KEYWORDS:
;  TAUF:: Time constant of feeding potential. Default:10.0ms.
;  TAUL:: Time constant of linking potential. Default:10.0ms.
;  TAUI:: Time constant of inhibition potential. Default:10.0ms.
;  TH0:: Threshold for action potential generation. Default:1.0.
;  SIGMA:: Standard deviation of normally distributed membrane
;          potential noise. Default:0.0 (no noise).
;  NOISYSTART:: All input potentials (F,L,I) are initialized with
;               equally distributed random numbers. The value of
;               noisystart is given in multiples of the threshold
;               <*>TH0</*>. Default:0.0.
;
; OUTPUTS:
;  para:: Structure to be used in <A>InitLayer_LIF()</A>, containing
;         the following tags:
;*         info : 'PARA'
;*         type : 'LIF'
;*         df   : exp(-1./tauf)
;*         dl   : exp(-1./taul)
;*         di   : exp(-1./taui)
;*         tauf : Float(tauf)
;*         taul : Float(taul)
;*         taui : Float(taui)
;*         th0  : th0
;*         sigma: sigma
;*         ns   : noisystart*th0
;
; RESTRICTIONS:
;  <*>TAUF</*>, <*>TAUL</*> and <*>TAUI</*> have to be GT 0.0.
;
; EXAMPLE:
;* parameters = InitPara_LIF(TAUF=5.0, TH0=2.0, SIGMA=0.1)
;
; SEE ALSO:
;  <A>InitLayer_LIF()</A>, <A>InputLayer_LIF</A>,
;  <A>ProceedLayer_LIF</A>.
;
;-



FUNCTION InitPara_LIF, TAUF=tauf, TAUL=taul, TAUI=taui $
                       , TH0=th0, SIGMA=sigma, NOISYSTART=noisystart

   Default, tauf      , 10.0
   Default, taul      , 10.0
   Default, taui      , 10.0
   Default, th0       ,  1.0
   Default, sigma     ,  0.0
   Default, noisystart,  0.0
   Default, spikenoise  ,  0.0

   Para = { info : 'PARA'         ,$
	    type : 'LIF'            ,$
            df   : exp(-1./tauf)  ,$
            dl   : exp(-1./taul)  ,$
            di   : exp(-1./taui)  ,$
            tauf : FLOAT(tauf)    ,$
            taul : FLOAT(taul)    ,$
            taui : FLOAT(taui)    ,$
            th0  : th0            ,$
            sigma: sigma          ,$
            ns   : noisystart*th0 }

   RETURN, Para

END 
