;+
; NAME:                Zip
;
; PURPOSE:             Komprimiert ein File. 
;                       - Original wird geloescht
;                       - neue Endung '.gz'
;                       - "Sinnvolles" Fehlerhandling.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    Zip, file [, /KEEPORG]
;
; INPUTS:              file: das zu komprimierende File
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
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;
;
;-
PRO Zip, file, KEEPORG=keeporg

   
   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   zip = 'gzip'
   


   IF FileExists(file, INFO=info) THEN BEGIN
      IF Contains(info, 'gzip') THEN BEGIN 
         Print, 'ZIP: file already compressed...renaming it to the zipped version...'+file+suffix
         Spawn, 'mv -f '+file+' '+file+suffix
      ENDIF ELSE BEGIN
         IF Keyword_Set(KEEPORG) THEN BEGIN
            Spawn, zip+' -c '+file+' > '+file+suffix, r
         ENDIF ELSE BEGIN
            Spawn, zip+' -f '+file, r
         ENDELSE
         IF r(0) NE '' THEN print, 'GZIP: ',r(0)
      ENDELSE

   ENDIF ELSE BEGIN
      Print, 'ZIP: file doesnot exist...'+file
      Print, 'ZIP: hoping that anybody else can handle that...'
   END   

END
