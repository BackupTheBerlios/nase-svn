;+
; NAME:                UShade_Surf
;
; AIM:
;  Display a shaded surface plot. Like IDL shade_surf, but works for
;  NULL device.
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
;     Revision 2.3  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 2.2  1999/11/04 17:31:40  kupper
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
;     Revision 2.1  1998/03/16 16:07:56  saam
;           fucking Null-Device !!
;
;
;-
PRO UShade_Surf, v1, v2, v3, _EXTRA=extra

   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN
      IF !D.Name NE 'PS' THEN BEGIN

        CASE N_Params() OF
            1 : Shade_Surf, v1,             _EXTRA=extra
            2 : Shade_Surf, v1, v2,         _EXTRA=extra
            3 : Shade_Surf, v1, v2, v3,     _EXTRA=extra
            ELSE: Message, 'wrong number of arguments'

         ENDCASE
      END
   END

END
