;+
; NAME: get_fd()
;
; PURPOSE: Returns the associated UNIX-File-Descriptor to a IDL Logacal Unit Number
;
; CATEGORY: I/O
;
; CALLING SEQUENCE: fd = get_fd(my_LUN, [/HELP])
;
; INPUTS: my_LUN: A(n Array of) Logical Unit Number(s)
;
; KEYWORD PARAMETERS: HELP: Display informational message
;
; OUTPUTS: fd (LONG): The associated UNIX-File-Descriptor(s)
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
;        Revision 2.2  1999/03/05 20:25:39  kupper
;        Also:
;        1) Get_fd() und non_block_readable() können jetzt wie "brave" IDL-Routinen
;        auch Arrays verarbeiten.
;        2) Wait_for_data() kann in BOOL_MASK optional die Maske der lesbaren LUNs zurückliefern.
;        3) non_block_readable() kann mit /USE_SELECT angewiesen werden, die UNIX select()
;           Funktion zu benutzen, anstatt wild drauflos Leseversuche zu starten.
;           Auf Systemen, die das unterstützen (SVR4 und 4.3+BSD und ?), ist das die Methode der Wahl.
;           (Man könnte drüber nachdenken, eine Systemvariable zu machen, die das anzeigt...)
;
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

   
   If (size(lun))(0) eq 0 then begin ; lun is a scalar

      if (lun lt -2) then message, "Not a valid LUN: "+str(lun)

      return, Call_External (!NASE_LIB, "get_fd", LONG(lun))

   endif else begin             ; It's an array!
      
      if (total(lun lt -2) gt 0) then message, "Array contains non-valid LUNs!"
 
      bool_mask = lun-lun       ; all 0
      for i=0, n_elements(bool_mask)-1 do bool_mask(i) = Call_External (!NASE_LIB, "get_fd", lun(i))
      
      return, bool_mask

   endelse

end

   
