;+
; NAME:
;  InitLayer_14()
;
; AIM:
;  Initialize layer of Two Dendrite Neurons.
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 14 (2 Feeding 2ZK, 1 Linking 1ZK, 2 Inihibition 2ZK, Schwelle 2ZK)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_14( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_14.pro
;
; OUTPUTS:              Layer : Struktur, die alle Informationen enthaelt, s.u.
;
; EXAMPLE:              para14      = InitPara_14(tauf1=10.0, vs=1.0)
;                       MyLayer = InitLayer_14(width=5, height=5, type=para14)
;
;-

FUNCTION InitLayer_14, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Random_Seed, seed

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER'              ,$
             Type   : '14'                  ,$
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




