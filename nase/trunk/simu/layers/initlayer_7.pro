;+
; NAME:                 InitLayer_7
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 7 (2 Feeding 2ZK, 1 Linking 1ZK, 2 Inihibition 2ZK, Schwelle 2ZK)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_7( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_2.pro
;
; OUTPUTS:              Layer : Struktur, die alle Informationen enthaelt, s.u.
;
; EXAMPLE:              para7      = InitPara_7(tauf1=10.0, vs=1.0)
;                       MyLayer = InitLayer_7(width=5, height=5, type=para7)
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.3  1998/11/09 10:53:38  saam
;             possible memory hole sealed up
;
;       Revision 2.2  1998/11/08 17:27:16  saam
;             the layer-structure is now a handle
;
;       Revision 2.1  1998/10/30 17:43:47  niederha
;        	initlayer_7.pro
;               inputlayer_7.pro
;               proceedlayer_7.pro
;
;-

FUNCTION InitLayer_7, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Random_Seed, seed

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER'              ,$
             Type   : '7'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F1     : type.ns*Double(RandomU(seed,width*height)) ,$
             F2     : type.ns*Double(RandomU(seed,width*height)) ,$
             L      : type.ns*Double(RandomU(seed,width*height)) ,$
             I1      : type.ns*Double(RandomU(seed,width*height)) ,$
             I2      : type.ns*Double(RandomU(seed,width*height)) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             R      : DblArr(width*height) ,$
             O      : handle  }

   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 




