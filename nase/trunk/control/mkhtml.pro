;+
; NAME:                 MkHTML
;
; PURPOSE:              erstellt HTML-Dokumentation in allen Unterverzeicnissen mit Namen index.html
;
; CATEGORY:             GENERAL
;
; CALLING SEQUENCE:     MkHTML, Dir
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
;                       Aufruf nur im Haupt-Nasen-Verzeicnis sinnvoll, Mirko, 13.8.97
;-



PRO MkHTML

Spawn, 'pwd', MainDir
SubDirs   = ['graphic', 'misc', 'simu']
HTMLFile  = 'index.html'

FOR i=0, N_Elements(SubDirs)-1 DO BEGIN

   actDir = MainDir(0) + '/' + SubDirs(i)

   cd, actDir
   Mk_HTML_Help, actDir, actDir + '/' + HTMLFile
   
   ;Spawn, 'chmod g+w '+HTMLFile
END

cd, MainDir(0)

END
