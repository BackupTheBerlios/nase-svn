;+
; NAME:
;  InitPara_14()
;
; AIM:
;  Define parameter values for layer of Two Dendrite Neurons.
;
; PURPOSE:              initialisiert Parameterstruktur Para14, die Neuronenparameter fuer Neuronentyp 14 enthaelt
;                            (2 Feeding 2ZK, 1 Linking 1ZK, 2 Inihibition 2ZK, Schwelle 2 additive ZK 1.Ordnung)
;
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_14( [TAUF1=tauf1] [, TAUF2=tauf2] [, TAUL=taul] [, TAUI1=taui1] [, TAUI2=taui2] [, VR=vr] [, TAUR=taur] $
;                                          [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] [NOISYSTART=noisystart] [,SPIKENOISE=spikenoise]  )
;
; KEYWORD PARAMETERS:   tauf1       : Feeding-Zeitkonstante1
;                       tauf2       : Feeding-Zeitkonstante2
;                       taul       : Linking-Zeitkonstante
;                       taui1       : Inihibition-Zeitkonstante1 (wirkt vor dem Linking)
;                       taui2       : Inihibition-Zeitkonstante2 (wirkt nach dem Linking)
;                       vaur       : Schwellen-Verstaerkung2
;                       taur       : Schwellen-Zeitkonstante2
;                       vaus       : Schwellen-Verstaerkung1
;                       taus       : Schwellen-Zeitkonstante1
;                       th0        : Schwellen-Offset
;                       sigma      : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       noisystart : alle Input-Potential (F,L,I) werden mit gleichverteilten Zufalls-
;                                    zahlen belegt. Der Wert von noisystart wird in Einheiten der Ruheschwelle
;                                    th0 angegeben.
;                       spikenoise  : mean spontanous activity in Hz 
;                       sampleperiod ::   die Dauer eines Simulationszeitschritts, Default: 0.001s
;
; OUTPUTS:              Para : Struktur namens Para14, die alle Neuronen-Informationen enthaelt, s.u.
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; EXAMPLE:              para14 = InitPara_14(tauf1=10.0, vs=1.0)
;-

FUNCTION InitPara_14, TAUF1=tauf1, TAUF2=tauf2, TAUL=taul, TAUI1=taui1, TAUI2=taui2, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise, SAMPLEPERIOD=sampleperiod

   Default, SAMPLEPERIOD, 0.001
   deltat = SAMPLEPERIOD*1000.



   Default, tauf1     , 10.0
   Default, tauf2     , 10.0
   Default, taul      , 10.0
   Default, taui1     , 10.0
   Default, taui2     , 10.0
   Default, vr        ,  5.0
   Default, taur      ,  5.0
   Default, vs        , 10.0
   Default, taus      , 10.0
   Default, th0       ,  1.0
   Default, sigma     ,  0.0
   Default, noisystart,  0.0
   Default, spikenoise  ,  0.0

   Para = { info: "PARA"         ,$
	    type: '14'             ,$		
            df1 : exp(-deltat/tauf1)   ,$
            df2 : exp(-deltat/tauf2)   ,$
            dl : exp(-deltat/taul)   ,$
            di1 : exp(-deltat/taui1)   ,$
            di2 : exp(-deltat/taui2)   ,$
            tauf1 : FLOAT(tauf1)    ,$
            tauf2 : FLOAT(tauf2)    ,$
            taul : FLOAT(taul)    ,$
            taui1 : FLOAT(taui1)    ,$
            taui2 : FLOAT(taui2)    ,$
            vr : vr              ,$
            dr : exp(-deltat/taur)   ,$
            vs : vs              ,$
            ds : exp(-deltat/taus)   ,$
            taus : FLOAT(taus)    ,$
            taur : FLOAT(taur)    ,$
            th0: th0             ,$
            sn   : deltat*spikenoise/1000.,$
            sigma: sigma         ,$
            ns   : noisystart*th0}

   RETURN, Para

END 




