;+
; NAME:
;  InitLayer_3() - OBSOLETE!
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 3
;                       (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 1ZK, Lernpotential)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_3( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_3.pro
;
; OUTPUTS:              Layer : Struktur namens Layer3, die alle Informationen enthaelt, s.u.
;
; EXAMPLE:              para3 = InitPara_3(tauf=10.0, vs=1.0, taup=30.0)     
;                       Layer = InitLayer_3(height=5, width=5, type=para3)
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.7  2000/09/28 13:05:26  thiel
;           Added types '9' and 'lif', also added AIMs.
;
;       Revision 1.6  1998/11/08 15:53:17  saam
;             neuron type disabled cause it out of date, use type 1
;             with a Recall-Structure instead
;
;
;                       initial version, Mirko Saam, 22.7.97
;                       alternative Keyword-Parameter zugefügt, Rüdiger Kupper, 24.7.97
;                       verbindliche Keyword-Parameter, Mirko Saam, 25.7.97
;                       Ergaenzung um Lernpotential-Parameter,Andreas, 29. Juli 97
;                       Strukturnamen entfernt, Rüdiger Kupper, 30.7.97
;                       Dafür Typ-Tag eingeführt, 30.7.97
;                       info-Tag zugefügt, Rüdiger, 4.9.1997
;
;-
FUNCTION InitLayer_3, WIDTH=width, HEIGHT=height, TYPE=type

   Message, "NeuronType3 is not needed any more"

;   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
;   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
;   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

;   Layer = { info   : 'LAYER', $
;             Type   : '3'                  ,$ 
;             w      : width                ,$
;             h      : height               ,$
;             para   : type                 ,$
;             F      : DblArr(width*height) ,$
;             L      : DblArr(width*height) ,$
;             I      : DblArr(width*height) ,$
;             M      : DblArr(width*height) ,$
;             S      : DblArr(width*height) ,$
;             P      : DblArr(width*height) ,$
;             O      : BytArr(width*height)  }

;   RETURN, Layer

END 
