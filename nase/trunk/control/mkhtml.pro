;+
; NAME:                 MkHTML
;
; AIM:  Generates HTML documentation (index.html) in all subdirectories
;
; PURPOSE:              erstellt HTML-Dokumentation in allen Unterverzeichnissen mit Namen index.html
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
;       Revision 1.21  2000/09/28 13:23:55  alshaikh
;             added AIM
;
;       Revision 1.20  2000/08/16 16:34:36  kupper
;       Added directory "object/widget_object".
;
;       Revision 1.19  2000/02/21 17:16:22  kupper
;       Added "object" directory.
;
;       Revision 1.18  1999/09/02 13:22:07  kupper
;       Forgot graphic/widgets/faceit_demo...
;
;       Revision 1.17  1999/09/02 13:08:28  kupper
;       added new grahic/widgets directory.
;
;       Revision 1.16  1998/06/22 21:27:58  saam
;             compress-folder was missing
;
;       Revision 1.15  1998/06/10 16:32:48  neuroadm
;             bug
;
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
             'graphic','graphic/colors','graphic/nase','graphic/plotcilloscope','graphic/sheets','graphic/support','graphic/widgets','graphic/widgets/faceit_demo',$
             'math',$
             'methods','methods/fits','methods/corrs+specs','methods/rfscan','methods/signals','methods/stat',$ $
             'misc','misc/arrays','misc/files+dirs','misc/files+dirs/compress','misc/handles','misc/keywords','misc/regler','misc/strings','misc/structures',$
             'object','object/widget_object', $
             'simu','simu/input','simu/connections','simu/layers','simu/plasticity']
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
