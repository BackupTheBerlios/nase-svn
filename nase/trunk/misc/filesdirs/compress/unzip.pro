;+
; NAME:                UnZip
;
; PURPOSE:             Dekomprimiert Files. 
;                       - Zipfile bleibt erhalten
;                       - "Sinnvolles" Fehlerhandling.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    UnZip, filepattern [,/NOKEEPORG]
;
; INPUTS:              filepattern: das zu dekomprimierende Filepattern ohne
;                            '.gz'-Endung
;
; KEYWORD PARAMETERS:  NOKEEPORG: das gezippte File wird geloescht
;                      FORCE    : ist sowohl das gezippte als auch das nicht-gezippte File
;                                 vorhanden, wird das nicht-gezippte durch auspacken
;                                 des gezippten Files ueberschrieben
;                      VERBOSE  : ein bisschen mehr Ausgabe
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
; SEE ALSO:            <A HREF="#ZIP">Zip</A>, <A HREF="#ZIPFIX">ZipFix</A>, <A HREF="#ZIPSTAT">ZipStat</A>, <A HREF="#CHECKZIP">CheckZip</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.5  1998/06/16 12:24:49  saam
;           + new Keywords FORCE, VERBOSE
;           + misleading status-message changed
;
;     Revision 2.4  1998/03/16 14:30:59  saam
;           the file-check of the gzip-integrity is
;           broken on alpha (doesn't recognize gzip-
;           files) and therefore removed
;
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
PRO UnZip, filepattern, NOKEEPORG=nokeeporg, FORCE=force, VERBOSE=verbose

   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   unzip = 'gunzip'


   ok = ZipStat(filepattern, ZIPFILES=gzfiles, BOTHFILES=bfiles)
   IF Keyword_Set(FORCE) AND bfiles(0) NE '-1' THEN BEGIN
      IF Keyword_Set(VERBOSE) THEN print, 'UNZIP: forced decompression'
      IF gzfiles(0) NE '-1' THEN gzfiles = [gzfiles,bfiles] ELSE gzfiles = bfiles
   END

   IF ok AND gzfiles(0) NE '-1' THEN BEGIN
      FOR i=0,N_Elements(gzfiles)-1 DO BEGIN
         IF FileExists(gzfiles(i)+suffix, INFO=info) THEN BEGIN
            
            IF NOT Keyword_Set(NOKEEPORG) THEN BEGIN
               Spawn, unzip+' -c '+gzfiles(i)+suffix+' > '+gzfiles(i), r
            ENDIF ELSE BEGIN
               Spawn, unzip+' -f '+gzfiles(i)+suffix, r
            ENDELSE
            IF r(0) NE '' THEN print, 'GUNZIP: ',r(0)
            
         ENDIF
      ENDFOR
   ENDIF ELSE BEGIN
      IF bfiles(0) NE '-1' AND NOT Keyword_Set(FORCE) THEN print, 'UNZIP: there are ZIP/NOZIP-file-pairs...dont like to touch them' ELSE BEGIN
         Print, 'UNZIP: there are no files matching '+filepattern+suffix
         Print, 'UNZIP: hoping that anybody else can handle that...'
      END
   ENDELSE
      
END
