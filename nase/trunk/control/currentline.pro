Function currentline, pickcaller
   Default, pickcaller, 0
   
   help, calls=callstack
   
;   assert, pickcaller ge 0
;   assert, (pickcaller+1) lt N_Elements(m) 
   
   origin = split(callstack(pickcaller+1), '<')
   If n_elements(origin) gt 1 then begin
      fileandline = split(origin(1), '>')
      file = (split(fileandline(0), '('))(0)
      line = fix((split(fileandline(0), '('))(1))
      
      openr, lun, file, /Get_Lun
      l = ""
      for i=1, line do readf, lun, l
      close, lun

      return, l
   endif else begin
      return, "(main level code)"
   endelse
   
End
