;+
; NAME: DogMin()
;
; AIM:  position of a DOG's minimum
;
; PURPOSE: Berechnet die Lage des Minimums einer DOG.
;
; CATEGORY: Simu, Analysis
;
; CALLING SEQUENCE: Xmin = DogMin( On_Sigma, Off_Sigma )
;
; INPUTS: On_Sigma, Off_Sigma : Standardabw. der Gäuße
;
; OUTPUTS: Xmin : x, für das DOG(x) minimal wird.
;
; PROCEDURE: Wird direkt ausgerechnet (Kurvendiskussion)
;
; RESTRICTIONS: Für On_Sigma < Off_Sigma ist die Stelle natürlich ein Maximum!
;
; EXAMPLE: myDOG = DOG (1000, 1, 100, 210, X0=0)
;          dummy = min(MyDOG, pos)
;          print, pos                  -> 239
;          print, DogMin(100,210)      -> 239.939
;
; SEE ALSO: <A HREF="#array/DOG">DOG()</A>
;-
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 2.2  2000/09/28 09:08:37  gabriel
;              AIM tag added
;
;        Revision 2.1  1998/03/03 16:30:43  kupper
;               Schöpfung.
;
;

function dogmin,s1,s2

   s1=float(s1)
   s2=float(s2)

   N1=1.0/(s1*sqrt(2.0*!PI))
   N2=1.0/(s2*sqrt(2.0*!PI))

   erg=6*alog(s1/s2)
   erg=erg/(s1^2.0-s2^2.0)
   erg=sqrt(erg)
   return, erg*s1*s2

end
