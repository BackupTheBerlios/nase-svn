;+
; NAME:
;  Interactive()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return <*>TRUE</*>, if session is running in an interactive terminal or GUI.
;
; PURPOSE:
;  This function returns <*>TRUE</*> (<*>1</*>), if the current IDL
;  session is interactive. I.e., <I>standard input</I> and <I>standard
;  output</I> are connected to a terminal, or an interactive graphical
;  user interface. (Note RESTRICTIONS below.) <BR>
;  This function is very useful in <*>nohup</*> sessions. It allows,
;  for example, to automatically skip program parts that would need
;  user interaction. Furthermore, this function is used by
;  <A>XAllowed()</A>, to determine if connections to the X server are
;  allowed during this session.
;
; CATEGORY:
;  ExecutionControl
;  IO
;  OS
;
; CALLING SEQUENCE:
;*result = Interactive()
;
; OUTPUTS:
;  <*>TRUE</*> (<*>1</*>) is returned, if the current IDL
;  session is interactive. I.e., <I>standard input</I> and <I>standard
;  output</I> are connected to a terminal, or an interactive graphical
;  user interface. <BR>
;  <*>FALSE</*> (<*>0</*>) is returned, if the current IDL
;  session is not interactive, which in most cases means that it is a
;  <*>nohup</*> session.
;
; RESTRICTIONS:
;  Only <I>standard output</I> is checked, but it is <I>very</I> likely that
;  <I>standard input</I> is connected to an interactive terminal, if
;  <I>standard output</I> is.
;
; PROCEDURE:
;  A call to <C>FSTAT(-1)</C>, plus some version-dependent stuff.
;  GUIs can only be recognised in IDL versions since IDL 4.
;
; EXAMPLE:
;*answer=""
;*If Interactive() then read, "Are you unsure (y/n)? ", answer else answer="y"
;
; SEE ALSO:
;  <A>XAllowed</A>, IDL's <C>FSTAT()</C>.
;-

Function Interactive
   ;;--- Are_we_running_an_interactive_session? -----   

   stdout_fstat = fstat(-1)

   if IDLVersion() lt 4 then $
     return, stdout_fstat.isatty $
   else $
     return, stdout_fstat.interactive   

End
