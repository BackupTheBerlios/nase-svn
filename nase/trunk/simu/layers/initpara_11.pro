;+
; NAME:
;  InitPara_11()
;
; AIM:
;  Define parameter values for layer of Inhibitory Linking Neurons.
;
; PURPOSE:              initialisiert Parameterstruktur Para11, die
;                       Neuronenparameter fuer Neuronentyp 11 enthaelt
;
; CATEGORY:             SIMULATION /LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_11( [TAUF=tauf] [, TAUL=taul] $
;                                           [, TAUI=taui] [, VS=vs] [, TAUS=taus] $
;                                           [, TH0=th0] [SIGMA=sigma] [NOISYSTART=noisystart] $
;                                           [,SPIKENOISE=spikenoise] )
;
; KEYWORD PARAMETERS:   tauf       : Feeding-Zeitkonstante
;                       taul1      : Linking-Zeitkonstante
;                       taul2      : inhibitorische Linking-Zeitkonstante
;                       taui       : Inihibition-Zeitkonstante
;                       vaus       : Schwellen-Verstaerkung
;                       taus       : Schwellen-Zeitkonstante
;                       th0        : Schwellen-Offset
;                       sigma      : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       noisystart : alle Input-Potential (F,L1,L2,I) werden mit gleichverteilten Zufalls-
;                                    zahlen belegt. Der Wert von noisystart wird in Einheiten der Ruheschwelle
;                                    th0 angegeben.
;                       spikenoise : mean spontanous activity in Hz 
;                       sampleperiod ::   die Dauer eines Simulationszeitschritts, Default: 0.001s
;
; OUTPUTS:              Para : Struktur namens Para1, die alle Neuronen-Informationen enthaelt, s.u.
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; EXAMPLE:              para11 = InitPara_11(tauf=10.0, vs=1.0)
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.4  2005/04/04 12:02:17  michler
;
;        Modified Files:
;        	initpara_6.pro initpara_11.pro initpara_12.pro
;
;        spell corrections in sampleperiod keyword
;
;        Revision 2.3  2004/09/27 14:03:32  michler
;
;        Modified Files:
;         	initpara_1.pro initpara_2.pro initpara_4.pro initpara_6.pro
;         	initpara_7.pro initpara_11.pro initpara_12.pro initpara_14.pro
;
;        adapting time constants to temporal resolution,
;        using parameter SAMPLEPERIOD as in initrecall.pro
;
;        Revision 2.2  2000/09/28 13:05:26  thiel
;            Added types '9' and 'lif', also added AIMs.
;
;        Revision 2.1  2000/06/06 15:02:32  alshaikh
;              new layertype 11
;
;-


FUNCTION InitPara_11, TAUF=tauf, TAUL1=taul1, TAUL2=taul2, TAUI=taui, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise, SAMPLEPERIOD=sampleperiod

   Default, SAMPLEPERIOD, 0.001
   deltat = SAMPLEPERIOD*1000.


   Default, tauf      , 10.0
   Default, taul1     , 10.0
   Default, taul2     , 10.0	
   Default, taui      , 10.0
   Default, vs        , 10.0
   Default, taus      , 10.0
   Default, th0       ,  1.0
   Default, sigma     ,  0.0
   Default, noisystart,  0.0
   Default, spikenoise  ,  0.0

   Para = { info : 'PARA'         ,$
	    type : '11'            ,$
            df   : exp(-deltat/tauf)  ,$
            dl1  : exp(-deltat/taul1) ,$
            dl2  : exp(-deltat/taul2) ,$	
            di   : exp(-deltat/taui)  ,$
            tauf : FLOAT(tauf)    ,$
            taul1: FLOAT(taul1)   ,$
 	    taul2: FLOAT(taul2)   ,$
            taui : FLOAT(taui)    ,$
            vs   : vs             ,$
            ds   : exp(-deltat/taus)  ,$
            taus : FLOAT(taus)    ,$
            th0  : th0            ,$
            sigma: sigma          ,$
            sn   : deltat*spikenoise/1000.,$
            ns   : noisystart*th0 }

   RETURN, Para

END 
