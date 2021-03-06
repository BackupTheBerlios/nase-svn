;+
; NAME: NaseTV (obsolete)
;
; AIM: Display arrays in NASE-orientation. Optionally zoom and handle
;      zero values.
;
; PURPOSE: Darstellung von Layerdaten (Inputs, Outputs, Potentiale,
;          Gewichte...) wie mit TV, aber richtig gedreht.
;          (D.h. z.B. werden Gewichtsmatrizen in der gleichen
;          Orientierung dargestellt, wie auch ShowWeigts sie ausgibt.
;
; CATEGORY:
;   Graphic
;   Image
;   NASE
;
; CALLING SEQUENCE: Entspricht TV. Bis auf die zusätzlichen
;                   Schlüsselworte ZOOM und BLACKBACK.
;
; INPUT KEYWORDS:
;   ZOOM     :: Vergrößerungsfaktor. Erspart ein
;              explizites Rebin.
;   BLACKBACK:: Ist dieses Schlüsselwort gesetzt, so
;              werden alle Null-Elemente im Array in 
;              der aktuellen Hintergrundfarbe
;              !P.BACKGROUND dargestellt. Das ist
;              z.B. dann nützlich, wenn die
;              NASE-typische rot/grün-Farbtabelle
;              installiert ist. Dann erscheinen
;              Nullelemente nämlich leuchtend rot,
;              was meist wohl nicht erwünscht ist.
;              Mit /BLACKBACK erscheinen sie dann schwarz.
;
; EXAMPLE: NaseTV, MeinInput, ZOOM=4
;-

Pro NaseTv, _array, par1, par2, par3, ZOOM=zoom, ORDER=order, BLACKBACK=blackback, _EXTRA = _extra
   COMPILE_OPT OBSOLETE
     
   if keyword_set(ORDER) then order = 0 else order = 1

   default, array, _array       ;Don't change contents
   If (size(array))(0) gt 2 then array = reform(array, /overwrite) ;Try to get rid of leading 1's

   Default, zoom, 1

;   xsize = (SIZE(array))(1) * zoom
;   ysize = (SIZE(array))(2) * zoom

   If Keyword_Set(BLACKBACK) and (!P.BACKGROUND ne 0) then begin
      nullen = Where(array eq 0, count)
      If count ne 0 then array(nullen) = !P.BACKGROUND
   Endif

   case N_Params() of

;      1:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra
;      2:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1 
;      3:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2
;      4:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2, par3
      1:    UTVScl, /NOSCALE, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra
      2:    UTVScl, /NOSCALE, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1 
      3:    UTVScl, /NOSCALE, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1, par2
      4:    UTVScl, /NOSCALE, transpose(Temporary(array)), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1, par2, par3

   endcase

End


