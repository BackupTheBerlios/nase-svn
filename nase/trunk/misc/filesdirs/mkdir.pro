;+
; NAME:               MkDir
;
; AIM:                creates a directory
;  
; PURPOSE:            A Directory is created. UNIX-Specific!
;  
; CATEGORY:           FILES DIRS MISC
;  
; CALLING SEQUENCE:   mkdir, dir
;  
; INPUTS:             dir: the directory to be created (string)
;  
; RESTRICTIONS:       only works under UNIX-like environments
;  
; EXAMPLE:
;                     mkdir, '/tmp/sillyExample'
;  
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/06/19 14:43:13  saam
;              hmmm, what should i say
;
;-

PRO Mkdir, dir

ON_Error, 2
IF N_Params() NE 1 THEN Console, 'wrong argument count', /FATAL

;console, dir, /msg
c = Command('test')+' -d '+dir+' || '+Command('mkdir')+' -p '+dir
spawn, c, e


END
