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
;*ULoadCt, nr [,/REVERT] [GAMMA=...] [,/NASE] [,IDLKEYWORDS]
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
;  GAMMA :: Gamma correction of the given value will be applied to the
;           color table. See also IDL's <C>GAMMA_CT</C> command.
;  /NASE :: Setting this switch is equivalent to passing
;           <*>FILE=!NASEPATH+"/graphic/nase/NaseColors.tbl"</*>. It is
;           provided for convenience only.<BR>
;
; EXAMPLE:
;*ULoadCt, 5
;*ULoadCt, 5 ,/NASE
;
; SEE ALSO:
;   <A>UTvLct</A>, <A>UXLoadCT</A>, <A>XAllowed()</A>, IDL's <C>GAMMA_CT</C>.
;-

PRO ULoadCt, nr, NCOLORS=ncolors, BOTTOM=bottom, REVERT=revert, $
             GAMMA=gamma, FILE=file, NASE=nase, _Extra=e

   common colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

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
   If bottom gt (!TOPCOLOR) then begin
      console, /Warning, "BOTTOM argument clipped to !TOPCOLOR ("+str(!TOPCOLOR)+")"
      bottom = !TOPCOLOR
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

  ;; gamma scaling:
  if set(GAMMA) then begin
;     R_CURR[BOTTOM:BOTTOM+NCOLORS-1] = (R_CURR[BOTTOM:BOTTOM+NCOLORS-1]/255.0)^gamma * 255 > 0 < 255
;     G_CURR[BOTTOM:BOTTOM+NCOLORS-1] = (G_CURR[BOTTOM:BOTTOM+NCOLORS-1]/255.0)^gamma * 255 > 0 < 255
;     B_CURR[BOTTOM:BOTTOM+NCOLORS-1] = (B_CURR[BOTTOM:BOTTOM+NCOLORS-1]/255.0)^gamma * 255 > 0 < 255
     i = ramp(NCOLORS, left=0.0, right=1.0) ^ gamma > 0.0 < 1.0
     R_CURR[BOTTOM:BOTTOM+NCOLORS-1] = R_CURR[BOTTOM+(NCOLORS-1)*i]
     G_CURR[BOTTOM:BOTTOM+NCOLORS-1] = G_CURR[BOTTOM+(NCOLORS-1)*i]
     B_CURR[BOTTOM:BOTTOM+NCOLORS-1] = B_CURR[BOTTOM+(NCOLORS-1)*i]
     utvlct, R_CURR, G_CURR, B_CURR
  endif
END
