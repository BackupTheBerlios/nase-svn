;+
; NAME:                ZipStat
;
; PURPOSE:             Ermittelt, ob gezippte/ungezippte Files
;                      fuer das uebergebene Filepattern existieren
;                      und gibt diese nach Wunsch zurueck. Die Unter-
;                      scheidung findet aufgrund des Filesuffix statt.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    exists = ZipStat(filepattern [,/VERBOSE] [,ZIPFILES=zipfiles]
;                                         [,NOZIPFILES=nozipfiles] [,/BOTHFILES=bothfiles])
;
; INPUTS:              filepattern: die zu fixenden Files
;
; KEYWORD PARAMETERS:  VERBOSE   : Routine wird geschwaetzig...naja ein bisschen
;                      ZIPFILES  : enthaelt die gefunden, nur gezippten Files als StrArr, -1 falls
;                                   nix gefunden wurde
;                      NOZIPFILES: enthaelt die gefundenen, nur nicht gezippten Files, -1 falls
;                                   nix gefunden wurde (ohne .GZ-Endung)
;                      BOTHFILES : enthaelt alle Files, die sowohl gezippt als auch nicht gezippt vorliegen, -1 falls
;                                   nix gefunden wurde (ohne .GZ-Endung)
;
; OUTPUTS:             exists: FALSE, falls weder gezippte noch nicht gezippte
;                                     Files gefunden wurden, TRUE sonst
;
; EXAMPLE:  
;                      print, ZipStat('*',/VERBOSE,ZIPFILES=zf,NOZIPFILES=nzf,BOTHFILES=bf)
;
; SEE ALSO:            <A HREF="#ZIP">Zip</A>, <A HREF="#UNZIP">UnZip</A>, <A HREF="#ZIPFIX">ZipFix</A>
;
; MODIFICATION HISTORY:
; 
;     $Log$
;     Revision 2.3  1998/03/14 13:28:31  saam
;           corrected some nasty bugs
;
;     Revision 2.2  1998/03/13 14:46:11  saam
;           more tolerant, now uses zipstat
;
;     Revision 2.1  1998/03/13 13:37:39  saam
;           hard work
;
;
;-
FUNCTION ZipStat, filepattern, VERBOSE=verbose, ZIPFILES=zipfiles, NOZIPFILES=nozipfiles, BOTHFILES=bothfiles

   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   

   tnozipfiles = -1
   tzipfiles = -1

   ; try the file pattern...this may get zipped/nonzipped versions
   ; depending on a final * for example
   files = FindFile(filepattern,COUNT=tc)
   tnzc = 0 ;(not zipped counter)
   
   IF tc NE 0 THEN BEGIN
      ; eliminate the zipped versions
      tnozipfiles = StrArr(tc)
      FOR i=0,tc-1 DO BEGIN
         IF NOT (RSTRPOS(files(i),suffix) EQ StrLen(files(i))-StrLen(suffix)) THEN BEGIN
            tnozipfiles(tnzc) = files(i)
            tnzc = tnzc+1
         END
      END
      IF tnzc GT 0 THEN tnozipfiles = tnozipfiles(0:tnzc-1)
   END ELSE tnzc = 0
   
   ; now try for zipped files only and cut the suffix
   tzipfiles = FindFile(filepattern+suffix,COUNT=tzc)
   IF tzc NE 0 THEN BEGIN
      FOR i=0,tzc-1 DO tzipfiles(i) = StrMid(tzipfiles(i),0,STRLEN(tzipfiles(i))-STRLEN(SUFFIX))
   ENDIF

   IF tnzc EQ 0 AND tzc EQ 0 THEN BEGIN
      zipfiles = '-1'
      nozipfiles = '-1'
      bothfiles = '-1'
      RETURN, 0                 ; no files exist
   END
   zc = 0
   nzc = 0
   bc = 0
   ; find&kill duplicates (BRUTE FORCE!)
   IF (tzc NE 0) AND (tnzc NE 0) THEN BEGIN
      zipfiles   = StrArr(tzc)
      nozipfiles = StrArr(tnzc)
      bothfiles = StrArr(MAX([tzc,tnzc]))

      FOR i=0,tnzc-1 DO BEGIN
         j     = 0
         found = 0
         WHILE (j LT tzc) AND (NOT found) DO BEGIN
            IF tnozipfiles(i) EQ tzipfiles(j) THEN BEGIN
            ; found a file in zipped and nonzipped version!
               found = 1
               bothfiles(bc) = tnozipfiles(i)
               bc = bc+1
            END
            j = j+1
         END
         IF NOT found THEN BEGIN
         ; only the nozipped variant exists
            nozipfiles(nzc) = tnozipfiles(i)
            nzc = nzc+1
         END
      END
      
      FOR i=0,tzc-1 DO BEGIN
         j     = 0
         found = 0
         WHILE j LT tnzc AND NOT found DO BEGIN
            IF tnozipfiles(j) EQ tzipfiles(i) THEN found = 1
            j = j+1
         END
         IF NOT found THEN BEGIN
         ; only the zipped variant exists
            zipfiles(zc) = tzipfiles(i)
            zc = zc+1
         END
      END
   END ELSE BEGIN
      nozipfiles = tnozipfiles
      zipfiles = tzipfiles
      nzc = tnzc
      zc = tzc
   END
   
   IF Keyword_Set(VERBOSE) THEN BEGIN
      print, 'ZIPSTAT: found '+STRCOMPRESS(nzc,/REMOVE_ALL)+' unzipped and '+STRCOMPRESS(zc,/REMOVE_ALL)+' zipped files and '+STRCOMPRESS(bc,/REMOVE_ALL)+' with both'
      print, 'ZIPSTAT: for '+filepattern
   END

   IF nzc EQ 0 THEN nozipfiles = '-1'
   IF  zc EQ 0 THEN zipfiles = '-1'
   IF  bc EQ 0 THEN bothfiles = '-1'
   
   RETURN, 1   
END
