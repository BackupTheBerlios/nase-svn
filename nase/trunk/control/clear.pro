;+
; NAME:
;  Clear
;
; VERSION:
;  $Id$
;
; AIM:
;  Clean up session: close files, free dynamic memory, close windows...
;
; PURPOSE:
;  This routine serves as a cleanup for the running session. It
;  performs the following steps:<BR>
;  Close all windows, widgets and files (using <A>CAW</A> and
;  <A>UClose</A>), free all NASE handles (using
;  <A>FreeEachHandle</A>), set <*>!P.Multi=0</*>, and garbage collect
;  the heap (using IDL's <C>HEAP_GC</C>). Unless keyword <*>/NORET</*>
;  is set, it also performs <C>RETALL</C>.
;
; CATEGORY:
;  ExecutionControl
;  Files
;  Graphic
;  Help
;  NASE
;  Widgets
;
; CALLING SEQUENCE:
;*Clear [,/NORET]
;
; INPUT KEYWORDS:
;  NORET:: If this keyword is set, no <C>RETALL</C> is performed.
;
; SIDE EFFECTS:
;  The routine breaks program execution and returns to the main level,
;  unless <C>/NORET</C> is set.
;
; PROCEDURE:
;  Do the operations described above, one after the other...
;
; EXAMPLE:
;*Q: Oh my god, my screen is messed up, I got thousand files open, and
;*   23 dangling references to pointers and objects!!
;*A: just do... 
;* clear
;*>UCLOSE: 0 open file(s) left
;*>% CLEAN: Garbage Collecting Heap...
;*>% CLEAN: ...done.
;
; SEE ALSO:
;  <A>CAW</A>, <A>UClose</A>, <A>FreeEachHandle</A>,
;   IDL's <C>HEAP_GC</C>, IDL's <C>!P.Multi</C>
;-

Pro Clear, NORET=noret

caw
uclose, /all, /verbose
freeeachhandle
!P.Multi = 0
message, /INFO, "Garbage Collecting Heap..."
Heap_GC, /Verbose               ;Garbage Collection of unreferenced Heap Variables
message, /INFO, "...done."

if not keyword_set(NORET) then retall

end
