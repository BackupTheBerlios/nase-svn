;+
; NAME:                UOpenW
;
; PURPOSE:             Erweitert die Funktionalitaet von OpenW, um die 
;                      Faehigkeit gezippte Files zu erzeugen.
;
; CATEGORY:            FILES+DIRS ZIP
;
; CALLING SEQUENCE:    lun = UOpenW(file [,/VERBOSE] [,/ZIP])
;
; INPUTS:              file: die zu oeffnende Datei (ohne ZIP-Endung)
;
; KEYWORD PARAMETERS:  VERBOSE: die Routine wird geschwaetzig
;                      ZIP    : das File wird nach dem Schliessen gezippt
;
; OUTPUTS:             lun : die lun des Files bzw. !NONE falls die Aktion fehlschlug
;
; COMMON BLOCKS:       UOPENW: enthaelt Filename und Zipstati der geoeffneten Files
;
; RESTRICTIONS:        die Zahl der simultan offenen Dateinen ist auf 40 begrenzt
;
; SEE ALSO:            UClose            
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/11/08 15:01:45  saam
;           maximum file number is now 40
;
;     Revision 2.1  1998/10/28 14:57:07  saam
;           simple but works
;
;
;-
FUNCTION UOpenW, file, VERBOSE=verbose, ZIP=zip, _EXTRA=e

   COMMON UOPENR, llun
   MaxFiles = 40

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
      Print, 'UOpenW: sorry, already maximum number of files (',STRCOMPRESS(MaxFiles,/REMOVE_ALL),') open'
      RETURN, !NONE
   END


   ; get a free entry
   idx = MIN(WHERE(llun.lun EQ !NONE, c))
   IF c EQ 0 THEN Message, 'this should not happen'

   llun.zip(idx) = zip
   OpenW, lun, file, /GET_LUN, _EXTRA=e 
   
   llun.lun(idx)  = lun & llun.act=llun.act+1
   llun.file(idx) = file
   
   
   RETURN, lun

END
