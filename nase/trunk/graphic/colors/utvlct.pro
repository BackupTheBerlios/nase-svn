;+
; NAME:                UTvLCt
;
; PURPOSE:             Ersatz fuer TvLCt mit gleichen Aufrufoptionen,
;                      stellt aber sicher, dass Farbdarstellung auf
;                      allen Displays funktioniert.
;
; CATEGORY:            GRAPHIC GENERAL
;
; SEE ALSO:            <A HREF="#ULOADCT">ULoadCt</A>, <A HREF="#UTVSCL">UTvScl</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  1998/05/25 12:51:57  kupper
;            Also, bei Postscripts einfach gar nicht zu tun, das war aber kein gutes Benehmen...
;
;     Revision 2.2  1998/02/27 13:20:57  saam
;           na was?? Bug in den HREFs
;
;     Revision 2.1  1998/02/27 13:15:44  saam
;           hoffentlich hat sich's bald mit den U-Dingern
;
;
;-
PRO UTvLCt, v1, v2, v3, v4, _EXTRA=extra

   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      IF !D.Name EQ 'X' THEN Device, BYPASS_TRANSLATION=0
      
      CASE N_Params() OF
         1 : TvLCt, v1,             _EXTRA=extra
         2 : TvLCt, v1, v2,         _EXTRA=extra
         3 : TvLCt, v1, v2, v3,     _EXTRA=extra
         4 : TvLCt, v1, v2, v3, v4, _EXTRA=extra
         ELSE: Message, 'wrong number of arguments'
      ENDCASE
      
      IF !D.Name EQ 'X' THEN Device, /BYPASS_TRANSLATION
   END

END
