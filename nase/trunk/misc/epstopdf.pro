;+
; NAME:
;  EPStoPDF
;
; VERSION:
;  $Id$
;
; AIM:
;  converts a given list (or the whole directory) of EPS files to PDF files
;
; PURPOSE:
;  if you're using PDFLaTeX you have to  use figures in PDF format. IDL
;  doesn't support PDF. EPStoPDF uses the EPStoPDF program
;  (probably exists under LINUX and WIN (if MIKTEX is installed)
;  computers.
;  
;
; CATEGORY:
;  Files
;  Graphic
;  NASE
;
; CALLING SEQUENCE:
;*EPStoPDF, FILE = file, REMOVEOLD=removeold, ALL=all
;
; INPUTS:
;  
;
; OPTIONAL INPUTS:
;  
;
; INPUT KEYWORDS:
;  FILE:: specifies a file or a list of files to convert. Has no
;         effect, if ALL is set
;  REMOVEOLD:: removes the EPS files if PDF was successfully generated
;  ALL:: process all files in a given directory (LINUX/UNIX only)
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
; You have to include the epstopdf-path into your PATH variable.
; Keyword ALL works only under LINUX/UNIX, because the filelist is
; generated via BASH shell-script.
;
;
; PROCEDURE:
; wrapper for epstopdf (shipped with the most latex distributions) 
;
; EXAMPLE:
;* epstopdf,/ALL
;*>
;
; SEE ALSO:
;
;-


pro epstopdf, FILE=file, REMOVEOLD=REMOVEOLD, ALL=ALL
   
   if set(ALL) then spawn,"for g in *.eps; do echo $g; done",file
   if not set(FILE) then console, /FATAL, "you have to specifiy at least one filename!"
   
   for i=0, n_elements(file)-1 do begin
      if fileexists(file(i)) then begin
         console, /MSG, "converting "+file(i)
         spawn, "epstopdf "+file(i), exit_status=foo
         if foo eq 0 then begin
            if set(REMOVEOLD) then FileDel, file(i)
         end 
      end else console, /MSG, file(i)+" doesn't exist"
   endfor
end

