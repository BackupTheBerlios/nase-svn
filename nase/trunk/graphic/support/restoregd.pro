;+
; NAME:
;  RestoreGD
;
; VERSION:
;  $Id$
;
; AIM:
;  restores relevant parameters for the current graphic device
;
; PURPOSE:
;  Restores a formerly saved status of the graphic device. See
;  <A>SaveDW</A> for a more extensive description. 
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*SaveGD
;
; SIDE EFFECTS:
;  modifies <*>!P</*>, <*>!X</*>, <*>!Y</*>, <*>!Z</*>
;
; EXAMPLE:
;*RestoreGD
;
; SEE ALSO:
;  <A>SaveGD</A>
;
;-
PRO RestoreGD

!P = !SAVEGD.P
!X = !SAVEGD.X
!Y = !SAVEGD.Y
!Z = !SAVEGD.Z

END
