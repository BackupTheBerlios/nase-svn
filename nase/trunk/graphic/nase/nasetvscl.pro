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
; CALLING SEQUENCE: Entspricht TVScl.
;
; EXAMPLE: NaseTVScl, MeinInput
;
; MODIFICATION HISTORY:
;
;       Thu Sep 11 14:48:25 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro NaseTvScl, array, par1, par2, par3, ORDER=order, _EXTRA = _extra
   
   if keyword_set(ORDER) then order = 0 else order = 1


   case N_Params() of

      1:    TVScl, transpose(array), ORDER=order, _EXTRA=_extra
      2:    TVScl, transpose(array), ORDER=order, _EXTRA=_extra, par1 
      3:    TVScl, transpose(array), ORDER=order, _EXTRA=_extra, par1, par2
      4:    TVScl, transpose(array), ORDER=order, _EXTRA=_extra, par1, par2, par3
   endcase

End
