;+
; NAME:               Local2Remote
;
; PURPOSE:            Ein lokales Verzeichnis wird auf einen anderen Rechner kopiert. 
;                     Dabei brauchen die Verzeichnisse nicht ueber NFS sichtbar sein. 
;                     Das kopieren erfolgt ueber TGZ-Files, um Zeit- und Netzaufwand zu 
;                     minimieren.
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   Local2Remote, LocalDir, RemoteDir [, /NODEL] [, /NOZIP]
;
; INPUTS:             LocalDir: das Verzeichnis, was kopiert werden soll. 
;                     RemoteDir: das Zielverzeichnis. Der zugehoerige Host wird aus 
;                                dem Filenamen abgeleitet.
;
; KEYWORD PARAMETERS: NOZIP: Sind die Daten in RemoteDir bereits gepackt kostet das
;                            erneute packen viel Zeit und bringt keinen Gewinn. Daher
;                            kann man es abschalten
;                     NODEL: in diesem Fall werden die lokalen Daten nicht geloescht
;
; RESTRICTIONS:
;                     - im .rhosts-File muessen alle beteiligten Rechner eingetragen sein
;                     - NOZIP ist bei ax1302,ax1303,ax1315 Pflicht
;                     - keine Fehlerueberpruefung der Operationen
;
; EXAMPLE:
;                     Local2Remote, '/home/gonzo/saam/sim/mastersim', '/usr/elauge1/saam/test'
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  1997/10/29 15:00:05  saam
;           das lokale Verzeichnis (nocht die Daten) wurde bisher
;           nicht geloescht
;
;     Revision 1.2  1997/10/29 13:04:08  saam
;           NODEL-Option hinzugefuegt
;
;     Revision 1.1  1997/10/29 12:38:46  saam
;           aus Remote2Local entstanden
;
;
;-
PRO Local2Remote, LocalDir, RemoteDir, NOZIP=nozip, NODEL=nodel


   IF N_Params() NE 2 THEN Message, 'wrong syntax, read documentation'
      
   TARFILE = 'zzz.tar'
   
   ; get hostname
   Spawn, 'hostname -s', LocalHost
   LocalHost = LocalHost(0)

   ; get username
   Spawn, 'whoami', User
   User = User(0)
   
   


   ; get the host where remote-dir resides
   RemoteHost = Path2Host(RemoteDir)

   ; is LocalDir really local?
   IF Path2Host(LocalDir) NE LocalHost THEN Message, 'Local Dir is not really local' 
  
;
; --------> COPY DATA FROM LOCALDIR -> REMOTEDIR  (IF NEEDED)
;
   
   IF RemoteHost NE LocalHost THEN BEGIN
      ; data is not local      

      ; create remote dir
      spawn, 'rsh '+RemoteHost+' mkdir -p '+RemoteDir

      ; zip original data in localdir on the local host
      spawn, 'cd '+LocalDir+'; tar -cvf '+TARFILE+' *'
      IF NOT Keyword_Set(NOZIP) THEN spawn, 'cd '+LocalDir+'; gzip '+TARFILE
   
      ; copy data
      IF NOT Keyword_Set(NOZIP) THEN spawn, 'rcp '+LocalDir+'/'+TARFILE+'.gz '+User+'@'+RemoteHost+':'+RemoteDir $
      ELSE spawn, 'rcp '+LocalDir+'/'+TARFILE+' '+User+'@'+RemoteHost+':'+RemoteDir

      IF NOT Keyword_Set(NOZIP) THEN spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; gunzip '+TARFILE+'.gz"'
      spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; tar -xvf '+TARFILE+'"'  
   
      ; clean zip/tar-files

      IF NOT Keyword_Set(NOZIP) THEN spawn, 'rm -f '+LocalDir+'/'+TARFILE ELSE spawn, 'rm -f '+LocalDir+'/'+TARFILE+'.gz'
      spawn, 'rsh '+RemoteHost+' "cd '+RemoteDir+'; rm -f '+TARFILE+'"' 
      IF NOT Keyword_Set(NODEL) THEN spawn, 'rm -f '+LocalDir+'/*'

   END ELSE BEGIN
      ; data is local

      IF N_Params() EQ 2 THEN BEGIN
         IF RemoteDir NE LocalDir THEN BEGIN
            ; the user seems to want a local copy
            spawn, 'cp -R '+RemoteDir+'/* '+LocalDir
            IF NOT Keyword_Set(NODEL) THEN spawn, 'rm -f '+LocalDir
         END
      END
   END


   
END
