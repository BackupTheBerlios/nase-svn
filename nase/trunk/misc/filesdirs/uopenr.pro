;+
; NAME:                UOpenR
;
; AIM:                 generalized version of IDL's openr function (allows zipping)
;
; PURPOSE:             Erweitert die Funktionalitaet von OpenR, um die 
;                      Faehigkeit auf gezippte Files zuzugreifen.
;
; CATEGORY:            FILES+DIRS
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
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.10  2005/03/22 16:48:09  kupper
;     bugfix: opening error state was not tested for 0, but for "true",
;     Since error codes obviously have changed, this broke.
;     fixed.
;
;     Revision 2.9  2001/04/25 13:28:57  gabriel
;           BugFix: RealFileName is a silly thing. Given filename is checked for existence and opened before changing
;                   filename via realfilename ...
;
;     Revision 2.8  2000/09/25 09:13:03  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
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
;
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
   
   rfile = file
   exists = ZipStat(rfile, ZIPFILES=zf, NOZIPFILES=nzf, BOTHFILES=bf)
   
   IF NOT exists then begin
      Console, ' '+rfile+ ' not exists', /warn
      rfile = RealFileName(file)
      Console, 'try to open '+rfile+' instead', /warn
      exists = ZipStat(rfile, ZIPFILES=zf, NOZIPFILES=nzf, BOTHFILES=bf)
      IF NOT exists then begin 
         Console, 'UOpenR: '+rfile
         Console, 'UOpenR: neither unzipped nor zipped version found!', /WARN
         RETURN, !NONE
      endif
   ENDIF
   

   

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
           ;;           print, "testing lun "+str(lun)
           OpenR, lun, rfile, Err=err, _EXTRA=e 
       END UNTIL ((lun GT 2+MaxFiles) OR (err eq 0))
       ;;       print, "using lun "+str(lun)
       ;;       print, "err="+str(err)
       IF (lun GT 2+MaxFiles) THEN Console, 'unable to aquire a lun: '+!ERR_STRING, /FATAL

       
       llun.lun(idx)  = lun & llun.act=llun.act+1
       llun.file(idx) = rfile
       
       
       RETURN, lun
   END
END
