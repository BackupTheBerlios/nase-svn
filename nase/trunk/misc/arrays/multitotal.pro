;+
; NAME:
;  MultoTotal()
;
; AIM: Return sum or mean over several dimensions of an array
;
; PURPOSE: This is a generalization of the IDL TOTAL() function. IDL's
;          TOTAL() allows to sum over one given dimension of an
;          array. However, in some cases, you want to sum over
;          several, not just one, dimensions. MultiTotal() returns the
;          sum or the average over several specified array dimensions.
;
; CATEGORY: MATH, ARRAY
;
; CALLING SEQUENCE: result = MultiTotal(Array, Dimensions[ ,/MEAN])
;
; INPUTS: Array     : Array to process
;         Dimensions: Array specifying the dimensions to total 
;
; KEYWORD PARAMETERS: /MEAN: Do not sum, but calculate the mean value
;                            over the given dimensions.
;
; OUTPUTS: result: an array with the given dimensions removed, each
;          value containing the sum or average of the removed
;          dimensions. (See also IDL help for function TOTAL()).
;
; PROCEDURE: Call TOTAL() in a loop and don't confuse indices :-)
;
; EXAMPLE:
;
; SEE ALSO: IDL help for TOTAL().
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.1  2000/06/14 14:07:04  kupper
;        Checked in at last!
;
;-

Function MultiTotal, Array, DimensionArray, MEAN=mean

   Default, DimensionArray

   Reihenfolge = Rotate(Sort([DimensionArray]), 2) ;umgekehrte Reihenfolge

   s = size(Array)
   erg = Array

   For i=0, n_elements(DimensionArray)-1 do begin
      erg = total(erg, DimensionArray(Reihenfolge(i)))
      If Keyword_Set(MEAN) then erg = erg/float(s(DimensionArray(Reihenfolge(i))))
   Endfor

   Return, erg

End
