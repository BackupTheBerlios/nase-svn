;+
; NAME:
;  Diag()
;
; VERSION:
;  $Id$
;
; AIM:
;  extracts the main diagonal from an array
;
; PURPOSE:
;  Extracts the main diagonal from an array A(i1,..,ik) with arbitrary
;  dimensions. The result is a one dimensional array B containing
;  min(i1,...,ik) elements, with B(i)=A(i,...,i) i=0..min(i1,...,ik)-1.
;
; CATEGORY:
;  Algebra
;  Array
;
; CALLING SEQUENCE:
;* d = Diag(A)  
;
; INPUTS:
;  A :: array with arbitrary dimensions
;
; OUTPUTS:
;  d :: diagonal elements of A   
;
; PROCEDURE:
;  creates index array containing the indices to the relevant
;  positions and extracts them 
;
; EXAMPLE:
;*print, indgen(3,4)      
;*;    0       1       2
;*;    3       4       5
;*;    6       7       8
;*;    9      10      11
;*
;*print, diag(indgen(3,4))
;*;    0       4       8
;
;-


FUNCTION Diag, M
 
ON_Error, 2
; get indices of diagonal elements
MS = SIZE(M)
IF MS(0) EQ 0 THEN RETURN, M ;; its a scalar!!
minDim=MIN(MS(1:MS(0)))
id = 0l
FOR k=MS(0),1,-1 DO BEGIN
    id = id*MS(k) + lindgen(minDim)
END

RETURN, M(id)
END                                                                                                                                               
