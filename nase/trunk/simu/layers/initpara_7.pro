;+
; NAME:
;  InitPara_7()
;
; AIM:
;  Define parameter values for layer of Two Feeding Inhibition Neurons.
;
; PURPOSE:              initialisiert Parameterstruktur Para7, die Neuronenparameter fuer Neuronentyp 7 enthaelt
;                            (2 Feeding 2ZK, 1 Linking 1ZK, 2 Inihibition 2ZK, Schwelle 2 additive ZK 1.Ordnung)
;
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_7( [TAUF1=tauf1] [, TAUF2=tauf2] [, TAUL=taul] [, TAUI1=taui1] [, TAUI2=taui2] [, VR=vr] [, TAUR=taur] $
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
; OUTPUTS:              Para : Struktur namens Para7, die alle Neuronen-Informationen enthaelt, s.u.
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; EXAMPLE:              para7 = InitPara_7(tauf1=10.0, vs=1.0)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.5  2005/04/04 11:56:25  michler
;
;       Spelling correction in sampleperiod keyword
;
;       Revision 2.4  2004/09/27 14:03:32  michler
;
;       Modified Files:
;        	initpara_1.pro initpara_2.pro initpara_4.pro initpara_6.pro
;        	initpara_7.pro initpara_11.pro initpara_12.pro initpara_14.pro
;
;       adapting time constants to temporal resolution,
;       using parameter SAMPLEPERIOD as in initrecall.pro
;
;       Revision 2.3  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 2.2  1998/11/04 16:26:55  thiel
;              Struktur enthaelt jetzt info='PARA'
;              und type='Neuronentyp' getrennt.
;
;       Revision 2.1  1998/10/30 17:41:58  niederha
;        	initpara_7.pro
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
FUNCTION InitPara_7, TAUF1=tauf1, TAUF2=tauf2, TAUL=taul, TAUI1=taui1, TAUI2=taui2, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise, SAMPLEPERIOD=sampleperiod

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
	    type: '7'             ,$		
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




