;+
; NAME:
;  available()
;
; VERSION:
;  $Id$
;
; AIM:
;  checks, if data is available for read on a logical unit number
;  (LUN)
;
; PURPOSE: 
; Check, if data is waiting on a LUN. I.e. the next attempt to read
; from the LUN wil <B>not</B> block IDL. (Blocking appears on
; device-special files like pipes or FIFOs, if no data ist ready to
; read. In that case no EOF is generated!)
;
; CATEGORY:
;  ExecutionControl
;  Files
;  IO
;  OS
;
; CALLING SEQUENCE:
;*ready = available (lun [,/USE_SELECT] [,/HELP])
;
; INPUTS:
;  lun:: A(n array of) valid IDL-Logical-Unit-Number(s)
;
; INPUT KEYWORDS:
;
;  HELP      :: If set, display informational message
;
;  USE_SELECT:: By default, this procedure calls the C++-implemented
;               function <C>non_block_readable()</C>, which determines
;               the status of the file by starting a non blocking read
;               attempt and catch any error. On systems providing the
;               UNIX <*>select()</*> system function, using
;               <*>select()</*> is a "smarter" solution. The UNIX
;               function <*>select()</*> can be called from NASE via
;               the <A>wait_for_data()</A> (IDL-wrapper) function.<BR>
;               If <C>USE_SELECT</C> is set, <C>available()</C> calls
;               <A>wait_for_data()</A>. <BR>
;               <BR>
;               Note: The usage of <*>select()</*> may lead to
;                     incorrect results on buffered streams. (See
;                     restrictions below.)
; 
; OUTPUTS:
;   ready:: (array of) BOOLEAN: TRUE or FALSE, indicating if a read
;           attempt on the LUN will not block.
;
; RESTRICTIONS:
;   LUN has to be valid and open for reading.<BR>
;   <BR>
;   Note that the <*>select()</*> function is a low-level I/O function
;   call. It bypasses the buffering performed by the
;   stdio-filestreams. This means that by a call to
;   <C>available(/USE_SELECT)</C>, the underlying filedescriptor is
;   tested for available data, regardless of any data already waiting
;   in a filestream-buffer. Thus, <C>available(/USE_SELECT)</C> should
;   best be used on non-buffered files (Keywords <C>BUFSIZE=0</C> and
;   <C>/NOSTDIO</C> in a call to <C>OPEN</C>). This is no drawback, as
;   <C>available(/USE_SELECT)</C> most oftenly will be used with pipes
;   or FIFOs that are inherently memory buffered by the operating
;   system and do not need buffering by the filestreams. However, if
;   you have to test for data available on a buffered stream and get
;   misleading results, do not use the <C>/USE_SELECT</C> option.
;
; PROCEDURE:
;  <C>CALL_EXTERNAL( ... )</C><BR>
;  (Obtain file-descriptors, set NON-BLOCKING-flag on it, attempt to
;  read a character, push it back if seccessfull, reset
;  NON-Blocking-flag)
;
; EXAMPLE:
;*if available(23) then readf, 23, data
;
; SEE ALSO:
;  <A>get_fd()</A>, <A>wait_for_data()</A>, Keyword HELP,
;  documentation of c++-routine in file <*>shared/IDL_IO_support.h</*>
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

   
