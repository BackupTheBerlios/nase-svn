;+
; NAME:                 InitPara_4
;
; PURPOSE:              initialisiert Parameterstruktur Para4, die Neuronenparameter fuer Neuronentyp 4 enthaelt
;                            (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 2 additive ZK 1.Ordnung,
;                             erhoehte Zeitaufloesung, waehlbare absolute Refraktaerzeit)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VR=vr] [, TAUR=taur] $
;                                          [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] [NOISYSTART=noisystart] $
;                                          [OVERSAMPLING=oversampling] [,REFPERIOD=refperiod] [,SPIKENOISE=spikenoise] )
;
; KEYWORD PARAMETERS:   tauf        : Feeding-Zeitkonstante
;                       taul        : Linking-Zeitkonstante
;                       taui        : Inihibition-Zeitkonstante
;                       vaur        : Schwellen-Verstaerkung2
;                       taur        : Schwellen-Zeitkonstante2
;                       vaus        : Schwellen-Verstaerkung1
;                       taus        : Schwellen-Zeitkonstante1
;                       th0         : Schwellen-Offset
;                       sigma       : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       oversampling: 1ms wird jetzt OVERSAMPLING-fach abgetastet
;                       refperiod   : die absolute Refraktaerzeit in ms (inclusive der AP-Generierung von einem BIN)
;                       noisystart  : alle Input-Potential (F,L,I) werden mit gleichverteilten Zufalls-
;                                     zahlen belegt. Der Wert von noisystart wird in Einheiten der Ruheschwelle
;                                     th0 angegeben.
;                       spikenoise  : mean spontanous activity in Hz 
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
                 NOISYSTART=noisystart, Oversampling=oversampling, REFPERIOD=RefPeriod, SPIKENOISE=spikenoise


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
   DeltaT = Double(DeltaT)

   Para = { info : "PARA4"            ,$
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
            rp   : FIX(refPeriod*oversampling)}

   RETURN, Para

END 
