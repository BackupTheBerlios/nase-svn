;+
; NAME: Gauss_2D()
;
;
;
; PURPOSE: Erzeugt ein Array mit einer zweidimensionalen Gaußverteilung mit Maximum 1.
;
;
;
; CATEGORY: Allgemein, Kohonen, X-Zellen, Basic
;
;
;
; CALLING SEQUENCE: Array = Gauss_2D (x_Laenge, y_Laenge [,sigma | ,HWB=hwb] [,x0] [,y0] )
;
;
; 
; INPUTS: x_Lange, y_Laenge: Dimensionen des gewünschten Arrays. Für y_Laenge=1 wird ein eindimensionales Array erzeugt.
;
;
; OPTIONAL INPUTS: sigma           : Die Standardabweichung in Gitterpunkten. (Default = X_Laenge/6)
;	  	   HWB		   : Die Halbwertsbreite in Gitterpunkten. Kann alternativ zu sigma angegeben werden.
;	  	   x0, y0	   : Die Position der Bergspitze. Für x0=0, y0=0 (Default) liegt der Berg in der Mitte des
;			  	     Feldes. (Genauer: bei fix(Laenge/2)).
;
;
;	
; KEYWORD PARAMETERS: HWB, s.o.
;
;
;
; OUTPUTS: Array: Ein ein- oder zweidimensionales Array vom Typ Double und der angegebenen Dimension mit Maximum 1.
;
;
;
; OPTIONAL OUTPUTS: ---
;
;
;
; COMMON BLOCKS: ---
;
;
;
; SIDE EFFECTS: ---
;
;
;
; RESTRICTIONS: Man beachte, dass die Arraydimensionen ungerade sein müssen, wenn der Berg symmetrisch im Array liegen soll!
;
;
;
; PROCEDURE: Default
;
;
;
; EXAMPLE: Bspl 1:	Int_Surf, Gauss_2D (31,31)
;	   Bspl 2:	Int_Surf, Gauss_2D (31,21, HWB=2, 5, 5)
;
;
;
; MODIFICATION HISTORY: Urversion irgendwann 1995 (?), Rüdiger Kupper
;			Keyword HWB zugefügt am 21.7.1997, Rüdiger Kupper
;			Standard-Arbeitsgruppen-Header angefügt am 25.7.1997, Rüdiger Kupper
;-


Function Gauss_2D, xlen,ylen, $
                   sigma, hwb=HWB, x0, y0             ;(optional)

  ; Defaults:
    Default, x0, 0
    Default, y0, 0
    Default, sigma, xlen/6d
    If keyword_set(HWB) then sigma=hwb/sqrt(alog(4))

  if ylen eq 1 then return, exp(-shift(dist(xlen,ylen),x0+xlen/2d)^2d / 2d /sigma^2d)           
  return, exp(-shift(dist(xlen,ylen),x0+xlen/2d,y0+ylen/2d)^2d / 2d /sigma^2d)          
end
