;+
; NAME:                UShade_Surf
;
; PURPOSE:             Ersatz fuer ShadeSurf mit gleichen Aufrufoptionen,
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
;     Revision 2.1  1998/03/16 16:07:56  saam
;           fucking Null-Device !!
;
;
;-
PRO UShade_Surf, v1, v2, v3, _EXTRA=extra

   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      IF !D.Name NE 'PS' THEN BEGIN

         Device, BYPASS_TRANSLATION=0
         CASE N_Params() OF
            1 : Shade_Surf, v1,             _EXTRA=extra
            2 : Shade_Surf, v1, v2,         _EXTRA=extra
            3 : Shade_Surf, v1, v2, v3,     _EXTRA=extra
            ELSE: Message, 'wrong number of arguments'
         ENDCASE
         Device, /BYPASS_TRANSLATION
      END
   END

END
