;+
; NAME: SQRTM 
;
; AIM: matrix square root (first solution)
;
;
;
; PURPOSE: Matrix square root. B = sqrtm(A) is the matrix square root of A. 
;          A warning message is printed if the computed B#B is not close to A.
;
;
; CATEGORY: MATH
;
;
; CALLING SEQUENCE:  B=sqrtm(A[,X][,METHOD=METHOD][,_EXTRA=e])
;
; 
; INPUTS:  
;           A: (n,n) matrix
;
; OPTIONAL INPUTS:
;
;           X: (n,n) matrix as initial guess for the root matrix (needed by the fitting routines) 
;              default: X = sqrt(abs(A))*signum(A)
;	
; KEYWORD PARAMETERS:
;
;           METHOD:  0 for nonliner fitting routine NEWTON (default)
;                    1 for nonliner fitting routine BROYDEN            
;
;           _EXTRA:  the Keywords of the routines NEWTON or BROYDEN
;
; OUTPUTS:
;           B:  (n,n) matrix square root of A. (equ.: A = B#B)
;
;
; COMMON BLOCKS: COMMON SQRTM_BLOCK
;
;
; RESTRICTIONS:  Matrix A must have full rank. 
;                Not really all solutions would be found.
;                If A is real, symmetric and positive definite, 
;                then so is the computed matrix square root.
;
; EXAMPLE:
;            X = [[7,10][15,22]]
;            Y=sqrtm(X)
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.3  2000/09/28 08:49:57  gabriel
;         AIM tag added
;
;     Revision 2.2  2000/06/14 14:18:15  kupper
;     Test checkin to test CVS watch.
;
;     Revision 2.1  1999/07/15 16:08:40  gabriel
;           Eine neue Linalg Routine
;
;
;

FUNCTION sqrtm_func, X
   COMMON SQRTM_BLOCK,M
   s = size(M)
   _X = reform(X,s(1),s(2))
   RETURN, (_X#_X-M)(*)
END

FUNCTION SQRTM,A,X,METHOD=METHOD,_EXTRA=e
   COMMON SQRTM_BLOCK,M
   On_Error, 2
   undef,M
   default,METHOD,0
   default,X,sqrt(abs(A))*signum(A) ;;initial guess
   sa = size(A)
   sx = size(X)
   IF SA(0) NE 2 THEN Message, 'wrong arguments, must be a (n,n) symmetric matrix '
   IF SX(0) NE 2 THEN Message, 'wrong arguments, must be a (n,n) symmetric matrix '
   M = A ;;writing array in common block
   _X = X(*)
   CASE METHOD OF
      0: sqrt_res = NEWTON(X,  'sqrtm_func',_EXTRA=e)
      1: sqrt_res = BROYDEN(X, 'sqrtm_func',_EXTRA=e)
      ELSE: message,'unknown value for METHOD, known methods are 0: NEWTON, 1: BROYDEN'
   ENDCASE
   
   sqrt_res = reform(sqrt_res,sa(1),sa(2))
   variance = (umoment((sqrt_res#sqrt_res-A)(*)))(1)
   IF variance GT 1e-5 THEN print,'warning: X # X differs from input matrix, variance: '+str(variance)
   return,sqrt_res
END
