;+
; NAME:                ZipFix
;
; PURPOSE:             Stellt sicher, dass nach der 
;                      beliebigen Benutzung von [Un]Zip
;                      nur noch das gezippte File erhalten bleibt.
;
; CATEGORY:            MISC
;
; CALLING SEQUENCE:    ZipFix, file
;
; INPUTS:              file: das zu fixende File
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
;     Revision 2.1  1998/02/24 08:40:53  saam
;           zip-zip-zippi-die-dip
;
;
;-
PRO ZipFix, file

   
   Default, suffix, 'gz'
   IF suffix NE '' THEN suffix = '.'+suffix
   
   
   IF FileExists(file) THEN BEGIN
      
      IF FileExists(file+suffix) THEN spawn, 'rm -f '+file ELSE BEGIN
         Zip, file
      ENDELSE
      
   ENDIF ELSE BEGIN

      IF NOT FileExists(file+suffix) THEN BEGIN
         Print, 'ZIPFIX: neither file nor zipfile exists...'+file
         Print, 'ZIPFIX: hope that is not too bad...'
      ENDIF

   END   

END
