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
;     Revision 2.1  1997/11/07 11:29:46  saam
;           Schoepfung
;
;
;-
PRO ULoadCt, nr, _Extra=e

   IF !D.Name NE 'PS' THEN BEGIN
      Device, BYPASS_TRANSLATION=0
      Loadct, nr, _Extra=e
      Device, /BYPASS_TRANSLATION
   END

END
