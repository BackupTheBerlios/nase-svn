;+
; NAME: available()
;
; PURPOSE: Check, if data is waiting on a LUN.
;          I.e. the next attempt to read from the LUN wil *not* block IDL.
;		  (Blocking appears on device-special files like pipes or FIFOs, if no data ist ready to read.
;		   In that case no EOF is generated!)
;
; CATEGORY: I/O
;
; CALLING SEQUENCE: ready = available (lun [,/USE_SELECT] [,/HELP])
;
; INPUTS: lun: A(n array of) valid IDL-Logical-Unit-Number(s)
;
; KEYWORD PARAMETERS: HELP: If set, display informational message

;                     USE_SELECT: By default, this procedure calls the 
;                                 C++ function non_block_readable(), which
;                                 determines the status of the file by starting a
;                                 non blocking read attempt and catch any error.
;                                 On systems providing the UNIX select() function, 
;                                 using select is a "smarter" solution. select()
;                                 can be called via the wait_for_data (C++ or
;                                 IDL-wrapper) function.
;                                 If USE_SELECT is set, this function
;                                 calls wait_for_data().
;                                 Note: The usage of select() may lead 
;                                 to different results on
;                                 buffered streams. (See
;                                 restrictions below.)
;                     
;
; OUTPUTS: ready ( (array of) BOOLEAN): TRUE or FALSE, indicating if a read attempt on the LUN will not block.
;
; RESTRICTIONS: LUN has to be valid and open for reading.
;
;               Note that the select() function is a low-level
;               I/O function call. It bypasses the buffering
;               performed by the stdio-filestreams. This means
;               that by a call to available(/USE_SELECT), the
;               underlying filedescriptor is tested for
;               available data, regardless of any data already
;               waiting in a filestream-buffer. Thus,
;               available(/USE_SELECT) should best be used on
;               non-buffered files (Keyword BUFSIZE=0 or
;               /NOSTDIO in a call to OPEN). This is no
;               drawback, as available(/USE_SELECT) most oftenly will
;               be used with pipes or FIFOs that are inherently
;               memory buffered by the operating system and do
;               not need buffering by the filestreams.
;               However, if you have to test for data available
;               on a buffered stream and get misleading results,
;               do not use the /USE_SELECT option.
;
; PROCEDURE: CALL_EXTERNAL( ... )
;            (Obtain file-descriptors, set NON-BLOCKING-flag on it, attempt to read a character,
;            push it back if seccessfull, reset NON-Blocking-flag)
;
; EXAMPLE: if available(23) then readf, 23, data
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
;        Revision 2.3  1999/09/13 13:46:59  kupper
;        Added warning about buffered streams and use of select(). (See Restrictions)
;
;        Revision 2.2  1999/09/10 13:00:54  kupper
;        Re-corrected some names in the Header after renaming the file.
;
;        Revision 2.1  1999/09/10 12:55:59  kupper
;        Changed Name from "non_block_readable()" to "available()".
;
;        Revision 2.3  1999/09/10 12:51:43  kupper
;        Changed Name from "non_block_readable()" to "available()".
;
;        Revision 2.2  1999/03/05 20:25:40  kupper
;        Also:
;        1) Get_fd() und non_block_readable() können jetzt wie "brave" IDL-Routinen
;        auch Arrays verarbeiten.
;        2) Wait_for_data() kann in BOOL_MASK optional die Maske der lesbaren LUNs zurückliefern.
;        3) non_block_readablee() kann mit /USE_SELECT angewiesen werden, die UNIX select()
;           Funktion zu benutzen, anstatt wild drauflos Leseversuche zu starten.
;           Auf Systemen, die das unterstützen (SVR4 und 4.3+BSD und ?), ist das die Methode der Wahl.
;           (Man könnte drüber nachdenken, eine Systemvariable zu machen, die das anzeigt...)
;
;        Revision 2.1  1999/03/05 14:30:22  kupper
;        Geburt der Wrapper-Routinen für CALL_EXTERNAL.
;
;-

Function available, lun, HELP=HELP, USE_SELECT=USE_SELECT

   ;;------------------> Keyword HELP
   If Keyword_Set(HELP) then begin
      message, /INFORM, !KEY.ENTER+$
       "available() ruft die C++-Routine non_block_readable() in der shared library "+!NASE_LIB+" auf."+!KEY.ENTER+$
       !KEY.ENTER+$
       "Hinweistext der C++-Routine:"
      dummy = Call_External (!NASE_LIB, "non_block_readable") ;Aufruf ohne Argument zeigt Hinweistext an und endet. 
   end
   ;;--------------------------------


   If (size(lun))(0) eq 0 then begin ; lun is a scalar
      
      if (lun lt -2) then message, "Non-valid LUN: "+str(lun)
      
      If Keyword_set(USE_SELECT) then Return, total(Wait_for_Data(lun, SECS=0, MICROSECS=0)) NE !NONE $
      else Return, Call_External (!NASE_LIB, "non_block_readable", lun)
      
   endif else begin             ; It's an array!
      
      if (total(lun lt -2) gt 0) then message, "Array contains non-valid LUNs!"
      
      If Keyword_set(USE_SELECT) then begin
         dummy = total(Wait_for_Data(lun, SECS=0, MICROSECS=0, BOOL_MASK=bool_mask))
      endif else begin
         bool_mask = lun-lun    ; all 0
         for i=0, n_elements(bool_mask)-1 do bool_mask(i) = Call_External (!NASE_LIB, "non_block_readable", lun(i))
      endelse
      
      Return, bool_mask
      
   endelse
   
end

   
