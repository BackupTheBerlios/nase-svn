;+
; NAME:               FileOpen
;
; AIM:                checks, if an existing file is already opened
;
; PURPOSE:            Testet, ob ein BESTEHENDES File geoffnet ist.
;
; CATEGORY:           FILES
;
; CALLING SEQUENCE:   open = FileOpen(filename)
;
; INPUTS:             filename: ein existierender Filename
;
; OUTPUTS:            open: TRUE, falls es existiert, FALSE sonst
;
; RESTRICTIONS:       Existiert das File nicht, wird die Bearbeitung abgebrochen.
;
; EXAMPLE:            IF FileExists(FileName) THEN BEGIN
;                        IF FileOpen(FileName) THEN Print, 'File is open!' $
;                           ELSE Print, 'File is closed!'
;                     END ELSE Print, 'no such File'
;            
; SEE ALSO:           <A HREF="FILEEXISTS"FileExists</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/09/25 09:13:02  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 2.2  1998/04/10 12:13:54  saam
;           fuser was not in every users PATH, so
;           the PATH variable was completed
;
;     Revision 2.1  1998/04/09 14:35:41  saam
;           here we go
;
;
;-
FUNCTION FileOpen, filename
   
   On_Error, 2

   IF FileExists(filename) THEN BEGIN
      SetEnv, 'PATH=/usr/sbin:/bin:'+GetEnv('PATH')
      spawn, 'fuser '+filename, result
      IF result(0) NE '' THEN RETURN, 1 ELSE RETURN, 0
   END ELSE Message,'no such file!' 
   

END
