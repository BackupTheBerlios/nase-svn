;+
; NAME:
;  PAAinit
;
; AIM: Create a new pool allocator array.
;  
;-


Function PAAsize, paa
   return, paa.size
End

Function PAAdata, paa
   If paa.size eq 0 then return, !NONE
   return, paa.data[0:paa.size-1]
End

Pro PAAreserve, paa, nelements
   If paa.size gt nelements then begin
      Console, /Warning, "PAA data is already bigger " + $
       "than requested reservation. Skipping request."
      return
   EndIf
   If paa.reserved eq nelements then begin
      Console, Level=5, "Requested reservation is already " + $
       "fulfilled. Skipping request."
      return
   EndIf
   
   If paa.reserved gt nelements then $
     Dmsg, "Shrinking reserved memory to " + str(nelements)+"elements." $
   else $
     Dmsg, "Extending reserved memory to " + str(nelements)+" elements."
   

   newpaa = PAAInit(Type=paa.type, Poolsize=paa.poolsize, $
                    Incrementfactor=paa.incrementfactor, $
                    Reserve=nelements)

   If paa.size ne 0 then newpaa.data[0:paa.size-1] = paa.data[0:paa.size-1]
   newpaa.size = paa.size

   paa = Temporary(newpaa)
End
   
Pro PAAappend, paa1, paa2
   newsize = paa1.size+paa2.size
   If newsize gt paa1.reserved then begin
      reserve = paa1.reserved
      repeat begin
         reserve = reserve+paa1.poolsize
         paa1.poolsize = paa1.poolsize*paa1.incrementfactor
      endrep until reserve ge newsize
      PAAreserve, paa1, reserve
   EndIf
      
   paa1.data[paa1.size:paa1.size+paa2.size-1] = paa2.data[0:paa2.size-1]
   paa1.size = paa1.size+paa2.size
End

Pro PAAappendArray, paa1, a2
   a2size = N_Elements(a2)
   newsize = paa1.size+a2size
   If newsize gt paa1.reserved then begin
      reserve = paa1.reserved
      repeat begin
         reserve = reserve+paa1.poolsize
         paa1.poolsize = paa1.poolsize*paa1.incrementfactor
      endrep until reserve ge newsize
      PAAreserve, paa1, reserve
   EndIf
      
   paa1.data[paa1.size:paa1.size+a2size-1] = Temporary(a2)
   paa1.size = paa1.size+a2size
End

Function PAAinit, TYPE=type, $
                  POOLSIZE=poolsize, INCREMENTFACTOR=incrementfactor, $
                  RESERVE=reserve

   Default, TYPE, 4 ;;FLOAT
   Default, POOLSIZE, 100
   Default, RESERVE, POOLSIZE
   Default, INCREMENTFACTOR, 1.0

   paa = { data: Make_Array(RESERVE, $
                            Type=type, /Nozero), $ ;;ULONG=ulong!!!!!!!!
           type: 0l, $
           size: 0ul, $
           poolsize: ULong(POOLSIZE), $
           reserved: ULong(RESERVE), $
           incrementfactor: Float(INCREMENTFACTOR) }
   
   paa.type = (size(paa.data))(2)

   return,  paa
     
End
