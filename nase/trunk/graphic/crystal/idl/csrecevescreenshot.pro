;+
; NAME:
; csReceveScreenShot()
;
; VERSION:
;  $Id$
;
; AIM:
;  receve a screen shot via TCP/IP socket from a Crystal Space application
;
; PURPOSE:
;  receve a screen shot via TCP/IP socket from a Crystal Space application
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*ScreenShot = csReceveScreenShot(lun, VERBOSE=VERBOSE)
;
; INPUTS:
; lun:: lun is a unit number assiciated with an open TCP/IP socket,
; connected with a running Crystal Space application. 
; You must use <C>csConnect()</C> to get this unit.
;  
; 
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
; VERBOSE:: You can set /verbose to get some debug information
;
; OUTPUTS:
;  ScreenShot is a bitmap (2D-Byte-Array)
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
;  <A>csConnect()</A>, <A>csRemoteDemo</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document

function csReceveScreenShot, lun, verbose=verbose

InitName = byte("ScreenShotStart")
InitName = [InitName, 10]
InitLength = n_elements(InitName)

HeaderLength = InitLength+4+4
header = bytarr(HeaderLength)

for i=0, HeaderLength-1 do begin
    a=byte(255)
    readu, lun, a
    if keyword_set(verbose) then print, a
    header[i]=a
endfor

if total(header[0:n_elements(initname)-1] eq initname) eq n_elements(InitName) then begin
    print, "Init-Sequenz korrekt"
endif else begin
    print, "Init-Sequenz nicht korrekt"
    stop
endelse

WidthArr = header[InitLength:InitLength+3]
HeightArr = header[InitLength+4:InitLength+7]

Width = WordToLongInt(WidthArr)
Height = WordToLongInt(HeightArr)

if keyword_set(verbose) then begin
    print, "Width = ", Width
    print, "Height= ", Height
endif

MemSize = long(Width)*long(Height)
picture = bytarr(Width,Height)
picture(*)=255

ON_IOERROR, fehler

ReadU, lun, picture, transfer_count=TransBytes
;print, "Transfer_Count = ", TransBytes

MaxTransTrials = 20
TrialCount=0
while ((TransBytes ne MemSize) and (TrialCount lt MaxTransTrials)) do begin
    if keyword_set(verbose)  then print, "Übertragung noch nicht komplett ", TrialCount 
    a = picture[TransBytes:*]
    readu, lun, a, transfer_count=tc
    picture[TransBytes:*] = a
    TransBytes=TransBytes+tc
    TrialCount = TrialCount+1
endwhile
if keyword_set(verbose) then print, "TrialCount=", TrialCount

invertHeight = Height-indgen(Height)

return, picture[*, sort(invertHeight)]

fehler: print, "Hier trat ein Fehler auf"
print, "Bytes: ", long(Width)*long(Height)
print, "ErrString="
print, !err_string 
stop
return, picture[*, sort(invertHeight)]

end
