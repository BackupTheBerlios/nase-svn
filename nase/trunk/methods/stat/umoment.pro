;+
; NAME:
;       UMOMENT
;
; PURPOSE:
;       This function computes the mean, variance, skewness and kurtosis
;       of an n-element vector. If it gets a scalar it returns it as 
;       mean and sets all other values to zero.
;
; CATEGORY:
;       STATISTICS.
;
; CALLING SEQUENCE:
;       Result = UMoment(X)
;
; INPUTS:
;       X:      An n-element vector of type integer, float or double.
;
; KEYWORD PARAMETERS:
;       MDEV:   Use this keyword to specify a named variable which returns
;               the mean absolute deviation of X.
;
;       SDEV:   Use this keyword to specify a named variable which returns
;               the standard deviation of X.
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
;       Revision 1.1  1998/03/14 14:00:39  saam
;             this is IDL4s moment-function with minor corrections
;
;
;-

function umoment, x, mdev = mdev, sdev = sdev

  on_error, 2
  nx = n_elements(x)
  if nx eq 1 then BEGIN
     mdev = 0
     sdev = 0
     RETURN, [x,0,0,0]
  END
  IF nx LT 1 THEN message, 'empty input'

  mean = total(x) / nx
  resid = x - mean
  ;Mean absolute deviation (returned through the MDEV keyword).
  mdev = total(abs(resid)) / nx
  r2 = total(resid^2)  
  var1 = r2 / (nx-1.0)
  var2 = (r2 - (total(resid)^2)/nx)/(nx-1.0)
  var =  (var1 + var2)/2.0
  ;Standard deviation (returned through the SDEV keyword).
  sdev = sqrt(var)

  if var ne 0 then begin 
    skew = total(resid^3) / (nx * sdev ^ 3)
    kurt = total(resid^4) / (nx * sdev ^ 4) - 3.0
  endif else message, $
     'Skewness and Kurtosis not defined for a sample variance of zero.'
  return, [mean, var, skew, kurt]
end

