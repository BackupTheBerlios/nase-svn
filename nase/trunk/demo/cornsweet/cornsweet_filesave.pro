;+
; NAME: cornsweet_filesave
;
;
; PURPOSE:
;
;
; CATEGORY:
;
;
; CALLING SEQUENCE:
;
; 
; INPUTS:
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2000/02/16 10:20:35  alshaikh
;           initial version
;
;
;-

PRO cornsweet_FILESAVE, dataptr, group

   ; Move to label 'skip' if IO-error occurs: 
   ON_IOERROR, skip


   GOTO, done

   skip: Message, /INFO, !ERR_STRING, /NONAME, /IOERROR
         Message, /INFO, 'Nothing saved.' 

   done: 


END
