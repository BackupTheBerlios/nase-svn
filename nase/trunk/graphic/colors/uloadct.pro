;+
; NAME:                ULoadCt
;
; AIM: Same as LoadCt, but works for all devices (including NULL).
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
;     Revision 2.9  2000/10/05 16:00:28  saam
;     * disabled setting of background color for non ps device
;       because color managment will change
;
;     Revision 2.8  2000/10/05 10:27:05  saam
;     shrinks color palette to !TOPCOLOR
;
;     Revision 2.7  2000/10/01 14:50:57  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.6  2000/07/07 14:15:52  gabriel
;           BGCOLOR BUG for ps plot fixed
;
;     Revision 2.5  2000/04/04 12:53:51  saam
;           sets the background to black (or
;           something that is nearly black)
;
;     Revision 2.4  1999/11/04 17:31:41  kupper
;     Kicked out all the Device, BYPASS_TRANSLATION commands. They
;     -extremely- slow down performance on True-Color-Displays when
;     connecting over a network!
;     Furthermore, it seems to me, the only thing they do is to work
;     around a bug in IDL 5.0 that wasn't there in IDL 4 and isn't
;     there any more in IDL 5.2.
;     I do now handle this special bug by loading the translation table
;     with a linear ramp. This is much faster.
;     However, slight changes in behaviour on a True-Color-Display may
;     be encountered.
;
;     Revision 2.3  1998/05/23 17:58:58  kupper
;            Also, bei Postscripts einfach gar nicht zu tun, das war aber kein gutes Benehmen...
;
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

      Loadct, nr, NCOLORS=!TOPCOLOR+1, _Extra=e
;      IF  !D.NAME NE 'PS' THEN BEGIN
;         !P.Background = RGB(0,0,0,/NOALLOC)
;      ENDIF
   END

END
