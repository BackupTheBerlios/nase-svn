;+
; NAME:                 InitLayer_1
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 1 
;                           (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 1ZK)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_1( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_1.pro
;
; OUTPUTS:              Layer : Struktur namens Layer, die folgende Tags enthaelt:
;
;                                Layer = { info   : 'LAYER'
;                                          Type   : '1'    
;                                          w      : width
;                                          h      : height
;                                          para   : type
;                                          decr   : 1      ;decides if potentials are to be decremented or not
;                                          F      : DblArr(width*height) 
;                                          L      : DblArr(width*height) 
;                                          I      : DblArr(width*height)
;                                          M      : DblArr(width*height)
;                                          S      : DblArr(width*height)
;                                          O      : handle}
;
; EXAMPLE:              para1 = InitPara_1(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_1(height=5, width=5, type=para1)
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.9  1998/11/09 10:53:35  saam
;             possible memory hole sealed up
;
;       Revision 1.8  1998/11/08 17:27:13  saam
;             the layer-structure is now a handle
;
;       Revision 1.7  1998/01/14 20:21:42  saam
;             Die Potentiale koennen nun zufaellig
;             vorbelegt werden
;
;       Revision 1.6  1997/10/27 11:16:51  thiel
;             Dokumentations-Header wurde ergaenzt,
;             enthaelt jetzt auch die Tags.
;
;
;-

FUNCTION InitLayer_1, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Common_Random, seed


   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'


   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '1'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F      : type.ns*Double(RandomU(seed,width*height)) ,$
             L      : type.ns*Double(RandomU(seed,width*height)) ,$
             I      : type.ns*Double(RandomU(seed,width*height)) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             O      : handle}

   
   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 
