;+
; NAME:                Zip
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
; SEE ALSO:            <A HREF="#UNZIP">UnZip</A>, <A HREF="#ZIPFIX">ZipFix</A>, <A HREF="#ZIPSTAT">ZipStat</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1998/03/13 14:46:11  saam
;           more tolerant, now uses zipstat
;
;     Revision 2.2  1998/03/10 13:34:22  saam
;           wildcards in filenames are now accepted
;
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;
;
;-
PRO Zip, filepattern, KEEPORG=keeporg

   
   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   zip = 'gzip'
   
   
   c = ZipStat(filepattern, NOZIPFILE=nzf, BOTHFILES=bf, /VERBOSE) 
   files = ''
   IF nzf(0) NE '-1' THEN files = [files, nzf]
   IF bf(0)  NE '-1' THEN files = [files, bf]
   IF N_Elements(files) NE 1 THEN BEGIN
      FOR i=1,N_Elements(files)-1 DO BEGIN
         IF FileExists(files(i), INFO=info) THEN BEGIN ;THE FILE MAY BE ERASED BY A ZIP-OPERATION
            IF Contains(info, 'gzip') THEN BEGIN 
               Print, 'ZIP: file already compressed...renaming it to the zipped version...'+files(i)+suffix
               Spawn, 'mv -f '+files(i)+' '+files(i)+suffix
            ENDIF ELSE BEGIN
               IF Keyword_Set(KEEPORG) THEN BEGIN
                  Spawn, zip+' -c '+files(i)+' > '+files(i)+suffix, r
               ENDIF ELSE BEGIN
                  Spawn, zip+' -f '+files(i), r
               ENDELSE
               IF r(0) NE '' THEN print, 'GZIP: ',r(0)
            ENDELSE
         ENDIF
      ENDFOR
   ENDIF ELSE BEGIN
      Print,' ZIP: there are no files matching '+filepattern
      Print, 'ZIP: hoping that anybody else can handle that...'
   ENDELSE   
   stop

END
