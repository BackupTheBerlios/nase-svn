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
; SEE ALSO:            <A HREF="#UNZIP">UnZip</A>, <A HREF="#ZIPFIX">ZipFix</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
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
   
   
   files = FindFile(filepattern,COUNT=c)
   FOR i=0,c-1 DO BEGIN
      IF RSTRPOS(files(i),suffix) EQ -1 THEN BEGIN
         IF FileExists(files(i), INFO=info) THEN BEGIN
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
         ENDIF ELSE Message, 'this must not happen !!!'
      END
   ENDFOR

   IF c EQ 0 THEN BEGIN
      Print,' ZIP: there are no files matching '+file
      Print, 'ZIP: hoping that anybody else can handle that...'
   END   

END
