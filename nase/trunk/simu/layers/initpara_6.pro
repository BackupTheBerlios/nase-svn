;+
; NAME:
;  InitPara_6()
;
; AIM:
;  Define parameter values for layer of Second Order EPSP Neurons.
;
; PURPOSE:              initialisiert Parameterstruktur Para4, die Neuronenparameter fuer Neuronentyp 4 enthaelt
;                            (1 Feeding 2ZK, 1 Linking 2ZK, 1 Inihibition 1ZK, Schwelle 2 additive ZK 1.Ordnung,
;                             erhoehte Zeitaufloesung, waehlbare absolute Refraktaerzeit)
;
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_6( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VR=vr] [, TAUR=taur] $
;                                          [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] [NOISYSTART=noisystart] $
;                                          [OVERSAMPLING=oversampling] [,REFPERIOD=refperiod] [,SPIKENOISE=spikenoise] [,FADE=fade])
;
; KEYWORD PARAMETERS:   tauf        : [tauf1, tauf2]; Feeding-Zeitkonstanten, Default:0.2,10
;                       taul        : [taul1, taul2]; Linking-Zeitkonstante , Default:0.2,10
;                       taui        : Inihibition-Zeitkonstante             , Default:10
;                       vaur        : Schwellen-Verstaerkung2
;                       taur        : Schwellen-Zeitkonstante2
;                       vaus        : Schwellen-Verstaerkung1
;                       taus        : Schwellen-Zeitkonstante1
;                       th0         : Schwellen-Offset
;                       sigma       : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       oversampling: 1ms wird jetzt OVERSAMPLING-fach abgetastet
;                       refperiod   : die absolute Refraktaerzeit in ms (inclusive der AP-Generierung von einem BIN)
;                       noisystart  : alle Input-Potential sowie die Schwellen (F,L,I,S,R) werden mit gleichverteilten Zufalls-
;                                     zahlen belegt. Der Wert von noisystart wird in Einheiten der Ruheschwelle
;                                     th0 angegeben.
;                       spikenoise  : mean spontanous activity in Hz (R.E. does not like this variant!! dunno why)
;                       fade        : um Anschalteffekte zu verringern generiert jedes Neuron Aktionspotentiale erst 
;                                     ab einem zufaelligen, individuellen Zeitpunkt im Bereich [0,fade], Default ist 250/OVERSAMPLING
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
;      $Log$
;      Revision 2.5  2004/09/27 14:03:32  michler
;
;      Modified Files:
;       	initpara_1.pro initpara_2.pro initpara_4.pro initpara_6.pro
;       	initpara_7.pro initpara_11.pro initpara_12.pro initpara_14.pro
;
;      adapting time constants to temporal resolution,
;      using parameter SAMPLEPERIOD as in initrecall.pro
;
;      Revision 2.4  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 2.3  1998/11/04 16:26:54  thiel
;             Struktur enthaelt jetzt info='PARA'
;             und type='Neuronentyp' getrennt.
;
;      Revision 2.2  1998/08/23 12:36:28  saam
;            new Keyword FADE
;
;      Revision 2.1  1998/08/23 12:19:18  saam
;            is there anything to say?
;
;      Revision 2.3  1998/06/01 15:10:47  saam
;            spontanous activity with keyword spikenoise implemented
;
;      Revision 2.2  1998/02/18 15:46:39  kupper
;             Strukturen sind jetzt wie alle NASE-Strukturen unbenannt und haben den info-Tag.
;
;      Revision 2.1  1998/02/05 13:47:33  saam
;            Cool
;
;
;-
FUNCTION InitPara_6, TAUF=tauf, TAUL=taul, TAUI=taui, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, $
                 NOISYSTART=noisystart, Oversampling=oversampling, REFPERIOD=RefPeriod, SPIKENOISE=spikenoise, FADE=fade, SAPLEPERIOD=sampleperiod

   Default, SAMPLEPERIOD, 0.001
   deltat = SAMPLEPERIOD*1000.

   Default, OverSampling, round(1./deltat)

   Default, tauf        , [0.2,10.0]
   Default, taul        , [0.2,10.0]
   Default, taui        , 10.0
   Default, vr          ,  5.0
   Default, taur        ,  5.0
   Default, vs          , 10.0
   Default, taus        , 10.0
   Default, th0         ,  1.0
   Default, sigma       ,  0.0
   Default, noisystart  ,  0.0
   Default, spikenoise  ,  0.0
   Default, oversampling,    1
   oversampling = ROUND(oversampling)
   Default, deltat      ,    1./ROUND(oversampling)
   Default, refPeriod   ,    1.
   Default, fade        ,  250
   DeltaT = Double(DeltaT)

   ; this is the correction factor to norm the maximal amplitude of 
   ; EPSP to 1 (or wij respectively)
   corrAmpF = 1./(exp(-alog(tauf(1)/tauf(0))*tauf(0)/(tauf(1)-tauf(0)))-exp(-alog(tauf(1)/tauf(0))*tauf(1)/(tauf(1)-tauf(0))))
   corrAmpL = 1./(exp(-alog(taul(1)/taul(0))*taul(0)/(taul(1)-taul(0)))-exp(-alog(taul(1)/taul(0))*taul(1)/(tauf(1)-taul(0))))

   Para = { info : "PARA"            ,$
	    type : '6'               ,$		
            df   : exp(-deltat/tauf) ,$
            dl   : exp(-deltat/taul) ,$
            di   : exp(-deltat/taui) ,$
            dr   : exp(-deltat/taur) ,$
            ds   : exp(-deltat/taus) ,$
            taur : FLOAT(taur)       ,$
            tauf : FLOAT(tauf)       ,$
            taul : FLOAT(taul)       ,$
            taui : FLOAT(taui)       ,$
            taus : FLOAT(taus)       ,$
            corrAmpF: corrAmpF       ,$
            corrAmpL: corrAmpL       ,$
            vr   : vr,$;*(1.-exp(-deltat/taur)),$
            vs   : vs,$;*(1.-exp(-deltat/taus)),$
            th0  : th0               ,$
            sigma: sigma             ,$
            ns   : noisystart*th0    ,$
            sn   : spikenoise/(1000.*FLOAT(oversampling)),$
            dt   : deltat            ,$
            fade : fade              ,$
            rp   : FIX(refPeriod*oversampling)}

   RETURN, Para

END 
