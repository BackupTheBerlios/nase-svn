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
; SEE ALSO:            <A HREF="#ZIP">Zip</A>, <A HREF="#UNZIP">UnZip</A>, <A HREF="#ZIPSTAT">ZipStat</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.4  1998/04/09 14:38:38  saam
;           now leaves opened files untouched
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
PRO ZipFix, filepattern

   
   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   
   
   c = ZipStat(filepattern, NOZIPFILES=nzf, BOTHFILES=bf)
   IF nzf(0) NE '-1' THEN BEGIN
      FOR i=0,N_Elements(nzf)-1 DO Zip, nzf(i)
   END
   IF bf(0) NE '-1' THEN BEGIN
      FOR i=0,N_Elements(bf)-1 DO BEGIN
         IF NOT FileOpen(bf(i)) THEN spawn, 'rm -f '+bf(i) ELSE Print, 'ZIPFIX: file is open...doing nothing'
      END
   END

   
END
