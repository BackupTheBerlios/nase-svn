;+
; NAME:                 InitLayer_1
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
; MODIFICATION HISTORY: 
;
;       Thu Sep 11 18:23:02 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;       Version: 1.4.2.4
;
;              O-Tag   : ist jetzt ein Handle auf ein SSparse-Array		
;              decr-Tag: legt fest, ob Potentiale im aktuellen Zeitschritt noch dekrementiert werden muessen
;                         oder nicht
;              
;
;       Wed Jul 30 15:14:07 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;               Strukturnamen "Layer_1" entfernt, da Srukturen für unterschiedliche Layer unterschiedliche Feldgrößen brauchen.		
;
;       Wed Jul 30 15:57:54 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Statt des Strukturnamens enthält die Struktur jetzt
;		ein Stringfeld mit der Neuronentypnummer ('1').
;
;                       info-Tag zugefügt, Rüdiger, 4.9.1997
;
;       initial version, Mirko Saam, 22.7.97
;
;       alternative Keyword-Parameter zugefügt,
;       Rüdiger Kupper, 24.7.97 verbindliche
;       Keyword-Parameter, Mirko Saam, 25.7.97
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
