;+
; NAME:                 InitPara_7
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
FUNCTION InitPara_7, TAUF1=tauf1, TAUF2=tauf2, TAUL=taul, TAUI1=taui1, TAUI2=taui2, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise


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
            df1 : exp(-1./tauf1)   ,$
            df2 : exp(-1./tauf2)   ,$
            dl : exp(-1./taul)   ,$
            di1 : exp(-1./taui1)   ,$
            di2 : exp(-1./taui2)   ,$
            tauf1 : FLOAT(tauf1)    ,$
            tauf2 : FLOAT(tauf2)    ,$
            taul : FLOAT(taul)    ,$
            taui1 : FLOAT(taui1)    ,$
            taui2 : FLOAT(taui2)    ,$
            vr : vr              ,$
            dr : exp(-1./taur)   ,$
            vs : vs              ,$
            ds : exp(-1./taus)   ,$
            taus : FLOAT(taus)    ,$
            taur : FLOAT(taur)    ,$
            th0: th0             ,$
            sn   : spikenoise/1000.,$
            sigma: sigma         ,$
            ns   : noisystart*th0}

   RETURN, Para

END 




