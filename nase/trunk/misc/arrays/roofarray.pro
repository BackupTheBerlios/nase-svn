;+
; NAME: RoofArray
;
; AIM: 
;  Generates 2-dim array with values resembling shape of a roof.
;  
; PURPOSE:
;  Assigns stepwise decreasing values (seen from the center) to a two
;  dimensional array. In case of a square-sized array it looks like a
;  pyramid.<BR>  It is the two dimensional version of <C>Hill</C>, though more
;  restricted.  
;
; CATEGORY: 
;  Array
;
; CALLING SEQUENCE: 
;*  array = RoofArray(n [,m] [/INVERSE])
;
; INPUTS: 
;  n:: Number of columns in resulting object. If optional input
;      <*>m</*> is not set then it also indicates the number of rows of
;      the (thus square) output.
;
; OPTIONAL INPUTS: 
;  m:: Number of rows in the resulting array. Is <*>m</*>
;      not indicated the resulting array is sized <*>n x
;      <*>n</*>.
;
; INPUT KEYWORDS: 
;  INVERSE:: Is <*>INVERSE</*> set, the border of the array
;            has the highest value, otherwise the center is
;            highest in value.
;
; OUTPUTS: 
;  array:: Outputs the resulting array. It is of type float.
;
; PROCEDURE: 
;  1. syntax control<BR>
;  2. generating a square array assigned values resembling a
;            pyramid<BR>
;  3.  copiing the middle row resp. column for generating a
;            rectangular array
;
; EXAMPLE: 
;* print, RoofArray(5,7) <BR>
;  ergibt: <BR>
;> 0.00000      0.00000      0.00000      0.00000      0.00000 <BR>
;  0.00000      1.00000      1.00000      1.00000      0.00000 <BR>
;  0.00000      1.00000      2.00000      1.00000      0.00000 <BR>
;  0.00000      1.00000      2.00000      1.00000      0.00000 <BR> 
;  0.00000      1.00000      2.00000      1.00000      0.00000 <BR> 
;  0.00000      1.00000      1.00000      1.00000      0.00000 <BR>
;  0.00000      0.00000      0.00000      0.00000      0.00000 <BR>
;
; SEE ALSO:
;  <A>Hill</A>
;-


FUNCTION RoofArray, n, m, INVERSE=inverse

 
   IF n_elements(m) LE 0 THEN m = n

   IF (n LE 1) OR (m LE 1) THEN Message, 'Dimensions less than 2 are senseless!'
   
   quadrat = Min([n,m])
   
   centerfloat = (quadrat-1)/2.0 > 0.5

   center = Round(centerfloat)

   i_row = indgen(quadrat)
   i_row = rebin(i_row, quadrat, quadrat, /SAMPLE)
   i_col = transpose(i_row)
  
   a = Float(Fix(Abs(i_col-centerfloat) > abs(i_row-centerfloat)))

   IF (n EQ m) THEN IF Keyword_Set(INVERSE) THEN Return, a $
    ELSE Return, Abs(a-Max(a))

   b = FLTARR(n,m,/NOZERO)

   IF n GT m THEN BEGIN
      b(0:center-1,*) = a(0:center-1,*)
      b(center:n-center-1,*) = rebin(a(center,*),n-2*center,m, /SAMPLE)
      b(n-center:n-1,*) = a(quadrat-center:quadrat-1,*)
   ENDIF ELSE BEGIN
      b(*,0:center-1) = a(*,0:center-1)
      b(*,center:m-center-1) = rebin(a(*,center),n,m-2*center, /SAMPLE)
      b(*,m-center:m-1) = a(*,quadrat-center:quadrat-1)
   ENDELSE

   IF Keyword_Set(INVERSE) THEN Return, b ELSE Return, Abs(b-Max(b))
 
END

