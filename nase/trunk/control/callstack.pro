;+
; NAME: 
;  callstack()
;
; VERSION:
;  $Id$
;
; AIM:
;  Return current contents of IDL's routine callstack as array of
;  name, source file and line number.
;   
; PURPOSE:
;  This routine can be used to return IDL's callstack at the time of
;  the call. Information on the callstack (called "traceback
;  information" in the IDL help) is provided by IDL's <C>HELP</C>
;  command. However, the output of this command is a string array,
;  containing routine name, source file and line number all
;  intermingled in a single string. <A>callstack()</A> scans this
;  string, breaks it down and returns routine name, source file and
;  line number as single strings.
;  Either the contents of the whole callstack, or information on a
;  single specified entry may be returned.
;   
; CATEGORY:
;  ExecutionControl
;  Help
;
; CALLING SEQUENCE:
;* result = callstack( [pick] )
;  
; OPTIONAL INPUTS:
;  pick:: The number of the routine on the callstack that information
;         is required on. 0 corresponds to the routine
;         <A>callstack()</A> was called from.
;         The pick argument must be positive and not larger than the
;         depth of the callstack.
;         If the argument is omitted, the whole contents of the
;         callstack is returned.
;  
; OUTPUTS:
;  result:: If <A>callstack()</A> was called with an argument,
;           information on the entry of the specified depth on the
;           stack is returned. In that case, the result is a
;           three-element string array, containing 1. the routine
;           name, 2. the source file the routine was compiled from,
;           and 3. the number of the line in that source file, where
;           program execution was suspended (either by calling another
;           routine or by a program error).
;           If <A>callstack()</A> was called without an argument,
;           information on the whole callstack is returned. In that
;           case, the result is a <*>3</*>x<*>n</*> string array, where
;           <*>n</*> is the depth of the callstack.
;           If the respective program level was the main program, the
;           source entry will contain <*>"(main level code)"</*>, and
;           the line number entry will contain <*>"(unknown)"</*> (see
;           example).
;  
; RESTRICTIONS:
;  The pick argument must be positive and not larger than the
;  depth of the callstack.
;  
; PROCEDURE:
;  Get callstack using <C>HELP, CALLS=...</C> and break down using
;  <A>Split()</A>.
;  
; EXAMPLE:
;   1. enter at the prompt:
;*  print, callstack()
;*  > $MAIN$ (main level code) (unknown)
;   
;   2. run a program and interrup anywhere
;*  print, callstack()
;   see what happens.
;  
; SEE ALSO:
;  <A>currentline()</A>, <C>HELP</C>
;
;-

Function callstack, pick
   
   help, calls=cs
   
   if set(pick) then begin
      ;; pick the element from the stack
      assert, pick ge 0
      assert, (pick+1) lt N_Elements(cs)
      cs = cs(pick+1)
   endif else begin
      ;; return whole stack, apart from this routine itself.
      assert, n_elements(cs) ge 2
      cs = cs(1:*)
   endelse
   
   assert, Set(cs)
   result = strarr(3, n_elements(cs))

   for l=0, n_elements(cs)-1 do begin
      origin = split(cs(l), '<')
      result(0, l) = origin(0)
      If n_elements(origin) gt 1 then begin
         fileandline = split(origin(1), '>')
         result(1, l) = (split(fileandline(0), '('))(0) ;;file
         result(2, l) = str(fix((split(fileandline(0), '('))(1))) ;;line
      endif else begin
         result(1, l) = "(main level code)"
         result(2, l) = "(unknown)"
      endelse
   end

   return, result
End
