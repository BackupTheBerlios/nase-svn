;+
; NAME:
;  csConnect()
;
; VERSION:
;  $Id$
;
; AIM:
;  connect to a TCP/IP socket
;
; PURPOSE:
;  <C>csConnect()</C> connects as client to a listening TCP/IP socket
;  and returns the unit number. You can spezify port number and host name.
;
; CATEGORY:
;  IO
;
; CALLING SEQUENCE:
;*lun = csConnect(port=port, read_timeout=seconds)
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
; see <A>csRemoteDemo</A>
;*
;*>
;
; SEE ALSO:
;  <A>csReceveScreenShot()</A>, <A>csRemoteDemo</A>
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document
 
function csConnect, port=port, host=host, error=error, read_timeout=read_timeout

default, port, 1234
default, host, 'localhost'
default, read_timeout, 2

print, "try connecting to host '", host, "' on port ", port
socket, lun, host, port, /get_lun, read_timeout=read_timeout, /rawio;, error=error
print, "Read-Timeout=", read_timeout
return, lun
end ;;pro csConnect, lun, port=port
