;+
; NAME: NaseTVScl
;
; AIM: Display arrays in NASE-orientation. Optionally zoom.
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
;       Revision 2.6  2000/10/01 14:51:09  kupper
;       Added AIM: entries in document header. First NASE workshop rules!
;
;       Revision 2.5  1998/04/09 12:25:35  kupper
;              Reform-Bug bei 2-dim. Arrays mit führender 1-Dim.
;
;       Revision 2.4  1998/04/07 14:33:07  kupper
;              Macht nun automatisch ein reform(), falls das Array führende 1-Dimensionen hat...
;
;       Revision 2.3  1998/03/03 14:40:50  kupper
;              Benutzt jetzt UTVScl für Kompatibilität mit allerlei Devices...
;
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

Pro NaseTvScl, _array, par1, par2, par3, ZOOM=zoom, ORDER=order, _EXTRA = _extra
   
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
