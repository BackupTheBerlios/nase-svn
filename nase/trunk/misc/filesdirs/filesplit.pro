;+
; NAME:               FileSplit
;
; PURPOSE:            Zerlegt eine komplette Filebezeichnung in Pfad-
;                     und Filenamen
;
; CATEGORY:           MISC FILES DIRS
;
; CALLING SEQUENCE:   PathFile = FileSplit(filename)
;
; INPUTS:             filename: ein beliebiger Filename
;
; OUTPUTS:            PathFile: ein zweielementiger Stringarray.
;                               Das erste Element ist das Pfad, das
;                               zweite der Filename.
;
; RESTRICITIONS:      Der Filename wird nicht ueberprueft, sondern
;                     lediglich syntaktisch geparst.
;
; EXAMPLE:            
;                     print, FileSplit('/usr/ax1303/saam/test.tex')
;                     ['/usr/ax1303/saam/', 'test.tex']
;
;                     print, FileSplit('/usr/ax1303/saam/')
;                     ['/usr/ax1303/saam/', '']
;
;                     print, FileSplit('test.tex')
;                     ['', 'test.tex']
;           
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1999/02/22 11:14:37  saam
;           new & cool
;
;
;-
FUNCTION FileSplit, file

   On_Error, 2
   
   IF N_Params() NE 1 THEN Message, 'at least on filename expected'
   IF TypeOf(file) NE 'STRING' THEN Message, 'filename expected'

   
   frags = Str_Sep(RealFileName(File), '/')
   nfrags = N_Elements(frags)

   path = ''
   IF nfrags GT 1 THEN BEGIN
      FOR i=0,nfrags-2 DO BEGIN
         path = path+frags(i)+'/'
      END
   END 
   file = frags(nfrags-1)

   RETURN, [path, file]
END
