;+
; NAME:
;  FreeCSEngine
;
; VERSION:
;  $Id$
;
; AIM:
;  close the connection to remote Crystal Space application
;
; PURPOSE:
;  close the connection to remote Crystal Space application
;
; CATEGORY:
;  Animation
;  Graphic
;  IO
;
; CALLING SEQUENCE:
;*FreeCSEngine, EngineHandle
;
; INPUTS:
;  EngineHandle:: Handle
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
;  <A>InitCSEngine()</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

pro FreeCSEngine, EngineHandle

Handle_Value, EngineHandle, Engine, /no_copy

close, Engine.socket

Handle_Free, EngineHandle

end ;pro FreeCSEngine, MyEngineHandle
