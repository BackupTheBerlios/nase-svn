;+
; NAME: get_fd()
;
; PURPOSE: Returns the associated UNIX-File-Descriptor to a IDL Logacal Unit Number
;
; CATEGORY: I/O
;
; CALLING SEQUENCE: fd = get_fd(my_LUN, [/HELP])
;
; INPUTS: my_LUN: Exactly one Logical Unit Number
;
; KEYWORD PARAMETERS: HELP: Display informational message
;
; OUTPUTS: fd (LONG): The associated UNIX-File-Descriptor
;          -1 (LONG) if the LUN is invalid.
;
; RESTRICTIONS: The LUN has to be valid
;
; PROCEDURE: This is a wrapper to the C++-Function get_fd() in
;            nasec.so called via CALL_EXTERNAL
;
; EXAMPLE: fd = get_fd (my_LUN)
;
; SEE ALSO: <A HREF="#WAIT_FOR_DATA">wait_for_data()</A>, 
;           <A HREF="#NON_BLOCK_READABLE">non_block_readable()</A>, 
;           Keyword /HELP, 
;           documentation of C++-Routine in shared/IDL_IO_support.h
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.1  1999/03/05 14:30:21  kupper
;        Geburt der Wrapper-Routinen für CALL_EXTERNAL.
;
;-

Function Get_fd, lun, HELP=HELP

   ;;------------------> Keyword HELP
   If Keyword_Set(HELP) then begin
      message, /INFORM, !KEY.ENTER+$
       "Get_fd() ruft die C++-Routine get_fd() in der shared library "+!NASE_LIB+" auf."+!KEY.ENTER+$
       !KEY.ENTER+$
       "Hinweistext der C++-Routine:"
      dummy = Call_External (!NASE_LIB, "get_fd") ;Aufruf ohne Argument zeigt Hinweistext an und endet. 
   end
   ;;--------------------------------

   
   if (lun lt -2) then message, "Not a valid LUN: "+str(lun)

   return, Call_External (!NASE_LIB, "get_fd", LONG(lun))

end

   
