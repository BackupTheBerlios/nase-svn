;+
; NAME:
;   subsample()
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
;   ARRAY, GRAPHICS, SIGNALPROCESSING
;
; CALLING SEQUENCE:
;   result = subsample (A, fraction [,/EDGE_WRAP|,/EDGE_TRUNCATE])
;
; INPUTS:
;   A       : The array to subsample. This must be two-dimensional, squareness
;             is not required.
;   fraction: The distance of sampling points (= the factor by which to reduce
;             the array size). This should be an integer value. (Any fractional
;             part is discarded.)
;             The dimenions of A are not required to be integer multiples of fraction.
;
; KEYWORD PARAMETERS:
;   EDGE_WRAP,
;   EDGE_TRUNCATE: Keywords are passed to CONVOL() for convolution (see IDL reference).
;
; OUTPUTS: result: The resampled array. The supplied array A stays unchanged.
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
; EXAMPLE: alison=fadetogrey(Getenv('NASEPATH')+'/graphic/alison.bmp')
;          LoadCt, 0
;          Window
;          TV, alison, 0
;          TV, subsample(alison,2), 2
;          TV, subsample(alison,3), 13
;
; SEE ALSO: REBIN(), CONGRID(), <A HREF="#GAUSS_2D">Gauss_2d()</A>, CONVOL()
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.2  2000/03/04 17:14:48  kupper
;        Forgot /Center in GetSubArray() call. Fixed.
;
;        Revision 1.1  2000/02/29 18:46:57  kupper
;        New and easy.
;
;-

Function Subsample, A, frac, Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate

   frac = fix(temporary(frac))

   samples_per_row = (size(A))[1]/frac
   samples_per_col = (size(A))[2]/frac

   return, $
   Rebin( /Sample, $
          Convol( Edge_Wrap=edge_wrap, Edge_truncate=edge_truncate, $
                  GetSubArray(A, /Center, samples_per_row*frac, samples_per_col*frac), $
                  Gauss_2d(/Autosize, HWB=frac/2.0, /Norm) $
                ), $
          samples_per_row, samples_per_col $
        )

End
