;+
; NAME:
;  InitPara_GRN()
;
; VERSION:
;  $Id$
;
; AIM:
;  Define parameter values for layer of Graded Response Neurons.
;
; PURPOSE:
;  <C>InitPara_GRN()</C> is used to set the parameter values for a
;  layer of graded response neurons.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
;*result = FunctionName( par [,optpar] [,/SWITCH] [,KEYWORD=...] )
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>InitLayer_GRN()</A>, <A>InputLayer_GRN()</A>.
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document



; PURPOSE:              initialisiert Parameterstruktur Para1, die Neuronenparameter fuer Neuronentyp 1 enthaelt
;
; CATEGORY:             SIMULATION /LAYERS
;
; CALLING SEQUENCE:     Para = InitPara_1( [TAUF=tauf] [, TAUL=taul] [, TAUI=taui] [, VS=vs] [, TAUS=taus] $
;                       [, TH0=th0] [SIGMA=sigma] [NOISYSTART=noisystart] [,SPIKENOISE=spikenoise] )
;
; KEYWORD PARAMETERS:   tauf       : Feeding-Zeitkonstante
;                       taul       : Linking-Zeitkonstante
;                       taui       : Inihibition-Zeitkonstante
;                       th0        : Schwelle
;                       sigma      : Standard-Abweichung des normalverteilten Rauschens des Membranpotentials
;                       noisystart : alle Input-Potential (F,L,I) werden mit gleichverteilten Zufalls-
;                                    zahlen belegt. Der Wert von noisystart wird in Einheiten der Ruheschwelle
;                                    th0 angegeben.
;                       spikenoise : mean spontanous activity in Hz 
;
; OUTPUTS:              Para : Struktur namens Para1, die alle Neuronen-Informationen enthaelt, s.u.
;
; RESTRICTIONS:         tau? muss > 0.0 sein
;
; EXAMPLE:              para1 = InitPara_1(tauf=10.0, vs=1.0)
;




FUNCTION InitPara_GRN, transfunc, TAUF=tauf, TAUL=taul $
                       , SIGMA=sigma, NOISYSTART=noisystart

   Default, tauf, 10.0
   Default, taul, 10.0
   Default, sigma, 0.0
   Default, noisystart, 0.0

   IF NOT Set(transfunc) THEN Console, /FATAL, 'Missing transfer function.'

   IF tauf EQ 0.0 THEN df = 0.0 ELSE df = Exp(-1.0/tauf)
   IF taul EQ 0.0 THEN dl = 0.0 ELSE dl = Exp(-1.0/taul)

   Para = { info: 'PARA', $
	    type: 'GRN', $
            transfunc: transfunc, $
            df: df, $
            dl: dl, $
            tauf: Float(tauf), $
            taul: Float(taul), $
            sigma: sigma, $
            ns: noisystart }

   Return, Para

END 
