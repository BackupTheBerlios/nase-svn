;+
; NAME:                 InitLayer_6
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 6 (1 Feeding 2ZK, 1 Linking 2ZK, 1 Inihibition 1ZK, Schwelle 2ZK)
;                       dieser Type unterschiedet sich vom Type durch beliebige Erhoehung der Zeitaufloesung.
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_6( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_6.pro
;
; OUTPUTS:              Layer : Struktur, die alle Informationen enthaelt, s.u.
;
; EXAMPLE:              para6      = InitPara_6(tauf=10.0, vs=1.0, OVERSAMPLING=10)
;                       MyLayer = InitLayer_6(width=5, height=5, type=para2)
;
; MODIFICATION HISTORY: 
;
;      $Log$
;      Revision 2.1  1998/08/23 12:19:18  saam
;            is there anything to say?
;
;
;-
FUNCTION InitLayer_6, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Random_Seed, seed

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   handle = Handle_Create(VALUE=[0, width*height])

   Layer = { info   : 'LAYER'              ,$
             Type   : '6'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F1     : Double(RandomU(seed,width*height)) ,$
             F2     : Double(RandomU(seed,width*height)) ,$
             L1     : Double(RandomU(seed,width*height)) ,$
             L2     : Double(RandomU(seed,width*height)) ,$
             I      : Double(RandomU(seed,width*height)) ,$
             M      : DblArr(width*height) ,$
             S      : type.ns*Double(1+RandomU(seed,width*height)) ,$
             R      : type.ns*Double(1+RandomU(seed,width*height)) ,$
             O      : handle               ,$
             AR     : Byte(250*RANDOMU(seed,width*height))  }  ; for the absolute refractory period

   RETURN, Layer

END 
