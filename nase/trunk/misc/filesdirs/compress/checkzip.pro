;+
; NAME:                CheckZip
;
; AIM:                 checks, if a file and its zipped version differ 
; 
; PURPOSE:             Test die Integritaet eines Zip-Files, indem es
;                      das gezippte und das nicht-gezippte File vergleicht.
;                      Das ganze funktionoert auch fuer filepatterns.
;
; CATEGORY:            MISC FILES ZIP
;
; CALLING SEQUENCE:    ok = CheckZip(filepattern [,/VERBOSE] [,DETAIL=detail])
;
; INPUTS:              filepattern : ein filepattern ohne gz-Endung
;
; KEYWORD PARAMETERS:  VERBOSE: die Routine wird geschwaetzig
;
; OUTPUTS:             ok: TRUE(1), wenn ALLE files uebereinstimmen, FALSE sonst.
;
; OPTIONAL OUTPUTS:    detail: Struktur, die Details darueber enthaelt, welche
;                              Files uebereinstimmen und welche nicht
;                              { file  : Stringarray ,
;                                check : BytArray    }
;                              Ist file(i) ok, dann ist check(i)=1 bzw. 0 sonst
;
; EXAMPLE:             
;                      save, FILENAME='test', /ALL                    ; speichere irgendwas
;                      spawn, 'gzip -c test > test.gz'                ; zippe es und behalte das Original
;                      spawn, 'cp test.gz test2.gz'                   ; noch ein zip-file
;                      spawn, 'echo jwehrlwkqjrhlqkjwrh  > test2'     ; erzeuge falsches ursprungsfile
;                      print, CheckZip('test*', /VERBOSE, DETAIL=d)
;                                  CHECKZIP: test[.gz] are equal
;                                  CHECKZIP: test2[.gz] are NOT equal
;                                  0
;                      help, d
;                                  ** Structure <40031508>, 2 tags, length=40, refs=1:
;                                     FILE            STRING    Array(2)
;                                     CHECK           BYTE      Array(2)                       
;                      print, d
;                                     { test test2
;                                       1   0
;                                     };                        
;
;
;
;
; SEE ALSO:            Zip, UnZip, ZipFix, ZipStat
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  2000/09/25 09:13:05  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.1  1998/06/16 11:55:19  saam
;           lange ersehnt, endlich gemacht
;
;
;
FUNCTION CheckZip, filepattern, VERBOSE=verbose, DETAIL=detail


   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   unzip = 'gunzip'
   

   IF ZipStat(filepattern, BOTHFILES=bf) AND bf(0) NE '-1' THEN BEGIN
      equal = BytArr(N_Elements(bf))
      FOR i=0,N_Elements(bf)-1 DO BEGIN
         Spawn, unzip+' -c -q '+bf(i)+suffix+' | diff - '+bf(i), r
         IF (SIZE(r))(0) EQ 0 THEN BEGIN
            IF Keyword_Set(VERBOSE) THEN Print, 'CHECKZIP: '+bf(i)+'['+suffix+'] are equal'
            equal(i) = 1
         END ELSE BEGIN
            IF Keyword_Set(VERBOSE) THEN Print, 'CHECKZIP: '+bf(i)+'['+suffix+'] are NOT equal'
            equal(i) = 0
         END
      ENDFOR
      DETAIL = { file : bf    ,$
                 check: equal  } ; OPTIONAL OUTPUT 
      IF TOTAL(equal) EQ N_Elements(bf) THEN RETURN, 1 ELSE RETURN, 0
   END ELSE BEGIN
      DETAIL = -1 ; OPTIONAL OUTPUT       
      Print, 'CHECKZIP: no ZIP/UNZIP-pair matching pattern '+filepattern
      RETURN, 0
   END
END
