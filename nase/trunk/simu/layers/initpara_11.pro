;+
; NAME:                 InitPara_11
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
;        Revision 2.1  2000/06/06 15:02:32  alshaikh
;              new layertype 11
;
;-


FUNCTION InitPara_11, TAUF=tauf, TAUL1=taul1, TAUL2=taul2, TAUI=taui, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise

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
            df   : exp(-1./tauf)  ,$
            dl1  : exp(-1./taul1) ,$
            dl2  : exp(-1./taul2) ,$	
            di   : exp(-1./taui)  ,$
            tauf : FLOAT(tauf)    ,$
            taul1: FLOAT(taul1)   ,$
 	    taul2: FLOAT(taul2)   ,$
            taui : FLOAT(taui)    ,$
            vs   : vs             ,$
            ds   : exp(-1./taus)  ,$
            taus : FLOAT(taus)    ,$
            th0  : th0            ,$
            sigma: sigma          ,$
            sn   : spikenoise/1000.,$
            ns   : noisystart*th0 }

   RETURN, Para

END 
