;+
; NAME:
;   BakRotate
;
; VERSION:
;   $Id$
;
; AIM:
;   creates, rotates and compresses backup files
;
; PURPOSE:
;   Implements a simple backup system for files. It keeps a fixed
;   number of backups in compressed form. All Versions
;   are assigned a running number, where a higher number indicates an
;   older version. Too old backups will be erased. The most recent
;   backup is not compressed. For Windows, compression is disables.
;                     
; CATEGORY:
;  DataStorage
;  Files
;  IO
; 
; CALLING SEQUENCE:
;*  BakRotate, files [,NUMBER=number] [,/NOCOMPRESS] [,INFIX=infix]
;
; INPUTS:
;   files :: a scalar or and array of filenames, that should be backed
;            up
;
; INPUT KEYWORDS:
;   NUMBER     :: maximal number of backups for a given file (Default: 5)
;   NOCOMPRESS :: backups (except) will not be compressed (Default for
;                 Windows)
;   INFIX      :: backups get filenames with a running number. This a
;                 by default separated by a ".". The separator may be
;                 changed with this keyword.
;
; EXAMPLE:
;
;*  $touch test
;*  BakRotate, 'test'
;*  $ls
;*  ;test.0 
;*  $touch test
;*  BakRotate, 'test'
;*  ;test.0     test.1.gz 
;*            
;*  ...
;*
;*  $touch test
;*  BakRotate, 'test'
;*  $ls
;*  ;test.0     test.2.gz  test.4.gz
;*  ;test.1.gz  test.3.gz 
;
;-
PRO BakRotate, files, NUMBER=number, NOCOMPRESS=nocompress, INFIX=infix



   Default, NUMBER    , 5
   IF (fix(!VERSION.Release) GE 4) AND (!VERSION.OS_FAMILY eq "Windows") THEN NOCOMPRESS=1 ELSE Default, NOCOMPRESS, 0 
   Default, INFIX, '.'
   
   ZIPSUFFIX = 'gz'

   gzip = Command('gzip')

   Assert, N_Params() EQ 1, 'at least on filename expected'
   Assert, TypeOf(files) EQ 'STRING', 'filename expected'
   
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
               FileMove, bakfiles(i), nbakfile
               IF (NOT NOCOMPRESS) AND (NOT zipped) THEN spawn, gzip+' '+nbakfile 
            END ELSE spawn, FileDel, bakfiles(i)

         END
         ; backup lastest file
         FileMove, files(k), files(k)+INFIX+'0'
         
      END
   END


END
