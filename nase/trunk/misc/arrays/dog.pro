;+
; NAME: DOG()
;
; SEE ALSO: <A HREF="#GAUSS_2D">Gauss_2D()</A>
;
; PURPOSE: Liefert eine DOG-Maske ('Difference of Gaussians') zurück.
;
; CATEGORY: Simulation, Allgemein
;
; CALLING SEQUENCE: Array = DOG ( XLen, YLen,
;                                { (,OnSigma, OffSigma) | (,ONHWB, OFFHWB) }
;                                [ ,x0 ,y0 ]
;                                [ ,X0_ARR, Y0_ARR] )
; 
; INPUTS: XLen, YLen       : Ausmaße des gewünschten Arrays
;         OnSigma, OffSigma: Stdabweichungen der beiden Gaussmasken, die überlagert werden.
;                            Für OnSigma < OffSigma erhält man On-Center/Off-Surround - DOGs,
;                            für umgekehrt - umgekehrt (was sonst?)
;
; OPTIONAL INPUTS: x0, y0  : Position des Zentrums bzg. der Mitte des Arrays
;
; KEYWORD PARAMETERS: ONHWB, OFFHWB: wie On/OffSigma nur in Halbwertsbreiten
;                     X0_ARR, Y0_ARR: wie x0/y0 nur bezügl. der linken oberen Arrayecke
;
; OUTPUTS: Eine entsprechende DOG-Maske mit ABS(Maximum)=1.0
;
; PROCEDURE: Zwei Gäusse besorgen mit <A HREF="#GAUSS_2D">Gauss_2D()</A>, auf 1 normieren, subtrahieren, abs(max) auf 1 addieren.
;
; EXAMPLE: XOnCellRecept = DOG(21,21, 2,3)
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.3  1998/03/09 15:24:02  kupper
;              Nur interne Änderung, wegen nichtfunktionierender _EXTRA-Implementation.
;
;       Revision 1.2  1997/11/25 12:51:18  kupper
;              Nur Header modifiziert.
;
;
;       Thu Sep 11 17:17:33 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Function DOG, xlen,ylen, $
                   onsigma, offsigma, ONHWB=onhwb, OFFHWB=offhwb, $
                   x0, y0, $                
                   X0_ARR=x0_arr, Y0_ARR=y0_arr

   Default, x0, 0
   Default, y0, 0

   on  = Gauss_2D (xlen, ylen, onsigma,  HWB=onhwb,  x0, y0, X0_ARR=x0_arr, Y0_ARR=y0_arr)
   off = Gauss_2D (xlen, ylen, offsigma, HWB=offhwb, x0, y0, X0_ARR=x0_arr, Y0_ARR=y0_arr)
   
   on  = on /total(on ) ; => Integral 1
   off = off/total(off) ; => Integral 1

   dog = on-off         ; => Integral 0
   
   return, dog/max([max(dog), -min(dog)]); abs(Zentrum) auf 1 normieren!

end
