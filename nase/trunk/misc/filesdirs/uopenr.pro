;+
; NAME:                UOpenR
;
; PURPOSE:             Erweitert die Funktionalitaet von OpenR, um die 
;                      Faehigkeit auf gezippte Files zuzugreifen.
;
; CATEGORY:            FILES+DIRS ZIP
;
; CALLING SEQUENCE:    lun = UOpenR(file [,/VERBOSE])
;
; INPUTS:              file: die zu oeffnende Datei (ohne ZIP-Endung)
;
; KEYWORD PARAMETERS:  VERBOSE: die Routine wird geschwaetzig
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
;     Revision 2.7  2000/06/19 13:21:58  saam
;           + print goes console
;           + lun's are not aquired via /FREE_LUN
;             because their number is restricted to max 32.
;             another mechanism now provides up to 97 luns.
;             the maximal lun number is increased respectively.
;           + new keyword FORCE in uopenw to create nonexisting
;             directories
;
;     Revision 2.6  1998/11/13 21:21:16  saam
;           now uses readfilename
;
;     Revision 2.5  1998/11/08 15:01:44  saam
;           maximum file number is now 40
;
;     Revision 2.4  1998/10/28 14:58:55  saam
;           bug in docheader
;
;     Revision 2.3  1998/10/26 13:54:35  saam
;           returns if an error occurs
;
;     Revision 2.2  1998/10/18 16:47:46  saam
;           now works and has a docheader
;
;     Revision 2.1  1998/10/12 10:32:02  saam
;           first version
;
;-
FUNCTION UOpenR, file, VERBOSE=verbose, _EXTRA=e

   COMMON UOPENR, llun
   MaxFiles = 97


   On_Error, 2

   IF N_Params() NE 1 THEN Message,' exactly one argument expected'
   

   IF NOT Set(llun) THEN BEGIN
      llun = { lun  : Make_Array(maxFiles, /LONG, VALUE=!NONE), $
               file : StrArr(maxFiles), $
               zip  : BytArr(maxFiles), $
               act  : 0l                }
   END

   IF llun.act EQ MaxFiles THEN BEGIN
       Console, 'sorry, already maximum number of files ('+STR(MaxFiles)+') open', /WARN
       RETURN, !NONE
   END
   
   rfile = RealFileName(file)
   exists = ZipStat(rfile, ZIPFILES=zf, NOZIPFILES=nzf, BOTHFILES=bf)
   IF exists THEN BEGIN
       
      ; get a free entry
       idx = MIN(WHERE(llun.lun EQ !NONE, c))
       IF c EQ 0 THEN Message, 'this should not happen'
       
       llun.zip(idx) = 0
       IF zf(0) NE '-1' THEN BEGIN
           IF Keyword_Set(Verbose) THEN Console, 'UOpenR: no unzipped version found...unzipping'
           UnZip, rfile
           llun.zip(idx) = 1
       END
       
       ; probe for unused lun
       lun = 2 ; reserved for stdin/stdout/stderr
       REPEAT BEGIN
           lun = lun + 1
           OpenR, lun, rfile, Err=err, _EXTRA=e 
       END UNTIL ((lun GT 2+MaxFiles) OR (NOT err))
       IF (lun GT 2+MaxFiles) THEN Console, 'unable to aquire a lun: '+!ERR_STRING, /FATAL

       
       llun.lun(idx)  = lun & llun.act=llun.act+1
       llun.file(idx) = rfile
       
       
       RETURN, lun
   END ELSE BEGIN
       Console, 'UOpenR: '+rfile
       Console, 'UOpenR: neither unzipped nor zipped version found!', /WARN
       RETURN, !NONE
   END
   
END
