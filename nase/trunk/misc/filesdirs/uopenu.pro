;+
; NAME:                UOpenU
;
; AIM:                 generalized version of IDL's openu function (allows zipping)
;
; PURPOSE:             Erweitert die Funktionalitaet von OpenU um die 
;                      Faehigkeit gezippte Files zu erzeugen.
;
; CATEGORY:            FILES+DIRS ZIP
;
; CALLING SEQUENCE:    lun = UOpenU(file [,/VERBOSE] [,/ZIP])
;
; INPUTS:              file: die zu oeffnende Datei (ohne ZIP-Endung)
;
; KEYWORD PARAMETERS:  VERBOSE: die Routine wird geschwaetzig
;                      ZIP    : das File wird nach dem Schliessen gezippt
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
;     Revision 1.3  2000/09/25 09:13:03  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.2  2000/06/19 13:21:58  saam
;           + print goes console
;           + lun's are not aquired via /FREE_LUN
;             because their number is restricted to max 32.
;             another mechanism now provides up to 97 luns.
;             the maximal lun number is increased respectively.
;           + new keyword FORCE in uopenw to create nonexisting
;             directories
;
;     Revision 1.1  1999/02/16 15:32:13  thiel
;            Entsprechung der IDL-Routine OpenU
;            Abgeleitet von UOpenW.
;
;     Revision 2.2  1998/11/08 15:01:45  saam
;           maximum file number is now 40
;
;     Revision 2.1  1998/10/28 14:57:07  saam
;           simple but works
;
;
;-
FUNCTION UOpenU, file, VERBOSE=verbose, ZIP=zip, _EXTRA=e

   COMMON UOPENR, llun
   MaxFiles = 97

   Default, ZIP, 0

   On_Error, 2

   IF N_Params() NE 1 THEN Message,' exactly one argument expected'
   

   IF NOT Set(llun) THEN BEGIN
      llun = { lun  : Make_Array(maxFiles, /LONG, VALUE=!NONE), $
               file : StrArr(maxFiles), $
               zip  : BytArr(maxFiles), $
               act  : 0l                }
   END

   IF llun.act EQ MaxFiles THEN BEGIN
      Consoole, 'UOpenW: sorry, already maximum number of files ('+STRCOMPRESS(MaxFiles,/REMOVE_ALL)+') open', /WARN
      RETURN, !NONE
   END


   ; get a free entry
   idx = MIN(WHERE(llun.lun EQ !NONE, c))
   IF c EQ 0 THEN Message, 'this should not happen'

   llun.zip(idx) = zip


   ; probe for unused lun
   lun = 2 ; reserved for stdin/stdout/stderr
   REPEAT BEGIN
       lun = lun + 1
       OpenU, lun, file, Err=err, _EXTRA=e 
   END UNTIL ((lun GT 2+MaxFiles) OR (NOT err))
   IF (lun GT 2+MaxFiles) THEN Console, 'unable to aquire a lun: '+!ERR_STRING, /FATAL

   
   llun.lun(idx)  = lun & llun.act=llun.act+1
   llun.file(idx) = file
   
   
   RETURN, lun

END
