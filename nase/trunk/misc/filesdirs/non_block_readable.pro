;+
; NAME: non_block_readable()
;
; PURPOSE: Check, if data is waiting on a LUN.
;          I.e. the next attempt to read from the LUN wil *not* block IDL.
;		  (Blocking appears on device-special files like pipes or FIFOs, if no data ist ready to read.
;		   In that case no EOF is generated!)
;
; CATEGORY: I/O
;
; CALLING SEQUENCE: ready = non_block_readable (lun [,/HELP])
;
; INPUTS: lun: A valid IDL-Logical-Unit-Number
;
; OUTPUTS: ready (BOOLEAN): TRUE or FALSE, indicating if a read attempt on the LUN will not block.
;
; RESTRICTIONS: LUN has to be valid and open for reading
;
; PROCEDURE: CALL_EXTERNAL( ... )
;            (Obtain file-descriptors, set NON-BLOCKING-flag on it, attempt to read a character,
;            push it back if seccessfull, reset NON-Blocking-flag)
;
; EXAMPLE: if non_block_readable(23) then readf, 23, data
;
;
; SEE ALSO: <A HREF="#GET_FD">get_fd()</A>,
;           <A HREF="#WAIT_FOR_DATA">wait_for_data()</A>,
;           Keyword HELP,
;           documentation of c++-routine in shared/IDL_IO_support.h
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1999/03/05 14:30:22  kupper
;        Geburt der Wrapper-Routinen für CALL_EXTERNAL.
;
;-

Function non_block_readable, lun, HELP=HELP

   ;;------------------> Keyword HELP
   If Keyword_Set(HELP) then begin
      message, /INFORM, !KEY.ENTER+$
       "non_block_readable() ruft die C++-Routine non_block_readable() in der shared library "+!NASE_LIB+" auf."+!KEY.ENTER+$
       !KEY.ENTER+$
       "Hinweistext der C++-Routine:"
      dummy = Call_External (!NASE_LIB, "non_block_readable") ;Aufruf ohne Argument zeigt Hinweistext an und endet. 
   end
   ;;--------------------------------

   if (lun lt -2) then message, "Non-valid LUN: "+str(lun)
   
   Return, Call_External (!NASE_LIB, "non_block_readable", lun)

end

   
