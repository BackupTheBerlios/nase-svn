;+
; NAME:
;  csGetScreen()
;
; VERSION:
;  $Id$
;
; AIM:
;  get a screenshot form remote Crystal Space application
;
; PURPOSE:
;  get a screenshot form remote Crystal Space application
;
; CATEGORY:
;  Animation
;  Graphic
;
; CALLING SEQUENCE:
;*ProcedureName, par [,optpar] [,/SWITCH] [,KEYWORD=...]
;*result = csGetScreen(EngineHandle)
;
; INPUTS:
;  EngineHandle:: handle, erzeugt mit <C>InitCSEngine()</C>
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  
;
; OUTPUTS:
;  result:: two dimensional byte array containing the screenshot
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
;  <A>InitCSEngine</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


function csGetScreen, EngineHandle, VERBOSE=VERBOSE

Handle_Value, EngineHandle, Engine, /no_copy

writeu, Engine.socket, 'g'
screen = csReceveScreenShot(Engine.socket, verbose=verbose)

Handle_Value, EngineHandle, Engine, /NO_COPY, /SET
return, screen
end ;function csGetScreen, EngineHandle
