;+
; NAME: Interleave ()
;
; PURPOSE: Überlagerung mehrer Arrays (i.d.R. zur Ausgabe mit TV) 
;
; CATEGORY: Graphik, Darstellung
;
; CALLING SEQUENCE: MischMasch = Interleave ( Arr1 [,Arr2 [,Arr3 [,Arr4 [,Arr5 [,Arr6 [,Arr7 [,Arr8]]]]]]] )
; 
; INPUTS: Arr? : bis zu acht Arrays GLEICHER GRÖSSE, die überlagert werden sollen.
;
; OPTIONAL INPUTS: s.o.
;	
; KEYWORD PARAMETERS: ---
;
; OUTPUTS: klar!
;
; OPTIONAL OUTPUTS: ---
;
; COMMON BLOCKS: ---
;
; SIDE EFFECTS: ---
;
; RESTRICTIONS: ---
;
; PROCEDURE: Arrayinhalte an geeigneten Stellen ins zielarray übernehmen.
;
; EXAMPLE: a=bytarr(200,200)
;          a(50:150,50:150)=1
;          b=shift(a,50,25)*2
;          c=shift(a,0,50)*3
;          x=rgb(255,0,0,INDEX=1)
;          x=rgb(0,255,0,INDEX=2)
;          x=rgb(0,0,255,INDEX=3)
;          tv, Interleave(a,b,c)
;
; MODIFICATION HISTORY:
;
;       Fri Aug 29 16:42:33 1997, Ruediger Kupper
;       <kupper@sisko.physik.uni-marburg.de>
;
;		Urversion.
;
;-

Function Interleave, a1,a2,a3,a4,a5,a6,a7,a8

   erg = a1

   elemente = n_elements(a1)
   arrays   = n_params()
   indizes  = lindgen(elemente/arrays+1)*arrays

   if arrays ge 2 then    erg(indizes(where(indizes+1 lt elemente))+1) = a2(indizes(where(indizes+1 lt elemente))+1)
   if arrays ge 3 then    erg(indizes(where(indizes+2 lt elemente))+2) = a3(indizes(where(indizes+2 lt elemente))+2)
   if arrays ge 4 then    erg(indizes(where(indizes+3 lt elemente))+3) = a4(indizes(where(indizes+3 lt elemente))+3)
   if arrays ge 5 then    erg(indizes(where(indizes+4 lt elemente))+4) = a5(indizes(where(indizes+4 lt elemente))+4)
   if arrays ge 6 then    erg(indizes(where(indizes+5 lt elemente))+5) = a6(indizes(where(indizes+5 lt elemente))+5)
   if arrays ge 7 then    erg(indizes(where(indizes+6 lt elemente))+6) = a7(indizes(where(indizes+6 lt elemente))+6)
   if arrays ge 8 then    erg(indizes(where(indizes+7 lt elemente))+7) = a8(indizes(where(indizes+7 lt elemente))+7)

   return, erg

end
