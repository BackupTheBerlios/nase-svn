;+
; NAME:
;  csTurnRight
;
; VERSION:
;  $Id$
;
; AIM:
;  tell remote Crystal Space application to turn camera right
;
; PURPOSE:
;  tell remote Crystal Space application to turn camera right
;
; CATEGORY:
;  Animation
;  Graphic
;  IO
;
; CALLING SEQUENCE:
;*csTurnRight, EngineHandle
;
; INPUTS:
;  EngineHandle:: handle
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
;  <A>csTurnLeft</A>, <A>InitCSEngine()</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

pro csTurnRight, EngineHandle
Handle_Value, EngineHandle, Engine, /no_copy

writeu, Engine.socket, 'r'

Handle_Value, EngineHandle, Engine, /NO_COPY, /SET
end
