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
;       Revision 1.14  1998/06/10 16:31:04  neuroadm
;            big
;
;       Revision 1.13  1998/06/10 15:49:31  neuroadm
;             new hierarchy
;
;       Revision 1.12  1998/01/22 11:52:31  saam
;             Neues Directory alien
;
;       Revision 1.11  1998/01/21 22:20:40  saam
;             HTML-Seiten haben nun einen NASE-Titel
;
;       Revision 1.10  1997/12/10 17:10:21  saam
;             Fehler korrigiert
;
;       Revision 1.9  1997/12/03 10:53:39  gabriel
;             filter fuer pwd eingebaut "/a/ax1303" wird geloescht
;
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

Spawn, '/bin/pwd | sed "s/\/a\/ax1303//g"', MainDir
SubDirs   = ['alien',$
	     'control','control/counter','control/loops','control/output','control/time','control/video+tape',$
	     'graphic','graphic/colors','graphic/nase','graphic/plotcilloscope','graphic/sheets','graphic/support',$
	     'math',$
             'methods','methods/fits','methods/corrs+specs','methods/rfscan','methods/signals','methods/stat',$
             'misc','misc/arrays','misc/files+dirs','misc/handles','misc/keywords','misc/regler','misc/strings','misc/structures',$
	     'simu','simu/input','simu/connections','simu/layers','simu/plsticity']
HTMLFile  = 'index.html'

FOR i=0, N_Elements(SubDirs)-1 DO BEGIN

   actDir = MainDir(0) + '/' + SubDirs(i)

   cd, actDir
   Spawn, 'rm -f '+HTMLFile
   Mk_HTML_Help, actDir, actDir + '/' + HTMLFile, TITLE='N.A.S.E. -  '+SubDirs(i)
   
   ;Spawn, 'chmod g+w '+HTMLFile
END

cd, MainDir(0)

Spawn, 'mkaindex.sh '+ MainDir(0)


END
