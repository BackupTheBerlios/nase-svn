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
; CALLING SEQUENCE: Entspricht TV. Bis auf die zusätzlichen
;                   Schlüsselworte ZOOM und BLACKBACK.
;
; KEYWORD PARAMETERS: ZOOM     : Vergrößerungsfaktor. Erspart ein
;                                explizites Rebin.
;                     BLACKBACK: Ist dieses Schlüsselwort gesetzt, so
;                                werden alle Null-Elemente im Array in 
;                                der aktuellen Hintergrundfarbe
;                                !P.BACKGROUND dargestellt. Das ist
;                                z.B. dann nützlich, wenn die
;                                NASE-typische rot/grün-Farbtabelle
;                                installiert ist. Dann erscheinen
;                                Nullelemente nämlich leuchtend rot,
;                                was meist wohl nicht erwünscht ist.
;                                Mit /BLACKBACK erscheinen sie dann schwarz.
;
; EXAMPLE: NaseTV, MeinInput, ZOOM=4
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 2.4  1998/03/03 14:40:50  kupper
;              Benutzt jetzt UTVScl für Kompatibilität mit allerlei Devices...
;
;       Revision 2.3  1998/02/26 15:49:33  kupper
;              Schlüsselwort BLACKBACK hinzugefügt.
;
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

Pro NaseTv, array, par1, par2, par3, ZOOM=zoom, ORDER=order, BLACKBACK=blackback, _EXTRA = _extra
     
   if keyword_set(ORDER) then order = 0 else order = 1

;   Default, zoom, 1

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
      1:    UTVScl, /NOSCALE, transpose(array), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra
      2:    UTVScl, /NOSCALE, transpose(array), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1 
      3:    UTVScl, /NOSCALE, transpose(array), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1, par2
      4:    UTVScl, /NOSCALE, transpose(array), ORDER=order, STRETCH=ZOOM, _EXTRA=_extra, par1, par2, par3

   endcase

   ;;------------------> Veränderungen am Array rückgängig machen:
   If Keyword_Set(BLACKBACK) and (!P.BACKGROUND ne 0) then if (count ne 0) then array(nullen) = 0
   ;;--------------------------------

End


