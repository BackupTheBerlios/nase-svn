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
