;+
; NAME:                Zip
;
; AIM:                 compresses files using gzip (UNIX)
;
; PURPOSE:             Komprimiert Files. 
;                       - Original wird geloescht
;                       - neue Endung '.gz'
;                       - "Sinnvolles" Fehlerhandling.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    Zip, filepattern [, /KEEPORG]
;
; INPUTS:              filepattern: das zu komprimierende Filepattern
;
; KEYWORD PARAMETERS:  KEEPORG: das originale, nicht-gepackte
;                               File bleibt erhalten
;
; EXAMPLE:             ; in einer Simulation, in zwei Schritten erfolgt:
;                      
;                      PRO Simulation
;                         ...
;                         Zip, Data
;                      END
;                      
;                      PRO Auswertung
;                         Unzip, Data
;                         ...
;                      END
;
;                      Simulation
;                      Auswertung
;                      ZipFix, Data
;
; SEE ALSO:            <A>UnZip</A>, <A>ZipFix</A>, <A>ZipStat</A>
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.8  2000/09/25 09:13:05  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.7  1998/07/21 16:04:36  saam
;           just a small bug
;
;     Revision 2.6  1998/04/09 14:38:38  saam
;           now leaves opened files untouched
;
;     Revision 2.5  1998/03/16 14:31:25  saam
;           the file-check of the gzip-integrity is
;           broken on alpha (doesn't recognize gzip-
;           files) and therefore removed
;
;     Revision 2.4  1998/03/14 13:28:31  saam
;           corrected some nasty bugs
;
;     Revision 2.3  1998/03/13 14:46:11  saam
;           more tolerant, now uses zipstat
;
;     Revision 2.2  1998/03/10 13:34:22  saam
;           wildcards in filenames are now accepted
;
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;

PRO Zip, filepattern, KEEPORG=keeporg, BZ2=bz2

   
   Default, suffix, 'gz'
   IF Keyword_Set(BZ2) THEN BEGIN
      suffix = 'bz2'
      zip = 'bzip2'
   END ELSE BEGIN
      suffix = 'gz'
      zip = 'gzip'
   END
   IF suffix NE '' THEN suffix = '.'+suffix
   r = StrArr(1)
   
   c = ZipStat(filepattern, NOZIPFILES=nzf, BOTHFILES=bf) 
   files = ''
   IF nzf(0) NE '-1' THEN files = [files, nzf]
   IF bf(0)  NE '-1' THEN files = [files, bf]
   IF N_Elements(files) NE 1 THEN BEGIN
      FOR i=1,N_Elements(files)-1 DO BEGIN
         IF FileExists(files(i), INFO=info) THEN BEGIN ;THE FILE MAY BE ERASED BY A ZIP-OPERATION
            IF Keyword_Set(KEEPORG) THEN BEGIN
               Spawn, zip+' -c '+files(i)+' > '+files(i)+suffix, r
            ENDIF ELSE BEGIN
               IF NOT FileOpen(files(i)) THEN Spawn, zip+' -f '+files(i), r ELSE Print, 'ZIP: file is open...doing nothing'
            ENDELSE
            IF r(0) NE '' THEN print, 'GZIP: ',r(0)
         ENDIF
      ENDFOR
   ENDIF ELSE BEGIN
      Print,' ZIP: there are no files matching '+filepattern
      Print, 'ZIP: hoping that anybody else can handle that...'
   ENDELSE   

END
