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
; CALLING SEQUENCE: Array = Gauss_2D (x_Laenge, y_Laenge [,NORM] [,sigma | ,HWB=hwb] [,x0] [,y0] [,BLOW])
;
;
; 
; INPUTS: x_Lange, y_Laenge: Dimensionen des gewünschten Arrays. Für y_Laenge=1 wird ein eindimensionales Array erzeugt.
;
;
; OPTIONAL INPUTS: sigma           : Die Standardabweichung in Gitterpunkten. (Default = X_Laenge/6)
;                  Norm            : Volumen der Gaussmaske auf Eins normiert
;	  	   HWB		   : Die Halbwertsbreite in Gitterpunkten. Kann alternativ zu sigma angegeben werden.
;                  BLOW            : setzt sigma_x=xlen/6 und sigma_y=ylen/6 (default sigmax=sigmay=xlen/6),  
;                                    bzw. HWB_x=HWB HWB_y=ylen/xlen*HWB_x
;	  	   x0, y0	   : Die Position der Bergspitze(reltiv zum Arraymittelpunkt). Für x0=0, y0=0 (Default) liegt der Berg in der Mitte des
;			  	     Feldes. (Genauer: bei fix(Laenge/2)).
;                  x0_arr,y0_arr   : wie x0,y0, relativ zur linken oberen Arrayecke
;
;	
; KEYWORD PARAMETERS: HWB, x0_arr, y0_arr, s.o.
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
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.5  1997/11/25 17:03:32  gabriel
;              Blow Keyword eingesetzt
;
;        Revision 1.4  1997/11/10 19:08:44  gabriel
;             Option: /NORM fuer Volumennormierte Gaussmaske
;
;
;        Urversion irgendwann 1995 (?), Rüdiger Kupper
;        Keyword HWB zugefügt am 21.7.1997, Rüdiger Kupper
;        Standard-Arbeitsgruppen-Header angefügt am 25.7.1997, Rüdiger Kupper
;        Keywords X0_ARR und Y0_ARR zugefügt, 30.7.1997, Rüdiger Kupper
;-


Function Gauss_2D, xlen,ylen, $
                   sigma,NORM=norm,hwb=HWB, x0, y0,BLOW=blow ,$ ;(optional)
                   X0_ARR=x0_arr, Y0_ARR=y0_arr ;(optional)

  ; Defaults:
    Default, x0, 0
    Default, y0, 0
    Default, x0_arr, x0+xlen/2d
    Default, y0_arr, y0+ylen/2d

    IF set(BLOW) THEN BEGIN 
       Default, sigma, (xlen < ylen)/6d
    END ELSE BEGIN
       Default, sigma, (xlen)/6d
    endelse



  If keyword_set(HWB) then sigma=hwb/sqrt(alog(4))
  
  if ylen eq 1 then return, exp(-shift(dist(xlen,ylen),x0_arr)^2d / 2d /sigma^2d)           
  IF set(BLOW) THEN BEGIN
     
     ERG =  exp(-shift(dist(xlen < ylen , xlen < ylen),x0_arr < y0_arr,x0_arr < y0_arr)^2d / 2d /sigma^2d)  
     ERG =  congrid(ERG,xlen,ylen)
  END ELSE BEGIN 
     ERG =  exp(-shift(dist(xlen,ylen),x0_arr,y0_arr)^2d / 2d /sigma^2d) 
  ENDELSE

  If set(NORM) then ERG =  ERG /TOTAL(ABS(ERG))

  return, ERG(*,*)          
end
