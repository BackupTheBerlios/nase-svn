;+
; NAME:               FileOpen
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
;     Revision 2.1  1998/04/09 14:35:41  saam
;           here we go
;
;
;-
FUNCTION FileOpen, filename
   
   On_Error, 2

   IF FileExists(filename) THEN BEGIN
      spawn, 'fuser '+filename, result
      IF result(0) NE '' THEN RETURN, 1 ELSE RETURN, 0
   END ELSE Message,'no such file!' 
   

END
