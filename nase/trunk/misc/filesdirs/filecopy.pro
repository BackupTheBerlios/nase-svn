;+
; NAME:
;  FileCopy
;
; VERSION:
;  $Id$
;
; AIM:
;  Copies a file
;
; PURPOSE:
;  This routines provides a operating system independent way to copy a
;  file to a specific location. It is unbelievable that IDL itself,
;  doesn't provide such a functionality.
;
; CATEGORY:
;  Files
;
; CALLING SEQUENCE:
;*FileCopy, src, dest
;
; INPUTS:
;   src  :: filepath to source file
;   dest :: filepath to destination file or destination directory
;
; EXAMPLE:
;*FileCopy, "data1", "data2"
;
; SEE ALSO:
;   <A>FileDel</A>, <A>FileMove</A>
;
;-

PRO FileCopy, src, dest

ON_Error, 2

IF (fix(!VERSION.Release) GE 4) THEN OS_FAMILY=!version.OS_FAMILY ELSE OS_FAMILY='unix'
CASE OS_FAMILY OF
    "unix"   : c = command("cp")
    "Windows": c = "copy"
    ELSE     : Console, [OS_FAMILY, " not supported...yet"], /FATAL
END

Spawn, c+' "'+str(src)+'" "'+str(dest)+'"', r

END
