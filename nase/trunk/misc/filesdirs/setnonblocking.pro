;+
; NAME:
;  SetNonblocking
;
; VERSION:
;  $Id$
;
; AIM:
;  Enable non-blocking I/O on a file.
;
; PURPOSE:
;  By default, IDL always opens a file in blocking I/O mode. I.e., if
;  the user tries to read from the file, and no data is
;  available<SUP>*)</SUP>, IDL sleeps until data becomes
;  available. <C>SetNonblocking</C> enables non-blocking I/O on an
;  IDL file. If the user tries to read from the file, and no data is
;  available, IDL will issue an I/O error. This error can be caught by
;  an <C>ON_IOERROR</C> call.<BR>
;  <BR> 
;  <SUP>*)</SUP> This means, there is nothing to read, although the file is not
;  EOF, which is very often the case when reading from a UNIX pipe or
;  fifo, or from a file that is open for writing by another
;  process.)<BR>
;  <BR> 
;  <I>Note that a file needs to be opened with the <C>/STDIO</C> keyword to
;  <C>OPEN[RWU]</C> for this routine to work!</I> This routine is a
;  wrapper to a C++ function, which is compiled into the NASE support
;  library.
;
; CATEGORY:
;  Files
;  IO
;  OS
;
; CALLING SEQUENCE:
;*SetNonblocking, LUN
;
; INPUTS:
;  LUN:: The logical unit number of the file. This file must have been
;        opened for reading, and with the keyword <C>/STDIO</C> set in
;        the <C>OPEN</C> call.
;
; RESTRICTIONS:
;  A file needs to be opened with the <C>/STDIO</C> keyword to
;  <C>OPEN[RWU</C>] for this routine to work.
;
; PROCEDURE:
;  Link to external C++ code via <C>CALL_EXTERNAL</C>. The code
;  retrieves the stdio-filepointer from the LUN, then retrieves the
;  UNIX-filedescriptor from the filepointer, then sets the
;  non-blocking flag on this filedescriptor, and returns.
;
; EXAMPLE:
;*$mkfifo testfifo
;*openw,23,"testfifo"
;*openr,24,"testfifo",/Stdio
;*printf,23,"line1"
;*printf,23,"line2"
;*printf,23,"line3"
;*setnonblocking,24
;*l=""
;*while 1 do begin & readf,24,l & print,l & endwhile
;*>line1
;*>line2
;*>line3
;*>% READF: Error encountered reading from file. Unit: 24
;*>         File: testfifo
;*>  Resource temporarily unavailable
;*>% Execution halted at:  $MAIN$  
;  Note: Try this example without the <C>SetNonblocking</C> command!
;        (Caution: IDL will not return!)
;
; SEE ALSO:
;  <A>SetBlocking</A>, <A>TryReadF</A>, <A>Available</A>,
;  <C>ON_IOERROR</C>.
;-

Pro SetNonblocking, lun
   dummy = Call_External (!NASE_LIB, "set_nonblocking", lun)
End
