;+
; NAME: InitLayer_10
;
; PURPOSE: Initialisiert eine Neuronenschicht vom Typ 10 (Poissonneuron) 
;
; CATEGORY: SIMULATION /LAYERS
;
; CALLING SEQUENCE: Layer = InitLayer_10 (PROBABILITY=probability, TYPE=type)
;
; INPUTS: probability : Ein Array, das f�r jedes Neuron die Feuer-
;                        wahrscheinlichkeit w�hrend eines Zeitschritts angibt. 
;                        Die Ausma�e der Layer werden �ber die Dimension 
;                        dieses Arrays festgelegt. Die Feuerwahrscheinlich-
;                        keit kann zus�tzlcih durch Feeding-Input beeinflu�t
;                        werden (siehe) <A>Inputlayer_10</A>. Dabei
;                        bleibt die Kontrolle �ber die Gesamtwahrscheinlichkeit
;                        und die Gewichtung der einzelnen Beitr�ge dem
;                        Benutzer �berlassen. Default: [0.5]
;         type : Struktur, die neuronenspezifische Parameter enth�lt; 
;                definiert in <A>InitPara_10</A>
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
; SEE ALSO: <A>InputLayer_10</A>, <A>InitPara_10</A>, <A>ProceedLayer_10</A>,
;           <A>PoissonInput</A>.
;
;-
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.4  2000/09/27 15:59:40  saam
;       service commit fixing several doc header violations
;
;       Revision 1.3  1999/07/28 14:59:21  thiel
;           Header updates.
;
;       Revision 1.2  1999/05/07 13:26:28  thiel
;           .para-Tag vergessen.
;
;       Revision 1.1  1999/05/07 12:43:21  thiel
;              Neu. Neu. Neu.
;

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
