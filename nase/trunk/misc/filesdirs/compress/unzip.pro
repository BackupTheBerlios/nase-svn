;+
; NAME:                UnZip
;
; PURPOSE:             Dekomprimiert Files. 
;                       - Zipfile bleibt erhalten
;                       - "Sinnvolles" Fehlerhandling.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    UnZip, filepattern [, /NOKEEPORG]
;
; INPUTS:              filepattern: das zu dekomprimierende Filepattern ohne
;                            '.gz'-Endung
;
; KEYWORD PARAMETERS:  NOKEEPORG: das gezippte File wird geloescht
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
; SEE ALSO:            <A HREF="#ZIP">Zip</A>, <A HREF="#ZIPFIX">ZipFix</A>, <A HREF="#ZIPSTAT">ZipStat</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1998/03/13 14:46:11  saam
;           more tolerant, now uses zipstat
;
;     Revision 2.2  1998/03/10 13:34:23  saam
;           wildcards in filenames are now accepted
;
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;
;
;-
PRO UnZip, filepattern, NOKEEPORG=nokeeporg

   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   unzip = 'gunzip'


   IF ZipStat(filepattern, ZIPFILES=gzfiles) AND gzfiles(0) NE '-1' THEN BEGIN
      FOR i=0,N_Elements(gzfiles)-1 DO BEGIN
         IF FileExists(gzfiles(i)+suffix, INFO=info) THEN BEGIN
            
            IF NOT Contains(info, 'gzip') THEN BEGIN 
               Print, 'UNZIP: file not compressed...renaming to original name...'+file
               Spawn, 'mv -f '+gzfile+' '+file
            ENDIF ELSE BEGIN
               IF NOT Keyword_Set(NOKEEPORG) THEN BEGIN
                  Spawn, unzip+' -c '+gzfiles(i)+suffix+' > '+gzfiles(i), r
               ENDIF ELSE BEGIN
                  Spawn, unzip+' -f '+gzfiles(i)+suffix, r
               ENDELSE
               IF r(0) NE '' THEN print, 'GUNZIP: ',r(0)
            ENDELSE
            
         ENDIF
      ENDFOR
   ENDIF ELSE BEGIN      
      Print, 'UNZIP: there are no files matching '+filepattern+suffix
      Print, 'UNZIP: hoping that anybody else can handle that...'
   ENDELSE
      
END
