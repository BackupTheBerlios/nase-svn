;+
; NAME:
;  ULoadCt
;
; VERSION:
;  $Id$
;
; AIM:
;  is more robust than IDLs <C>LoadCT</C>
;
; PURPOSE:
;  Replaces IDLs <C>LOADCT</C> with compatible but extended calling
;  syntax. It ensures that NASE color management works for all kinds
;  of displays. <BR> 
;  Unlike IDL's <C>LOADCT</C>, <C>ULoadCT</C> does not break if it is
;  called on the NULL device. The call is simply skipped. <BR>
;  The call is skipped also, if the current device is the X device,
;  and connecting to the X server is not allowed during this session
;  (see <A>XAllowed()</A> for details).
;
; CATEGORY:
;  Graphic
;  Color
;
; CALLING SEQUENCE:
;*ULoadCt, nr [,/REVERT] [,IDLKEYWORDS]
;
; INPUTS:
;  nr:: index of the color table
;
; INPUT KEYWORDS:
;  all Keywords as documented in the IDL help of <C>LoadCT</C> and
;  additionally:
;
;  REVERT:: The loaded colormap will be reverted. This is especially
;           useful with postscript output. 
;
;
; EXAMPLE:
;*ULoadCt, 5
;
; SEE ALSO:
;   <A>UTvLct</A>, <A>XAllowed()</A>.
;-

PRO ULoadCt, nr, REVERT=revert, _Extra=e

   ;; ----------------------------
   ;; Do absolutely nothing in the following cases, as code will break
   ;; otherwise:
   ;;
   ;; Device is the NULL device:
   If Contains(!D.Name, 'NULL', /IGNORECASE) then begin
      printf, -2, "% WARN: (ULOADCT) "+ $
        "Skipping call on 'NULL' device."
      flush, -2
      return
   endif
   ;; Device is the X device, but connecting to the X-Server is forbidden:
   If (!D.Name eq 'X') and not XAllowed() then begin
      printf, -2, "% WARN: (ULOADCT) "+ $
        "Connecting to X server is forbidden. Skipping call on 'X' device."
      flush, -2
      return
   endif
   ;; ----------------------------




   Loadct, nr, NCOLORS=!TOPCOLOR+1, _Extra=e
   
   ;; set the shading range to the continuous color table:
   Set_Shading, VALUES=[0, !TOPCOLOR]
   
   
  IF Keyword_Set(REVERT) THEN RevertCT

END
