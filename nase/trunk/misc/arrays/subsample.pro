;+
; NAME:
;   subsample()
;
; AIM: resamples an already discrete two dimensional array 
;    
; PURPOSE:
;   Subsample a two-dimensional array, respecting the sampling theorem.
;   The original array is low-pass filtered prior to resampling.
;   Note that the faster REBIN() function produces comparable results in many
;   cases. (REBIN() uses near-neighbour-averaging, i.e. convolution with a box
;   car function.) Use <C>subsample()</C> where respecting the sampling theorem is
;   crucial.
;
; CATEGORY:
;   Array,
;   Graphic,
;   Signals
;
; CALLING SEQUENCE:
;*   result = subsample (A, fraction               [,/EDGE_WRAP|,/EDGE_TRUNCATE])
;*   result = subsample (A [,SIGMA=...|,HMW=...]   [,/EDGE_WRAP|,/EDGE_TRUNCATE])
;
; INPUTS:
;  A       :: The array to subsample. This must be two-dimensional, squareness
;             is not required.
;  fraction:: The distance of sampling points (= the factor by which to reduce
;             the array size). This is not required to be an integer value.
;             The dimenions of A are not required to be integer
;             multiples of fraction. To determine the width and height of the
;             result array, the width and height of A will be
;             multiplied by fraction and then converted to integer.<BR>
;             Example: a fraction of 3 reduces the size of the array
;                      by factor 3.<BR>
;             This parameter is ignored and need not be specified, if
;             one of the keyword parameters <*>SIGMA=...</*> or <*>HMW=...</*> is
;             specified (see below). 
;
; INPUT KEYWORDS:
;   EDGE_WRAP    :: Keyword passed to CONVOL() for convolution (see IDL reference).
;   EDGE_TRUNCATE:: Keyword passed to CONVOL() for convolution (see IDL reference).
;   SIGMA        :: Standard deviation of the Gaussian kernel used to
;                   low-pass filter the array before resampling.
;                   Only one of SIGMA, HMW, or the fraction parameter
;                   shall be specified.
;   HMW          :: Half mean width of the Gaussian kernel used to
;                   low-pass filter the array before resampling.
;                   Only one of SIGMA, HMW, or the fraction parameter
;                   shall be specified.
;
; OUTPUTS: result:: The resampled array. The supplied array A stays unchanged.<BR>
;                   To determine the width and height of the result
;                   array, the width and height of A will be multiplied by
;                   fraction and then converted to integer.
;
; RESTRICTIONS: A has to be two-dimensional.
;               fraction is the same for x and y dimensions. (Feel free to
;                implement support for individual x and y fractions :-) )
;
; PROCEDURE: A is convolved by a Gaussian mask (using <C>CONVOL()</C> and
;            <A>Gauss_2d()</A>). The Gaussians are sized to overlap at their
;            half-mean-width. (Ist this really the optimal choice?).
;            Then the array is resampled using <C>Congrid(Cubic=-0.5,/Minus_One)</C>.
;
; EXAMPLE: alison=float(READ_BMP(Getenv('NASEPATH')+'/graphic/alison_greyscale.bmp'))
;          ULoadCt, 0
;          Window
;          UTV, alison, 0
;          UTV, subsample(alison,2), 2
;          UTV, subsample(alison,3), 13
;
; SEE ALSO: <C>REBIN()</C>, <C>CONGRID()</C>, <A>Gauss_2d()</A>, <C>CONVOL()</C>
;-

Function Subsample, A, frac, $
                    Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate, $
                    HMW=hmw, SIGMA=sigma


   ;; first handle HMW and SIGMA: derive frac
   ;; SIGMA overrides HMW overrides frac.
   If Keyword_Set(SIGMA) then hmw  = !Sigma2HMW*sigma
   If Keyword_Set(HMW)   then frac = 2.0*hmw else hmw = frac/2.0


   frac = float(temporary(frac))

   samples_per_row = Fix((size(A))[1]/frac)
   samples_per_col = Fix((size(A))[2]/frac)

   return, $
    Congrid( Convol( Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate, $
                     A, $
                     Gauss_2d(/Autosize, HMW=hmw, /Norm) $
                   ), $
             samples_per_row, samples_per_col, $
             Cubic=-0.5, /Minus_One $
           )

End
