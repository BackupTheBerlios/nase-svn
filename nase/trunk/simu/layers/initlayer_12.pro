;+
; NAME:
;  InitLayer_12()
;
; VERSION:
;  $Id$
;
; AIM:
;  Initialize layer of Standard Marburg Model Neurons with additional shunting-inhibition
;
; PURPOSE:
;  Initialize layer of Standard Marburg Model Neurons with additional shunting-inhibition
;
; CATEGORY:
;  DataStructures
;  Demonstration
;  Layers
;  MIND
;  NASE
;  Simulation
;
; CALLING SEQUENCE:
;*  Layer = InitLayer_12( WIDTH=width, HEIGHT=height, TYPE=type )
;
; INPUTS:
;
; OUTPUTS:
;   initialized layer structure
;
; EXAMPLE:
;*
;* >
;
; SEE ALSO:
;   <a>InitLayer_12</a>, <a>ProceedLayer_12</a>,
;   <a>InputLayer_12</a>, <a>Layerdata</a>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

FUNCTION InitLayer_12, WIDTH=width, HEIGHT=height, TYPE=type

   COMMON Common_Random, seed

   IF (NOT Keyword_Set(width))  THEN Message, 'Keyword WIDTH expected'
   IF (NOT Keyword_Set(height)) THEN Message, 'Keyword HEIGHT expected'
   IF (NOT Keyword_Set(type))   THEN Message, 'Keyword TYPE expected'


   handle = Handle_Create(!MH, VALUE=[0, width*height])

   Layer = { info   : 'LAYER', $
             Type   : '12'                  ,$
             w      : width                ,$
             h      : height               ,$
             para   : type                 ,$
             decr   : 1                    ,$ ;decides if potentials are to be decremented or not
             F      : type.ns*Double(RandomU(seed,width*height)) ,$
             L      : type.ns*Double(RandomU(seed,width*height)) ,$
             I      : type.ns*Double(RandomU(seed,width*height)) ,$
             X      : type.ns*Double(RandomU(seed,width*height)) ,$
             M      : DblArr(width*height) ,$
             S      : DblArr(width*height) ,$
             O      : handle}

   
   RETURN, Handle_Create(!MH, VALUE=Layer, /NO_COPY)

END 
