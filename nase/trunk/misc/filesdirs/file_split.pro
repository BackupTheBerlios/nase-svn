;+
; NAME:               File_Split
;
; PURPOSE:            Splits a filepath in a directory and a file part.
;
; CATEGORY:
;  Files
;  Dirs
;
; CALLING SEQUENCE:
;*PathFile = FileSplit(filepath)
;
; INPUTS:             filepath:: an arbitrary path to a file
;
; OUTPUTS:            PathFile:: a two element string array, containing
;                               first the path and second the file
;                               name.
;
; RESTRICITIONS:      The filename has to have a correct syntax.
;
; EXAMPLE:            
;* print, FileSplit('/usr/ax1303/saam/test.tex')
;* ['/usr/ax1303/saam/', 'test.tex']
;*
;* print, FileSplit('/usr/ax1303/saam/')
;* ['/usr/ax1303/saam/', '']
;*
;* print, FileSplit('test.tex')
;* ['', 'test.tex']
;
; SEE ALSO:
;  <A>FileSplit</A>
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
