;+
; NAME:
;  Prime()
;
; VERSION:
;  $Id$
;
; AIM:
;  Determines whether a number <*>n</*> is a prime or not.
;
; PURPOSE:
;  This function just says whether the passed positive integer number(s) <*>n</*> is (are) prime or not and returns the
;  result as a boolean (0 or 1) scalar or array.
;
; CATEGORY:
;  Algebra
;  Math
;  NumberTheory
;
; CALLING SEQUENCE:
;* p = Prime(n)
;
; INPUTS:
;  n::  An integer scalar or array giving the number(s) which is (are) to be tested. If you have several numbers to be
;       tested, pass them in an array to avoid a <C>FOR</C> loop in your program.
;
; OUTPUTS:
;  p::  A byte array of the same dimensional structure as <*>n</*>, which states whether the corresponding value of
;       <*>n</*> is prime (1) or not (0).
;
; RESTRICTIONS:
;  <*>n</*> has to be positive.
;
; PROCEDURE:
;  All primes up to the maximum of <*>n</*> are determined using IDL's <*>Primes</*> function, and each element of
;  <*>n</*> is tested for whether it appears in the primes list or not. At the corresponding positions, <*>p</*> is set
;  to zero or to 1, respectively.
;
; EXAMPLE:
;  Test for all numbers in the range 1...1000 whether they are primes:
;
;* Plot, Prime(IndGen(999)+1), yrange=[-2,2]
;
; SEE ALSO:
;  <A>PrimeFactors</A>
;
;-



FUNCTION   Prime, N


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT Set(N)  THEN  Console, '   Argument N not defined.', /fatal
   DimsN = Size(N, /dim)
   TypeN = Size(N, /type)
   IF  (TypeN GE 6) AND (TypeN LE 11)  THEN  Console, '  N is of wrong type.', /fatal
   IF  Min(N) LT 1                     THEN  Console, '  N must be positive.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; The primes up to the maximum of N are determined:
   ;----------------------------------------------------------------------------------------------------------------------

   NMax = Max(N)   ; the maximum value of N
   ; For this purpose, first, the number NP of primes in this range is estimated according to Legendre, 1785
   ; [ p(x)=~x/(ln(x)-1.08366) ], with an additional 100, just to be sure that no prime is missed:
   NP = Long64(NMax / (ALog(NMax)-1.08366)) + 100
   P  = Long64(Primes(NP))        ; the first NP primes
   P  = P(Where(P LE (NMax>2)))   ; only the primes up to NMax are taken

   Return, Equal(N,P)


END
