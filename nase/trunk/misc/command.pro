;+
; NAME:                COMMAND
; 
; PURPOSE:             Sucht ein Executable in den Standard-Pfaden und gibt den
;                      vollstaendigen Pfadnamen zurueck. Wurde das File nicht
;                      gefunden, wird ein Fehler erzeugt.
;
; CATEGORY:            MISC FILES DIRS
;
; CALLING SEQUENCE:    c = Command(exe [,/NOSTOP])
;
; INPUTS:              exe: das zu suchende Executable als String
;
; KEYWORD PARAMETERS:  NOSTOP: bei Nichtfinden des Executables wird lediglich
;                              eine Warnung ausgegeben, der Rueckgabe ist !NONE
;
; OUTPUTS:             c: der vollstaendige Pfadname bzw. !NONE, falls nichts
;                         gefunden wurde (mit Keyword NOSTOP)
;
; COMMON BLOCKS:       Benutzt globale NASE-Systemvariable EXECPATHS fuer die zu
;                      durchsuchende Pfade
;
; EXAMPLE:             print, command('bunzip2')
;                      '/vol/bin/bunzip2'
;
;                      print, command('michgibtsnet')
;                      % COMMAND: "michgibtsnet" not found in /bin:/sbin:/usr/bin:/usr/sbin:/usr/games:/usr/X11R6/bin:/usr/bin/X11:/vol/bin:~/bin
;                      ;;execution halted
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/02/22 11:14:36  saam
;           new & cool
;
;
;-
FUNCTION Command, com, NOSTOP=nostop

   On_Error, 2

   IF N_Params() NE 1 THEN Message, 'command expected'
   IF TypeOf(com) NE 'STRING' THEN Message, 'string expected'

   

   IF FileExists(com, STAT=stat) THEN Return, com
   FOR i=0, N_Elements(!EXECPATHS)-1 DO BEGIN
      IF FileExists(!EXECPATHS(i)+'/'+com, STAT=stat) THEN Return, !EXECPATHS(i)+'/'+com
   END
   IF Keyword_Set(NOSTOP) THEN BEGIN
      Message, /INFO, '"'+com+ '" not found in '+StrJoin(!EXECPATHS,':')
      RETURN, !NONE
   END ELSE Message, '"'+com+ '" not found in '+StrJoin(!EXECPATHS,':')

END
