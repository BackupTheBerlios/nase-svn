;+
; NAME:
;  csRemoteDemo
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
;*csRemoteDemo, port=port
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  port ist the port number used by the Crystal Space application
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
;  <A>csConnect()</A>, <A>csReceveScreenShot()</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

pro csRemoteDemo, port=port
;spawn, "~/prog/simplecs/simple &"
verbose = 0

if not keyword_set(port) then port=1234

MyError='NOERR'
print, MyError
lun = csconnect(port=port, read_timeout=2)
print, MyError

print, "Waiting"

WaitSeconds=5
for i=0, WaitSeconds-1 do begin
    wait, 1
    print, WaitSeconds-i
endfor

print, "genug gewartet"
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
            writeu, lun, 'l'
        end
        2 : begin
            print, "hier passiert nix"
        end
        3: tvscl, indgen(300,200)
        4 : begin
            sendCount= sendCount+1
            if keyword_set(verbose) then print, sendCount, "sende RECHTS"
            writeu, lun, 'r'
        end
        5: tvscl, indgen(20,20)
        6: tvscl, indgen(100,20)
        7: exit=1
        else: a=0
    endcase
    if keyword_set(verbose) then begin
        print, MyError
        print, "ScreenShot requested"
    endif
    writeu, lun, 'g'
    screen = csReceveScreenShot(lun, verbose=verbose)
    if keyword_set(verbose) then help, screen
    tvscl, screen
;    wait, 0.01
    

endrep until (exit eq 1)



writeu, lun, 'l'
writeu, lun, 'r'


close, lun

end                             ;pro csRemoteDemo
