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
   IF Contains(FilePath, '/tmp_mnt/') THEN Renorm = StrMid(FilePath, 8, 500)
   IF Contains(FilePath, '/a/') THEN BEGIN
      slashpos = StrPos(FilePath, '/', 3)
      IF slashpos LT 1 THEN Message, 'broke my neck, this shouldnt happen'
      Renorm = StrMid(FilePath, slashpos, 500)
   END

   RETURN, Renorm

END
