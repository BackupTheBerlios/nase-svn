;+
; NAME:                 InitPara_5
;
; PURPOSE:              initialisiert Parameterstruktur Para5, die Neuronenparameter fuer Neuronentyp 5 enthaelt
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Para = InitPara_5( [TAUF=tauf] [, TAUL=taul] [, TAUN=taun] [, TAUI=taui] [, VS=vs] [, TAUS=taus] [, TH0=th0] [SIGMA=sigma] )
;
; INPUTS:               ---
;
; OPTIONAL INPUTS:      ---
;
; KEYWORD PARAMETERS:   tauf  : Feeding-Zeitkonstante
;                       taul  : Linking-Zeitkonstante
;                       taun  : Linking-Zeitkonstante (NMDA)
;                       taui  : Inihibition-Zeitkonstante
;                       vaus  : Schwellen-Verstaerkung
;                       taus  : Schwellen-Zeitkonstante
;                       th0   : Schwellen-Offset
;                       sigma : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;
; OUTPUTS:              Para : Struktur namens Para1, die alle Neuronen-Informationen enthaelt, s.u.
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
; EXAMPLE:              para5 = InitPara_5(tauf=10.0, vs=1.0)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.2  1998/02/18 15:46:39  kupper
;              Strukturen sind jetzt wie alle NASE-Strukturen unbenannt und haben den info-Tag.
;
;             ------------------------------------------------------------------------------------
;                       initial version, Mirko Saam, 22.7.97
;                       Ergaenzung um Rauschen des Membranpotetials, Mirko Saam, 25.7.97
;
;-
FUNCTION InitPara_5, TAUF=tauf, TAUL=taul,TAUN=taun, TAUI=taui, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma

   Default, tauf , 10.0
   Default, taul , 10.0
   Default, taun , 10.0
   Default, taui , 10.0
   Default, vs   , 10.0
   Default, taus , 10.0
   Default, th0  ,  1.0
   Default, sigma,  0.0


   Para = { info : "PARA5"         ,$
            df   : exp(-1./tauf)  ,$
            dl   : exp(-1./taul)  ,$
            dn   : exp(-1./taun)  ,$
            di   : exp(-1./taui)  ,$
            vs   : vs             ,$
            ds   : exp(-1./taus)  ,$
            th0  : th0            ,$
            sigma: sigma          }

   RETURN, Para

END 
