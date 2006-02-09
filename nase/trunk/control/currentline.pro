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
;* result = currentline( [pick]
;*                       [, /CONTINUATION | , /INLINE_CONTINUATION]
;*                       [, /REMOVE_COMMENTS] )
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
; INPUT KEYWORDS:
;  /CONTINUATION:: If the current logical line of sourcecode is split
;                  across several physical lines using the
;                  continuation sign (dollar sign, $), the whole
;                  logical line is returned. Note: The result returned is a
;                  scalar string containing linefeeds and carriage
;                  returns, as well as the continuation ($) signs. It
;                  is not a string array.
;
;  /INLINE_CONTINUATION:: Same as <C>/CONTINUATION</C>, but linebreaks
;                         and continuation signs are removed.
;                         Indentations are removed, and line fragments
;                         pasted. The logical line is returned as
;                         a single-line string.
;                         Implies <C>/REMOVE_COMMENTS</C>.
;
;  /REMOVE_COMMENTS:: Comments at the returned line of sourcecode are removed.
;
; RESTRICTIONS:
;  o The pick argument must be positive and not larger than the
;    depth of the callstack.
;  o <C>/REMOVE_COMMENTS</C> currently does not correctly ignore
;    semikoli inside quotation marks.
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


Pro currentline_remove_comments_, l
   ;; this currently does not correctly ignore semikoli inside quotation marks!
   l = (strsplit(l, ";", /extract))[0]
   l = strtrim(l)
End

Function currentline_has_continuation_, l
   ;; remove comments and the look if last character is a "$".
   ;; breaks, if currentline_remove_comments_ breaks (see above)
   l2 = l
   currentline_remove_comments_, l2
   return, strmid(l2, strlen(l2)-1, 1) eq "$"
End


Function currentline, pickcaller, $
                      CONTINUATION=continuation, $
                      INLINE_CONTINUATION=inline_continuation, $
                      REMOVE_COMMENTS=remove_comments

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

         ;; read first line:
         for i=1, fix(lines(f)) do readf, lun, l
         if keyword_set(REMOVE_COMMENTS) or keyword_set(INLINE_CONTINUATION) then currentline_remove_comments_, l

         result(f) = l

         ;; read all other lines:
         If keyword_set(CONTINUATION) then begin
            while currentline_has_continuation_(l) do begin
               readf, lun, l
               if keyword_set(REMOVE_COMMENTS) then currentline_remove_comments_, l
               result(f) = result(f)+str(10b)+str(13b)+l
            endwhile
         endif

         If keyword_set(INLINE_CONTINUATION) then begin
            while currentline_has_continuation_(l) do begin
               result(f) = strmid(result(f), 0, strlen(result(f))-1)
               readf, lun, l
               currentline_remove_comments_, l
               result(f) = result(f)+strtrim(l, 1)
            endwhile
         endif
            
         close, lun
      endelse
   endfor
   
   return, result
End



