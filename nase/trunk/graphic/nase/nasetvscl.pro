;+
; NAME: NaseTVScl (obsolete)
;
; AIM: Display arrays in NASE-orientation. Optionally zoom.
;
; PURPOSE:
;  Darstellung von Layerdaten (Inputs, Outputs, Potentiale,
;  Gewichte...) wie mit TVScl, aber richtig gedreht.
;  (D.h. z.B. werden Gewichtsmatrizen in der gleichen
;  Orientierung dargestellt, wie auch ShowWeights sie ausgibt.
;
; CATEGORY:
;   Graphic
;   Image
;   NASE
;
; CALLING SEQUENCE: Entspricht TVScl. Bis auf den ZOOM-Parameter.
;
; INPUT KEYWORDS:
;   ZOOM:: Vergrößerungsfaktor. Erspart ein explizites Rebin.
;
; EXAMPLE: NaseTVScl, MeinInput
;-

Pro NaseTvScl, _array, par1, par2, par3, ZOOM=zoom, ORDER=order, _EXTRA = _extra
   COMPILE_OPT OBSOLETE

   if keyword_set(ORDER) then order = 0 else order = 1

   default, array, _array       ;Don't change contents
   If (size(array))(0) gt 2 then array = reform(array, /overwrite) ;Try to get rid of leading 1's

   Default, zoom, 1

;   xsize = (SIZE(array))(1) * zoom
;   ysize = (SIZE(array))(2) * zoom

   case N_Params() of

;      1:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra
;      2:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1 
;      3:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2
;      4:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2, par3
      1:    UTVScl, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra
      2:    UTVScl, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1 
      3:    UTVScl, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1, par2
      4:    UTVScl, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1, par2, par3

   endcase

End
