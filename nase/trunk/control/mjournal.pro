;+
; NAME:
;  MJournal
;
; AIM:
;  extends IDLs journal routine by a backup system
;
; PURPOSE:
;  Extends IDLs <C>Journal</C> routine with a backup
;  system <A>BakRotate</A>
;  Never mix IDLs <C>Journal</C> and <C>MJournal</C>. <BR>
;
;  The JOURNAL procedure provides a record of an interactive session 
;  by saving, in a file, all text entered from the terminal in response
;  to the IDL prompt. The first call to JOURNAL starts the logging process.
;  The read-only system variable !JOURNAL is set to the file unit used. 
;  To stop saving commands and close the file, call JOURNAL with no 
;  parameters. If logging is in effect and JOURNAL is called with a parameter,
;  the parameter is simply written to the journal file.
;
; CATEGORY:
;  ExecutionControl
;  Help
;
; CALLING SEQUENCE:
;* MJournal [, Arg]
;
; INPUTS:
;  Arg:: A string containing the name of the journal file to be opened or text 
;       to be written to an open journal file. If Arg is not supplied, and a
;       journal file is not already open, the file idlsave.pro is used. Once 
;       journaling is enabled, a call to JOURNAL with Arg supplied causes Arg 
;       to be written into the journal file. Calling JOURNAL without Arg while 
;       journaling is in progress closes the journal file and ends the logging process.
;
; COMMON BLOCKS:
;  MJOURNAL
;
; EXAMPLE:
;  To begin journaling to the file myjournal.pro, enter:
;* MJOURNAL, 'myjournal'
;  Any commands entered at the IDL prompt are recorded in the file until IDL is exited
;  or the JOURNAL command is entered without an argument.
;
; SEE ALSO:
;  <C>RESTORE</C>, <C>SAVE</C>, <A>BakRotate</A> 
;
;-
PRO MJournal, arg

   COMMON MJournal, on

   Default, file, 'idlsave.pro'
   Default, on, 0
   np = N_Params()

   numBak = 5

   IF (np EQ 1) THEN BEGIN
      IF (NOT on) THEN BEGIN   ;open journal with filename arg
         seps = Str_Sep(arg, '.')
         file = arg
         IF seps(N_Elements(seps)-1) NE 'pro' THEN file = arg+'.pro'
         IF FileExists(file) THEN BakRotate,file, NUMBER=numBak
         Journal, file
         on = 1
      END ELSE BEGIN           ;write arg to already opened journal
         Journal, arg
      END
   END ELSE IF (NOT on) THEN BEGIN ; open a journal with standard name
      IF FileExists(file) THEN BakRotate,file, NUMBER=numBak
      Journal
      on = 1
   END ELSE BEGIN                  ; close journal
      Journal     
      on = 0
   END

END
