;+
; NAME:
;  UClose
;
; AIM:
;  generalized version of IDL's close function (allows zipping)
;
; PURPOSE:
;   Der Gegenspieler von <A>UOpenR</A>. Beide Routinen ermoeglichen
;   das transparente (sic!) Arbeiten mit gezippten Dateien.
; 
; CATEGORY:            
;  Files
;  Dirs
;  IO
;  OS
;
; CALLING SEQUENCE:
;*UClose, lun [,/VERBOSE] [,/ALL]
;
; INPUTS:              
;  lun:: die LUN der zu schliessenden Datei
;
; INPUT KEYWORDS:
;   VERBOSE:: die Routine wird geschwaetzig
;   ALL::     schliesst ALLE files
;
; COMMON BLOCKS:
;   UOPENR: enthaelt Filename und Zipstati der geoeffneten Files
;
; SEE ALSO:
;   <A>UOpenR</A>
;-

PRO UClose, lun, VERBOSE=verbose, ALL=all, _EXTRA=e

   COMMON UOPENR, llun

   On_Error, 2

   IF NOT Set(llun) THEN BEGIN
      Message, /INFO, 'this routine should only be used in conjunction with UOPENR !!!'
      IF Keyword_Set(ALL) THEN Close, /ALL
      RETURN
   END


   IF Keyword_Set(ALL) THEN BEGIN
      idx = WHERE(llun.lun NE !NONE, c)
   END ELSE BEGIN
      idx = WHERE(llun.lun EQ lun, c)
      IF c EQ 0 THEN BEGIN
         Print, 'UCLOSE: ooops, this lun is not my list..closing anyway (unzipped)'
         Close, lun
      END
   END
   
   FOR n=0,c-1 DO BEGIN
      actIdx = idx(n)
      Close, llun.lun(actIdx) &  Free_Lun, llun.lun(actIdx) &  llun.lun(actIdx)=!NONE &  llun.act=llun.act-1
      IF Keyword_Set(VERBOSE) THEN Print, 'UCLOSE: closing "'+llun.file(actIdx)+'"'
      IF llun.zip(actIdx) THEN BEGIN
         IF Keyword_Set(VERBOSE) THEN Print, 'UCLOSE: zipping "'+llun.file(actIdx)+'"'
         ZipFix, llun.file(actIdx)
      END
      llun.file(actIdx) = ''
   END

   IF Keyword_Set(ALL) THEN Close, /ALL

   IF Keyword_Set(VERBOSE) THEN Print, 'UCLOSE: ',STRCOMPRESS(llun.act, /REMOVE_ALL),' open file(s) left'
END
