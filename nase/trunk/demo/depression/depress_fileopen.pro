;+
; NAME: depress_fileopen
;
;
; PURPOSE: siehe depress.pro
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/10/14 12:31:11  alshaikh
;           initial version
;
;
;-
PRO depress_FILEOPEN, dataptr, displayptr, group

; (noch) nicht implementiert

   ; Move to label 'skip' if IO-error occurs: 
   ON_IOERROR, skip



   skip: ;Message, /INFO, !ERR_STRING, /NONAME, /IOERROR

   done: 

END
