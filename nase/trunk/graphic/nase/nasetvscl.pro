;+
; NAME: NaseTVScl
;
; PURPOSE: Darstellung von Layerdaten (Inputs, Outputs, Potentiale,
;          Gewichte...) wie mit TVScl, aber richtig gedreht.
;          (D.h. z.B. werden Gewichtsmatrizen in der gleichen
;          Orientierung dargestellt, wie auch ShowWeigts sie ausgibt.
;
; CATEGORY: Darstellung, Visualisierung
;
; CALLING SEQUENCE: Entspricht TVScl. Bis auf den ZOOM-Parameter.
;
; KEYWORD PARAMETERS: ZOOM: Vergrößerungsfaktor. Erspart ein explizites Rebin.
;
; EXAMPLE: NaseTVScl, MeinInput
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.2  1997/09/12 11:32:52  kupper
;       Keyword ZOOM für automatisches Rebin zugefügt.
;
;
;       Thu Sep 11 14:48:25 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro NaseTvScl, array, par1, par2, par3, ZOOM=zoom, ORDER=order, _EXTRA = _extra
   
   if keyword_set(ORDER) then order = 0 else order = 1

   Default, zoom, 1

   xsize = (SIZE(array))(1) * zoom
   ysize = (SIZE(array))(2) * zoom

   case N_Params() of

      1:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra
      2:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1 
      3:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2
      4:    TVScl, rebin(/SAMPLE, transpose(array), ysize, xsize), ORDER=order, _EXTRA=_extra, par1, par2, par3

   endcase

End
