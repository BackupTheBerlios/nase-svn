;+
; NAME:
;  csTurnLeft
;
; VERSION:
;  $Id$
;
; AIM:
;  tell remote Crystal Space application to turn camera left
;
; PURPOSE:
;
; CATEGORY:
;  Animation
;  Graphic
;  IO
;
; CALLING SEQUENCE:
;*csTurnLeft, EngineHandle
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
;  <A>csTurnRight</A>, <A>InitCSEngine</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

pro csTurnLeft, EngineHandle
Handle_Value, EngineHandle, Engine, /no_copy

writeu, Engine.socket, 'l'

Handle_Value, EngineHandle, Engine, /NO_COPY, /SET
end
