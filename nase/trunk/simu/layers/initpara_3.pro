;+
; NAME:                 InitPara_3
;
; PURPOSE:              initialisiert Parameterstruktur Para3, die Neuronenparameter fuer Neuronentyp 3 enthaelt
;
; CATEGORY:             SIMULATION /LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_3( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] 
;                                          [, VS=vs] [, TAUS=taus] [,TH0=th0] 
;                                          [, VP=Vp] [,TAUP=taup]
;                                          [, SIGMA=sigma] [,SPIKENOISE=spikenoise])
;
; INPUTS:               ---
;
; OPTIONAL INPUTS:      ---
;
; KEYWORD PARAMETERS:   tauf  : Feeding-Zeitkonstante
;                       taul  : Linking-Zeitkonstante
;                       taui  : Inihibition-Zeitkonstante
;                       Vs    : Schwellen-Verstaerkung
;                       taus  : Schwellen-Zeitkonstante
;                       th0   : Schwellen-Offset
;                       Vp    : Lernpotential-Verstaerkung
;                       taup  : Lernpotential-Zeitkonstante (Lernfenster)
;                       sigma : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       spikenoise  : mean spontanous activity in Hz 
;
; OUTPUTS:              Para : Struktur namens Para3, die alle Neuronen-Informationen enthaelt, s.u.
;
; OPTIONAL OUTPUTS:     ---
;
; COMMON BLOCKS:        ---
;
; SIDE EFFECTS:         ---
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; PROCEDURE:            ---
;
; EXAMPLE:              para3 = InitPara_3(tauf=10.0, vs=1.0, taup=30.0)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.5  1998/11/04 16:26:53  thiel
;              Struktur enthaelt jetzt info='PARA'
;              und type='Neuronentyp' getrennt.
;
;       Revision 1.4  1998/06/01 15:10:46  saam
;             spontanous activity with keyword spikenoise implemented
;
;       Revision 1.3  1998/02/18 15:46:39  kupper
;              Strukturen sind jetzt wie alle NASE-Strukturen unbenannt und haben den info-Tag.
;
;             ------------------------------------------------------------------------------------
;                       initial version, Mirko Saam, 22.7.97
;                       Ergaenzung um Rauschen des Membranpotetials, Mirko Saam, 25.7.97
;                       Neue Parameter fuers Lernpotential: Vp und taup, Andreas 29. Juli 97
;-
FUNCTION InitPara_3, TAUF=tauf, TAUL=taul, TAUI=taui, VS=vs, TAUS=taus, TH0=th0, VP=Vp, TAUP=taup, SIGMA=sigma, SPIKENOISE=spikenoise

   Default, tauf , 10.0
   Default, taul , 10.0
   Default, taui , 10.0
   Default, vs   , 10.0
   Default, taus , 10.0
   Default, th0  ,  1.0
   Default, Vp   , 1.0
   Default, taup , 10.0
   Default, spikenoise  ,  0.0
   
   Default, sigma,  0.0


   Para = { info : "PARA"         ,$
	    type ; '3'            ,$
            df   : exp(-1./tauf)  ,$
            dl   : exp(-1./taul)  ,$
            di   : exp(-1./taui)  ,$
            vs   : vs             ,$
            ds   : exp(-1./taus)  ,$
            th0  : th0            ,$
            Vp   : Vp             ,$
            dp   : exp(-1./taup)  ,$
            sn   : spikenoise/1000.,$
            sigma: sigma          }

   RETURN, Para

END 
