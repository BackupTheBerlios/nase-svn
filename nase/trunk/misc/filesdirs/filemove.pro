;+
; NAME:
;  FileMove
;
; VERSION:
;  $Id$
;
; AIM:
;  Moves a file to a new location.
;
; PURPOSE:
;  This routines provides a operating system independent way to move a
;  file to a specific location. It is unbelievable that IDL itself,
;  doesn't provide such a functionality.
;
; CATEGORY:
;  Files
;
; CALLING SEQUENCE:
;* FileMove, src, dest
;
; INPUTS:
;   src  :: filepath to source file
;   dest :: filepath to destination file or destination directory
;
; EXAMPLE:
;* FileMove, "data1", "data2"
;
; SEE ALSO:
;   <A>FileDel</A>, <A>FileCopy</A>
;
;-
PRO FileMove, src, dest

ON_Error, 2

FileCopy, src, dest
FileDel, src

END
