;+
; NAME:
;  NextPowerOf2()
;
; VERSION:
;  $Id$
;
; AIM:
;  Determines the power of 2 which is closest (up- or downward) to the argument.
;
; PURPOSE:
;  This function returns the power of 2 which is closest to <*>N</*> (the passed argument). Alternatively, it returns
;  the next power of 2 in the up- or downward direction from <*>N</*> (even if the next power of 2 in the opposite
;  direction may be closer). <*>N</*> must be of integer or float type (including, of course, byte, long, unsigned, etc.,
;  but no complex, structure, string or pointer, because for these types the "next power of 2" would make no sense).
;  If <*>N</*> already is a power of 2, the function returns the same value.<BR>
;  <*>N</*> can be a scalar or array; in the latter case, a result is determined for each element of <*>N</*>.
;  The result is of 64-bit integer type and has the same dimensional structure as <*>N</*>. (Remember, if necessary
;  and possible, to convert the result to a less memory consuming data type before running further operations on it.)<BR>
;  The function returns -1 for those elements of <*>N</*> which are smaller than 1 or larger than 2^62, because no
;  appropriate power of 2 can be determined by the algorithm in these cases.
;
; CATEGORY:
;  Algebra
;  Math
;
; CALLING SEQUENCE:
;* out = NextPowerOf2(n [,/UPPER] [,/LOWER])
;
; INPUTS:
;  N:: A scalar or array of any integer or float type containing the value(s) for which you want to know the closest
;      power of 2.
;
; INPUT KEYWORDS:
;  UPPER:: Set this keyword if you want to get the next power of 2 which is larger than <*>N</*>.
;  LOWER:: Set this keyword if you want to get the next power of 2 which is smaller than <*>N</*>.
;
; OUTPUTS:
;  out:: A variable of 64-bit integer type with the same dimensional structure as <*>N</*>, containing the desired
;        power(s) of 2.
;
; RESTRICTIONS:
;  If <*>N</*> is of a data type other than integer or float (or their variants), this is considered a fatal error.<BR>
;  For elements of <*>N</*> which are smaller than 1 or larger than 2^62, the function returns -1. This is <B>not</B>
;  considered a fatal error, but only produces a console warning message.<BR>
;  The two keywords <*>UPPER</*> and <*>LOWER</*> must not be set at the same time. If both keywords are set, <*>LOWER</*>
;  is ignored.
;
; PROCEDURE:
;  The binary logarithm of <*>N</*> is determined, and the adjacent integer exponents below and above represent the
;  two closest powers of 2. Depending on the exact position of the logarithm between the adjacent exponents and on the
;  specified keyword, the appropriate exponent is selected and used to calculate the desired power of 2.
;
; EXAMPLE:
;* Print, NextPowerOf2([45,46,0.5])
;
;  IDL prints (the first message refers to the "0.5"):
;
;* >(20)NEXTPOWEROF2:  Argument contains values out of acceptable range.
;* >                    32                    64                    -1
;
;-


FUNCTION  NextPowerOf2,   N,   upper = upper, lower = lower


   ; Checking parameters and errors:
   IF  N_Params() LT 1  THEN  Console, '  Wrong number of arguments.', /FATAL
   SizeN = Size(N)
   TypeN = SizeN(SizeN(0)+1)
   IF  (TypeN GE 6) AND (TypeN LE 11)  THEN  Console, '  Argument is of wrong type', /fatal
   Valid = (N GE 1) AND (N LE Long64(2)^62)   ; is =1 where N is within the acceptable range of the algorithm
   IF  TOTAL(1-Valid) NE 0  THEN  Console, '  Argument contains values out of acceptable range.', /warning
   ; (The variable "Valid" is also used in the expressions below in order to avoid arithmetic errors.)

   ; The binary logarithm of N is determined as well as the integer powers of 2 lying above and below it:
   ALog2_N   = ALog(Valid*Double(N)+1-Valid) / ALog(2D)
   UpperExp2 = Ceil( ALog2_N)
   LowerExp2 = Floor(ALog2_N)

   ; If specified explicitly, either the greater or the lower power of 2 is returned:
   IF  Keyword_Set(upper)  THEN  Return, Long64(2)^(Valid*UpperExp2) * Valid + Valid - 1
   IF  Keyword_Set(lower)  THEN  Return, Long64(2)^(Valid*LowerExp2) * Valid + Valid - 1
   ; Otherwise, that one power of 2 lying closer to N (geometrically, not arithmetically!) is returned:
   LowerNext  = (Alog2_N - LowerExp2) LE (UpperExp2 - Alog2_N)      ; is =1 where N is closer to the lower power of 2
   CloserExp2 = LowerNext * LowerExp2 + (1-LowerNext) * UpperExp2   ; contains the power of 2 which is closer to N
   Return, Long64(2)^(Valid*CloserExp2) * Valid + Valid - 1


END
