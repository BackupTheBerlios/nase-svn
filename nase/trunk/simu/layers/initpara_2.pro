;+
; NAME:
;  InitPara_2()
;
; AIM:
;  Define parameter values for layer of Adaptive Marburg Model Neurons.
;
; PURPOSE:              initialisiert Parameterstruktur Para1, die Neuronenparameter fuer Neuronentyp 2 enthaelt
;                            (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 2 additive ZK 1.Ordnung)
;
; CATEGORY:             SIMULATION /LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VR=vr] [, TAUR=taur] $
;                                          [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] [NOISYSTART=noisystart] [,SPIKENOISE=spikenoise]  )
;
; KEYWORD PARAMETERS:   tauf       : Feeding-Zeitkonstante
;                       taul       : Linking-Zeitkonstante
;                       taui       : Inihibition-Zeitkonstante
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
; OUTPUTS:              Para : Struktur namens Para2, die alle Neuronen-Informationen enthaelt, s.u.
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; EXAMPLE:              para2 = InitPara_2(tauf=10.0, vs=1.0)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.7  2004/09/27 14:03:32  michler
;
;       Modified Files:
;        	initpara_1.pro initpara_2.pro initpara_4.pro initpara_6.pro
;        	initpara_7.pro initpara_11.pro initpara_12.pro initpara_14.pro
;
;       adapting time constants to temporal resolution,
;       using parameter SAMPLEPERIOD as in initrecall.pro
;
;       Revision 1.6  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 1.5  1998/11/04 16:26:52  thiel
;              Struktur enthaelt jetzt info='PARA'
;              und type='Neuronentyp' getrennt.
;
;       Revision 1.4  1998/06/01 15:10:46  saam
;             spontanous activity with keyword spikenoise implemented
;
;       Revision 1.3  1998/02/18 15:46:39  kupper
;              Strukturen sind jetzt wie alle NASE-Strukturen unbenannt und haben den info-Tag.
;
;   ------------------------------------------------------------------------------------
;       initial version, Mirko Saam, 22.7.97
;
;-
FUNCTION InitPara_2, TAUF=tauf, TAUL=taul, TAUI=taui, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise, SAMPLEPERIOD=SamplePeriod

   Default, SAMPLEPERIOD, 0.001
   deltat = SAMPLEPERIOD*1000.


   Default, tauf      , 10.0
   Default, taul      , 10.0
   Default, taui      , 10.0
   Default, vr        ,  5.0
   Default, taur      ,  5.0
   Default, vs        , 10.0
   Default, taus      , 10.0
   Default, th0       ,  1.0
   Default, sigma     ,  0.0
   Default, noisystart,  0.0
   Default, spikenoise  ,  0.0

   Para = { info: "PARA"         ,$
            type: '2'            ,$
            df : exp(-deltat/tauf)   ,$
            dl : exp(-deltat/taul)   ,$
            di : exp(-deltat/taui)   ,$
            tauf : FLOAT(tauf)    ,$
            taul : FLOAT(taul)    ,$
            taui : FLOAT(taui)    ,$
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
