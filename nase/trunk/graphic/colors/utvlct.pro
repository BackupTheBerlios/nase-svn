;+
; NAME:                UTvLCt
;
; PURPOSE:             Ersatz fuer TvLCt mit gleichen Aufrufoptionen,
;                      stellt aber sicher, dass Farbdarstellung auf
;                      allen Displays funktioniert.
;
; CATEGORY:            GRAPHIC GENERAL
;
; SEE ALSO:            <A HREF="#ULOADCT>ULoadCt</A>, <A HREF="#UTVSCL>UTvScl</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/02/27 13:15:44  saam
;           hoffentlich hat sich's bald mit den U-Dingern
;
;
;-
PRO UTvLCt, v1, v2, v3, v4, _EXTRA=extra

   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      IF !D.Name NE 'PS' THEN BEGIN

         Device, BYPASS_TRANSLATION=0
         CASE N_Params() OF
            1 : TvLCt, v1,             _EXTRA=extra
            2 : TvLCt, v1, v2,         _EXTRA=extra
            3 : TvLCt, v1, v2, v3,     _EXTRA=extra
            4 : TvLCt, v1, v2, v3, v4, _EXTRA=extra
            ELSE: Message, 'wrong number of arguments'
         ENDCASE
         Device, /BYPASS_TRANSLATION
      END
   END

END
