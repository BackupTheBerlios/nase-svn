;+
; NAME:               UMOMENT
;
; PURPOSE:            This function computes the mean, variance, skewness and kurtosis
;                     of an n-element vector. if values are not defined !NONE  will
;                     be returned instead
;
; CATEGORY:           METHODS STATISTICS
;
; CALLING SEQUENCE:   Result = UMoment(X, [,/DOUBLE] [,MDEV=mdev] [,SDEV=sdev])
;
; INPUTS:             X : An n-element vector of type integer, float or double.
;
; KEYWORD PARAMETERS: DOUBLE: If set to a non-zero value, computations are done in
;                             double precision arithmetic.
;                     MDEV:   Use this keyword to specify a named variable which returns
;                             the mean absolute deviation of X.
;
;                     SDEV:   Use this keyword to specify a named variable which returns
;                             the standard deviation of X.
;
; EXAMPLE:
;       Define the n-element vector of sample data.
;         x = [65, 63, 67, 64, 68, 62, 70, 66, 68, 67, 69, 71, 66, 65, 70]
;       Compute the mean, variance, skewness and kurtosis.
;         result = moment(x)
;       The result should be the 4-element vector: 
;       [66.7333, 7.06667, -0.0942851, -1.18258]
;
; PROCEDURE:
;       UMOMENT computes the first four "moments" about the mean of an 
;       n-element vector of sample data. The computational formulas 
;       are given in the Univariate Statistics section of the Mathematics
;       Guide.
;
; REFERENCE:
;       APPLIED STATISTICS (third edition)
;       J. Neter, W. Wasserman, G.A. Whitmore
;       ISBN 0-205-10328-6
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.4  1999/02/17 17:55:59  saam
;             + new keyword DOUBLE
;             + is stolen from moment.pro ( IDL5 )
;             + fixes the strange VARIANCE/STANDARD DEVIATION calculation of
;                IDL 3/4
;
;       Revision 1.3  1998/07/19 18:19:24  saam
;             error message for 'kurtosis not defined' removed
;
;       Revision 1.2  1998/06/01 14:34:03  saam
;             now returns !NONE for skew & kurt if undefined
;
;       Revision 1.1  1998/03/14 14:00:39  saam
;             this is IDL4s moment-function with minor corrections
;
;
;-

FUNCTION DATOTAL, Arg, Double = Double

  Type = SIZE(Arg)

  ;If DATOTAL is called without the Double keyword let the type
  ;of input argument drive the precision of TOTAL.
  if N_ELEMENTS(Double) eq 0 then Double = (Type(Type(0)+1) eq 5) or (Type(Type(0)+1) eq 9)
    
  ArgSum = TOTAL(Arg, Double = Double)

  if Type(Type(0)+1) eq 5 and Double eq 0 then $
    RETURN, FLOAT(ArgSum) else $
  if Type(Type(0)+1) eq 9 and Double eq 0 then $
    RETURN, COMPLEX(ArgSum) else $
    RETURN, ArgSum

END


FUNCTION UMoment, X, Double = Double, Mdev = Mdev, Sdev = Sdev

   ON_ERROR, 2

   TypeX = SIZE(X)

   ;Check length.
   if TypeX(TypeX(0)+2) eq 1 then BEGIN
      RETURN, [X(0),0.0,!NONE,!NONE]
   END

   if TypeX(TypeX(0)+2) lt 2 then $
    MESSAGE, "X array must contain 1 or more elements."

  ;If the DOUBLE keyword is not set then the internal precision and
  ;result are identical to the type of input.
  if N_ELEMENTS(Double) eq 0 then $
    Double = (TypeX(TypeX(0)+1) eq 5 or TypeX(TypeX(0)+1) eq 9)

  nX = TypeX(TypeX(0)+2)
  Mean = DATOTAL(X, Double = Double) / nX
  Resid = X - Mean

  ;Mean absolute deviation (returned through the Mdev keyword).
  Mdev = DATOTAL(ABS(Resid), Double = Double) / nX
 
  Var = DATOTAL(Resid^2, Double = Double) / (nX-1.0)
    ;Numerically-stable "two-pass" formula.
    ;r2 = DATOTAL(Resid^2, Double = Double)
    ;Var1 = r2 / (nX-1.0)
    ;Var2 = (r2 - (DATOTAL(Resid, Double = Double)^2)/nX)/(nX-1.0)
    ;Var =  (Var1 + Var2)/2.0

  ;Standard deviation (returned through the Sdev keyword).
  Sdev = SQRT(Var)

  if Sdev ne 0 then begin	;Skew & kurtosis defined?
    Skew = DATOTAL(Resid^3, Double = Double) / (nX * Sdev ^ 3)
    Kurt = DATOTAL(Resid^4, Double = Double) / (nX * Sdev ^ 4) - 3.0
      ;The "-3" term makes the kurtosis value zero for normal distributions.
      ;Positive values of the kurtosis (lepto-kurtic) indicate pointed or
      ;peaked distributions; Negative values (platy-kurtic) indicate flatt-
      ;ened or non-peaked distributions.
    RETURN, [Mean, Var, Skew, Kurt]
  endif else $		;All elements equal. Return NaN for skew & kurtosis
    RETURN, [Mean, Var, !NONE, !NONE]
end

