;+
; NAME:
;  csRemoteDemo1
;
; VERSION:
;  $Id$
;
; AIM:
;  demo program that shows how to remote control a Crystal Space application
;
; PURPOSE:
;  demo program that shows how to remote control a Crystal Space application
;
; CATEGORY:
;  Demonstration
;  Graphic
;  IO
;
; CALLING SEQUENCE:
;*csRemoteDemo, PORT=PORT
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  PORT:: port ist the port number used by the Crystal Space
;  application; default value is <*>1234</*>
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
;  the Crystal Space application must be started before, waiting for a
;  connection on port number <*>PORT</*>
;
; PROCEDURE:
;  
;
; EXAMPLE:
; start nase/graphic/crystal/cpp/simple from console
;* csremotedemo
;then press the SPACE button in the simple application to accept the
;connection;
; now you can click with the mouse buttons in the idl widget window
; and you see the screenshot of the simple application. Using left and
; right mouse button you can turn left and right.
;*>
;
; SEE ALSO:
;  <A>csConnect()</A>, <A>csReceveScreenShot()</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

pro csRemoteDemo1, port=port

verbose = 0

if not keyword_set(port) then port=1240

MyEngine = InitCSEngine(port=port)

sendCount = 0l

repeat begin
    cursor, x, y, /down
    mb = !mouse.button
                                ;if mb ne 0 then print, mb
    exit=0

    case !mouse.button of
        1: begin
            sendCount = sendCount+1
            if keyword_set(verbose) then print, sendCount, " sende LINKS"
            csTurnLeft, MyEngine
        end
        4 : begin
            sendCount= sendCount+1
            if keyword_set(verbose) then print, sendCount, "sende RECHTS"
            csTurnRight, MyEngine
        end
        5: exit=1
        else: a=0
    endcase
    if keyword_set(verbose) then begin
        print, MyError
        print, "ScreenShot requested"
    endif

    screen = csGetScreen(MyEngine)
    if keyword_set(verbose) then help, screen
    tvscl, screen
;    wait, 0.01
    

endrep until (exit eq 1)


FreeCSEngine, MyEngine

end                             ;pro csRemoteDemo
