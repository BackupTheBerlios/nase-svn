;+
; NAME: NaseTV
;
; PURPOSE: Darstellung von Layerdaten (Inputs, Outputs, Potentiale,
;          Gewichte...) wie mit TV, aber richtig gedreht.
;          (D.h. z.B. werden Gewichtsmatrizen in der gleichen
;          Orientierung dargestellt, wie auch ShowWeigts sie ausgibt.
;
; CATEGORY: Darstellung, Visualisierung
;
; CALLING SEQUENCE: Entspricht TV. Bis auf den ZOOM-Parameter.
;
; KEYWORD PARAMETERS: ZOOM: Vergrößerungsfaktor. Erspart ein explizites Rebin.
;
; EXAMPLE: NaseTV, MeinInput
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.2  1997/09/12 11:32:51  kupper
;       Keyword ZOOM für automatisches Rebin zugefügt.
;
;
;       Thu Sep 11 14:48:25 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro NaseTv, array, par1, par2, par3, ZOOM=zoom, ORDER=order, _EXTRA = _extra
     
   if keyword_set(ORDER) then order = 0 else order = 1

   Default, zoom, 1

   xsize = (SIZE(array))(1) * zoom
   ysize = (SIZE(array))(2) * zoom

   case N_Params() of

      1:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra
      2:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1 
      3:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2
      4:    TV, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2, par3
   endcase

End


