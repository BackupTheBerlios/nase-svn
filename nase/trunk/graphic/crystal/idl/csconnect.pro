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
;*lun = csConnect(PORT=PORT, HOST=HOST, READ_TIMEOUT=READ_TIMEOUT)
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  PORT:: TCP/IP port number, there must be a server program listening
;  to this port; default ist 1234
;  HOST:: host name to which to connect; default is 'localhost'
;  READ_TIMEOUT:: this keyword is set to the number of seconds to wait
;  for data to arrive before giving up and issuing an error (see
;  idlhelp for "socket")
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
;  before finishing your program you should close the connection using
;  <*>close, lun</*>
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
