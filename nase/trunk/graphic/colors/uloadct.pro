;+
; NAME:
;  ULoadCt
;
; VERSION:
;  $Id$
;
; AIM:
;  NASE compliant and more robust implementation of IDLs <C>LoadCT</C>
;
; PURPOSE:
;  Replaces IDLs <C>LOADCT</C> with compatible but extended calling
;  syntax. It ensures that NASE color management works for all kinds
;  of displays. The reserved NASE color entries above <*>!TOPCOLOR</*> are
;  protected. Care is taken, that these entries will not be
;  overwritten. In addition, a <*>/NASE</*> keyword is supplied for
;  easy access to the special NASE colortables.<BR> 
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
;*ULoadCt, nr [,/REVERT] [,/NASE] [,IDLKEYWORDS]
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
;  /NASE :: Setting this switch is equivalent to passing
;           <*>FILE=!NASEPATH+"/graphic/nase/NaseColors.tbl"</*>. It is
;           provided for convenience only.<BR>
;
; EXAMPLE:
;*ULoadCt, 5
;*ULoadCt, 5 ,/NASE
;
; SEE ALSO:
;   <A>UTvLct</A>, <A>UXLoadCT</A>, <A>XAllowed()</A>.
;-

PRO ULoadCt, nr, NCOLORS=ncolors, BOTTOM=bottom, REVERT=revert, FILE=file, NASE=nase, _Extra=e

   ;; ----------------------------
   ;; Do absolutely nothing in the following cases, as code will break
   ;; otherwise:
   ;;
   ;; Device is the NULL device:
   If Contains(!D.Name, 'NULL', /IGNORECASE) then begin
      console, /Warning, "Skipping call on NULL-device."
      return
   endif
   ;; Device is the X device, but connecting to the X-Server is forbidden:
   If (!D.Name eq 'X') and not XAllowed() then begin
      console, /Warning, "No X-connection allowed. Skipping."
      return
   endif
   ;; ----------------------------



   If Keyword_Set(NASE) then file = !NASEPATH+"/graphic/nase/NaseColors.tbl"

   Default, bottom, 0
   bottom = bottom > 0
   If bottom gt (!TOPCOLOR+2) then begin
      console, /Warning, "BOTTOM argument clipped to !TOPCOLOR+2 ("+str(!TOPCOLOR+2)+")"
      bottom = !TOPCOLOR+2
   endif

   Default, ncolors, !TOPCOLOR-BOTTOM+1
   ncolors = ncolors > 0
   If ncolors gt (!TOPCOLOR-BOTTOM+1) then begin
      console, /Warning, "NCOLORS argument clipped to !TOPCOLOR-BOTTOM+1 ("+str(!TOPCOLOR-BOTTOM+1)+")"
      ncolors = !TOPCOLOR-BOTTOM+1
   endif


   Loadct, nr, NCOLORS=ncolors, BOTTOM=bottom, FILE=file, _Extra=e
   
   ;; set the shading range to the continuous color table:
   Set_Shading, VALUES=[0, !TOPCOLOR]
   
   
  IF Keyword_Set(REVERT) THEN RevertCT

END
