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

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   handle = Handle_Create(VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '2'                  , $
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F      : DblArr(width*height) ,$
             L      : DblArr(width*height) ,$
             I      : DblArr(width*height) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             R      : DblArr(width*height) ,$
             O      : handle  }

   RETURN, Layer

END 
