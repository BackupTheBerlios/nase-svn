;+
; NAME:               RealFileName
;
; PURPOSE:            Bereinigt einen Pfadnamen um laestige/fehlerhafte
;                     Automounter-Pade wie /tmp_mnt, /a/
;
; CATEGORY:           MISC FILES+DIRS
;
; CALLING SEQUENCE:   RealFile = RealFileName(File)
;
; INPUTS:             File: ein Pfadname
;
; OUTPUTS:            Host: der normierte Pfadname
;
; EXAMPLE:
;                     print, RealFileName('/tmp_mnt/usr/ax1315/...')
;                     liefert: /usr/ax1315/...
;                     print, RealFileName('/a/ax1319/usr/ax1319.a/...')
;                     liefert: /usr/ax1319.a/...
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1999/07/28 08:38:12  saam
;           fixed a bug with slashes
;
;     Revision 2.2  1999/03/11 14:06:10  saam
;           + uses the much more flexible StrRepeat command
;           + completely rewritten
;           + works now!!
;
;     Revision 2.1  1998/11/13 21:16:02  saam
;           created because of several problems with
;           automounted directories, a wrong PWD-resolutions
;           leads to access to the internal automount-dirctories
;           with the consequence that paths which are
;           currently unmounted are and will not be availible,
;           this small routine fixes this problem. All other
;           routines in this directory use it...
;
;
;-
FUNCTION RealFileName, FilePath

   ON_Error, 2

   IF N_Params() NE 1 THEN Message, 'wrong calling syntax'
   
   Renorm = FilePath
   Renorm = StrReplace(Renorm, '/tmp_mnt/', '/')

   slashified = Str_Sep(Renorm, '/')
   IF N_Elements(slashified) GT 1 THEN BEGIN
      IF ((slashified(0) EQ '') AND (slashified(1) EQ 'a')) THEN Renorm = StrReplace(Renorm, '/'+slashified(1)+'/'+slashified(2)+'/', '/')
   END

   Renorm = StrReplace(Renorm, '/home/', '/usr/')
   Renorm = StrReplace(Renorm, '/gonzo/', '/ax1317/')
   Renorm = StrReplace(Renorm, '/./','/')
   Renorm = RemoveDup(Renorm, '/')

   RETURN, Renorm
END
