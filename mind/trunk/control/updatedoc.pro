;+
;
; NAME:                 UpdateDOC
;
; PURPOSE:              creates hypertext-documentation for MIND
;
; CATEGORY:             MIND CONTROL
;
; CALLING SEQUENCE:     UpdateDoc
;
; MODIFICATION HISTORY: 
;
;       $Log
;
;-
PRO UpdateDOC

   MINDdir =  '/vol/neuro/nase/mind'

   Print, "Updating HTML-Help..."
   cd, MINDdir, CURRENT=oldPWD
   Spawn, "cvs update"

   SubDirs   = ['control', 'demo', 'graphic', 'input', 'internal', 'sim', 'xplore']
   HTMLFile  = 'index.html'

   FOR i=0, N_Elements(SubDirs)-1 DO BEGIN
      cd, SubDirs(i) 
      Spawn, 'rm -f '+HTMLFile
      Mk_HTML_Help, MINDdir+'/'+SubDirs(i), MINDdir+'/'+SubDirs(i)+'/'+HTMLFile, TITLE='M.I.N.D. -  '+SubDirs(i)
      cd, '..'
   END

   cd, oldPWD
   print, !KEY.UP, "Updating HTML-Help...done"
   
END
