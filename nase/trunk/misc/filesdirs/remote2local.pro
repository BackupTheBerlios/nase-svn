;+
; NAME:               Remote2Local
;
; PURPOSE:            Ein auf einem anderen Rechner liegendes Verzeichnis wird
;                     auf eine lokale Platte geschoben. Dabei brauchen die
;                     Verzeichnisse nicht ueber NFS sichtbar sein. Das kopieren
;                     erfolgt ueber TGZ-Files, um Zeit- und Netzaufwand zu 
;                     minimieren. Ist das Verzeicnis bereits lokal passiert nichts.
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   WorkingDir = Remote2Local(RemoteDir [, WishDir] [, /NOZIP])
;
; INPUTS:             RemoteDir: das Verzeichnis, was kopiert werden soll. Der
;                              zugehoerige Host wird aus dem Filenamen abgeleitet.
;
; OPTIONAL INPUTS:    WishDir: hier kann ein (lokales) Wunsch-Arbeitsdirectory
;                              angegeben werden. Ist es nicht lokal, wird dieses
;                              Argument ignoriert. Siehe auch: GetLocalDir()
;
; KEYWORD PARAMETERS: NOZIP: Sind die Daten in RemoteDir bereits gepackt kostet das
;                            erneute packen viel Zeit und bringt keinen Gewinn. Daher
;                            kann man es abschalten
;
; OUTPUTS:            WorkingDir: das temporaere Verzeichnis mit den lokalen Daten
;
; RESTRICTIONS:
;                     - im .rhosts-File muessen alle beteiligten Rechner eingetragen sein
;                     - NOZIP ist bei ax1302,ax1303,ax1315 Pflicht
;                     - keine Fehlerueberpruefung der Operationen
;
; EXAMPLE:
;                     IDL laeuft auf fozzy, Daten auf gonzo unter /home/gonzo/saam/sim/mastersim
;                     LocalDir = Remote2Local( '/home/gonzo/saam/sim/mastersim' )
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  1997/10/29 11:41:06  saam
;           Ermittlung des Hosts aus dem Pfadnamen in Path2Host
;     	ausgelagert
;
;     Revision 1.1  1997/10/29 11:10:44  saam
;          vom Klapperstorch gebracht
;
;
;-
FUNCTION Remote2Local, RemoteDir, WishDir, NOZIP=nozip


   IF N_Params() LT 1 THEN Message, 'there has to be at least one argument'
   
   
   TARFILE = 'zzz.tar'
   
   ; get hostname
   Spawn, 'hostname -s', LocalHost
   LocalHost = LocalHost(0)
   
   ; get username
   Spawn, 'whoami', User
   User = User(0)
   

   ; get the host where remote-dir resides
   RemoteHost = Path2Host(RemoteDir)

     
;
; --------> COPY DATA FROM DATADIR -> WORKINGDIR  (IF NEEDED)
;
   
   IF RemoteHost NE LocalHost THEN BEGIN
      ; data is not local      


      ; create local workingdir
      IF N_Params() EQ 2 THEN LocalDir = GetLocalDir(WishDir) ELSE LocalDir = GetLocalDir()

      ; zip original data in datadir on the local host
      spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; tar -cvf '+TARFILE+' *"'
      IF NOT Keyword_Set(NOZIP) THEN spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; gzip '+TARFILE+'"'
   
      ; copy data
      IF NOT Keyword_Set(NOZIP) THEN spawn, 'rcp '+User+'@'+RemoteHost+':'+RemoteDir+'/'+TARFILE+'.gz '+LocalDir $
      ELSE spawn, 'rcp '+User+'@'+RemoteHost+':'+RemoteDir+'/'+TARFILE+' '+LocalDir

      IF NOT Keyword_Set(NOZIP) THEN spawn, 'cd '+LocalDir+'; gunzip '+TARFILE+'.gz'
      spawn, 'cd '+LocalDir+'; tar -xvf '+TARFILE 
   
      ; clean zip/tar-files
      spawn, 'rm -f '+LocalDir+'/'+TARFILE
      IF NOT Keyword_Set(NOZIP) THEN spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; rm -f '+TARFILE+'.gz"' $
      ELSE spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; rm -f '+TARFILE+'"'

   END ELSE BEGIN
      ; data is local

      LocalDir = RemoteDir
      IF N_Params() EQ 2 THEN BEGIN
         IF RemoteDir NE WishDir THEN BEGIN
            ; the user seems to want a local copy
            LocalDir = GetLocalDir(WishDir)
            spawn, 'cp -R '+RemoteDir+'/* '+LocalDir
         END
      END
   END
   RETURN, LocalDir

END
