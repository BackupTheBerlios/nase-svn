;+
; NAME:
;  wait_for_data()
;
; VERSION:
;  $Id$
;
; AIM:
;  waits for data on severals logical unit numbers (LUNs)
;
; PURPOSE:
;   Check, if data is waiting on one or several LUNs (wait for it if
;   specified). I.e. the next attempt to read from the LUN wil *not*
;   block IDL. <BR>
;   <I>Note</I>: Blocking appears on device-special files like pipes
;                or FIFOs, if no data ist ready to read. In that case
;                no EOF is generated!
;
; CATEGORY:
;  ExecutionControl
;  Files
;  IO
;  OS
;
; CALLING SEQUENCE:
;*ready_array = wait_for_data(lun_array [,SECS=secs, MICROSECS=microsecs]
;                                       [,BOOL_MASK=bool_mask] [,/HELP])
;
; INPUTS:
;  lun_array:: An array of valid IDL-Logical-Unit-Numbers, or a scalar
;              LONG.
;
; INPUT KEYWORDS:
;
;   SECS, MICROSECS:: Time to wait for one of the LUNs to get readable.
;                     <C>SECS=-1</C> or not specified: wait forever
;                     <C>SECS=0</C> and <C>MICROSECS=0</C>: return immediately
;
;   HELP           :: Show some information on routine usage.
;  
;
; OUTPUTS:
;   ready_array:: Array of non-blocking readable LUNS (a subset of
;                 lun_array) <C>!NONE</C> on error, or if time out before any
;                 LUN was readable.
; 
;
; OPTIONAL OUTPUTS:
;   An informational message is issued if an error occurs.
;
;   BOOL_MASK:: A boolean mask (Array, size of lun_array), indicating
;               which LUNs are readable. 
;
;   It is <*>ready_array = lun_array(where(BOOL_MASK)).</*>
;  
;
; SIDE EFFECTS:
;  IDL timer signals are suspended during execution.
;
; RESTRICTIONS:
;   LUNs have to be valid and open for reading.<BR>
;
;   Works only on systems supporting the <*>select()</*>
;   system-function. Use <A>non_block_readable()</A> on other
;   systems!<BR>
; 
;   This routine checks only for reading. Could be changed to check
;   for writing (quite?) easily. (See documentation of
;   <*>select()</*>.)<BR>
; 
;   Note that the <*>select()</*> function is a low-level I/O function
;   call. It bypasses the buffering performed by the
;   stdio-filestreams. This means that by a call to
;   <C>wait_for_data()</C>, the underlying filedescriptor is tested
;   for available data, regardless of any data already waiting in a
;   filestream-buffer. Thus, <C>wait_for_data()</C> should best be
;   used on non-buffered files (Keyword <C>BUFSIZE=0</C> or
;   <C>/NOSTDIO</C> in a call to <C>OPEN</C>). This is no drawback, as
;   <C>wait_for_data()</C> most oftenly will be used with pipes or
;   FIFOs that are inherently memory buffered by the operating system
;   and do not need buffering by the filestreams. However, if you have
;   to test for data available on a buffered stream and get misleading
;   results from <C>wait_for_data()</C>, use <A>available()</A>
;   instead.
;  
; PROCEDURE:
;  <C>CALL_EXTERNAL(!NASE_LIB,"wait_for_data", ...)</C>
;
; EXAMPLE:
;*ready_luns = wait_for_data([lun1,lun2,lun3]) ;wait forever
;*if n_elements(ready_luns) gt 0 then readf, ready_luns[0], data
;
; SEE ALSO:
;  <A>get_fd()</A>, <A>available()</A>,
;  documentation of c++-routine in shared/IDL_IO_support.h
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

   number_ready = Call_External (!NASE_LIB, "wait_for_data", temp_luns, N_ELEMENTS(temp_luns), LONG(SECS), LONG(MICROSECS))
   
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

   
