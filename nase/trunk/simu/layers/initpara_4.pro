;+
; NAME:
;  InitPara_4()
;
; AIM:
;  Define parameter values for layer of Oversampling Neurons.
;
; PURPOSE:              initialisiert Parameterstruktur Para4, die Neuronenparameter fuer Neuronentyp 4 enthaelt
;                            (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 2 additive ZK 1.Ordnung,
;                             erhoehte Zeitaufloesung, waehlbare absolute Refraktaerzeit)
;
; CATEGORY:             SIMULATION / LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_4( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VR=vr] [, TAUR=taur] $
;                                          [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] [NOISYSTART=noisystart] $
;                                          [OVERSAMPLING=oversampling] [,REFPERIOD=refperiod] [,SPIKENOISE=spikenoise] [,FADE=fade])
;
; KEYWORD PARAMETERS:   tauf        : Feeding-Zeitkonstanten, Default: 10
;                       taul        : Linking-Zeitkonstante , Default: 10
;                       taui        : Inihibition-Zeitkonstante, Default:10
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
;      Revision 2.6  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 2.5  1998/11/04 16:26:53  thiel
;             Struktur enthaelt jetzt info='PARA'
;             und type='Neuronentyp' getrennt.
;
;      Revision 2.4  1998/08/23 12:36:28  saam
;            new Keyword FADE
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
FUNCTION InitPara_4, TAUF=tauf, TAUL=taul, TAUI=taui, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, $
                 NOISYSTART=noisystart, Oversampling=oversampling, REFPERIOD=RefPeriod, SPIKENOISE=spikenoise, FADE=fade


   Default, tauf        , 10.0
   Default, taul        , 10.0
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

   Para = { info : "PARA"            ,$
	    type : '4'               ,$
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
