;+
; NAME: Subscript()
;
; PURPOSE: Liefert den korrespondierenden mehrdimensionalen Index zum
;          eindimensionalen Index eines Arrays.
;
; CATEGORY: miscellaneous
;
; CALLING SEQUENCE: Indizes = Subscript (Array, 1D_Index)
;
; INPUTS: Array: Das betreffende Array (Nur die Form wird beachtet,
;                                       Inhalt  gleichgültig.)
;         1D_Index: Der eindimensionale Index eines Elementes aus Array
;
; OUTPUTS: Indizes: Array vom Typ Integer, das soviele Elemente
;                   enthält, wie Array Dimensionen hat.
;                   Die Werte sind die entsprechenden
;                   mehrdimensionalen Indizes.
;
; PROCEDURE: Integer-Divisionen und Modulos
;
; EXAMPLE: Arr = IndGen(23,17,5)
;          print, Subscript(Arr, 999)
;                                      => Ausgabe: 10    9    2
;          print, Arr(10,9,2)
;                                      => Ausgabe: 999
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  1997/10/29 15:59:57  kupper
;        Schöpfung!
;
;-

Function Subscript, Array, Index
 
   i = Index
   s = Size(Array)
   erg = intarr(s(0))
   dims = s(0)
   divby = s(n_elements(s)-1)

   for dim=dims, 2, -1 do begin
      divby = divby/s(dim)
      erg(dim-1) = i/divby
      i = i mod divby
   endfor
   erg(0) = i

   return, erg

End
