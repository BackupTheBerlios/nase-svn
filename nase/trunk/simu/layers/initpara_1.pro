;+
; NAME:
;  InitPara_1()
;
; AIM:
;  define parameter values for layer of Standard Marburg Model Neurons
;
; PURPOSE: Initialises parameter-structure <*>Para1</*> containing
; neuron-parameters for neuron-type 1  
;
; CATEGORY:             SIMULATION /LAYERS
;
; CALLING SEQUENCE:    
;* Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] $
;*                    [, VS=vs] [, TAUS=taus] [, TH0=th0] $
;*                    [SIGMA=sigma] [NOISYSTART=noisystart] [,SPIKENOISE=spikenoise] )
;
; INPUT KEYWORDS:       tauf       :: Feeding-Zeitkonstante
;                       taul       :: Linking-Zeitkonstante
;                       taui       :: Inihibition-Zeitkonstante
;                       vaus       :: Schwellen-Verstaerkung
;                       taus       :: Schwellen-Zeitkonstante
;                       th0        :: Schwellen-Offset
;                       sigma      :: Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       noisystart :: alle Input-Potential (F,L,I) werden mit gleichverteilten Zufalls-
;                                    zahlen belegt. Der Wert von noisystart wird in Einheiten der Ruheschwelle
;                                    <*>th0</*> angegeben.
;                       spikenoise :: mean spontanous activity in Hz 
;
; OUTPUTS:              Para :: Struktur namens <*>Para1</*>, die alle Neuronen-Informationen enthaelt, s.u.
;
; RESTRICTIONS:         <*>tau?</*> muss > 0.0 sein
;
; EXAMPLE:              
;* para1 = InitPara_1(tauf=10.0, vs=1.0)
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.8  2004/03/16 16:09:17  zwickel
;            introduced new header layout, translated purpose
;
;       Revision 1.7  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 1.6  1998/11/04 16:26:52  thiel
;              Struktur enthaelt jetzt info='PARA'
;              und type='Neuronentyp' getrennt.
;
;       Revision 1.5  1998/06/01 15:10:46  saam
;             spontanous activity with keyword spikenoise implemented
;
;       Revision 1.4  1998/02/18 15:46:39  kupper
;              Strukturen sind jetzt wie alle NASE-Strukturen unbenannt und haben den info-Tag.
;
;       Revision 1.3  1998/01/21 21:44:08  saam
;             korrekte Behandlung der DGL durch Keyword CORRECT
;             in InputLayer_?
;
;       Revision 1.2  1998/01/14 20:21:42  saam
;             Die Potentiale koennen nun zufaellig
;             vorbelegt werden
; 
;
;                initial version, Mirko Saam, 22.7.97
;                Ergaenzung um Rauschen des Membranpotetials, Mirko Saam, 25.7.97
;
;-
FUNCTION InitPara_1, TAUF=tauf, TAUL=taul, TAUI=taui, VS=vs, TAUS=taus, TH0=th0, SIGMA=sigma, NOISYSTART=noisystart, SPIKENOISE=spikenoise

   Default, tauf      , 10.0
   Default, taul      , 10.0
   Default, taui      , 10.0
   Default, vs        , 10.0
   Default, taus      , 10.0
   Default, th0       ,  1.0
   Default, sigma     ,  0.0
   Default, noisystart,  0.0
   Default, spikenoise  ,  0.0

   Para = { info : 'PARA'         ,$
	    type : '1'            ,$
            df   : exp(-1./tauf)  ,$
            dl   : exp(-1./taul)  ,$
            di   : exp(-1./taui)  ,$
            tauf : FLOAT(tauf)    ,$
            taul : FLOAT(taul)    ,$
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
