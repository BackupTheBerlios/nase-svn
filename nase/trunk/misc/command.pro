;+
; NAME:                COMMAND
; 
; AIM:                 Full pathname for executables.
;
; PURPOSE:             Searches for an executable in all directories
;                      specified in the PATH environment variable and
;                      returns the full pathname. This execution is
;                      stopped if the executable is not found.
;
; CATEGORY:            MISC FILES DIRS
;
; CALLING SEQUENCE:    c = Command(exe [,/NOSTOP])
;
; INPUTS:              exe: string, containing the executable to search for
;
; KEYWORD PARAMETERS:  NOSTOP: Generates only a warning, if the
;                              executable is not found. The return
;                              value c is !NONE in this case.
;
; OUTPUTS:             c: full pathname the exe or !NONE if the
;                         executable is not found (when using /NOSTOP)
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
;     Revision 1.2  2000/09/18 12:44:15  saam
;           + uses PATH environment variable, now
;           + switched to console
;
;     Revision 1.1  1999/02/22 11:14:36  saam
;           new & cool
;
;
;-
FUNCTION Command, com, NOSTOP=nostop

   On_Error, 2

   IF N_Params() NE 1 THEN Command, 'command expected', /FATAL
   IF TypeOf(com) NE 'STRING' THEN Command, 'string expected', /FATAL

   
   ExecPaths = Split(GetEnv("PATH"), ':')

   IF FileExists(com, STAT=stat) THEN Return, com
   FOR i=0, N_Elements(ExecPaths)-1 DO BEGIN
      IF FileExists(ExecPaths(i)+'/'+com, STAT=stat) THEN Return, ExecPaths(i)+'/'+com
   END
   IF Keyword_Set(NOSTOP) THEN BEGIN
      Console, '"'+com+ '" not found in '+StrJoin(ExecPaths,':'), /WARN
      RETURN, !NONE
   END ELSE Console, '"'+com+ '" not found in '+StrJoin(ExecPaths,':'), /FATAL

END
