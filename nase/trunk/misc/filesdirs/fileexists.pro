;+
; NAME:
;  FileExists()
;
; AIM:
;  tests the existence of a given file;
;
; PURPOSE:
;  To test whether the passed filename exists and optionally return the file statistics (IDL structure FStat)
;  and file information (shell command; only under UNIX).
;
; CATEGORY:
;  DataStorage
;  Dirs
;  ExecutionControl
;  Files
;  IO
;
; CALLING SEQUENCE:
;* out = FileExists(file [, STAT=...] [, INFO=...])
;
; INPUTS:
;  file::  A string scalar containing the name of the file whose existence is to be tested.
;
; OUTPUTS:
;  out::  A boolean expression which is true (=1) if the specified file exists and false (=0) if not.
;
; OPTIONAL OUTPUTS:
;  STAT::  Set this keyword to a named variable which will contain the file statistics in an IDL-FStat structure
;          if the specified file exists (if it does not exist, no changes are made to the named variable).
;  INFO::  Set this keyword to a named variable which will contain the result of the <*>file</*> command
;          if the specified file exists (if it does not exist, no changes are made to the named variable).
;          This keyword has no effect under WINDOWS.
;
; PROCEDURE:
;  This function tries to open the specified file via <*>OpenR</*> and proceeds depending on the error variable
;  returned by <*>OpenR</*>.
;
; EXAMPLE:
;* Info = 1  &  Stat = 1
;* Print, FileExists('d:/temp/test.doc', INFO = Info, STAT = Stat)
;* Print, Info
;* Help , Stat, /str
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/11/28 13:24:07  bruns
;     * translated doc header
;     * fixed syntax violations in the doc header
;     * established compatibility to WINDOWS
;
;     Revision 2.3  2000/09/25 09:13:02  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.2  1998/03/16 17:42:46  saam
;           now hopefully works with IDL5
;
;     Revision 2.1  1998/02/24 08:40:52  saam
;           zip-zip-zippi-die-dip
;
;-



FUNCTION  FileExists, file,   STAT = STAT, INFO = INFO

   OpenR, lun, file, /GET_LUN, ERROR = Err

   IF  Err EQ 0  THEN  BEGIN

     IF  Keyword_Set(stat)  THEN  Stat = FStat(lun)
     IF  Keyword_Set(info) AND (StrUpCase(!Version.OS_Family) EQ 'UNIX')  THEN  BEGIN
       Spawn, 'file '+file, r
       Info = r[0]
     END
     Close, lun
     Free_Lun, lun

     Return, 1

   ENDIF  ELSE  Return, 0

END
