;+
; NAME: 
;  currentline()
;
; VERSION:
;  $Id$
;
; AIM:
;  Scan sourcefiles for the current position of program execution and
;  return current lines as strings.
;   
; PURPOSE:
;  This routine extracts the current position of program execution
;  from IDL's callstack, opens the source files, reads the current
;  lines and returns them as an array of strings. <A>currentline()</A>
;  is very much related to <A>callstack()</A>. 
;   
; CATEGORY:
;  ExecutionControl
;  Help
;
; CALLING SEQUENCE:
;* result = currentline( [pick] )
;  
; OPTIONAL INPUTS:
;  pick:: The number of the routine on the callstack that information
;         is required on. 0 corresponds to the routine
;         <A>currentline()</A> was called from.
;         The pick argument must be positive and not larger than the
;         depth of the callstack.
;         If the argument is omitted, lines for the current position
;         in all routines on the callstack is returned.
;  
; OUTPUTS:
;  result:: If <A>currentline()</A> was called with an argument,
;           information on the entry of the specified depth on the
;           stack is returned. In that case, the result is a
;           scalar string, containing 1. the line form the routine's
;           sourcefile, where execution was suspended (either by
;           calling another routine or by a program error).
;           If <A>currentline()</A> was called without an argument,
;           information on every routine on the callstack is
;           returned. In that case, the result is a <*>n</*> element
;           string array, where <*>n</*> is the depth of the
;           callstack.
;           If the respective program level was the main program, the
;           result will contain <*>"(main level code)"</*>. (see
;           example).
;  
; RESTRICTIONS:
;  The pick argument must be positive and not larger than the
;  depth of the callstack.
;  
; PROCEDURE:
;  Get callstack using <A>callstack()</A>, open source files and read
;  line form the current position.
;  
; EXAMPLE:
;   1. enter at the prompt:
;*  print, currentline()
;*  > (main level code)
;   
;   2. run a program and interrup anywhere
;*  print, currentline()
;   see what happens.
;  
; SEE ALSO:
;  <A>callstack()</A>, <C>HELP, CALLS=...</C>
;
;-


Function currentline, pickcaller

   if set(pickcaller) then begin
      assert, pickcaller ge 0, "Argument must be positive."
      caller = callstack(pickcaller+1)
   endif else begin
      caller = (callstack())(*, 1:*)
   endelse

   lines = caller(2, *)
   files = caller(1, *)
   
   If Set(pickcaller) then result = "" else $
    result = strarr(n_elements(files))

   l = ""
   for f=0, n_elements(files)-1 do begin
      if lines(f) eq "(unknown)" then begin
         result(f) = "(main level code)"
      endif else begin
         openr, lun, files(f), /Get_Lun
         for i=1, fix(lines(f)) do readf, lun, l
         close, lun
         result(f) = l
      endelse
   endfor

   return, result
End



