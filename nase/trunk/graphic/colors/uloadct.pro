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
;  replaces IDLs <C>LoadCT</C> with compatible but extended calling
;  syntax. It ensures that NASE color management works for all kinds
;  of displays. 
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
;           useful with postscript output.<BR><BR> 
;
;
; EXAMPLE:
;*ULoadCt, 5
;
;-
PRO ULoadCt, nr, REVERT=revert, _Extra=e

   IF NOT Contains(!D.Name, 'NULL', /IGNORECASE) THEN BEGIN

      Loadct, nr, NCOLORS=!TOPCOLOR+1, _Extra=e
;      IF  !D.NAME NE 'PS' THEN BEGIN
;         !P.Background = RGB(0,0,0,/NOALLOC)
;      ENDIF

      ;; set the shading range to the continuous color table:
      Set_Shading, VALUES=[0, !TOPCOLOR]
  END
  IF Keyword_Set(REVERT) THEN RevertCT

END
