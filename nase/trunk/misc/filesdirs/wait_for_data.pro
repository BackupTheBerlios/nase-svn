;+
; NAME: wait_for_data()
;
; PURPOSE: Check, if data is waiting on one or several LUNs, wait if specified.
;          I.e. the next attempt to read from the LUN wil *not* block IDL.
;		  (Blocking appears on device-special files like pipes or FIFOs, if no data ist ready to read.
;		   In that case no EOF is generated!)
;
; CATEGORY: I/O
;
; CALLING SEQUENCE: ready_array=wait_for_data(lun_array [,SECS=secs, MICROSECS=microsecs]
;                                                       [,BOOL_MASK=bool_mask] [,/HELP])
;
; INPUTS: lun_array           : An array of valid IDL-Logical-Unit-Numbers, or a scalar LONG.
;
; KEYWORED PARAMETERS: SECS, MICROSECS: Time to wait for one of the LUNs to get readable.
;		                        SECS=-1 or not specified: wait forever
;                                       SECS=0 and MICROSECS=0: return immediately
;
;                      HELP           : Information
;
; OUTPUTS: ready_array: Array of non-blocking readable LUNS (a subset of lun_array)
;                       !NONE on error, or if time out before any LUN was readable
;
; OPTIONAL OUTPUTS: An informational message is issued if an error occurs.
;                   BOOL_MASK: A boolean mask (Array, size of lun_array), indicating which LUNs are readable.
;                   It is ready_array=lun_array(where(BOOL_MASK)).
;
; SIDE EFFECTS: IDL timer signals are suspended during execution.
;
; RESTRICTIONS: LUNs have to be valid and open for reading
;               Works only on systems supporting the select() system-function. Use non_block_readable() on other systems!
;	        This routine checks only for reading. Could be changed to check for writing (quite?) easily.
;               (See documentation of select())
;
; PROCEDURE: CALL_EXTERNAL(!NASE_LIB,"wait_for_data", ...)
;
; EXAMPLE: 
;		  ready_luns=wait_for_data([lun1,lun2,lun3]) ;wait forever
;		  if n_elements(ready_luns) gt 0 then readf, ready_luns[0], data
;
; SEE ALSO: <A HREF="#GET_FD">get_fd()</A>,
;           <A HREF="#NON_BLOCK_READABLE">non_block_readable()</A>,
;           documentation of c++-routine in shared/IDL_IO_support.h
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  1999/03/05 20:25:40  kupper
;        Also:
;        1) Get_fd() und non_block_readable() können jetzt wie "brave" IDL-Routinen
;        auch Arrays verarbeiten.
;        2) Wait_for_data() kann in BOOL_MASK optional die Maske der lesbaren LUNs zurückliefern.
;        3) non_block_readable() kann mit /USE_SELECT angewiesen werden, die UNIX select()
;           Funktion zu benutzen, anstatt wild drauflos Leseversuche zu starten.
;           Auf Systemen, die das unterstützen (SVR4 und 4.3+BSD und ?), ist das die Methode der Wahl.
;           (Man könnte drüber nachdenken, eine Systemvariable zu machen, die das anzeigt...)
;
;        Revision 2.1  1999/03/05 14:30:22  kupper
;        Geburt der Wrapper-Routinen für CALL_EXTERNAL.
;
;-

Function wait_for_data, lun_array ,SECS=secs, MICROSECS=microsecs, BOOL_MASK=BOOL_MASK, HELP=HELP

   ;;------------------> Keyword HELP
   If Keyword_Set(HELP) then begin
      message, /INFORM, !KEY.ENTER+$
       "Wait_for_data() ruft die C++-Routine wait_for_data() in der shared library "+!NASE_LIB+" auf."+!KEY.ENTER+$
       !KEY.ENTER+$
       "Hinweistext der C++-Routine:"
      dummy = Call_External (!NASE_LIB, "wait_for_data") ;Aufruf ohne Argument zeigt Hinweistext an und endet. 
   end
   ;;--------------------------------

   if (total(lun_array lt -2) gt 0) then message, "Array contains non-valid LUNs!"
   
   Default, SECS, -1
   Default, MICROSECS, 0

   temp_luns = LONG(lun_array)

   number_ready = Call_External (!NASE_LIB, "wait_for_data", temp_luns, N_ELEMENTS(temp_luns), SECS, MICROSECS)
   
   if (number_ready gt 0) then BOOL_MASK = temp_luns else BOOL_MASK = (lun_array-lun_array);all 0

   Case number_ready of
      
      0 : Return, !NONE
      
      -1: $
       begin
         Message, /INFORM, "An error occured, or a signal was caught during execution!"
         Return, !NONE
      end
      
      else: Return, lun_array(where(temp_luns))
   EndCase

end

   
