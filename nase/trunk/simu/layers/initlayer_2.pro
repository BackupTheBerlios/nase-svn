;+
; NAME:                 InitLayer_2
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 2 (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 2ZK)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_2( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_2.pro
;
; OUTPUTS:              Layer : Struktur, die alle Informationen enthaelt, s.u.
;
; EXAMPLE:              para2      = InitPara_2(tauf=10.0, vs=1.0)
;                       MyLayer = InitLayer_2(width=5, height=5, type=para2)
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.8  1998/11/09 10:53:36  saam
;             possible memory hole sealed up
;
;       Revision 1.7  1998/11/08 17:27:14  saam
;             the layer-structure is now a handle
;
;       Revision 1.6  1998/01/21 21:44:10  saam
;             korrekte Behandlung der DGL durch Keyword CORRECT
;             in InputLayer_?
;
;       Revision 1.5  1997/10/14 16:31:39  kupper
;              Schöpfung, durch Übernahme von initlayer_1
;
;
;                       initial version, Mirko Saam, 22.7.97
;                       Alternative Keyword-Parameter zugefügt, Rüdiger Kupper, 24.7.97
;                       verbindliche Keyword-Parameter, Mirko Saam, 25.7.97
;                       Strukturnamen entfernt, Rüdiger Kupper, 30.7.97
;                       Dafür String-Tag Typ eingeführt, Rüdiger Kupper, 30.7.97
;                       info-Tag zugefügt, Rüdiger, 4.9.1997
;-

FUNCTION InitLayer_2, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Random_Seed, seed

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER'              ,$
             Type   : '2'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F      : type.ns*Double(RandomU(seed,width*height)) ,$
             L      : type.ns*Double(RandomU(seed,width*height)) ,$
             I      : type.ns*Double(RandomU(seed,width*height)) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             R      : DblArr(width*height) ,$
             O      : handle  }

   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 
