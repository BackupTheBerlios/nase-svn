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
; CALLING SEQUENCE: Entspricht TV.
;
; EXAMPLE: NaseTV, MeinInput
;
; MODIFICATION HISTORY:
;
;       Thu Sep 11 14:48:25 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Pro NaseTv, array, par1, par2, par3, ORDER=order, _EXTRA = _extra
     
   if keyword_set(ORDER) then order = 0 else order = 1


   case N_Params() of

      1:    TV, transpose(array), ORDER=order, _EXTRA=_extra
      2:    TV, transpose(array), ORDER=order, _EXTRA=_extra, par1 
      3:    TV, transpose(array), ORDER=order, _EXTRA=_extra, par1, par2
      4:    TV, transpose(array), ORDER=order, _EXTRA=_extra, par1, par2, par3
   endcase

End


