;+
; NAME:                 IARR
;
; PURPOSE:              Creates an array A that fulfilles the following
;                       condition:  A(i,j) = [i,j]  for arbitrary i,j  
;                       The Array therefore has the dimension (m,n,2),
;                       where m and n denote the maximal number of
;                       cols and rows, respectively.
;
; CATEGORY:             NASE MISC ARRAY
;
; CALLING SEQUENCE:     A = IArr(m,n)
;
; INPUTS:               m,n: number of cols and rows
;
; OUTPUTS:              A: array of dimension (m,n,2) with A(i,j)=[i,j]
;
; RESTRICTIONS:         + works only for two-dimnesional arrays (yet?!)
;                       + m,n have to be valid int/long and gt 0
;
; EXAMPLE:              A = IArr(10,5)
;                       print, reform(A(2,4,*))
;                       > 2  4
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.1  2000/06/19 14:48:21  saam
;             its was already documented
;
;-
FUNCTION IARR, d1, d2

ON_ERROR,2 

d = Set(d1)+Set(d2)
IF d NE 2 THEN Message, 'sorry, only for two dimensions'

i = REBIN(LIndGen(d1,d2), d1, d2, 2)
i(*,*,0)=i(*,*,0) MOD d1
i(*,*,1)=i(*,*,1)  /  d1

RETURN, i

END
