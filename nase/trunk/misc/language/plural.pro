Function plural, noun

   if strmid(noun, /Reverse_Offset, 1) eq "ey" then begin
      return, strmid(noun, 0, strlen(noun)-2)+"ies"
   endif

   if strmid(noun, /Reverse_Offset, 0) eq "y" then begin
      return, strmid(noun, 0, strlen(noun)-1)+"ies"
   endif

   return, noun+"s"
End
