Function genitive, noun

   if strmid(noun, /Reverse_Offset, 0) eq "s" then begin
      return, noun+"'"
   endif

   return, noun+"'s"
End
