;+
; NAME: Schwerpunkt()
;
; PURPOSE: Liefert die Koordinaten des (Masse-)Schwerpunktes in einem
;          Array beliebiger Dimension. 
;
; CATEGORY: miscellaneous, visualisation
;
; CALLING SEQUENCE: Ortsvektor = Schwerpunkt (Array)
;
; INPUTS: Array: Ein beliebiges Array (natürlich kein Stringarray...)
;
; OUTPUTS: Ortsvektor: Ortsvektor zum Schwerpunkt in Arraykoordinaten
;                      (Ursprung bei Array(0,0))
;
; RESTRICTIONS: Funktioniert auf allen Arrays, hat aber nicht mehr die
;               Aussage eines Masseschwerpunktes, wenn das Array
;               negative Wrte enthält... (Stichwort: Ladungsschwerpunkt) 
;
; PROCEDURE: Definitionsgemäß. Benutzt Subscript()
;
; EXAMPLE: myArr = Gauss_2D(21,21)
;          print, Schwerpunkt(myArr)
;                                     => Ausgabe: 10.000   10.000
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/10/29 17:29:45  kupper
;               Schöpfung!
;
;-

Function Schwerpunkt, Array

   s = size(Array)
   dims = s(0)
   erg = fltarr(dims)
   
   for i=0, N_Elements(Array)-1 do $
    erg = erg + Array(i)*Subscript(Array, i)
   
   return, erg/Total(Abs(Array))
   
End
