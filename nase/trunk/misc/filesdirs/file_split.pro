;+
; NAME:               FileSplit
;
; PURPOSE:            Splits a filepath in a directory and a file part.
;
; CATEGORY:           MISC FILES DIRS
;
; CALLING SEQUENCE:   PathFile = FileSplit(filepath)
;
; INPUTS:             filepath: an arbitrary path to a file
;
; OUTPUTS:            PathFile: a two element string array, containing
;                               first the path and second the file
;                               name.
;
; RESTRICITIONS:      The filename has to have a correct syntax.
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
;     Revision 2.1  2000/09/08 13:54:03  kupper
;     Now using new File_Split(), as old FileSplit() modified the path to !NASE_LIB.
;
;     Revision 1.2  2000/06/19 13:30:08  saam
;           + doc header translated
;           + uses split now
;
;     Revision 1.1  1999/02/22 11:14:37  saam
;           new & cool
;
;
;-
FUNCTION File_Split, filepath

   On_Error, 2
   
   IF N_Params() NE 1 THEN Message, 'at least on filename expected'
   IF TypeOf(filepath) NE 'STRING' THEN Message, 'filename expected'

   
   frags = Split(filePath, '/')
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
