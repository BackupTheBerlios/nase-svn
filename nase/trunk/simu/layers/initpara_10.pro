;+
; NAME:
;  InitPara_10()
;
; AIM:
;  Define parameter values for layer of Poisson Neurons.
;
; PURPOSE: Initialisiert Parameterstruktur, die Neuronenparameter 
;          für Neuronentyp 10 (Poissonneuron) enthält.
;
; CATEGORY: SIMULATION / LAYERS
;
; CALLING SEQUENCE: Para = InitPara_10( [TAUF=tauf] )
;
; KEYWORD PARAMETERS:   tauf : Feeding-Zeitkonstante / BIN, 
;                              Wird tauf=0.0 gewählt, so bleibt das
;                              Feeding-Potential genau einen Zeitschritt
;                              lang bestehen. Defualt: 0.0
;
; OUTPUTS: Para : Struktur, die alle Neuronen-Informationen enthält, 
;                  im einzelnen:
;                  Para = { info : 'PARA', $
;	                    type : '10', $
;                           df   : df, $ ; entweder = Exp(-1.0/tauf) oder = 0.0
;                           tauf : FLOAT(tauf)}
;
;
; EXAMPLE: para10 = InitPara_10(tauf=10.0)
;
; SEE ALSO: <A>InitLayer_10</A>, <A>InputLayer_10</A>, <A>ProceedLayer_10</A>,
;           <A>PoissonInput</A>
;
;-
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.3  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 1.2  2000/09/27 15:59:40  saam
;       service commit fixing several doc header violations
;
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;
;
;

FUNCTION InitPara_10, TAUF=tauf

   Default, tauf, 0.0

   IF tauf EQ 0.0 THEN df = 0.0 ELSE df = Exp(-1.0/tauf)

   Para = { info : 'PARA', $
	    type : '10', $
            df   : df, $
            tauf : FLOAT(tauf) }

   RETURN, Para

END 
