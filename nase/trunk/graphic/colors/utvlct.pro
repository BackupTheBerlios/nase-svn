;+
; NAME:                UTvLCt
;
; AIM: Same as TvLct, but works for all devices (including NULL).
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
;     Revision 2.5  2000/10/01 14:50:57  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
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
      
      CASE N_Params() OF
         1 : TvLCt, v1,             _EXTRA=extra
         2 : TvLCt, v1, v2,         _EXTRA=extra
         3 : TvLCt, v1, v2, v3,     _EXTRA=extra
         4 : TvLCt, v1, v2, v3, v4, _EXTRA=extra
         ELSE: Message, 'wrong number of arguments'
      ENDCASE
      
   END

END
