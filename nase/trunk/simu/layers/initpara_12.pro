;+
; NAME:
;  InitPara_12()
;
; VERSION:
;  $Id$
;
; AIM:
;  Define parameter values for layer of Marburg Model Neurons with
;  additional shunting mechanism.
;
; PURPOSE:
; Define parameter values for layer of Marburg Model Neurons with
;  additional shunting mechanism.
;
; CATEGORY:
;  Layers
;  MIND
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VS=vs] [, TAUS=taus] $
;*                       [, TH0=th0] [SIGMA=sigma]
;* [NOISYSTART=noisystart] [,SPIKENOISE=spikenoise] )
;
;
; INPUT KEYWORDS:
;   taux :: Time-Constant of the Shunting-Potential
;   sampleperiod ::   die Dauer eines Simulationszeitschritts, Default: 0.001s
;
;
; OUTPUTS:
; Para : Structure namend Para1, which contains all neuron parameters
;
; RESTRICTIONS:
;   tau? has to be greater than 0
;
; EXAMPLE:
;*
;* >
;
; SEE ALSO: <a>InitLayer_12</a>, <a>ProceedLayer_12</a>,
;           <a>InputLayer_12</a>, <a>Layerdata</a>
;
;-

FUNCTION InitPara_12, TAUF=tauf, TAUL=taul, TAUI=taui, TAUX=taux, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise, SAMPLEPERIOD=sampleperiod

   Default, SAMPLEPERIOD, 0.001
   deltat = SAMPLEPERIOD*1000.


   Default, tauf     , 10.0
   Default, taul      , 10.0
   Default, taui      , 10.0
   Default, taux     , 10.0
   Default, vs        , 10.0
   Default, taus      , 10.0
   Default, th0       ,  1.0
   Default, sigma     ,  0.0
   Default, noisystart,  0.0
   Default, spikenoise  ,  0.0

   Para = { info : 'PARA'         ,$
	    type : '12'            ,$
            df   : exp(-deltat/tauf)  ,$
            dl   : exp(-deltat/taul)  ,$
            di   : exp(-deltat/taui)  ,$
            dx   : exp(-deltat/taux) ,$
            tauf : FLOAT(tauf)    ,$
            taul : FLOAT(taul)    ,$
            taui : FLOAT(taui)    ,$
            taux : FLOAT(taux)   ,$
            vs   : vs             ,$
            ds   : exp(-deltat/taus)  ,$
            taus : FLOAT(taus)    ,$
            th0  : th0            ,$
            sigma: sigma          ,$
            sn   : deltat*spikenoise/1000.,$
            ns   : noisystart*th0 }

   RETURN, Para

END 
