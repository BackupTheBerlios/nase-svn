;+
; NAME:               GetLocalDir
;
; AIM:                creates a local working directory (UNIX, MR)
;
; PURPOSE:            Auf dem Rechner, auf dem IDL laeuft wird ein
;                     lokales (temporaeres) Verzeicnis erstellt. Als
;                     optionales Argument kann ein Wunschverzeichnis
;                     angegeben werden, das genau dann benutzt wird,
;                     wenn es lokal ist. Um den Verzeichnisnamen ein-
;                     deutig zu machen, wird er um den User-Namen und einen 
;                     20-stelligen Zufallsnamen ergaenzt.
;                     Folgende Pfade sind Default:
;                       ax1302:  /usr/ax1302/...
;                       ax1303:  /usr/ax1303/...
;                       ax1315:  /usr/elauge1/...
;                       gonzo :  /home/gonzo/tmp...
;                       retsim:  /usr/ax1318.a/tmp...
;                       fozzy :  /usr/ax1319.a/tmp...
;                       neuro :  /home/neuro/tmp...                     
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   WorkingDir = GetLocalDir( [WishDir] )
;
; OPTIONAL INPUTS:    WishDir: ein (lokales) Wunschverzeichnis, das die Routine
;                              ggf. erstellt. Ist das Verzeichnis nicht lokal, dann
;                              wird das Argument ignoriert.
;
; OUTPUTS:            WorkingDir: das temporaere Verzeichnis auf dem lokalen Rechner
;
; EXAMPLE:
;                     IDL laeuft auf gonzo
;                     print, GetLocalDir( '/home/gonzo/saam/mysim' )
;                         ;liefert: /home/gonzo/saam/mysim/
;                     print, GetLocalDir( '/usr/ax1319.a/saam/mysim' )
;                         ;liefert z.B.: /home/gonzo/tmp/saam/hxqtupaycacmtmivxhwn/         
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.8  2000/09/25 09:13:02  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.7  1998/11/13 21:19:40  saam
;            now return on error
;
;     Revision 1.6  1998/06/01 14:51:50  saam
;           problems with gonzo's new system corrected
;
;     Revision 1.5  1998/02/09 16:33:23  saam
;           Pfadname enthaelt nun einen nachfolgenden Slash
;
;     Revision 1.4  1997/10/29 11:37:32  saam
;           Bestimmung des Hosts aus dem Pfadnamen ausgelagert in
;             Path2Host
;
;     Revision 1.3  1997/10/29 10:05:07  saam
;           print-Befehle vom Developing entfernt
;
;     Revision 1.2  1997/10/29 09:57:28  saam
;           Sinnvollere Variablennamen
;
;     Revision 1.1  1997/10/29 09:51:59  saam
;           vom Himmel gefallen
;
;
;-
FUNCTION GetLocalDir, WishDir

   COMMON Random_Seed, seed

   ON_ERROR,2 

   ; get hostname
   Spawn, 'hostname -s', Host
   Host = Host(0)
   
   ; get username
   Spawn, 'whoami', User
   User = User(0)
   

   IF N_Params() EQ 0 THEN BEGIN
      ; no WishDir passed
      CASE Host OF
         'ax1302' : WorkDir = '/usr/ax1302'
         'ax1303' : WorkDir = '/usr/ax1303'
         'ax1315' : WorkDir = '/usr/elauge1'
         'ax1317' : WorkDir = '/home/gonzo/tmp'
         'gonzo'  : WorkDir = '/home/gonzo/tmp'
         'ax1318' : WorkDir = '/usr/ax1318.a/tmp'
         'ax1319' : WorkDir = '/usr/ax1319.a/tmp'
         'neuro'  : WorkDir = '/home/neuro/tmp'
         
         ELSE: Message, 'no default dir for host '+STRING(Host)
      END
      
      ; generate user/temp-string
      TmpDir  = User + '/' + STRING([BYTE(97+25*RANDOMU(seed,20))])    
      WorkDir = WorkDir + '/' + TmpDir
   END ELSE IF N_Params() EQ 1 THEN BEGIN
      ; a WishDir was passwd

      WishHost = Path2Host(WishDir)
      IF WishHost EQ Host THEN WorkDir = WishDir ELSE WorkDir = GetLocalDir()

   END ELSE Message, 'wrong calling sequence'
   
   
   ; create directory if it doesnot exist 
   Spawn, 'mkdir -p '+ WorkDir
   
   RETURN, WorkDir+'/'
END
