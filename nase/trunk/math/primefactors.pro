;+
; NAME:
;  PrimeFactors()
;
; VERSION:
;  $Id$
;
; AIM:
;  Determines the prime factors of a number <*>n</*>.
;
; PURPOSE:
;  This function performs a prime factorization of the passed positive integer number <*>n</*> and returns the
;  prime factors in an array. This can be useful when optimizing the length <*>n</*> of an array for performing a
;  Fast Fourier Transform. Due to restrictions imposed by the evaluated data structures, it is sometimes not possible
;  to choose <*>n</*> to be a power of 2. However, the duration of the FFT algorithm is proportional to the sum of
;  prime factors of <*>n</*>, and values of <*>n</*> are usually available which are not powers of 2, but also yield
;  an acceptable computational speed (cf. the example given below).
;
; CATEGORY:
;  Algebra
;  Math
;  NumberTheory
;
; CALLING SEQUENCE:
;* p = PrimeFactors(n)
;
; INPUTS:
;  n::  An integer scalar (no array) giving the number for which the prime factorization is to be performed. If you have
;       several numbers to be factorized, use a <C>FOR</C> loop in your program; there is no way to rationalize the
;       algorithm for multi-dimensional arrays.
;
; OUTPUTS:
;  p::  A 64-bit integer array containing the prime factors of <*>n</*> in ascending order.
;
; RESTRICTIONS:
;  <*>n</*> has to be a positive number.
;
; PROCEDURE:
;  All primes up to the square root of <*>n</*> are determined using IDL's <*>Primes</*> function. Starting from 2, each
;  prime is tested for being a prime divisor of <*>n</*> until the first prime divisor is found. This factor (p1) is kept,
;  and the prime factors of the remaining quotient <*>n</*>/p1 are determined recursively and concatenated to p1.
;
; EXAMPLE:
;  Search, in the range 370...400, for the number <*>n</*> with the smallest sum of prime factors:
;
;* PFSum = LonArr(51)
;* FOR  i=0,50  DO  PFSum(i) = Total(PrimeFactors(370+i))
;* MinPFSum = Min(PFSum, n)
;* Print, 'Best number:  ' + Str(370+n) + '  (sum of prime factors: ' + Str(MinPFSum) + ')'
;
;  IDL prints:
;
;* >Best number:  384  (sum of prime factors: 17)
;
; SEE ALSO:
;  <A>NextPowerOf2</A>
;
;-



FUNCTION   PrimeFactors, N_, P   ; The second argument is not meant for the caller, but only for internal use of the
                                 ; recursive algorithm!


   FORWARD_FUNCTION PrimeFactors

   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT Set(N_)  THEN  Console, '   Argument N not defined.', /fatal
   SizeN = Size(N_)
   TypeN = Size(N_, /type)
   IF  (TypeN GE 6) AND (TypeN LE 11)  THEN  Console, '  N is of wrong type.', /fatal
   IF  SizeN(0) NE 0                   THEN  Console, '  N must be a scalar.', /fatal
   IF  N_       LT 1                   THEN  Console, '  N must be positive.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Now the algorithm starts:
   ;----------------------------------------------------------------------------------------------------------------------

   N    = Long64(Round(N_))
   Root = SQRT(N)
   ; All primes up to the square root of N are determined (if not already passed in a recursive call; the primes are
   ; determined only once and then passed on recursively, which makes computation much more efficient).
   ; For this purpose, first, the number NP of primes in this range is estimated according to Legendre, 1785
   ; [ p(x)=~x/(ln(x)-1.08366) ], with an additional 100, just to be sure that no prime is missed:
   IF  NOT Set(P)  THEN  BEGIN
     NP = Long64(Root / (ALog(Root)-1.08366)) + 100
     P  = Long64(Primes(NP))        ; the first NP primes
     P  = P(Where(P LE (Root>2)))   ; only the primes up to SQRT(N) are taken
   ENDIF
   NP = Long64(N_Elements(P))     ; the number of primes up to SQRT(N)

   Factors = Long64(1)
   FOR  ip = Long64(0), NP-1  DO  IF  (N MOD P(ip)) EQ 0  THEN  BEGIN
                                    Factors = [ P(ip) , PrimeFactors(N/P(ip), P) ]
                                    GOTO, Finish
                                  ENDIF
   Finish:

   IF  Factors(0) NE 1  THEN  RETURN, Factors(WHERE(Factors NE 1))  $   ; prime factors were found
                        ELSE  RETURN, [N]                               ; no prime factors were found

END


;*************************************************************************************************************************
;*************************************************************************************************************************
