;+
; NAME:                 InitLayer_4
;
; PURPOSE:              initialisiert eine Neuronenschicht vom Typ 1 
;                           (1 Feeding 1ZK oder 1 Feeding TP2 , 1 Linking 1ZK, 1 NMDA 1ZK, 1 Inihibition 1ZK, Schwelle 1ZK)
;
; CATEGORY:             SIMULATION
;
; CALLING SEQUENCE:     Layer = InitLayer_4( WIDTH=width, HEIGHT=height, TYPE=type )
;
; KEYWORD PARAMETERS:   WIDTH, HEIGHT : Breite und Hoehe des Layers
;                       TYPE          : Struktur, die neuronenspezifische Parameter enthaelt; definiert in InitPara_1.pro
;
; OUTPUTS:              Layer : Struktur namens Layer, die folgende Tags enthaelt:
;
;                                Layer = { info   : 'LAYER'
;                                          Type   : '4'    
;                                          w      : width
;                                          h      : height
;                                          para   : type
;                                          decr   : 1      ;decides if potentials are to be decremented or not
;                                          F1     : DblArr(width*height) ;Vorstufe fuer den TP 2.Ordnung
;                                          F      : DblArr(width*height) 
;                                          L      : DblArr(width*height) 
;                                          N      : DblArr(width*height) 
;                                          I      : DblArr(width*height)
;                                          M      : DblArr(width*height)
;                                          S      : DblArr(width*height)
;                                          O      : handle}
;
; EXAMPLE:              para4 = InitPara_5(tauf=10.0, vs=1.0)     
;                       Layer = InitLayer_5(height=5, width=5, type=para5)
;
; MODIFICATION HISTORY: 
;
; $Log$
; Revision 2.1  1998/02/09 15:55:49  gabriel
;       Ein neuer TYP mit NMDA- und Feeding TP 2.Ordnung-Synapsen
;
; Revision 1.6  1997/10/27 11:16:51  thiel
;        Dokumentations-Header wurde ergaenzt,
;        enthaelt jetzt auch die Tags.
;
;
;-

FUNCTION InitLayer_5, WIDTH=width, HEIGHT=height, TYPE=type

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'




   handle = Handle_Create(VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '5'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F1     : DblArr(width*height) ,$ ;vorstufe fuer den TP 2.Ordnung
             F      : DblArr(width*height) ,$
             L      : DblArr(width*height) ,$
             N      : DblArr(width*height) ,$
             I      : DblArr(width*height) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             O      : handle}

   
   RETURN, Layer

END 
