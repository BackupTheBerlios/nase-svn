;+
; NAME: InitLayer_10
;
; PURPOSE: Initialisiert eine Neuronenschicht vom Typ 10 (Poissonneuron) 
;
; CATEGORY: SIMULATION /LAYERS
;
; CALLING SEQUENCE: Layer = InitLayer_10 (PROBABILITY=probability, TYPE=type)
;
; INPUTS: probability : Ein Array, das für jedes Neuron die Feuer-
;                        wahrscheinlichkeit während eines Zeitschritts angibt. 
;                        Die Ausmaße der Layer werden über die Dimension 
;                        dieses Arrays festgelegt. Die Feuerwahrscheinlich-
;                        keit kann zusätzlcih durch Feeding-Input beeinflußt
;                        werden (siehe) <A HREF="#INPUTLAYER_10">Inputlayer_10</A>. Dabei
;                        bleibt die Kontrolle über die Gesamtwahrscheinlichkeit
;                        und die Gewichtung der einzelnen Beiträge dem
;                        Benutzer überlassen. Default: [0.5]
;         type : Struktur, die neuronenspezifische Parameter enthält; 
;                definiert in <A HREF="#INITPARA_10">InitPara_10</A>
;
; OUTPUTS:  Layer : Struktur, die folgende Tags enthaelt:
;
;                   Layer = { info   : 'LAYER'
;                             Type   : '10'    
;                             w      : width
;                             h      : height
;                             para   : type
;                             decr   : 1      ;decides if potentials are to be decremented or not
;                             F      : FltArr(width*height) 
;                             S      : probability
;                             O      : handle}
;
; EXAMPLE: para10 = InitPara_10(tauf=10.0)     
;          layer = InitLayer_10(PROBABILITY=[0.5,0.7], TYPE=para10)
;
; SEE ALSO: <A HRE <A HREF="#INPUTLAYER_10">InputLayer_10</A>,F="#INITPARA_10">InitPara_10</A>, <A HREF="#PROCEEDLAYER_10">ProceedLayer_10</A>,
;           <A HREF="../input/#POISSONINPUT">PoissonInput</A>
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.2  1999/05/07 13:26:28  thiel
;           .para-Tag vergessen.
;
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;

;
;-

FUNCTION InitLayer_10, PROBABILITY=probability, TYPE=type


   IF NOT Set(TYPE) THEN Message, 'Specify parameters!'
   Default, probability, [0.5]

   width = (Size(probability))(1)
   IF (Size(probability))(0) EQ 1 THEN height = 1 $
   ELSE height = (Size(probability))(2)

   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '10', $
             w      : width, $
             h      : height, $
             para   : type, $
             decr   : 1, $
             F      : FltArr(width*height), $
             S      : probability, $
             O      : handle}

   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 
