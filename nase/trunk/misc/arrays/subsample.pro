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
;   car function.) Use subsample() where respecting the sampling theorem is
;   crucial.
;
; CATEGORY:
;   Array,
;   Graphic,
;   Signals
;
; CALLING SEQUENCE:
;*   result = subsample (A, fraction [,/EDGE_WRAP|,/EDGE_TRUNCATE])
;
; INPUTS:
;  A       :: The array to subsample. This must be two-dimensional, squareness
;             is not required.
;  fraction:: The distance of sampling points (= the factor by which to reduce
;             the array size). This is not required to be an integer value.
;             The dimenions of A are not required to be integer multiples of fraction.<BR> 
;<BR> 
;             Note, that if faction is not an integer value, the next higher
;             integer is used for computing the low-pass-filter. This is due to
;             a quantization problem: After low-pass-filtering, the image will
;             be shrunken to the new size by selecting pixels from the
;             original. When fraction is not an integer value, pixel distances
;             of FLOOR(fraction) as well as CEIL(fraction) will appear. To
;             avoid vialoation of the sampling theorem, the lower value
;             CEIL(fraction) will be used for computing the filter mask.
;
; INPUT KEYWORDS:
;   EDGE_WRAP,
;   EDGE_TRUNCATE:: Keywords are passed to CONVOL() for convolution (see IDL reference).
;
; OUTPUTS: result:: The resampled array. The supplied array A stays unchanged.
;
; RESTRICTIONS: A has to be two-dimensional.
;               fraction is the same for x and y dimensions. (Feel free to
;                implement support for individual x and y fractions :-) )
;
; PROCEDURE: A is convolved by a Gaussian mask (using CONVOL() and
;            <A HREF="#GAUSS_2D">Gauss_2d()</A>). The Gaussians are sized to overlap at their
;            half-mean-width. (Ist this really the optimal choice?).
;            Then the array is resampled using REBIN(/SAMPLE).
;
; EXAMPLE: alison=float(READ_BMP(Getenv('NASEPATH')+'/graphic/alison_greyscale.bmp'))
;          LoadCt, 0
;          Window
;          TV, alison, 0
;          TV, subsample(alison,2), 2
;          TV, subsample(alison,3), 13
;
; SEE ALSO: <C>REBIN()</C>, <C>CONGRID()</C>, <A>Gauss_2d()</A>, <C>CONVOL()</C>
;-

Function Subsample, A, frac, Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate

   frac = float(temporary(frac))

   samples_per_row = (size(A))[1]/frac
   samples_per_col = (size(A))[2]/frac

   return, $
    Congrid( Convol( Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate, $
                     A, $
                     Gauss_2d(/Autosize, HWB=Ceil(frac)/2.0, /Norm) $
                   ), $
             samples_per_row, samples_per_col $
           )

End
