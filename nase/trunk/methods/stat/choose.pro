;+
; NAME:
;  Choose()
;
; VERSION:
;  $Id$
;
; AIM:
;  This routine computes <*>n</*> choose <*>k</*>.
;
; PURPOSE:
;  This function determines <*>n</*> choose <*>k</*>, i.e., the number of different possible sample sets with <*>k</*>
;  elements taken from a set with <*>n</*> elements, either "scalar- or array-wise". <*>n</*> choose <*>k</*> is
;  defined as <*>n</*>!/(<*>k</*>!*(<*>n</*>-<*>k</*>)!).
;
; CATEGORY:
;  Algebra
;  CombinationTheory
;  Math
;  NumberTheory
;  Statistics
;
; CALLING SEQUENCE:
;* m = Choose(n, k)
;
; INPUTS:
;  n::  An integer or float array containing the argument(s) for the upper position in the "<*>n</*> choose <*>k</*>"
;       expression; the size(s) of the set(s) from which the sample sets are taken.
;  k::  An integer or float array containing the argument(s) for the lower position in the "<*>n</*> choose <*>k</*>"
;       expression; the size(s) of the sample sets.
;
; OUTPUTS:
;  m::  The result(s) of the operation; <*>n</*> choose <*>k</*>.
;
; RESTRICTIONS:
;  If "real" float values (no integers) are supplied for <*>n</*> or <*>k</*>, they are converted to float. There will
;  be no warning in such a case, because it is desirable that integer values represented as floating-point variables are
;  also accepted by the routine.
;
; PROCEDURE:
;  The expression <*>n</*>!/(<*>k</*>!*(<*>n</*>-<*>k</*>)!) is evaluated in an efficient way.
;
; EXAMPLE:
;* Print, '  Lottery chance: ', 100/Choose(49,6), ' %'
;
;  IDL prints (sad, but true):
;
;* >  Lottery chance:   7.1511238e-006 %
;
; SEE ALSO:
;  <*>n</*>! and <*>k</*>! are computed using IDL's <A>Factorial</A>! function.
;
;-



FUNCTION  Choose,   N_, K_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(N_) AND Set(K_))  THEN  Console, '   Not all arguments defined.', /fatal

   SizeN = Size(N_)
   SizeK = Size(K_)
   DimsN = Size(N_, /dim)
   DimsK = Size(K_, /dim)
   TypeN = Size(N_, /type)
   TypeK = Size(K_, /type)
   IF  (TypeN GE 6) AND (TypeN LE 11)  THEN  Console, '  N is of wrong type.', /fatal
   IF  (TypeK GE 6) AND (TypeK LE 11)  THEN  Console, '  K is of wrong type.', /fatal
   IF  (SizeN(0) NE SizeK(0)) OR (Max(DimsN NE DimsK) EQ 1)  THEN  Console, '  N and K must have the same size.', /fatal
   IF  Min(N_) LT 1  THEN  Console, '  N must be positive.'
   IF  Min(K_) LT 0  THEN  Console, '  K must be positive or zero.'

   ;----------------------------------------------------------------------------------------------------------------------
   ; Determining N choose K:
   ;----------------------------------------------------------------------------------------------------------------------

   NchooseK = Make_Array(dimension = DimsN, type = 5, /nozero)   ; double precision array for the result

   N = Long(N_)
   ; Since "choose" is symmetrical in K around N/2, the larger "version" of K is chosen in order to make computation
   ; more efficient:
   K = Long(K_ > (N_-K_))

   ; "N choose K" is computed for each N-K combination seperately in a FOR loop:
   FOR  iN = 0L, N_Elements(N)-1  DO  BEGIN
     ; Factorial(N) / Factorial(K) is determined as being (K+1)*(K+2)*...*N:
     FN_FK = 1D
     FOR  i = K(iN)+1, N(iN)  DO  FN_FK = i*FN_FK
     NChooseK(iN) = FN_FK / Factorial(N(iN)-K(iN))
   ENDFOR
   IF  SizeN(0) EQ 0  THEN  NChooseK = NChooseK(0)

   Return, NChooseK

END
