;+
; NAME:                UOpenW
;
; PURPOSE:             Erweitert die Funktionalitaet von OpenW, um die 
;                      Faehigkeit gezippte Files zu erzeugen.
;
; CATEGORY:            FILES+DIRS ZIP
;
; CALLING SEQUENCE:    lun = UOpenW(file [,/VERBOSE] [,/ZIP] [,/FORCE])
;
; INPUTS:              file: die zu oeffnende Datei (ohne ZIP-Endung)
;
; KEYWORD PARAMETERS:  VERBOSE: die Routine wird geschwaetzig
;                      ZIP    : das File wird nach dem Schliessen gezippt
;                      FORCE  : non-existent directories will be
;                               created. This behaviour may be set to
;                               the default, by setting the system
;                               variable !CREATEDIR to 1.
;
; OUTPUTS:             lun : die lun des Files bzw. !NONE falls die Aktion fehlschlug
;
; COMMON BLOCKS:       UOPENR: enthaelt Filename und Zipstati der geoeffneten Files
;
; RESTRICTIONS:        die Zahl der simultan offenen Dateinen ist auf 40 begrenzt
;
; SEE ALSO:            UClose            
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  2000/06/19 13:21:58  saam
;           + print goes console
;           + lun's are not aquired via /FREE_LUN
;             because their number is restricted to max 32.
;             another mechanism now provides up to 97 luns.
;             the maximal lun number is increased respectively.
;           + new keyword FORCE in uopenw to create nonexisting
;             directories
;
;     Revision 2.3  1999/02/16 17:23:45  thiel
;            Bloﬂ ein kleiner Druckfehler im Header.
;
;     Revision 2.2  1998/11/08 15:01:45  saam
;           maximum file number is now 40
;
;     Revision 2.1  1998/10/28 14:57:07  saam
;           simple but works
;
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
       Openw, lun, file, ERROR=err
   END UNTIL ((lun GT 2+MaxFiles) OR (err EQ 0))
   IF (lun GT 2+MaxFiles) THEN Console, 'unable to aquire a lun: '+!ERR_STRING, /FATAL

   
   llun.lun(idx)  = lun & llun.act=llun.act+1
   llun.file(idx) = file
   
   
   RETURN, lun

END
