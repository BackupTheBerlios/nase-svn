;+
; NAME:
;  DIREXISTS
;
; VERSION:
;  $Id$
;
; AIM:
;          tests the existence of a given directory
;
; PURPOSE:
;          Tests the existence of a given directory.
;
; CATEGORY:
;  Dirs
;  Files
;
; CALLING SEQUENCE:
;*          trueFalse = DirExists(directory)           
;
; INPUTS:
;           directory:: the name of the directory (string)
;
; OUTPUTS:             
;           trueFalse:: if exists returns 1, if not 0 
;
; RESTRICTIONS:
;      supported only sice IDL Version 5.3 (use of CATCH)
;
; EXAMPLE:
;
;*       if direxists('/tmp') then cd,'/tmp'
;        
; SEE ALSO: <A>FILEEXISTS</A>
;
;-

;;; look in headerdoc.pro for explanations and syntax,
;;; or view the NASE Standards Document


function direxists, dir

IDLVER = IDLVERSION(/FULL)
if IDLVER(0) LT 5 AND IDLVER(0) LT 3 then $
 console, /fatal, "support only for IDL Version 5.3 or higher (uses CATCH)"
if last(size(dir), pos=-1) NE 7 THEN $
  console, /fatal, "String expression required in this context: dir"
tmp_dir = dir
CATCH, Error_status

flag = 1
if Error_status NE 0 then begin 
   flag = 0
   tmp_dir = ''
endif
cd, tmp_dir, current=olddir

if flag eq 1 then cd, olddir


return, flag

end
