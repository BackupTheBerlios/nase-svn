;+
; NAME: 
;   assert
;
; VERSION:
;   $Id$
;
; AIM:
;   Check a program invariant.
;   
; PURPOSE:
;   Assert is a simple but very effective debugging utility. It is
;   used for checking boolean expressions that can safely be expected
;   to be satisified, if a routine works as it is meant to do
;   (so called program invariants).
;   A failed assertion is an indicator for a bug, either in a
;   routine's code or in a routines general design, or in the user's,
;   designer's or programmer's understanding of it's operation.
;
;   Assert is silently passed, if the supplied expression is TRUE, and
;   issues an error and stops program execution, if it is FALSE.
;   
; CATEGORY:
;*  Help
;
; CALLING SEQUENCE:
;*  assert, boolexpr [,reason]
;  
; INPUTS:
;   boolexpr:: The boolean expression (program invariant) that is
;              expected to be fulfilled.
;   reason:: An optional string describing the reason for a possible
;            failure of this assertion. This text will be displayed
;            when the specified assertion fails.
;  
; SIDE EFFECTS:
;   In case of a failed assertion, program executions stops and an
;   informative message is displayed.
;  
; RESTRICTIONS:
;   Assertions must not exert any side effect on the checked
;   variables. Side effects are not only regarded bad and unsafe
;   programming style, but may cause severe program malfunction in
;   the case of assertions: As assertions are used as a general
;   debugging tool, programming languages usually provide a means for
;   totally removing assert statements from the compiled program
;   (e.g. by preprocessing the source before compiling). In that case,
;   the side effects will silently be removed from the code, too,
;   which is likely to cause program malfunction.
;   Although assertion removal is currently not supported by IDL, it
;   may well be the case in future versions of IDL or NASE.
;   Hence, don never use a call alike the following:
;*  assert, addOne(a) eq 23
;   where the imaginary function addOne() does actually change the
;   value contained in variable a.
;
; PROCEDURE:
;   Most simple. Check argument for true or false.
;  
; EXAMPLE:
;   assert, d ne 0.0, "Division by zero." & return, array/d
;   assert, step ne 0 & for i=1,100,step do something
;   [..compute prime factors of n..] & assert, Product(result) eq n
;  
;-

Pro assert, condition, text
   On_Error, 2 ;;return to caller.
   
   if not condition then begin
      assertionstring = currentline(1, /inline_continuation)

      if assertionstring ne "(main level code)" then begin
         ;; find "ASSERT" in string:
         posbegin = strpos(strupcase(assertionstring), "ASSERT")
         assertionstring = StrMid(assertionstring, posbegin)

         if set(text) then begin
            ;; remove all behind last comma:
            posend = strpos(strupcase(assertionstring), /reverse_search, ",")
            assertionstring = StrMid(assertionstring, 0, posend)
         endif
         assertionstring = str(assertionstring)
      endif
         

      If Set(text) then begin
         message = ["FAILED ASSERTION: " + "'"+assertionstring $
                    +"' in line "+(callstack(1))(2)+".", $
                    "Reason: "+text]
      endif else begin
         message = "FAILED ASSERTION: " + "'"+assertionstring $
         +"' in line "+(callstack(1))(2)+"."         
      endelse
      
      Console, /Fatal, PickCaller=1, message
    
   endif
End
