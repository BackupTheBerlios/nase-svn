;+
; NAME:                 InitPara_2
;
; PURPOSE:              initialisiert Parameterstruktur Para1, die Neuronenparameter fuer Neuronentyp 2 enthaelt
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VR=vr] [, TAUR=taur] [, VS=vs] [, TAUS=taus] [, TH0=th0] [, SIGMA=sigma] )
;
; INPUTS:               ---
;
; OPTIONAL INPUTS:      ---
;
; KEYWORD PARAMETERS:   tauf : Feeding-Zeitkonstante
;                       taul : Linking-Zeitkonstante
;                       taui : Inihibition-Zeitkonstante
;                       vaur : Schwellen-Verstaerkung2
;                       taur : Schwellen-Zeitkonstante2
;                       vaus : Schwellen-Verstaerkung1
;                       taus : Schwellen-Zeitkonstante1
;                       th0  : Schwellen-Offset
;                       sigma : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;
; OUTPUTS:              Para : Struktur namens Para2, die alle Neuronen-Informationen enthaelt, s.u.
;
; OPTIONAL OUTPUTS:     ---
;
; COMMON BLOCKS:        ---
;
; SIDE EFFECTS:         ---
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; PROCEDURE:            ???
;
; EXAMPLE:              para2 = InitPara_2(tauf=10.0, vs=1.0)
;
; MODIFICATION HISTORY: initial version, Mirko Saam, 22.7.97
;
;-
FUNCTION InitPara_2, TAUF=tauf, TAUL=taul, TAUI=taui, VR=vr, TAUR=taur, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma


   Default, tauf, 10.0
   Default, taul, 10.0
   Default, taui, 10.0
   Default, vr  ,  5.0
   Default, taur,  5.0
   Default, vs  , 10.0
   Default, taus, 10.0
   Default, th0 ,  1.0
   Default, sigma,  0.0

   Para = { Para2               ,$
            df : exp(-1./tauf)  ,$
            dl : exp(-1./taul)  ,$
            di : exp(-1./taui)  ,$
            vr : vr             ,$
            dr : exp(-1./taur)  ,$
            vs : vs             ,$
            ds : exp(-1./taus)  ,$
            th0: th0            ,$
            sigma: sigma        }

   RETURN, Para

END 
