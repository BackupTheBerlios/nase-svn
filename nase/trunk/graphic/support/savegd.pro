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
;  <A>RestoreGD</A> can restore it whenever wanted. Additionally you
;  can save the current status in an arbitrary variable.<BR>
;  This routine is also called directly after the NASE startup, so you
;  can always use <A>RestoreGD</A> to get a defined status.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*SaveGD [,gd]
;
; OPTIONAL OUTPUTS:
;  gd:: returns a structure containing the status of the graphics
;       device. If not set, the status will be saved in <*>!SAVEGD</*>.
;  
; SIDE EFFECTS:
;  may create or modify the system variable <*>!SAVEGD</*>
;
; EXAMPLE:
;  Save the current state...
;*  SaveGD, gd
;...do some terrible graphics nonsense...
;*  make_nonsense
;...restore the previous state
;*  RestoreGD, gda
;...and everything is fine again
;
; SEE ALSO:
;  <A>RestoreGD</A>
;
;-
PRO SaveGD, gd

On_Error, 2

gd = { P: !P, X: !X, Y: !Y, Z: !Z }

IF N_Params() EQ 0 THEN BEGIN
    DefSysV, '!SAVEGD', EXISTS=e

    IF e EQ 1 THEN           !SAVEGD = gd $
              ELSE DefSysV, '!SAVEGD', gd 
END

END
