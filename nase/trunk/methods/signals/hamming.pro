;+
; NAME:
;  Hamming()
;
; VERSION:
;  $Id$
;
; AIM:
;  Returns a hamming window of specified length.
;
; PURPOSE:
;  This function returns a one-dimensional array of length <*>n</*> which contains the hamming window function, scaled
;  to the respective lenght of the array. By default, the window function is normalized to its own power, i.e., its
;  energy is always equal to <*>n</*>. This is useful in so far as the absolute power or energy estimates are preserved
;  for stationary signals. If you prefer a hamming window with 1 as its peak value, set the keyword <*>NONORM</*>.
;
; CATEGORY:
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* w = Hamming(n [, /NONORM])
;
; INPUTS:
;  n::  An integer scalar giving the desired length of the hamming window (number of sample points).
;
; INPUT KEYWORDS:
;  NONORM::  Set this keyword in order to avoid the automatic normalization of the hamming window function to its own
;            power.
;
; OUTPUTS:
;  w::  A one-dimensional float array of length <*>n</*>, containing the hamming window function.
;
; EXAMPLE:
;* Plot , Hamming(64)
;* OPlot, Hamming(64, /NONORM), color = RGB('blue')
;
; SEE ALSO:
;  IDL's <*>Hanning</*> routine.
;
;-




FUNCTION  Hamming,   N,   nonorm = nonorm


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT Set(N)  THEN  Console, '   Argument N not defined.', /fatal
   TypeN = Size(N, /type)
   ; no integer or float:
   IF  (TypeN GE 6) AND (TypeN LE 11)  THEN  Console, '  N is of wrong type.', /fatal

   N = Round(N[0])   ; If N is an array, only the first value is taken seriously.

   ;----------------------------------------------------------------------------------------------------------------------
   ; Constructing the hamming window:
   ;----------------------------------------------------------------------------------------------------------------------

   a = 25./46.
   h = a - (1-a)*Cos(2*!pi*FIndGen(N)/N)

   IF  Keyword_Set(nonorm)  THEN  Return, h   $
                            ELSE  Return, h / Sqrt(Total(h^2)/N)


END
