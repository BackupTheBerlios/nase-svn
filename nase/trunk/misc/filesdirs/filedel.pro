;+
; NAME:
;  FileDel
;
; VERSION:
;  $Id$
;
; AIM:
;  Deletes a file
;
; PURPOSE:
;  This routines provides a operating system independent way to delete a
;  file. It is unbelievable that IDL itself,
;  didn't provide such a functionality up to IDL5.3. Since IDL5.4 file
;  deleting is supported, and this routine simply passes the call on
;  to IDL's FILE_DELETE procedure.
;
; CATEGORY:
;  Files
;
; CALLING SEQUENCE:
;* FileDel, file
;
; INPUTS:
;   file :: file to delete
;
; EXAMPLE:
;* FileDel, "../data1"
;
; SEE ALSO:
;   <A>FileCopy</A>, <A>FileMove</A>
;
;-
PRO FileDel, src

   If IDLVersion(/float) ge 5.4 then begin
      FILE_DELETE, src
      return
   endif

ON_Error, 2

IF (fix(!VERSION.Release) GE 4) THEN OS_FAMILY=!version.OS_FAMILY ELSE OS_FAMILY='unix'
CASE OS_FAMILY OF
    "unix"   : c = command("rm")
    "Windows": c = "del"
    ELSE     : Console, [OS_FAMILY, " not supported...yet"], /FATAL
END

Spawn, c+' "'+str(src)+'"', r

END
