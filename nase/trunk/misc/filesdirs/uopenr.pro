;+
; NAME:                UOpenR
;
; PURPOSE:             Erweitert die Funktionalitaet von OpenR, um die 
;                      Faehigkeit auf gezippte Files zuzugreifen.
;
; CATEGORY:            FILES+DIRS ZIP
;
; CALLING SEQUENCE:    lun = UOpenR(file [,/VERBOSE] [,/ZIP])
;
; INPUTS:              file: die zu oeffnende Datei (ohne ZIP-Endung)
;
; KEYWORD PARAMETERS:  VERBOSE: die Routine wird geschwaetzig
;
; OUTPUTS:             lun : die lun des Files bzw. !NONE falls die Aktion fehlschlug
;
; COMMON BLOCKS:       UOPENR: enthaelt Filename und Zipstati der geoeffneten Files
;
; RESTRICTIONS:        die Zahl der simultan offenen Dateinen ist auf 20 begrenzt
;
; SEE ALSO:            UClose            
;
; MODIFICATION HISTORY:
;
;     $Log$
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
   MaxFiles = 20


   On_Error, 2

   IF N_Params() NE 1 THEN Message,' exactly one argument expected'
   

   IF NOT Set(llun) THEN BEGIN
      llun = { lun  : Make_Array(maxFiles, /LONG, VALUE=!NONE), $
               file : StrArr(maxFiles), $
               zip  : BytArr(maxFiles), $
               act  : 0l                }
   END

   IF llun.act EQ MaxFiles THEN BEGIN
      Print, 'UOpenR: sorry, already maximum number of files (',STRCOMPRESS(MaxFiles,/REMOVE_ALL),') open'
      RETURN, !NONE
   END

   exists = ZipStat(file, ZIPFILES=zf, NOZIPFILES=nzf, BOTHFILES=bf)
   IF exists THEN BEGIN

      ; get a free entry
      idx = MIN(WHERE(llun.lun EQ !NONE, c))
      IF c EQ 0 THEN Message, 'this should not happen'

      llun.zip(idx) = 0
      IF zf(0) NE '-1' THEN BEGIN
         IF Keyword_Set(Verbose) THEN print, 'UOpenR: no unzipped version found...unzipping'
         UnZip, file
         llun.zip(idx) = 1
      END
      OpenR, lun, file, /GET_LUN, _EXTRA=e 
      
      llun.lun(idx)  = lun & llun.act=llun.act+1
      llun.file(idx) = file

      
      RETURN, lun
   END ELSE BEGIN
      print, 'UOpenR: ', file
      print, 'UOpenR: neither unzipped nor zipped version found!'
      RETURN, !NONE
   END

END
