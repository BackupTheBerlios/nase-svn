;+
; NAME:               BakRotate
;
; PURPOSE:            Realisiert ein einfaches Backupsystem fuer Files.
;                     Das Prinzip ist das einer Queue. Alte Backups werden
;                     nach hinten geschoben. Wird die maximale Anzahl ueber-
;                     schritten, wird das aelteste Backup geloescht. Die
;                     Backups werden automatisch gezippt. Die Backups erhalten
;                     eine laufende Nummer (0: neuestes Backup)
;                     
; CATEGORY:           CONTROL FILES DIRS
; 
; CALLING SEQUENCE:   BakRotate, files [,NUMBER=number] [,/NOCOMPRESS] [,INFIX=infix]
;
; INPUTS:             files: ein (Array von) Filename, fuer das ein Backup erstellt
;                            werden soll.
;
; KEYWORD PARAMETERS: NUMBER    : maximale Zahl von Backups fuer ein File (Default: 5)
;                     NOCOMPRESS: Backups werden nicht gezippt
;                     INFIX     : Backups erhalten laufende Nummern, die durch
;                                 INFIX vom Filename getrennt sind (Default: '.')
;
;
; EXAMPLE:            $touch test
;                     BakRotate, 'test'
;                     $ls
;                     ;test.0 
;                     $touch test
;                     BakRotate, 'test'
;                     ;test.0     test.1.gz 
;            
;                     usw.
;
;                     $touch test
;                     BakRotate, 'test'
;                     $ls
;                     ;test.0     test.2.gz  test.4.gz
;                     ;test.1.gz  test.3.gz 
I
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/02/22 11:14:37  saam
;           new & cool
;
;
;-
PRO BakRotate, files, NUMBER=number, NOCOMPRESS=nocompress, INFIX=infix

   Default, NUMBER    , 5
   Default, NOCOMPRESS, 0 
   Default, INFIX     , '.'
   
   ZIPSUFFIX = 'gz'

   mv   = Command('mv')
   rm   = Command('rm')
   gzip = Command('gzip')

   IF N_Params() NE 1 THEN Message, 'at least on filename expected'
   IF TypeOf(files) NE 'STRING' THEN Message, 'filename expected'
   
   nf = N_Elements(files)

   
   FOR k=0,nf-1 DO BEGIN
      IF FileExists(files(k)) THEN BEGIN

         ; care for backup files
         bakfiles = FindFile(files(k)+infix+'*', COUNT = bc)
         bakfiles = bakfiles(REVERSE(SORT(bakfiles)))
         FOR i=0,bc-1 DO BEGIN
            ; dissect filename
            pathfile = FileSplit(bakfiles(i))
            fileseps = Str_Sep(pathfile(1), INFIX)
            nfileseps = N_Elements(fileseps)
            
            ; get the version number
            IF fileseps(nfileseps-1) EQ ZIPSUFFIX THEN BEGIN
               version = fileseps(nfileseps-2) 
               zipped = 1
            END ELSE BEGIN
               version = fileseps(nfileseps-1)
               zipped = 0
            END
            version = FIX(version)+1
            
            ; assemble new filename
            nbakfile = pathfile(0)
            FOR j=0,nfileseps-2-zipped DO BEGIN
               IF j GT 0 THEN nbakfile = nbakfile + INFIX
               nbakfile = nbakfile + fileseps(j)
            END
            nbakfile = nbakfile + INFIX + Str(version)
            IF zipped THEN nbakfile = nbakfile+INFIX+ZIPSUFFIX

            IF version LT NUMBER THEN BEGIN
               spawn, mv+' '+bakfiles(i)+' '+nbakfile
               IF (NOT NOCOMPRESS) AND (NOT zipped) THEN spawn, gzip+' '+nbakfile 
            END ELSE spawn, rm+' '+bakfiles(i)

         END
         ; backup lastest file
         spawn, mv+' '+files(k)+' '+files(k)+'.0'
         
      END ELSE Message, /INFO, 'Warning: File "'+Str(files(i))+'" not existent'
   END


END
