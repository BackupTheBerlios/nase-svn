;+
; NAME:
;  UXloadCT
;
; VERSION:
;  $Id$
;
; AIM:
;  Variation of IDL's XLoadCt compatible with NASE color management.
;
; PURPOSE:
;  <C>UXloadCT</C> is a wrapper to IDL's <C>XLOADCT</C>, that ensures
;  that the reserved NASE color entries above <*>!TOPCOLOR</*> are
;  protected. Care is taken, that these entries will not be
;  overwritten. In addition, a <*>/NASE</*> keyword is supplied for
;  easy access to the special NASE colortables. Furthermore, a bug in
;  IDL's <C>XLOADCT</C> is worked around.<BR>
;  Unlike IDL's <C>XLOADCT</C>, <C>UXLoadCT</C> does not break if it is
;  called on the NULL device. The call is simply skipped.
;  The call is skipped also, if the current device is the X device,
;  and connecting to the X server is not allowed during this session
;  (see <A>XAllowed()</A> for details).
;
; CATEGORY:
;  Color
;  NASE
;
; CALLING SEQUENCE:
;*UXloadCT [-all keywords to XLOADCT-] [,/NASE]
;
; INPUT KEYWORDS:
;  /NASE:: Setting this switch is equivalent to passing
;          <*>FILE=!NASEPATH+"/graphic/nase/NaseColors.tbl"</*>. It is
;          provided for convenience only.<BR>
; <BR>
;  For all other keywords, see IDL's documentation of <C>XLOADCT</C>.
;  The highest color index that <C>UXloadCT</C> will modify is
;  <*>!TOPCOLOR</*>.
;
; COMMON BLOCKS:
;   xloadct_com:: defined in IDL's implementation of <C>XLOADCT</C>,
;                 used for working around a bug.
;
; SIDE EFFECTS:
;  The current color table is modified.
;
; RESTRICTIONS:
;  The highest color index that <C>UXloadCT</C> will modify is
;  <*>!TOPCOLOR</*>.
;  
; PROCEDURE:
;  Do parameter checking, then call <C>XLOADCT</C>.
;
; EXAMPLE:
;*UXloadCT
;*UXloadCT, /NASE
;
; SEE ALSO:
;  IDL's <C>XLOADCT</C>, <A>ULoadCT</A>
;-

Pro UXLoadCt, NCOLORS=ncolors, BOTTOM=bottom, FILE=file, $
              _EXTRA=_extra, NASE=nase

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

   If Keyword_Set(NASE) then file = !NASEPATH+"/graphic/nase/NaseColors.tbl"

   ;; Workaround a bug in IDL's XLOADCT: if FILE was specified in a
   ;;   previous call to XLOADCT, but is not specified now, XLOADCT
   ;;   correctly reads the standard table names, but nevertheless
   ;;   remembers the OLD file when loading the actual colors!
   COMMON xloadct_com, r0, g0, b0, tfun, state, filename
   If not Keyword_Set(FILE) then undef, filename

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

   XLoadCt, NCOLORS=ncolors, BOTTOM=bottom, FILE=file, _EXTRA=_extra
End
