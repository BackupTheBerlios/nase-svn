;+
; NAME:
;  InitLayer_GRN()
;
; VERSION:
;  $Id$
;
; AIM:
;  Initialize layer of Graded Response Neurons.
;
; PURPOSE:
;  <C>InitLayer_GRN()</C> can be used to initialize a layer of graded
;  response neurons.
;
; CATEGORY:
;  Layers
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
;*result = FunctionName( par [,optpar] [,/SWITCH] [,KEYWORD=...] )
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  
;
; OPTIONAL OUTPUTS:
;  
;
; COMMON BLOCKS:
;  
;
; SIDE EFFECTS:
;  
;
; RESTRICTIONS:
;  
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>InputLayer_GRN</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


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
;
;



FUNCTION InitLayer_GRN, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Common_Random, seed

   IF (NOT Keyword_Set(width)) THEN Console, /FATAL, 'Keyword WIDTH expected.'
   IF (NOT Keyword_Set(height)) THEN $
    Console, /FATAL, 'Keyword HEIGHT expected.'
   IF (NOT Keyword_Set(type)) THEN Console, /FATAL, 'Keyword TYPE expected.'


   handle = Handle_Create(!MH, VALUE=[0, width*height])

   layer = {info: 'LAYER', $
            type: 'GRN', $
            w: width, $
            h: height, $
            para: type, $
            decr: 1, $ ; decides if potentials are to be decremented or not
            f: type.ns*Float(RandomU(seed,width*height)), $
            l: type.ns*Float(RandomU(seed,width*height)), $
            m: FltArr(width*height), $
            o: handle}

   
   Return, Handle_Create(!MH, VALUE=layer, /NO_COPY)

END 
