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
; $Log$
; Revision 1.6  1997/10/27 11:16:51  thiel
;        Dokumentations-Header wurde ergaenzt,
;        enthaelt jetzt auch die Tags.
;
;
;-

FUNCTION InitLayer_1, WIDTH=width, HEIGHT=height, TYPE=type

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'




   handle = Handle_Create(VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '1'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F      : DblArr(width*height) ,$
             L      : DblArr(width*height) ,$
             I      : DblArr(width*height) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             O      : handle}

   
   RETURN, Layer

END 
