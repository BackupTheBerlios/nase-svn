;+
; NAME:
;  CC2DFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the 2-dimensional cross-correlation or cross-covariance function via the frequency domain.
;
; PURPOSE:
;  This function computes the 2-dimensional cross-correlation or cross-covariance (see corresponding keyword) function for
;  a pair of 2-dimensional images (they will be called "images" in the following, but may of course be any 2-dimensional
;  arrays) <*>x</*> and <*>y</*> or for several such pairs, arranged in a multi-dimensional array. Since the correlation
;  function is computed via the frequency domain, it is not possible to compute only its center part, but you will always
;  get the complete shift range in both the 1st and the 2nd dimension (the l1- and l2-direction in the following).<BR>
;  The cross-correlation function cc(L1,L2) (<*>cc</*> here) between two images x(l1,l2) and y(l1,l2) is defined as the
;  (L1,L2)-dependent sum over the product x(l1,l2) * y(l1+L1,l2+L2). A peak at a positive value of <*>L1</*> or <*>L2</*>
;  indicates a high correlation between some sub-image of <*>x</*> and some other sub-image of <*>y</*> at a positive
;  shift, i.e., "<*>L1</*>>0" means "<*>y</*> is shifted to positive values compared to <*>x</*> along the l1-axis".
;
; CATEGORY:
;  Image
;  Math
;  Signals
;  Statistics
;
; CALLING SEQUENCE:
;* cc = CCFFT(x, y  [, L1] [, L2] [, /COVARIANCE] [, /ENERGYNORM | /SIZENORM] [, /OVERLAPNORM]
;*                  [, XENERGY=...] [, YENERGY=...])
;
; INPUTS:
;  x::  An integer or float array of >=2 dimensions, with the first two dimensions representing the l1- and l2-directions
;       of the images. The first argument for the cross-correlation. Each image is treated independently of the others.
;  y::  An integer or float array of the same dimensionality and size as <*>x</*>; the second argument for the
;       cross-correlation.
;
; INPUT KEYWORDS:
;  COVARIANCE::  Set this keyword in order to compute the <I>covariance</I> rather than the <I>correlation</I> function.
;                The former includes subtracting the mean values of the images before correlating them. The difference
;                is especially striking when <*>x</*> and <*>y</*> have a marked DC offset; in this case, the normalized
;                <I>correlation</I> will be close to 1, whereas the <I>covariance</I> can still take any value.
;  ENERGYNORM::  Set this keyword in order to normalize the correlation function(s) to the energies of the <*>x</*> and
;                <*>y</*> images. "Normalizing to" here means "dividing by the square root of the product of". This
;                kind of normalization is very common in correlation calculations and ensures that the coefficient
;                lies between -1 and 1, the latter indicating perfect (except for a scaling factor) correlation, the
;                former indicating perfect anticorrelation, and 0 indicating perfect (linear) independence of the vectors.
;                However, without setting the keyword <*>OVERLAPNORM</*> at the same time, the above said holds only for
;                the zero-shift value. Please cf. <*>OVERLAPNORM</*> for further information.
;  SIZENORM::    Set this keyword in order to normalize the correlation function(s) to the size of the <*>x</*> and
;                <*>y</*> images. "Normalizing to" here means "dividing by". This kind of normalization is <I>not</I>
;                very common in correlation calculations, but may sometimes be useful when comparing correlation values
;                between image pairs of different sizes. The size normalization, by the way, is implicitly also carried
;                out when normalizing to the energies (with <*>ENERGYNORM</*>), since the energy of an image is the sum of
;                its squared elements and therefore generally becomes larger with increasing image size. For this reason,
;                the <*>SIZENORM</*> keyword is ignored if the <*>ENERGYNORM</*> keyword is simultaneously set.
;                Simultaneously setting the keyword <*>OVERLAPNORM</*>, however, does have an effect (cf.
;                <*>OVERLAPNORM</*>).
;  OVERLAPNORM:: Usually, a cross-correlation function falls off towards the edges because the size of the overlapping
;                sub-images decreases with increasing shift. Set this keyword to compensate for this effect. The behaviour
;                of this keyword depends on which of the two other normalization keywords (<*>ENERGYNORM</*> or
;                <*>SIZENORM</*>) is simultaneously set:<BR>
;                (1.) <*>SIZENORM</*> is simultaneously set: Each correlation value is divided by the size of the
;                     corresponding <*>x</*>-<*>y</*>-overlap sub-image (which actually contributed to that value).<BR>
;                (2.) Neither <*>SIZENORM</*> nor <*>ENERGYNORM</*> is simultanously set: Is almost equivalent to case
;                     (1.), except for a scaling factor N*M (N and M being the <*>x</*> and <*>y</*> image lengths in
;                     the l1- and l2-directions, respectively). In other words, correlation values are divided by the
;                     <I>relative</I>, not by the <I>absolute</I> overlap sizes (relative to the maximal overlap size,
;                     which corresponds to zero-shift).<BR>
;                (3.) <*>ENERGYNORM</*> is simultaneously set: Each correlation value is normalized to the energies of
;                     the sub-images that actually contributed to its computation. Without <*>OVERLAPNORM</*> being set,
;                     <I>all</I> values of one correlation function are normalized to the energies of the <I>whole</I>
;                     corresponding <*>x</*> and <*>y</*> images. Thus, strictly speaking, correlation values are
;                     normalized to "wrong" energies that are actually only partly related to the correlation values,
;                     except for the zero-shift value. Setting <*>OVERLAPNORM</*> does normalize each correlation value
;                     to the "right" energy, but this procedure is not very common in the scientific community, and it
;                     is also enormously time-consuming (it takes about 3 times as long as the conventional energy
;                     normalization). Note also that the edge values, of course, are always +/-1, because they represent
;                     the normalized correlation between two 1-element images, which is always +/-1.
;
; OUTPUTS:
;  cc:: A float array of the same dimensional structure as <*>x</*> and <*>y</*>, except that the first two dimensions
;       contain 2*N-1 and 2*M-1 elements, N and M being the lengths of the first two dimensions of <*>x</*> and <*>y</*>.
;       This array contains the cross-correlation function(s) between <*>x</*> and <*>y</*>. The zero-shift correlation
;       value is represented by the middle sample of <*>cc</*> (cf. <*>L1</*> and <*>L2</*>).
;
; OPTIONAL OUTPUTS:
;  L1::       A one-dimensional float array of the same length as the first dimension of one <*>cc</*> epoch, giving for
;             each element in that dimension the number of samples by which <*>x</*> and <*>y</*> were shifted to each
;             other in the l1-direction (1st dimension) in order to obtain that correlation value. A positive sign means
;             "<*>y</*> is shifted to the positive l1-direction", i.e., for this correlation value, <*>y</*> had to be
;             shifted in the negative l1-direction relative to <*>x</*>.
;  L2::       A one-dimensional float array of the same length as the second dimension of one <*>cc</*> epoch; the
;             analogue of L1 for the l2-direction.
;  XENERGY::  Set this keyword to a named variable which on return will be a float array giving the energy value(s) of
;             the image(s) <*>x</*> that was (were) used for normalizing the correlation function(s). It is, of course,
;             only returned if the keyword <*>ENERGYNORM</*> is set. If the keyword <*>OVERLAPNORM</*> is set at the
;             same time, <*>XENERGY</*> has the same dimensionality and size as <*>cc</*>, otherwise it has almost the
;             same dimensionality, but with the first two dimensions containing only one element each.
;  YENERGY::  The analogue of <*>XENERGY</*> for the <*>y</*> argument.
;
; PROCEDURE:
;  Each signal epoch is quadrupled in size by zero-padding and then Fourier transformed. The complex <*>x</*> spectra are
;  multiplied by the conjugate complex <*>y</*> spectra, and the cross-spectra are transformed back to the initial domain.
;  The result has to be shifted, reversed, truncated (by the last element in each dimension), and scaled in order to
;  represent the correlation function appropriately.<BR>
;  The different types of normalization are implemented quite straightforward. In case of combining <*>ENERGYNORM</*> and
;  <*>OVERLAPNORM</*>, the cumulative energy values for each image are obtained by cross-correlating the image with a
;  boxcar (rectangular) window of equal size, which inludes a recursive call of <*>CC2DFFT</*>.
;
; EXAMPLE:
;* ix = Filtering2DFFT(RandomN(seed, 128, 192), FHIGH = 0.05)
;* iy = Filtering2DFFT(RandomN(seed, 128, 192), FHIGH = 0.05) + 3*ix
;* cc = CC2DFFT(ix, iy, L1, L2, /ENERGYNORM)
;* TVScl, cc
;
;-



FUNCTION  CC2DFFT, X, Y,   L1, L2,  $
                   covariance = covariance, energynorm = energynorm, sizenorm = sizenorm, overlapnorm = overlapnorm,  $
                   xenergy = xenergy, yenergy = yenergy


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X) AND Set(Y))  THEN  Console, '   Not all arguments defined.', /fatal
   SizeX = Size(X)
   SizeY = Size(Y)
   DimsX = Size(X, /dim)
   DimsY = Size(Y, /dim)
   TypeX = Size(X, /type)
   TypeY = Size(Y, /type)
   IF  (SizeX[0] NE SizeY[0]) OR (Max(DimsX NE DimsY) EQ 1)  THEN  Console, '  x and y must have the same size', /fatal
   IF  (TypeX GE 6) AND (TypeX LE 11)  THEN  Console, '  x is of wrong type', /fatal
   IF  (TypeY GE 6) AND (TypeY LE 11)  THEN  Console, '  y is of wrong type', /fatal
   IF  SizeX[0] LT 2                   THEN  Console, '  x and y must have at least 2 dimensions', /fatal
   NI = DimsX[0:1]                     ; number of sample points of one image (x or y) in the 1st and 2nd direction
   NC = 2*NI-1                         ; number of sample points of one CC-function in the 1st and 2nd direction
   N  = N_Elements(X) / (NI[0]*NI[1])  ; number of images
   IF  Min(NI) LT 2  THEN  Console, '  Image must have more than one element in each dimension.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the cross-correlation or cross-covariance function in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   ; If the covariance rather than the correlation is to be computed, the input variables are temporarily saved in
   ; "backup copies" X_ and Y_, from which they are restored later on:
   IF  Keyword_Set(covariance)  THEN  BEGIN
     X_ = X
     Y_ = Y
   ENDIF

   ; All epochs are merged in the 3nd dimension, for easier handling of the arrays:
   X = Reform(X, NI[0], NI[1], N, /overwrite)
   Y = Reform(Y, NI[0], NI[1], N, /overwrite)
   C = FltArr(   NC[0], NC[1], N, /nozero)
   ; If the covariance rather than the correlation is to be computed, the mean value(s) of the image(s) is (are)
   ; subtracted:
   IF  Keyword_Set(covariance)  THEN  BEGIN
     XM = IMean(X, dim = [1,2])
     YM = IMean(Y, dim = [1,2])
     FOR  i = 0L, N-1  DO  X[*,*,i] = X[*,*,i] - XM[i]
     FOR  i = 0L, N-1  DO  Y[*,*,i] = Y[*,*,i] - YM[i]
   ENDIF

   ; The actual correlation procedure:
   Xi = FltArr(2*NI[0],2*NI[1])
   Yi = FltArr(2*NI[0],2*NI[1])
   FOR  i = 0L, N-1  DO  BEGIN
     Xi[0:NI[0]-1,0:NI[1]-1] = X[*,*,i]
     Yi[0:NI[0]-1,0:NI[1]-1] = Y[*,*,i]
     ; The result has to be shifted, reversed and truncated by the last element in order to establish the right order
     ; of the samples in the time domain.
     C[*,*,i] = (Reverse(Reverse(Shift( Float(FFT(FFT(Xi)*Conj(FFT(Yi)),1)) , NI[0], NI[1] ),2),1))[0:2*NI[0]-2,0:2*NI[1]-2]
   ENDFOR
   C = 4*NI[0]*NI[1] * Temporary(C)   ; The scaling factor is necessary because of the inherent scaling factor of the FFT.

   ;----------------------------------------------------------------------------------------------------------------------
   ; Normalizations:
   ;----------------------------------------------------------------------------------------------------------------------

   L1 = FIndGen(NC[0]) - (NI[0]-1)   ; The axis giving the shift length in the l1-direction in samples.
   L2 = FIndGen(NC[1]) - (NI[1]-1)   ; The axis giving the shift length in the l2-direction in samples.

   IF  Keyword_Set(energynorm)  THEN  BEGIN

     IF  Keyword_Set(overlapnorm)  THEN  BEGIN
       XPower  = Float(X)^2    ; power of x
       YPower  = Float(Y)^2    ; power of y
       ; The energies of the sub-images are determined via cross-correlation of XPower and YPower with a "1-array":
       OneArr  = FltArr(NI[0],NI[1],N) + 1      ; array filled with 1's
       XEnergy = CC2DFFT(XPower, OneArr) > 0    ; cumulative sums of x power values
       YEnergy = CC2DFFT(OneArr, YPower) > 0    ; cumulative sums of y power values
       Energy  = sqrt(XEnergy * YEnergy)
       ; Only those epochs are valid whose energy is greater than zero (otherwise the correlation is left zero):
       Valid   = Where((Energy GE abs(C)) AND (Energy NE 0), NValid)
       IF  NValid GT 0  THEN  C[Valid] = C[Valid] / Energy[Valid]
       ; The energy arrays are reformed to the dimensions as they were implicitly specified through the x and y arrays:
       DimsE      = DimsX
       DimsE[0:1] = NC
       XEnergy    = Reform(XEnergy, DimsE, /overwrite)
       YEnergy    = Reform(YEnergy, DimsE, /overwrite)
     ENDIF  ELSE  BEGIN
       XEnergy = Total(Total(Float(X)^2,1),1)   ; energies of x signal epochs
       YEnergy = Total(Total(Float(Y)^2,1),1)   ; energies of y signal epochs
       Energy  = sqrt(XEnergy * YEnergy)        ; square root product of the x and y energies
       ; Only those epochs are valid whose energy is greater than zero (otherwise the correlation is left zero):
       Valid   = Where(Energy NE 0, NValid)
       FOR  i = 0L, NValid-1  DO  C[*,*,Valid[i]] = C[*,*,Valid[i]] / Energy[Valid[i]]
       ; The energy arrays are reformed to the dimensions as they were implicitly specified through the x and y arrays:
       DimsE      = DimsX
       DimsE[0:1] = 1
       XEnergy    = Reform([XEnergy], DimsE, /overwrite)
       YEnergy    = Reform([YEnergy], DimsE, /overwrite)
     ENDELSE

   ENDIF  ELSE  $
   IF  Keyword_Set(sizenorm)  THEN  BEGIN

     IF  Keyword_Set(overlapnorm)  THEN  BEGIN
       NormArr = (NI[0]-Abs(L1)) # (NI[1]-Abs(L2))
       FOR  i = 0L, N-1  DO  C[*,*,i] = C[*,*,i] / NormArr
     ENDIF  ELSE  BEGIN
       C = Temporary(C) / (NI[0]*NI[1])
     ENDELSE

   ENDIF  ELSE  $
   IF  Keyword_Set(overlapnorm)  THEN  BEGIN

     NormArr = (1-Abs(L1)/NI[0]) # (1-Abs(L2)/NI[1])
     FOR  i = 0L, N-1  DO  C[*,*,i] = C[*,*,i] / NormArr

   ENDIF

   ;----------------------------------------------------------------------------------------------------------------------
   ; Making the results' structure ready for returning:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The cross-correlation array is reformed to the dimensions as they were implicitly specified through the x and y
   ; arrays; the latter are "reformed back", too:
   DimsC      = DimsX
   DimsC[0:1] = NC
   C = Reform(C, DimsC, /overwrite)
   X = Reform(X, DimsX, /overwrite)
   Y = Reform(Y, DimsY, /overwrite)

   ; If the COVARIANCE keyword was set, the original variables have to be restored from the "backup copies":
   IF  Keyword_Set(covariance)  THEN  BEGIN
     X = Reform(X_, DimsX, /overwrite)
     Y = Reform(Y_, DimsY, /overwrite)
   ENDIF

   Return, C


END
