;+
; NAME:                ZipFix
;
; PURPOSE:             Stellt sicher, dass nach der 
;                      beliebigen Benutzung von [Un]Zip
;                      nur noch gezippte Files erhalten bleibt.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    ZipFix, filepattern
;
; INPUTS:              filepattern: die zu fixenden Files
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
; SEE ALSO:            <A HREF="#ZIP">Zip</A>, <A HREF="#UNZIP">UnZip</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/03/10 13:34:23  saam
;           wildcards in filenames are now accepted
;
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;
;
;-
PRO ZipFix, filepattern

   
   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   
   
   files = FindFile(filepattern,COUNT=c)
   FOR i=0,c-1 DO BEGIN
      IF FileExists(files(i)) THEN BEGIN
         
         IF FileExists(files(i)+suffix) THEN spawn, 'rm -f '+files(i) ELSE Zip, files(i)
         
      ENDIF ELSE Message, 'this must not happen !!!'
   ENDFOR
   
END
