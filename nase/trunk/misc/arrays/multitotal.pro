;+
; NAME:
;  MultiTotal()
;
; AIM: returns sum or mean over several dimensions of an array (obsolete! use IMOMENT)
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
; RESTRICTIONS:
;  This routine was scheduled to be removed from the repository during
;  the first NASE workshop. It was meant to be replaced by IMEAN(),
;  but at the moment, IMEAN() has no possibility to total (not
;  average). Since this routine works pretty well, I commented out the
;  warning message. When IMEAN is ready to replace this routine, we
;  can think about it again...
;   Rüdiger.
;
; SEE ALSO: <A>IMean</A>, IDL help for <C>TOTAL()</C>.
;
;-

Function MultiTotal, Array, DimensionArray, MEAN=mean

;;   Console, '  This routine will be removed from the repository soon. Use IMean() instead.', /warning

;; what use is the next line? Something missing??
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
