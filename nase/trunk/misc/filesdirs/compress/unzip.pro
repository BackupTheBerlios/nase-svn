;+
; NAME:                UnZip
;
; PURPOSE:             Dekomprimiert ein File. 
;                       - Zipfile bleibt erhalten
;                       - "Sinnvolles" Fehlerhandling.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    UnZip, file [, /NOKEEPORG]
;
; INPUTS:              file: das zu dekomprimierende File ohne
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
; SEE ALSO:            <A HREF="#ZIP">Zip</A>, <A HREF="#ZIPFIX">ZipFix</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;
;
;-
PRO UnZip, file, NOKEEPORG=nokeeporg

   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   unzip = 'gunzip'


   IF FileExists(file+suffix, INFO=info) THEN BEGIN
      IF NOT Contains(info, 'gzip') THEN BEGIN 
         Print, 'UNZIP: file not compressed...renaming to original name...'+file
         Spawn, 'mv -f '+file+suffix+' '+file
      ENDIF ELSE BEGIN
         IF NOT Keyword_Set(NOKEEPORG) THEN BEGIN
            Spawn, unzip+' -c '+file+suffix+' > '+file, r
         ENDIF ELSE BEGIN
            Spawn, unzip+' -f '+file+suffix, r
         ENDELSE
         IF r(0) NE '' THEN print, 'GUNZIP: ',r(0)
      ENDELSE

   ENDIF ELSE BEGIN
      Print, 'UNZIP: file doesnot exist...'+file
      Print, 'UNZIP: hoping that anybody else can handle that...'
   ENDELSE

END
