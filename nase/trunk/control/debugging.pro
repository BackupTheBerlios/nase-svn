;+
; NAME: 
;  Debugging
;
; VERSION:
;  $Id$
;
; AIM:
;  Control the debugging tools (DMsg and assert).
;   
; PURPOSE:
;  <C>Debugging</C> is used to turn on or off 
;  <A NREF=DMSG>debugmessages</A> and <A NREF=ASSERT>assertions</A> in an
;  effective way. Instead of simply suppressing output, the respective
;  routines are recompiled to an empty call.
;   
; CATEGORY:
;  ExecutionControl
;  Help
;
; CALLING SEQUENCE:
;* Debugging [,MESSAGES=(0|1)] [,ASSERTIONS=(0|1)]
;  
; INPUT KEYWORDS:
;  MESSAGES:: Set this keyword to turn on <A
;             NREF=DMSG>debugging messages</A>.
;             Set this keyword explicitely to 0 to turn them off.
;
;  ASSERTIONS:: Set this keyword to turn on <A
;               NREF=ASSERT>assertions</A>.
;               Set this keyword explicitely to 0 to turn them off.
;
; SIDE EFFECTS:
;  According to the provided keywords, the <A>DMsg</A> and
;  <A>assert</A> routines are recompiled.
;  
; RESTRICTIONS:
;  Currently, the features can not be controlled for individual
;  routines. Use the <A>ConsoleConf</A> command to suppress debugging
;  messages for individual routines.
;  Note that suppressing debugging output using the <A>ConsoleConf</A>
;  command is less efficient than using <C>Debugging</C>, as the
;  verbosity level is checked at runtime.
;  Note that even after turning off assertions, the boolean expression
;  passed to <A>assert</A> is still evaluated. Assertions in time
;  critical program portions should not check any expressions that are
;  time consuming to evaluate.
;  
; PROCEDURE:
;  Recompile using <C>RESOLVE_ROUTINE</C>.
;  
; EXAMPLE:
;  Get rid of debugging messages and speed up program execution by
;  ignoring assertions:
;*  Debugging, MESSAGES=0, ASSERTIONS=0
;*  DMsg, "This will not be printed."
;*  assert, 1 eq 0, "This assertion will not be checked."
;  
; SEE ALSO:
;  <A>DMsg</A>, <A>assert</A>
;-

Pro Debugging, MESSAGES=messages, ASSERTIONS=assertions
   If Set(Messages) then begin
      If Keyword_Set(Messages) then $
       resolve_routine, "dmsg" $
      else $       
       resolve_routine, "dmsg_off"
   Endif

   If Set(Assertions) then begin
      If Keyword_Set(Assertions) then $
       resolve_routine, "assert" $
      else $       
       resolve_routine, "assert_off"
   Endif
End
