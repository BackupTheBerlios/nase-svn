;+
; NAME:
;  XAllowed()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return <*>TRUE</*>, if connecting to the X server is allowed.
;
; PURPOSE:
;  This function returns <*>TRUE</*> (<*>1</*>), if connections to the
;  X server are allowed during this IDL session. It can be used to
;  skip any low-level graphic commands on the X device, which would
;  need to establish communication to an X Windows server. (For
;  example, it is used inside the <A>UTVLct</A> and <A>USet_Plot</A>
;  routines.) <BR>
;  Connecting to the X server may either be impossible (if there is no
;  such server, or if the DISPLAY environment variable is improperly
;  set), which would cause program interruption, or it may be
;  undesired (e.g. in <*>nohup</*> sessions, where it would violently
;  cause the IDL process to terminate, when the X server process
;  dies.) <BR>
;  The result is computed due to the following rationale:<BR>
;  o Always allow X connections if session is interactive.<BR>
;  o Forbid X connections if session is not interactive (e.g. a nohup
;    session).<BR>
;  o Even in a non-interactive session, allow X connections, if
;    environment variable NASELOGO is set to 'TRUE'.<BR>
; 
; CATEGORY:
;  ExecutionControl
;  IO
;  OS
;
; CALLING SEQUENCE:
;*result = XAllowed()
;
; OUTPUTS:
;  <*>TRUE</*> (<*>1</*>) is returned, if X connections are allowed
;  during this IDL session. <BR>
;  <*>FALSE</*> (<*>0</*>) is returned, if X connections are
;  forbidden, which in most cases means that we are running a
;  <*>nohup</*> session.
;
; RESTRICTIONS:
;  This functions relies on <A>Interactive()</A>. Hence, restrictions
;  stated there do also apply to <C>XAllowed()</C>.
;
; PROCEDURE:
;  Call <A>Interactive()</A> and check for the NASELOGO environment
;  variable set to 'TRUE'.
;
; EXAMPLE:
;*If XAllowed() then ShowLogo else print, "Welcome to NASE."
;
; SEE ALSO:
;  <A>Interactive()</A>.
;-

Function XAllowed
  
   ;; RATIONALE:
   ;;
   ;;  o Always allow X-connections if session is interactive.
   ;;  o Forbid X-connections if session is not interactive (e.g. a nohup
   ;;    session).
   ;;  o Even in a non-interactive session, allow X-connections, if
   ;;    environment variable NASELOGO is set to 'TRUE'.
 
   Return, Interactive() or (StrUpcase(GetEnv("NASELOGO")) eq "TRUE")

End
