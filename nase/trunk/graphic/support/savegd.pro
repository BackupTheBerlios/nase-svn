;+
; NAME:
;  SaveGD
;
; VERSION:
;  $Id$
;
; AIM:
;  saves relevant parameters of the current graphics device
;
; PURPOSE:
;  There are some routines that permanently change plotting parameters
;  (i.e. charsizes, axis parameter) in their normal operation or
;  during an exception. The original parameters are hard to restore by
;  hand, so most times IDL will be restarted instead. <C>SaveGD</C>
;  saves the current state of the graphic device (<*>!P</*>,
;  <*>!X</*>, <*>!Y</*>, <*>!Z</*>) and its partner
;  <A>RestoreGD</A> can restore it whenever wanted.<BR>
;  This routine is also called directly after the NASE startup, so you
;  can always use <A>RestoreGD</A> to get a defined status.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*SaveGD
;
; SIDE EFFECTS:
;  creates or modifies the system variable <*>!SAVEGD</*>
;
; EXAMPLE:
;*SaveGD
;
; SEE ALSO:
;  <A>RestoreGD</A>
;
;-
PRO SaveGD

DefSysV, '!SAVEGD', EXISTS=e

IF e EQ 1 THEN           !SAVEGD = { P: !P, X: !X, Y: !Y, Z: !Z } $
          ELSE DefSysV, '!SAVEGD', { P: !P, X: !X, Y: !Y, Z: !Z }

END
