Pro Check_NASE_LIB

   If IDLVersion() gt 3 then begin
      ;; !Version.OS_Family doesn't exist on IDL3.6
      If !Version.OS_Family eq "Windows" then $
       console, /Warn, "Making of the NASE support library is curently " + $
       "not supported for Windows. You will encounter problems " + $
       "(crashes) when accesing routines form the support library."
      return
   end
      
   ; ensure architecture dependent libdir exists
   LIBDIR = (File_Split(!NASE_LIB))(0)
   mkdir, LIBDIR
   
   PushD, !NASEPATH+"/shared"
   If NOT Fileexists(!NASE_LIB) THEN $
     Spawn, Command('cp')+' -pf * '+LIBDIR ; -p doesn't change time stamp when copying from 
                                           ; shared to LIBDIR and therefore
                                           ; doesn't confuse make
   PopD
   PushD, LIBDIR
   Spawn, ["make"], /Noshell              ; create or update library if necessary
   
   If NOT Fileexists(!NASE_LIB) THEN begin
      Console, !NASE_LIB+" doesn't exist. Something's going wrong " + $
       "here.", /WARNING
      Console, "You will encounter problems using the C-library " + $
       "routines.", /WARNING
      PopD
      return
   End

   dummy = MTime(!NASE_LIB, Date=d)
   Print
   Print, "NASE support library: "+!NASE_LIB
   Print, "compiled on " + d + "."
   Print
   PopD
End
