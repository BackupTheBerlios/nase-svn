; $Id$

PRO	GAUSSN__FUNCT,X,A,F,PDER
; NAME:
;	GAUSSN__FUNCT
;
; PURPOSE:
;	EVALUATE THE SUM OF A GAUSSIAN AND A 2ND ORDER POLYNOMIAL
;	AND OPTIONALLY RETURN THE VALUE OF IT'S PARTIAL DERIVATIVES.
;	NORMALLY, THIS FUNCTION IS USED BY CURVEFIT TO FIT THE
;	SUM OF A LINE AND A VARYING BACKGROUND TO ACTUAL DATA.
;
; CATEGORY:
;	E2 - CURVE AND SURFACE FITTING.
; CALLING SEQUENCE:
;	FUNCT,X,A,F,PDER
; INPUTS:
;	X = VALUES OF INDEPENDENT VARIABLE.
;	A = PARAMETERS OF EQUATION DESCRIBED BELOW.
; OUTPUTS:
;	F = VALUE OF FUNCTION AT EACH X(I).
;
; OPTIONAL OUTPUT PARAMETERS:
;	PDER = (N_ELEMENTS(X),6) ARRAY CONTAINING THE
;		PARTIAL DERIVATIVES.  P(I,J) = DERIVATIVE
;		AT ITH POINT W/RESPECT TO JTH PARAMETER.
; COMMON BLOCKS:
;	NONE.
; SIDE EFFECTS:
;	NONE.
; RESTRICTIONS:
;	NONE.
; PROCEDURE:
;	F = A(0)*EXP(-Z^A(3)/2)
;	Z = ABS((X-A(1))/A(2))
; MODIFICATION HISTORY:
;	WRITTEN, DMS, RSI, SEPT, 1982.
;	Modified, DMS, Oct 1990.  Avoids divide by 0 if A(2) is 0.
;	Added to Gauss_fit, when the variable function name to
;		Curve_fit was implemented.  DMS, Nov, 1990.
;
	n = n_elements(a)
;	ON_ERROR,2                      ;Return to caller if an error occurs
	if a(2) ne 0.0 then begin
	    Z = (ABS(X-A(1)))/A(2) 	;GET Z
	    EZ = EXP(-Z^A(3)/2.)	;GAUSSIAN PART
	endif else begin
	    z = 100.
	    ez = 0.0
	endelse

	case n of
4: 	F = A(0)*EZ
	ENDCASE

	IF N_PARAMS(0) LE 3 THEN RETURN ;NEED PARTIAL?
;
	PDER = FLTARR(N_ELEMENTS(X),n) ;YES, MAKE ARRAY.
	PDER(0,0) = EZ		;COMPUTE PARTIALS
        DZ = A(3)*Z^(A(3)-1)/2.
        SIG = Signum(X-A(1))
	if a(2) ne 0. then PDER(0,1) = A(0) * EZ * DZ * SIG / A(2)
	PDER(0,2) = A(0) * EZ * DZ * Z / A(2)
        d = where(Z GT 0,c)
        IF c NE 0 THEN PDER(d,3) = - A(0) * EZ(d) / 2. * (Z(d))^(A(3)) * alog(Z(d))
;	if n gt 3 then PDER(*,3) = 1.
;	if n gt 4 then PDER(0,4) = X
;	if n gt 5 then PDER(0,5) = X^2
	RETURN
END





Function GaussN_Fit, x, y, a, NTERMS=nt, ESTIMATES=est, CONVERGED=converged
;+
; NAME:
;	GAUSS_FIT
;
; PURPOSE:
; 	Fit the equation y=f(x) where:
;
; 		F(x) = A0*EXP(-z^2/2) + A3 + A4*x + A5*x^2
; 			and
;		z=(x-A1)/A2
;
;	A0 = height of exp, A1 = center of exp, A2 = sigma (the width).
;	A3 = constant term, A4 = linear term, A5 = quadratic term.
;	Terms A3, A4, and A5 are optional.
; 	The parameters A0, A1, A2, A3 are estimated and then CURVEFIT is 
;	called.
;
; CATEGORY:
;	?? - fitting
;
; CALLING SEQUENCE:
;	Result = GAUSS_FIT(X, Y [, A])
;
; INPUTS:
;	X:	The independent variable.  X must be a vector.
;	Y:	The dependent variable.  Y must have the same number of points
;		as X.
; KEYWORD INPUTS:
;	ESTIMATES = optional starting estimates for the parameters of the 
;		equation.  Should contain NTERMS (6 if NTERMS is not
;		provided) elements.
;	NTERMS = Set NTERMS to 4 to compute the fit: F(x) = A0*EXP(-z^A(3)/2).
;       CONVERGED: If set to a named variable, the status of the fit will
;               be returned.
;
; OUTPUTS:
;	The fitted function is returned.
;
; OPTIONAL OUTPUT PARAMETERS:
;	A:	The coefficients of the fit.  A is a three to six
;		element vector as described under PURPOSE.
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	None.
;
; RESTRICTIONS:
;	The peak or minimum of the Gaussian must be the largest
;	or smallest point in the Y vector.
;
; PROCEDURE:
;	The initial estimates are either calculated by the below procedure
;	or passed in by the caller.  Then the function CURVEFIT is called
;	to find the least-square fit of the gaussian to the data.
;
;  Initial estimate calculation:
;	If the (MAX-AVG) of Y is larger than (AVG-MIN) then it is assumed
;	that the line is an emission line, otherwise it is assumed there
;	is an absorbtion line.  The estimated center is the MAX or MIN
;	element.  The height is (MAX-AVG) or (AVG-MIN) respectively.
;	The width is found by searching out from the extrema until
;	a point is found less than the 1/e value.
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.1  1999/02/22 11:14:34  saam
;             new & cool
;
;       Revision 1.5  1998/03/10 17:05:24  saam
;             dirty bug with CONVERGED
;
;       Revision 1.4  1998/03/10 16:50:22  saam
;             new keyword CONVERGED
;             now uses ucurvefit
;
;
;       Thu Aug 21 10:56:14 1997, Mirko Saam
;		dies ist im wesentlichen die IDL 5 Routine von Gaussfit, die nun auch den Parameter NTerms akzeptiert
;
;-


;on_error,2                      ;Return to caller if an error occurs
csave = !c
if n_elements(nt) eq 0 then nt = 4
if nt NE 4 then $
   message,'NTERMS must have 4 values.'
n = n_elements(y)		;# of points.
s = size(y)

if n_elements(est) eq 0 then begin	;Compute estimates?
   ; sorry, dont have a real estimator
   ; too much work :-(
   a = [MAX(y), 0.0, 2.0, 2.0]
endif else begin
    if nt ne n_elements(est) then message, 'ESTIMATES must have NTERM elements'
    a = est
endelse

!c=csave			;reset cursor for plotting
return,ucurvefit(x,y,replicate(1.,n),a,sigmaa, $
		function_name = "GAUSSN__FUNCT", CONVERGED=converged) ;call curvefit

end
