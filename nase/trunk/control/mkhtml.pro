;+
; NAME:                 MkHTML
;
; PURPOSE:              erstellt HTML-Dokumentation in allen Unterverzeicnissen mit Namen index.html
;
; CATEGORY:             GENERAL
;
; CALLING SEQUENCE:     Mk_HTML
;
; INPUTS:               ---
;
; OPTIONAL INPUTS:      ---
;
; KEYWORD PARAMETERS:   ---
;
; OUTPUTS:              ---
;
; OPTIONAL OUTPUTS:     ---
;
; COMMON BLOCKS:        ---
;
; SIDE EFFECTS:         ---
;
; RESTRICTIONS:         ---
;
; PROCEDURE:            ---
;
; EXAMPLE:              MkHTML
;
; MODIFICATION HISTORY: initial version, Mirko Saam, 25.7.97
;
;-



PRO MkHTML

MainDir   = '/usr/ax1303/saam/idl_pro'
SubDirs   = ['graphic', 'misc', 'simu']
HTMLFile  = 'index.html'

FOR i=0, N_Elements(SubDirs)-1 DO BEGIN

   actDir = MainDir + '/' + SubDirs(i)

   cd, actDir
   Mk_HTML_Help, actDir, actDir + '/' + HTMLFile
   
   Spawn, 'chmod g+w '+HTMLFile
END


END
