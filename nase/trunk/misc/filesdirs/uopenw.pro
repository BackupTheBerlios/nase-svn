;+
; NAME:
;  UOpenW()
;
; AIM:
;  opens a file for read/write access (generalizes IDL's <C>OpenW</C> function)
;
; PURPOSE:
;  This routine extends IDLs <C>OpenW</C> with a simpler Handling of
;  the LUNs and additionally allows file compression for IDL older
;  versions. New IDL version should use <*>/COMPRESS</*> because no
;  temporary file is created.
;
; CATEGORY:
;  Files
;  IO
;
; CALLING SEQUENCE:
;  lun = UOpenW(file [,/VERBOSE] [,/ZIP] [,_EXRA=...])
;
; INPUTS:
;  file:: file to be opened
;
; KEYWORD PARAMETERS:
;  VERBOSE:: some debugging output is generated
;  ZIP    :: compresses file after it is closed, consider using IDLs
;            <*>/COMPRESS</*>, if available.
;  FORCE  :: non-existent directories will be
;            created. This behaviour may be set to
;            the default, by setting the system
;            variable <*>!CREATEDIR</*> to 1.
;
; OUTPUTS:
;  lun : LogicalUnitNumber of the file or <*>!NONE</*> if the action failed
;
; COMMON BLOCKS:
;  UOPENR:: contains filenames and status of all open files
;
; RESTRICTIONS:
;  the number of simulaneously open files is currently restricted to 40
;
; SEE ALSO:
;  <A>UOpenR</A>, <A>UClose</A>
;
;-
FUNCTION UOpenW, file, VERBOSE=verbose, ZIP=zip, FORCE=force, _EXTRA=e

   COMMON UOPENR, llun
   On_Error, 2

   MaxFiles = 97
   Default, ZIP, 0
   Default, FORCE, !CREATEDIR


   IF N_Params() NE 1 THEN CONSOLE,' exactly one argument expected', /FATAL
   

   IF NOT Set(llun) THEN BEGIN
      llun = { lun  : Make_Array(maxFiles, /LONG, VALUE=!NONE), $
               file : StrArr(maxFiles), $
               zip  : BytArr(maxFiles), $
               act  : 0l                }
   END

   IF llun.act EQ MaxFiles THEN BEGIN
      Console, 'UOpenW: sorry, already maximum number of files (',STRCOMPRESS(MaxFiles,/REMOVE_ALL),') open', /WARN
      RETURN, !NONE
   END


   ; get a free entry
   idx = MIN(WHERE(llun.lun EQ !NONE, c))
   IF c EQ 0 THEN Console, 'this should not happen', /FATAL

   llun.zip(idx) = zip


   ; create non-existing dirs if wanted
   IF Keyword_Set(FORCE) THEN BEGIN
       pf = FileSplit(file)
       IF pf(0) NE '' THEN mkdir, pf(0)
   END


   ; probe for unused lun
   lun = 2 ; reserved for stdin/stdout/stderr
   REPEAT BEGIN
       lun = lun + 1
       Openw, lun, file, ERROR=err, _EXTRA=e
   END UNTIL ((lun GT 2+MaxFiles) OR (err EQ 0))
   IF (lun GT 2+MaxFiles) THEN Console, 'unable to aquire a lun: '+!ERR_STRING, /FATAL

   
   llun.lun(idx)  = lun & llun.act=llun.act+1
   llun.file(idx) = file
   
   
   RETURN, lun

END
