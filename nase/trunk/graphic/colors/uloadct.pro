;+
; NAME:                ULoadCt
;
; PURPOSE:             Ersatz fuer LoadCt mit gleichen Aufrufoptionen,
;                      stellt aber sicher, dass Farbdarstellung auf
;                      allen Displays funktioniert.
;
; CATEGORY:            GRAPHIC
;
; CALLING SEQUENCE:    ULoadCt, nr [,KEYWORDS]
;
; INPUTS:              nr: der Index der Farbtabelle
;
; KEYWORD PARAMETERS:  siehe LoadCt
;
; EXAMPLE:
;                      ULoadCt, 5
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1998/02/05 13:29:48  saam
;           now handles the NULL device correctly
;
;     Revision 2.1  1997/11/07 11:29:46  saam
;           Schoepfung
;
;
;-
PRO ULoadCt, nr, _Extra=e

   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      IF !D.Name NE 'PS' THEN BEGIN
         Device, BYPASS_TRANSLATION=0
         Loadct, nr, _Extra=e
         Device, /BYPASS_TRANSLATION
      END
   END

END
