;+
; NAME:               Path2Host
;
; AIM:                returns the hostname for a given path, where the actual harddisk originates (UNIX,MR)
;
; PURPOSE:            Ermittelt aus dem uebergebenen Pfadnamen den Host, auf dem
;                     sich das Verzeichnis befindet. Dies funktioniert fuer die
;                     Alphas (ax1302,ax1303,ax1315,gonzo,retsim,fozzy) und fuer 
;                     neuro.
;
; CATEGORY:           MISC
;
; CALLING SEQUENCE:   Host = Path2Host(Path)
;
; INPUTS:             Path: ein Pfadname
;
; OUTPUTS:            Host: der zugehoerige Host
;
; RESTRICTIONS:
;                     kann der Host nicht ermittelt werden bricht die Routine ab
;
; EXAMPLE:
;                     print, Path2Host('/usr/elauge1/bildmaterial')
;                     liefert: ax1315
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.8  2000/09/25 09:13:03  saam
;     * added AIM tag
;     * update header for some files
;     * fixed some hyperlinks
;
;     Revision 1.7  2000/08/31 17:22:00  saam
;           now also knows /vol/data
;
;     Revision 1.6  1999/07/28 08:37:26  saam
;           fiex a bug for host ax1319
;
;     Revision 1.5  1998/11/13 21:19:17  saam
;            now return on error
;
;     Revision 1.4  1998/11/08 14:59:53  saam
;           + improved behaviour for pathnames which don't contain a hostname
;           + linux-automounter problems resolved
;
;     Revision 1.3  1998/06/01 14:51:50  saam
;           problems with gonzo's new system corrected
;
;     Revision 1.2  1998/02/05 11:21:17  saam
;           problems concerning automount dir '/tmp_mnt' fixed
;
;     Revision 1.1  1997/10/29 11:36:32  saam
;           aus getlocaldir extrahiert
;
;
;-
FUNCTION Path2Host, Path
   
   On_Error, 2
   IF N_Params() NE 1 THEN Message, 'wrong calling syntax'
   IF NOT SET(PATH) THEN Message, 'argument undefined'
   
   PPath = RealFileName(Path)
   Host = 'unknown'
   IF Contains(PPath, '/ax1302')                                       THEN Host = 'ax1302'
   IF Contains(PPath, '/ax1303')                                       THEN Host = 'ax1303'
   IF Contains(PPath, '/usr/elauge1') OR Contains(PPath, '/ax1315')    THEN Host = 'ax1315'
   IF Contains(PPath, '/ax1317') OR Contains(PPath, '/home/gonzo')     THEN Host = 'gonzo'
   IF Contains(PPath, '/ax1318')                                       THEN Host = 'ax1318'
   IF Contains(PPath, '/ax1319')                                       THEN Host = 'ax1319'
   IF Contains(PPath, '/usr/neuro') OR Contains(PPath, '/home/neuro') OR Contains(PPath, '/vol')  THEN Host = 'neuro'

   IF Host EQ 'unknown' THEN BEGIN
      Message, /INFORMATIONAL, "can't resolve host for "+Path
      Message, /INFORMATIONAL, "defaulting to neuro"
      host = 'neuro'
   END

   RETURN, Host

END
