;+
; NAME:
;  Subsample()
;
; VERSION:
;  $Id$
;
; AIM:
;  Resamples an already discrete one- or twodimensional array.
;
; PURPOSE:
;  Subsample a two-dimensional array, respecting the sampling
;  theorem. The original array is low-pass filtered prior to
;  resampling. Note that IDL's faster <C>REBIN()</C> function produces
;  comparable results in many cases. (<C>REBIN()</C> uses
;  near-neighbour-averaging, i.e. convolution with a box car
;  function.) Use <C>Subsample()</C> where respecting the sampling
;  theorem is crucial.
;
; CATEGORY:
;  Array
;  Graphic
;  Signals
;
; CALLING SEQUENCE:
;* result = Subsample (A, fraction [,/EDGE_WRAP|,/EDGE_TRUNCATE])
;* result = Subsample (A [,SIGMA=...|,HMW=...]   [,/EDGE_WRAP|,/EDGE_TRUNCATE])
;
; INPUTS:
;  A:: The array to subsample. This must be one or twodimensional,
;      squareness is not required.
;  fraction:: The distance of sampling points (= the factor by which to reduce
;             the array size). This is not required to be an integer value.
;             The dimenions of <*>A</*> are not required to be integer
;             multiples of fraction. <BR>
;             This parameter can be either a scalar (resulting in same
;             fraction for x and y) or a vector of two
;             elements [x,y] (separate values for x and y).<BR>
;             To determine the width and height of the
;             resulting array, the width and height of A will be
;             multiplied by fraction and then converted to integer.<BR>
;             Example: a fraction of 3 reduces the size of the array
;                      by factor 3.<BR>
;             This parameter is ignored and need not be specified, if
;             one of the keyword parameters <*>SIGMA=...</*> or
;             <*>HMW=...</*> is specified (see below). 
;  
; INPUT KEYWORDS:
;   EDGE_WRAP:: Keyword passed to <C>CONVOL()</C> for convolution (see
;               IDL reference). 
;   EDGE_TRUNCATE:: Keyword passed to <C>CONVOL()</C> for convolution
;                   (see IDL reference). 
;   SIGMA        :: Standard deviation of the Gaussian kernel used to
;                   low-pass filter the array before resampling.
;                   This parameter can be either a scalar (resulting in same
;                   deviation for x and y) or a vector of two
;                   elements [x,y] (separate values for x and y).<BR>
;                   Only one of <*>SIGMA</*>, <*>HMW</*>, or the
;                   fraction parameter 
;                   shall be specified.
;   HMW          :: Half mean width of the Gaussian kernel used to
;                   low-pass filter the array before resampling.
;                   This parameter can be either a scalar (resulting in same
;                   width for x and y) or a vector of two
;                   elements [x,y] (separate values for x and y).<BR>
;                   Only one of <*>SIGMA</*>, <*>HMW</*>, or the
;                   fraction parameter 
;                   shall be specified.
;  
;
; OUTPUTS:
;  result:: The resampled array. The supplied array A stays unchanged.<BR>
;                   To determine the width and height of the result
;                   array, the width and height of A will be multiplied by
;                   fraction and then converted to integer.
;
; RESTRICTIONS:
;  A has to be one or twodimensional.
;  fraction is the same for x and y dimensions. (Feel free to
;  implement support for individual x and y fractions :-) )
;
; PROCEDURE:
;  A is convolved by a Gaussian mask (using <C>CONVOL()</C> and
;  <A>Gauss_2D()</A>). The Gaussians are sized to overlap at their
;  half-mean-width. (Is this really the optimal choice?).
;  Then the array is resampled using <C>Congrid(Cubic=-0.5,/Minus_One)</C>.
;
; EXAMPLE:
;* UTV, alison(), 0
;* UTV, subsample(alison(),2), 2
;* UTV, subsample(alison(),3), 13
;
; SEE ALSO:
;  <A>Gauss_2D()</A>, IDL's <C>REBIN()</C>, <C>CONGRID()</C>, and <C>CONVOL()</C>
;-

FUNCTION Subsample, A, frac, $
                    Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate, $
                    HMW=hmw, SIGMA=sigma

   sa = Size(a)

   ;; fractions et al can be given as scalar or as vector of two.
   ;; Convert them to vectors of two:
   if n_elements(frac)  eq 1 then frac  = [frac, frac]
   if n_elements(hmw)   eq 1 then hmw   = [hmw, hmw]
   if n_elements(sigma) eq 1 then sigma = [sigma, sigma]

   ;; first handle HMW and SIGMA: derive frac
   ;; SIGMA overrides HMW overrides frac.
   If Keyword_Set(SIGMA) then hmw  = !Sigma2HMW*sigma
   IF Keyword_Set(HMW) THEN frac = 2.0*hmw $
    ELSE hmw = frac/2.0

   frac = float(temporary(frac))

   samples_per_row = Long(sa[1]/frac[0])

   IF sa[0] NE 1 THEN BEGIN
      samples_per_col = Fix(sa[2]/frac[1])
      g = Gauss_2D(/AUTOSIZE, XHWB=hmw[0], YHWB=hmw[1], /Norm)
   ENDIF ELSE BEGIN
      samples_per_col = 1
      g = Gauss_2D(6.*!HMW2Sigma*hmw[0], 1, HWB=hmw[0], /NORM)
   ENDELSE

   Return, $
    Congrid( Convol( Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate, $
                     A, g), $
             samples_per_row, samples_per_col, $
             Cubic=-0.5, /Minus_One $
           )

END
