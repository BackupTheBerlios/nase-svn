;+
; NAME:
;  TmpNam()
;
; VERSION:
;  $Id$
;
; AIM:
;  Generate a string that is a valid non-existing file name.
;
; PURPOSE:
;  The <C>TmpNam()</C> function generates a string that is a valid
;  filename and that is not the name of an existing file. The
;  <C>TmpNam()</C> function generates a different name each time it is
;  called (up to a number of times that is given by the C-constant
;  TMP_MAX).<BR>
;  <C>TmpNam()</C> is a wrapper to the UNIX/POSIX tmpnam() kernel
;  function. It is linked via the nase shared C library.
;
; CATEGORY:
;  DataStorage
;  Files
;  IO
;  OS
;
; CALLING SEQUENCE:
;*result = TmpNam()
;
; OUTPUTS:
;  result:: A string specifying a valid non-existing filename.
;
; PROCEDURE:
;  Link to nase.so via CALL_EXTERNAL.N
;  For further details see the  "POSIX Programmer's Guide" or any
;  other standard works on UNIX/POSIX.
;
; EXAMPLE:
;*help, TmpNam()
;*><Expression>    STRING    = '/tmp/file4wRmgb'
;
; SEE ALSO:
;  the <C>IDL_TMPDIR</C> environment variable.
;-

Function TmpNam
   return, Call_External (!NASE_LIB, "tmp_nam",/S_value)
End
