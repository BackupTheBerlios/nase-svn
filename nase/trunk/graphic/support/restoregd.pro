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
;*RestoreGD [,gd]
;
; OPTIONAL INPUTS:
;  gd:: structure returned by <A>SaveGD</A>. If not passed, the
;       routine will use the system variable <*>!SAVEGD</*>.
;
; SIDE EFFECTS:
;  modifies <*>!P</*>, <*>!X</*>, <*>!Y</*>, <*>!Z</*>
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
;  <A>SaveGD</A>
;
;-
PRO RestoreGD, gd

On_Error, 2

IF N_Params() EQ 0 THEN gd = !SAVEGD

!P = gd.P
!X = gd.X
!Y = gd.Y
!Z = gd.Z

END
