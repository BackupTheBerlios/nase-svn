;+
; NAME:               Path2Host
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
;     Revision 1.2  1998/02/05 11:21:17  saam
;           problems concerning automount dir '/tmp_mnt' fixed
;
;     Revision 1.1  1997/10/29 11:36:32  saam
;           aus getlocaldir extrahiert
;
;
;-
FUNCTION Path2Host, Path

   IF N_Params() NE 1 THEN Message, 'wrong calling syntax'
   
   Host = 'dummy'
   IF Contains(Path, '/ax1302')                                       THEN Host = 'ax1302'
   IF Contains(Path, '/ax1303')                                       THEN Host = 'ax1303'
   IF Contains(Path, '/usr/elauge1') OR Contains(Path, '/ax1315')     THEN Host = 'ax1315'
   IF Contains(Path, '/ax1317') OR Contains(Path, '/home/gonzo')      THEN Host = 'ax1317'
   IF Contains(Path, '/ax1318')                                       THEN Host = 'ax1318'
   IF Contains(Path, '/usr/ax1319')                                   THEN Host = 'ax1319'
   IF Contains(Path, '/usr/neuro') OR Contains(Path, '/home/neuro')   THEN Host = 'neuro'
   IF Host EQ 'dummy' THEN Message, 'could not get host where path "'+Path+'" resides'


   IF Contains(Path, '/tmp_mnt/') THEN Path = StrMid(Path, 8, 500)
   
   RETURN, Host

END
