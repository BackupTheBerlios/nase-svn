;+
; NAME:                 InitLayer_3
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 1 (1 Feeding 1ZK, 1 Linking 1ZK, 1 Inihibition 1ZK, Schwelle 1ZK)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_1( WIDTH=width, HEIGHT=height, TYPE=type )
;
; INPUTS:               ---
;
; OPTIONAL INPUTS:      ---
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_1.pro
;
; OUTPUTS:              Layer : Struktur namens Layer1, die alle Informationen enthaelt, s.u.
;
; OPTIONAL OUTPUTS:     ---
;
; COMMON BLOCKS:        ---
;
; SIDE EFFECTS:         ---
;
; RESTRICTIONS:         ---
;
; PROCEDURE:            ---
;
; EXAMPLE:              para1 = InitPara_1(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_1(height=5, width=5, type=para1)
;
; MODIFICATION HISTORY: initial version, Mirko Saam, 22.7.97
;                       alternative Keyword-Parameter zugefügt, Rüdiger Kupper, 24.7.97
;                       verbindliche Keyword-Parameter, Mirko Saam, 25.7.97
;
;-
FUNCTION InitLayer_1, WIDTH=width, HEIGHT=height, TYPE=type

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'

   Layer = { Layer1                        ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             F      : DblArr(width*height) ,$
             L      : DblArr(width*height) ,$
             I      : DblArr(width*height) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             O      : BytArr(width*height)  }

   RETURN, Layer

END 
