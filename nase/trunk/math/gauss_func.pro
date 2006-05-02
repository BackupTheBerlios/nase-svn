;+
; NAME:
;  Gauss_func()
;
; VERSION:
;  $Id$
;
; AIM:
;  This is the good-old gaussian bell function.
;
; PURPOSE:
;  This is the good-old gaussian bell function.
;
; CATEGORY:
;  Math
;
; CALLING SEQUENCE:
;*y = Gauss_func( x, mean, sigma )
;
; INPUTS:
;  x:: the abscissa value
;  mean:: the mean of the distribution.
;  sigma:: the standard deviation of the distribution
;
; OUTPUTS:
;  y:: the ordinate value
;
; PROCEDURE:
;  Straightforward. <i>No</i> normalization factor is applied, the peak value
;  is 1.0.
;
; EXAMPLE:
;*
;*> x=Ramp(100, left=-7, right=13)
;*> Plot, x, Gauss_func(x, 3.0, 3.0)
;
; SEE ALSO:
;  <A>Fermi()</A>, <A>Gauss_2d()</A>, IDL's <C>Gauss_*()</C> functions.
;-

Function Gauss_func, x, mean, sigma
   return, exp( -0.5 * ( (x-mean)^2 / double(sigma)^2 ) )
End
