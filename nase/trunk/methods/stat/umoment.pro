;+
; NAME:
;  UMoment()
;
; VERSION:
;  $Id$
;
; AIM:
;  Mean, variance, skewness and kurtosis of an n-element vector.
;
; PURPOSE:
;  This function computes the mean, variance, skewness and kurtosis of
;  an n-element vector.  <BR> 
;  Reference: APPLIED STATISTICS (third edition), J. Neter,
;             W. Wasserman, G.A. Whitmore, ISBN 0-205-10328-6
;
; CATEGORY:
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* result = UMoment(x [,ORDER=...] [,/DOUBLE] [,MDEV=...] [,SDEV=...])
;
; INPUTS:
;  x:: An n-element vector of type integer, float or double.
;
; INPUT KEYWORDS:
;  ORDER:: The maximal order of the moment to calculate (default: 3).  
;  DOUBLE:: If set to a non-zero value, computations are done in
;           double precision arithmetic. 
;
; OUTPUTS:
;  result:: Moments of the distribution contained in
;           <*>x</*>. Undefined values are returned as <*>!NONE</*>.
;
; OPTIONAL OUTPUTS:
;  MDEV:: Use this keyword to specify a named variable which returns
;         the mean absolute deviation of <*>x</*>. 
;  SDEV:: Use this keyword to specify a named variable which returns
;         the standard deviation of <*>x</*>.
;
; SIDE EFFECTS:
;  If keyword <*>ORDER</*> is equal zero, no MDEV and SDEV are
;  calculated.
;
; PROCEDURE:
;  <C>UMoment()</C> computes the first four "moments" about the mean
;  of an n-element vector of sample data. The computational formulas
;  are given in the Univariate Statistics section of the Mathematics
;  Guide.
;
; EXAMPLE:
;  Define the n-element vector of sample data.
;*  x = [65, 63, 67, 64, 68, 62, 70, 66, 68, 67, 69, 71, 66, 65, 70]
;  Compute the mean, variance, skewness and kurtosis.
;*  result =UMoment(x)
;  The result should be the 4-element vector: 
;*> [66.7333, 7.06667, -0.0942851, -1.18258]
;
; SEE ALSO:
;  <A>IMoment()</A>. 
;
;-
;
; MODIFICATION HISTORY:
;
;       $Log$
;       Revision 1.8  2001/05/25 08:27:13  thiel
;          Header update.
;
;       Revision 1.7  2000/10/05 16:39:14  gabriel
;            KEYWORD order new
;
;       Revision 1.6  2000/09/28 09:48:34  gabriel
;             AIM tag added , message <> console
;
;       Revision 1.5  1999/07/28 08:48:19  saam
;             SDEV and MDEV are now set to !NONE, if necessary
;
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
;

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


FUNCTION UMoment, X,ORDER=ORDER, Double = Double, Mdev = Mdev, Sdev = Sdev

   ON_ERROR, 2
   default, order, 3
   

   if order gt 3 or order lt 0 then $
    Console, /FATAL , "Maximal order of moment is exceeded: "+str(order)

   TypeX = SIZE(X)

   ;Check length.
   if TypeX(TypeX(0)+2) eq 1 then BEGIN
      SDEV = !NONE
      MDEV = !NONE
      RETURN, ([X(0),0.0,!NONE,!NONE])(0:order)
   END

   if TypeX(TypeX(0)+2) lt 2 then $
    Console, /FATAL , "X array must contain 1 or more elements."

  ;If the DOUBLE keyword is not set then the internal precision and
  ;result are identical to the type of input.
  if N_ELEMENTS(Double) eq 0 then $
    Double = (TypeX(TypeX(0)+1) eq 5 or TypeX(TypeX(0)+1) eq 9)

  nX = TypeX(TypeX(0)+2)
  Mean = DATOTAL(X, Double = Double) / nX
  case order of 
     0: begin 
        return, [Mean]
     end
     1: begin
        Resid = X - Mean
        Var = DATOTAL(Resid^2, Double = Double) / (nX-1.0)
        Mdev = DATOTAL(ABS(Resid), Double = Double) / nX
        Sdev = SQRT(Var)
        return, [Mean, var] 
     end
     2: begin
        Resid = X - Mean
        Var = DATOTAL(Resid^2, Double = Double) / (nX-1.0)
        Mdev = DATOTAL(ABS(Resid), Double = Double) / nX
        Sdev = SQRT(Var)    
        if Sdev ne 0 then begin	;Skew & kurtosis defined?  
           return, [Mean,var,$
                    DATOTAL(Resid^3, Double = Double) / (nX * Sdev ^ 3)] 
        end else  RETURN, [Mean, Var, !NONE ]
     end
     3: begin
        Resid = X - Mean
        Var = DATOTAL(Resid^2, Double = Double) / (nX-1.0)
        Mdev = DATOTAL(ABS(Resid), Double = Double) / nX
        Sdev = SQRT(Var)     
        if Sdev ne 0 then begin	;Skew & kurtosis defined?  
           return, [Mean,var,$
                    DATOTAL(Resid^3, Double = Double) / (nX * Sdev ^ 3), $
                    DATOTAL(Resid^4, Double = Double) / (nX * Sdev ^ 4) - 3.0] 
        end else  RETURN, [Mean, Var, !NONE, !NONE]
     end
  endcase

  ;;;;;;;;;;;;;;;; this is the old part (obsolete) ;;;;;;;;;;;;;;;;;;;;;;;;

  Resid = X - Mean

  ;Mean absolute deviation (returned through the Mdev keyword).
  Mdev = DATOTAL(ABS(Resid), Double = Double) / nX
 
  Var = DATOTAL(Resid^2, Double = Double) / (nX-1.0)

  ;;;;;;;;;;;;;;;; this is the original code of IDL  ;;;;;;;;;;;;;;;;;;;;;;;;
    ;;Numerically-stable "two-pass" formula.
    ;;r2 = DATOTAL(Resid^2, Double = Double)
    ;;Var1 = r2 / (nX-1.0)
    ;;Var2 = (r2 - (DATOTAL(Resid, Double = Double)^2)/nX)/(nX-1.0)
    ;;Var =  (Var1 + Var2)/2.0
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

