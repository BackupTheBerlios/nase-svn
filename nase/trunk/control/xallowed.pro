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
;  The result is computed due to the following rationale (the
;  following points are checked in the given order until the first one
;  applies):<BR>
;
;  o Return <*>TRUE</*> if running under Windows OS. (There is no such
;    thing as X Servers and <*>nohup</*> sessions in this case.)<BR> 
;  o Forbid X connections, if environment variable DISPLAY is not
;    set or is set to the empty string. (As connecting the X
;    server would fail anyway.)<BR> 
;  o Allow X connections, if environment variable NASELOGO is set
;    to 'TRUE'. (The user has explicitely requested an X
;    connection.)<BR>
;  o Allow X connections if session is interactive. (The normal
;    way to use IDL.)<BR>
;  o Forbid X connections. (As session is not interactive, e.g. a
;    nohup session).<BR>
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
;  Perform checks according to the rationale given above.
;  Check environment variables and call <A>Interactive()</A>.
;
; EXAMPLE:
;*If XAllowed() then ShowLogo else print, "Welcome to NASE."
;
; SEE ALSO:
;  <A>Interactive()</A>.
;-

Function XAllowed
  
   ;; RATIONALE:
   ;;  The following points are checked in the given order until the
   ;;  first one applies:
   ;;
   ;;  o Return TRUE if running under Windows OS.
   ;;  o Forbid X connections, if environment variable DISPLAY is not
   ;;    set or is set to the empty string. (As connecting the X
   ;;    server would fail anyway.)
   ;;  o Allow X connections, if environment variable NASELOGO is set
   ;;    to 'TRUE'. (The user has explicitely requested an X
   ;;    connection.)
   ;;  o Allow X connections if session is interactive. (The normal
   ;;    way to use IDL.)
   ;;  o Forbid X connections. (As session is not interactive, e.g. a
   ;;    nohup session).
 

   IF (fix(!VERSION.Release) ge 4) THEN $
    OS_FAMILY=!version.OS_FAMILY $
   ELSE $
    OS_FAMILY='unix'
   
   IF StrUpcase(OS_FAMILY) EQ "WINDOWS" THEN Return, 1

   If GetEnv("DISPLAY") eq "" then return, 0
   
   If StrUpcase(GetEnv("NASELOGO")) eq "TRUE" then return, 1

   If Interactive() then return, 1

   Return, 0

End
