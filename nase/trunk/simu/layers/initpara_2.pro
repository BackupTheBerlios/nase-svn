;+
; NAME:                 InitPara_2
;
; PURPOSE:              initialisiert Parameterstruktur Para1, die Neuronenparameter fuer Neuronentyp 2 enthaelt
;                            (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 2 additive ZK 1.Ordnung)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VR=vr] [, TAUR=taur] $
;                                          [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] [NOISYSTART=noisystart] )
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
;       Revision 1.3  1998/02/18 15:46:39  kupper
;              Strukturen sind jetzt wie alle NASE-Strukturen unbenannt und haben den info-Tag.
;
;   ------------------------------------------------------------------------------------
;       initial version, Mirko Saam, 22.7.97
;
;-
FUNCTION InitPara_2, TAUF=tauf, TAUL=taul, TAUI=taui, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart


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

   Para = { info: "PARA2"         ,$
            df : exp(-1./tauf)   ,$
            dl : exp(-1./taul)   ,$
            di : exp(-1./taui)   ,$
            tauf : FLOAT(tauf)    ,$
            taul : FLOAT(taul)    ,$
            taui : FLOAT(taui)    ,$
            vr : vr              ,$
            dr : exp(-1./taur)   ,$
            vs : vs              ,$
            ds : exp(-1./taus)   ,$
            taus : FLOAT(taus)    ,$
            taur : FLOAT(taur)    ,$
            th0: th0             ,$
            sigma: sigma         ,$
            ns   : noisystart*th0}

   RETURN, Para

END 
