;+
; NAME:
;  InitLayer_6()
;
; AIM:
;  Initialize layer of Second Order EPSP Neurons.
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
;      Revision 2.6  2000/09/28 13:05:26  thiel
;          Added types '9' and 'lif', also added AIMs.
;
;      Revision 2.5  1999/12/02 18:11:55  saam
;            new "SYNPASE" DIRECT
;
;      Revision 2.4  1998/11/09 10:53:38  saam
;            possible memory hole sealed up
;
;      Revision 2.3  1998/11/08 17:27:16  saam
;            the layer-structure is now a handle
;
;      Revision 2.2  1998/08/23 12:36:27  saam
;            new Keyword FADE
;
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

   handle = Handle_Create(!MH, VALUE=[0, width*height])

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
             DM     : DblArr(width*height) ,$
             M      : DblArr(width*height) ,$
             S      : type.ns*Double(1+RandomU(seed,width*height)) ,$
             R      : type.ns*Double(1+RandomU(seed,width*height)) ,$
             O      : handle               ,$
             AR     : Byte(type.fade*RANDOMU(seed,width*height))  }  ; for the absolute refractory period

   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 
