;+
; NAME: N_Gau_2D()
;
;
;
; PURPOSE: Erzeugt ein Array mit einer zweidimensionalen Volumennormierten Gaußverteilung.
;	   Diese Funktion erzeugt bis auf einen konstanten Faktor die gleiche Ausgabe wie Gauss_2D().
;
;
;
; CATEGORY: Allgemein, Kohonen, X-Zellen, Basic
;
;
;
; CALLING SEQUENCE: Diese Funktion ist aufrufkompatibel zu Gauss_2D:
;
;			Array = N_Gau_2D (x_Laenge, y_Laenge [,sigma | ,HWB=hwb] [,x0] [,y0] )
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
; OUTPUTS: Array: Ein ein- oder zweidimensionales Array vom Typ Double und der angegebenen Dimension mit 0<Maximum<1.
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
; RESTRICTIONS: Man beachte, dass diese Funktion eine Gaußverteilung erzeugt, die ein Gesamtvolumen von 1 HÄTTE, wenn
;		sie genuegend aufgelöst und unendlich ausgedehnt WÄRE.
;		Der Defaultwert für sigma ist so eingestellt, dass der Ausschnitt der Gausskurve, der das Array abdeckt,
;		normalerweise ausreichend groß ist, um ein Gesamtvolumen von ca. 1 zu gewährleisten.
;		So ist besipielsweise TOTAL ( n_Gau_2D(11,11) ) = 0.99523138
;		Insbesondere bei kleinen Array-Dimensionen (<=5) oder bei (sigma nicht << Arraylänge) oder 
;		wann auch immer ein genaues Gesamtvolumen von 1 benötigt wird (z.B. bei der Konstruktion
;	 	von Maxican Hats als Differunz von Gaußbergen) kann von Hand nachnormiert werden mit
;		Array = Array/TOTAL(Array).
;
;
;
; PROCEDURE: Default
;
;
;
; EXAMPLE: Bspl 1:	Int_Surf, n_Gau_2D (31,31)
;	   Bspl 2:	Int_Surf, n_Gau_2D (31,21, HWB=2, 5, 5)
;
;
;
; MODIFICATION HISTORY: Urversion irgendwann 1995 (?), Rüdiger Kupper
;			Fehlerhafte Normierung im 2D-Fall korrigiert am 21.7.1997, Rüdiger Kupper
;			Keyword HWB zugefügt am 21.7.1997, Rüdiger Kupper
;			Standard-Arbeitsgruppen-Header angefügt am 25.7.1997, Rüdiger Kupper
;-

Function n_Gau_2D, xlen,ylen,sigma, $
                   hwb=HWB, x0, y0       ;(optional)

 ; Defaults:
    Default, x0, 0
    Default, y0, 0
    Default, sigma, xlen/6d
    If keyword_set(HWB) then sigma=hwb/sqrt(alog(4))

   if ylen eq 1 then return, exp(-shift(dist(xlen,ylen),x0+xlen/2d)^2d / 2d /sigma^2d) / sigma/sqrt(2d*!DPI) 
   return, exp(-shift(dist(xlen,ylen),x0+xlen/2d,y0+ylen/2d)^2d / 2d /sigma^2) / sigma^2d / (2d*!DPI) 
end        
