;+
; NAME:
;  InitLayer_11()
;
; AIM:
;  Initialize layer of Inhibitory Linking Neurons.
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 11 
;                           (1 Feeding 1ZK, 2 Linking 2ZK, 1 Inihibition 1ZK, Schwelle 1ZK)
;
;                       das ganze unterscheidet sich von typ1
;                       lediglich durch eine inhibitorische
;                       linkingsynapse...
;                       das linkingpotentials berechnet sich
;                       folgendermassen :
;
;                       L = max (( NORMALES_LINKING - INHIBITORISCHES_LINKING),0)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_11( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_11.pro
;
; OUTPUTS:              Layer : Struktur namens Layer, die folgende Tags enthaelt:
;
;                                Layer = { info   : 'LAYER'
;                                          Type   : '11'    
;                                          w      : width
;                                          h      : height
;                                          para   : type
;                                          decr   : 1      ;decides if potentials are to be decremented or not
;                                          F      : DblArr(width*height) 
;                                          L1     : DblArr(width*height) 
;                                          L2     : DblArr(width*height) 
;                                          I      : DblArr(width*height)
;                                          M      : DblArr(width*height)
;                                          S      : DblArr(width*height)
;                                          O      : handle}
;
; EXAMPLE:              para1 = InitPara_11(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_11(height=5, width=5, type=para1)
;
; MODIFICATION HISTORY: 
;
;        $Log$
;        Revision 2.3  2000/09/28 13:05:26  thiel
;            Added types '9' and 'lif', also added AIMs.
;
;        Revision 2.2  2000/09/27 15:59:40  saam
;        service commit fixing several doc header violations
;
;        Revision 2.1  2000/06/06 15:02:31  alshaikh
;              new layertype 11
;
;-

FUNCTION InitLayer_11, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Common_Random, seed


   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'


   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '11'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F      : type.ns*Double(RandomU(seed,width*height)) ,$
             L1     : type.ns*Double(RandomU(seed,width*height)) ,$
             L2     : type.ns*Double(RandomU(seed,width*height)) ,$
             I      : type.ns*Double(RandomU(seed,width*height)) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             O      : handle}

   
   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 
