;+
; NAME: InitPara_10
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
; SEE ALSO: <A HREF="#INITLAYER_10">InitLayer_10</A>, <A HREF="#INPUTLAYER_10">InputLayer_10</A>, A HREF="#PROCEEDLAYER_10">ProceedLayer_10</A>,
;           <A HREF="../input/#POISSONINPUT">PoissonInput</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;
;
;-

FUNCTION InitPara_10, TAUF=tauf

   Default, tauf, 0.0

   IF tauf EQ 0.0 THEN df = 0.0 ELSE df = Exp(-1.0/tauf)

   Para = { info : 'PARA', $
	    type : '10', $
            df   : df, $
            tauf : FLOAT(tauf) }

   RETURN, Para

END 
