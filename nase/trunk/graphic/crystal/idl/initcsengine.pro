;+
; NAME:
;  InitCSEngine()
;
; VERSION:
;  $Id$
;
; AIM:
;  initialize a Crystal Space remote application
;
; PURPOSE:
;  initialize a Crystal Space remote application
;
; CATEGORY:
;  Animation
;  Graphic
;  IO
;
; CALLING SEQUENCE:
;*EngineHandle = InitCSEngine(PORT=PORT, PATH=PATH, EXEC=EXEC)
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  PORT:: TCP/IP port number
;  PATH:: path (string) to the Crystal Space application
;  EXEC:: name (string) of the executable CS application
;
; OUTPUTS:
;  EngineHandle:: Handle
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
;  by now it only works on local host
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*>
;
; SEE ALSO:
;  <A>FreeCSEngine</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function InitCSEngine, PATH=PATH, EXEC=EXEC, PORT=PORT
default, path, "$NASEPATH/graphic/crystal/cpp/simple1/"
default, exec, "simple"
default, port, 1234

para = " -port="+str(port)
Call = path + exec + para + "&"

spawn, Call

wait, 2

socket = csconnect(port=port, read_timeout=2)

MyEngine = {$
            socket: socket $
}

RETURN, Handle_Create(!MH, VALUE=MyEngine, /NO_COPY)

end ;function csStartEngine, PATH=PATH, EXEC=EXEC, PORT=PORT
