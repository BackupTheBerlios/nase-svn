#ifndef IDL_IO_SUPPORT
#define IDL_IO_SUPPORT


/**************************************************************
 *             Routines callable by CALL_EXTERNAL()           *
 **************************************************************

===============================================================================================================
+
 NAME: get_fd()

 PURPOSE: Returns the associated UNIX-File-Descriptor to a IDL Logacal Unit Number 

 CATEGORY: I/O

 CALLING SEQUENCE: fd = CALL_EXTERNAL("foo.so", "get_fd", my_LUN)

 INPUTS: my_LUN (LONG): Exactly one Logical Unit Number

 OUTPUTS: fd (LONG): The associated UNIX-File-Descriptor

 RESTRICTIONS: The LUN has to be valid.
               my_LUN has to be a scalar LONG.

 PROCEDURE: Get FILE Structure by call to IDL_FileStat()
            Get File-Descriptor by call to fileno()

 EXAMPLE: fd = CALL_EXTERNAL("foo.so", "get_fd", my_LUN)

 SEE ALSO: -Call routine with no parameters for informational message-

 MODIFICATION HISTORY: Born on Mar 01 1999

-

===============================================================================================================

+
 NAME: wait_for_data()

 PURPOSE: Check, if data is waiting on one or several LUNs, wait if specified.
          I.e. the next attempt to read from the LUN wil *not* block IDL.
		  (Blocking appears on device-special files like pipes or FIFOs, if no data ist ready to read.
		   In that case no EOF is generated!)

 CATEGORY: I/O

 CALLING SEQUENCE: number_ready=CALL_EXTERNAL("foo.so","wait_for_data", lun_array, N_ELEMENTS_lun_array, secs, microsecs)

 INPUTS: lun_array ([LONG])          : An array of valid IDL-LogicalUnit-Numbers, or a scalar LONG.
         N_ELEMENTS_lun_array (LONG) : N_ELEMENTS(lun_array)
		 secs, microsecs (LONG, LONG): Time to wait for one of the LUNs to get readable.
		                               secs=-1: wait forever
                                       secs=0 and microsecs=0: return immediately

 OUTPUTS: number_ready (LONG):
                >0: Number of LUNs ready for non-blocking read.
				    In this case (only!) lun_array will be changed to a boolean mask, indicating wich LUNs are readable
				 0: Time out before any LUN was readable
				-1: An error occured. This can be a signal caught from IDL, although IDL-Timer-Signals
				    are suspended during execution of wait_for_data().

 OPTIONAL OUTPUTS: If wait_for_data() returns a number >0, lun_array is changed to contain a boolean mask to the
                   LUNs that are ready for non-blocking read.
				   Obtain an array of readable LUNs with "readable = original_lun_array(WHERE(lun_array))"

 SIDE EFFECTS: IDL timer signals are suspended during execution.

 RESTRICTIONS: LUNs have to be valid and open for reading
               Works only on systems supporting the select() system-function. Use non_block_readable() on other systems!
			   This routine checks only for reading. Could be changed to check for writing quite easily.
               (See documentation of select())

 PROCEDURE: Obtain file-descriptors, call select()

 EXAMPLE: lun_arr=[lun1, lun2]
          orig_lun_arr=lun_arr
		  number_ready=CALL_EXTERNAL("foo.so","wait_for_data",lun_arr,N_ELEMENTS(lun_arr), -1, -1) ;wait
		  if (number_ready gt 0) then readable=orig_lun_arr(WHERE(lun_arr))

 SEE ALSO: -Call routine with no parameters for informational message-
           documentation of select()

 MODIFICATION HISTORY: Born on Mar 01 1999 

-

===============================================================================================================

+
 NAME: non_block_readable()

 PURPOSE: Check, if data is waiting on al LUN.
          I.e. the next attempt to read from the LUN wil *not* block IDL.
		  (Blocking appears on device-special files like pipes or FIFOs, if no data ist ready to read.
		   In that case no EOF is generated!)

 CATEGORY: I/O

 CALLING SEQUENCE: ready=CALL_EXTERNAL("foo.so","non_block_readable", lun)

 INPUTS: lun (LONG): A valid IDL-Logical-Unit-Number

 OUTPUTS: ready (BOOLEAN): TRUE or FALSE, indicating if a read attempt on the LUN will not block.
 
 RESTRICTIONS: LUN has to be valid and open for reading

 PROCEDURE: Obtain file-descriptors, set NON-BLOCKING-flag on it, attempt to read a character,
            push it back if seccessfull, reset NON-Blocking-flag

 EXAMPLE: ready=CALL_EXTERNAL("foo.so","non_block_readable",lun)
		  if (ready) readf, lun, data

 SEE ALSO: -Call routine with no parameters for informational message-

 MODIFICATION HISTORY: Born on Mar 01 1999

-

===============================================================================================================

        $Log$
        Revision 1.6  2003/01/15 16:48:58  kupper
        Das C++-File IDL_IO_support.cc wurde in ein Standard-C-File
        umgewandelt, da das Compilieren und Linken mit IDL bei C++-Files immer
        wieder Schwierigkeiten machte. Im wesentlichen enthielt das File
        ohnehin nur C-Code.

        Revision 1.1.1.2  2001/08/24 13:48:42  synod
        include newest widget objects, consoles, etc.

        Revision 1.5  2001/08/22 16:16:25  kupper
        added set_nonblocking and set_blocking calls.
        non_block_readable does not work any more with IDL5.4 (buffering problems???)

        Revision 1.4  2001/08/16 17:26:03  kupper
        Added tmp_nam function for getting a temporary filename.

        Revision 1.3  2000/08/04 15:13:02  kupper
        Added system variable !NASEDIR.

        NASE C lib is now located in each users nase directory (no system wide
        install).
        The library is checked at startup and compiled if it doesn't exist.

        Revision 1.2  1999/03/05 14:28:32  kupper
        IDL-Wrapper-Routinen jetzt fertig.

        Revision 1.1  1999/03/04 16:36:21  kupper

        Erster Commit.
        Wrapper-Routinen in IDL folgen demn�chst...


*/

IDL_LONG   get_fd             (int argc, void* argv[]);
IDL_LONG   wait_for_data      (int argc, void* argv[]);
IDLBool_t  non_block_readable (int argc, void* argv[]);
IDL_LONG   set_nonblocking    (int argc, void* argv[]);
IDL_LONG   set_blocking       (int argc, void* argv[]);
char*      tmp_nam            (int argc, void* argv[]);





/****************************************************************
 *     Internal Routines:                                       *
 ****************************************************************/

int get_fd_intern (IDL_LONG lun); // returns filedescriptor for IDL-LUN
int get_fd_array (IDL_LONG *lun_array, int n_elements, int *fd_array); //fills fd_array, returns max(fd_array)

#endif
