;+
; NAME:                 MkHTML
;
; PURPOSE:              erstellt HTML-Dokumentation in allen Unterverzeicnissen mit Namen index.html
;
; CATEGORY:             GENERAL
;
; CALLING SEQUENCE:     MkHTML, Dir
;
; EXAMPLE:              MkHTML
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 1.8  1997/11/20 19:55:03  gabriel
;            da war noch ein Bug in Spawn ' .....'
;
;       Revision 1.7  1997/11/20 19:48:15  gabriel
;            Jettzt werden alphabetische Listen fuer Routinen erzeugt
;
;       Revision 1.6  1997/11/11 16:46:54  saam
;             an neue Verzeichnisstruktur angepasst
;
;
;       Tue Aug 19 21:16:01 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;		Ergaenzung um stat-Ordner
;
;        initial version, Mirko Saam, 25.7.97
;        Aufruf nur im Haupt-Nasen-Verzeicnis sinnvoll, Mirko, 13.8.97
;-



PRO MkHTML

Spawn, 'pwd', MainDir
SubDirs   = ['control','input','graphic','graphic/nonase','misc', $
             'misc/array', 'misc/structures', 'simu', 'simu/connections',$
             'simu/layers', 'simu/plasticity', 'stat', 'video+tape']
HTMLFile  = 'index.html'

FOR i=0, N_Elements(SubDirs)-1 DO BEGIN

   actDir = MainDir(0) + '/' + SubDirs(i)

   cd, actDir
   Spawn, 'rm -f '+HTMLFile
   Mk_HTML_Help, actDir, actDir + '/' + HTMLFile
   
   ;Spawn, 'chmod g+w '+HTMLFile
END

cd, MainDir(0)

Spawn, 'mkaindex.sh '+ MainDir(0)


END
