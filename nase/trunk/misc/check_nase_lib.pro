Pro Check_NASE_LIB
   If Fileexists(!NASE_LIB) then begin
      dummy = MTime(!NASE_LIB, Date=d)
      Print
      Print, "NASE support library: "+!NASE_LIB
      Print, "compiled on " + d + "."
      Print
   Endif Else begin
      Print
      Print, "Making NASE support library: "+!NASE_LIB
      PushD, !NASEPATH+"/shared"
      Spawn, ["make"], /Noshell
      Print, "done."
      Print
      PopD
   Endelse
End
