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
;       $Log$
;       Revision 1.4  2000/01/27 10:55:41  saam
;             added learn dir
;
;       Revision 1.3  2000/01/19 17:50:21  saam
;             templates added
;
;       Revision 1.2  2000/01/11 14:19:14  saam
;             $ in log was missing
;
;
;-
PRO UpdateDOC

   MINDdir =  '/vol/neuro/nase/mind'

   Print, "Updating HTML-Help..."
   cd, MINDdir, CURRENT=oldPWD
   Spawn, "cvs update"

   SubDirs   = ['control', 'demo', 'graphic', 'input', 'internal', 'learn', 'sim', 'templates', 'xplore']
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
