;+
; NAME: COV
;
;
; PURPOSE: Covariance matrix
;
;
; CATEGORY: METHODS
;
;
; CALLING SEQUENCE:    result=COV(X[,Y])
;
; 
; INPUTS:              
;            C = cov(x) where x is a vector returns the variance of the vector elements. 
;            For matrices where each row is an observation and each column a variable,
;            cov(x) is the covariance matrix.
;            C = cov(x,y), where x and y are column vectors of equal length, is equivalent to cov([[x],[y]]). 
;
;
; OUTPUTS:    result: the covariance matrix
;
;
; SIDE EFFECTS:   cov removes the mean from each column before calculating the result.
;
;
; EXAMPLE:
;
;
;
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1999/07/15 16:11:29  gabriel
;             Covariance matrix for matrices and vektors
;
;
;-
FUNCTION COV,X,Y
   On_Error, 2
   ;; check for argument count
   np = N_Params()
   IF (np GT 2) OR (np LT 1) THEN Message, 'wrong number of arguments'
   IF np EQ 2 THEN A = [[X],[Y]] $ 
    ELSE A = X
   s = size(A)
   ;;if A is a Vector
   IF S(0) EQ 1 THEN return,(umoment(A))(1)
   ;;if A is a Matrix
   cov_matrix = make_ARRAY(SIZE=[2,S(2),s(2),S(N_ELEMENTS(s)-2),S(2)^2])
   FOR I=0L,s(2)-1 DO BEGIN
      FOR J=0L, I DO BEGIN   
         coeff = total((reform(A(*,I))-(umoment(reform(A(*,I))))(0))*(reform(A(*,J))-(umoment(reform(A(*,J))))(0)))
         coeff = coeff/FLOAT(S(1))
         cov_matrix(i,j) =  coeff
         cov_matrix(j,i) =  coeff ;;the covariance matrix is symmetric
      ENDFOR
   ENDFOR
   return,cov_matrix
END
