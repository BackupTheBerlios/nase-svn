;+
; NAME:
;  CCFFT()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the cross-correlation or cross-covariance function via the frequency domain.
;
; PURPOSE:
;  This function computes the cross-correlation or cross-covariance (see corresponding keyword) function for a pair of
;  signal epochs <*>x</*> and <*>y</*> or for several such pairs, arranged in a multi-dimensional array. The main
;  differences to <A>CrossCor</A> are:<BR>
;  (1.) Several signal epochs, arranged in multiple dimensions, can be treated in one command-line,<BR>
;  (2.) the correlation function is computed via the frequency domain,<BR>
;  (3.) it is therefore not possible to compute only on the center part of the correlation function, but you will always
;       get the complete shift range from -(N-1) to (N-1) (N denoting the number of samples in one epoch), and <BR>
;  (4.) for suitable epoch lengths N (i.e., N should have a small sum of prime factors, cf. <A>PrimeFactors</A>),
;       <*>CCFFT</*> is faster. The speed factor strongly depends on the actual epoch legth N and varies from 4 (N=16)
;       over 8 (N=128) and 13 (N=512) to 340 (N=16384).<BR>
;  If you are definitely only interested in the center part of the correlation function(s), computation might be faster
;  in the time domain. For this purpose, then, use the routine <A>CC</A>.<BR>
;  The cross-correlation function <*>cc(T)</*> between two signal epochs <*>x(t)</*> and <*>y(t)</*> is defined as the
;  <*>T</*>-dependent sum over the product <*>x(t) * y(t+T)</*>. A peak at a positive value of <*>T</*> (the latter being
;  given by the <*>ShiftAxis</*> here, see below) indicates a high correlation between some interval of <*>x</*> and some
;  later interval of <*>y</*>, i.e., "<*>T</*>>0" means "<*>y</*> comes after <*>x</*>", or "<*>x</*> precedes <*>y</*>".
;
; CATEGORY:
;  Math
;  Signals
;  Statistics
;
; CALLING SEQUENCE:
;* cc = CCFFT(x, y  [, ShiftAxis] [, /COVARIANCE] [, /ENERGYNORM | /LENGTHNORM] [, /OVERLAPNORM]
;*                  [, XENERGY=...] [, YENERGY=...])
;
; INPUTS:
;  x::  An integer or float array of any dimensionality, with the first dimension representing the independent variable
;       within each signal epoch (e.g., time). The first argument for the cross-correlation. Each signal epoch is treated
;       independently of the others.
;  y::  An integer or float array of the same dimensionality and size as <*>x</*>; the second argument for the
;       cross-correlation.
;
; INPUT KEYWORDS:
;  COVARIANCE::  Set this keyword in order to compute the <I>covariance</I> rather than the <I>correlation</I> function.
;                The former includes subtracting the mean values of the epochs before correlating them. The difference
;                is especially striking when <*>x</*> and <*>y</*> have a marked DC offset; in this case, the normalized
;                <I>correlation</I> will be close to 1, whereas the <I>covariance</I> can still take any value.
;  ENERGYNORM::  Set this keyword in order to normalize the correlation function(s) to the energies of the <*>x</*> and
;                <*>y</*> epochs. "Normalizing to" here means "dividing by the square root of the product of". This
;                kind of normalization is very common in correlation calculations and ensures that the coefficient
;                lies between -1 and 1, the latter indicating perfect (except for a scaling factor) correlation, the
;                former indicating perfect anticorrelation, and 0 indicating perfect (linear) independence of the vectors.
;                However, without setting the keyword <*>OVERLAPNORM</*> at the same time, the above said holds only for
;                the zero-shift value. Please cf. <*>OVERLAPNORM</*> for further information.
;  LENGTHNORM::  Set this keyword in order to normalize the correlation function(s) to the length of the <*>x</*> and
;                <*>y</*> epochs. "Normalizing to" here means "dividing by". This kind of normalization is <I>not</I>
;                very common in correlation calculations, but may sometimes be useful when comparing correlation values
;                between epoch pairs of different lengths. The length normalization, by the way, is implicitly also
;                carried out when normalizing to the energies (with <*>ENERGYNORM</*>), since the energy of an epoch is
;                the sum of its squared elements and therefore generally becomes larger with increasing epoch length.
;                For this reason, the <*>LENGTHNORM</*> keyword is ignored if the <*>ENERGYNORM</*> keyword is
;                simultaneously set. Simultaneously setting the keyword <*>OVERLAPNORM</*>, however, does have an effect
;                (cf. <*>OVERLAPNORM</*>).
;  OVERLAPNORM:: Usually, a cross-correlation function falls off to both sides because the length of the overlapping
;                epoch intervals decreases with increasing shift. Set this keyword to compensate for this effect. The
;                behaviour of this keyword depends on which of the two other normalization keywords (<*>ENERGYNORM</*>
;                or <*>LENGTHNORM</*>) is simultaneously set:<BR>
;                (1.) <*>LENGTHNORM</*> is simultaneously set: Each correlation value is divided by the length of the
;                     corresponding <*>x</*>-<*>y</*>-overlap inverval (which actually contributed to that value).<BR>
;                (2.) Neither <*>LENGTHNORM</*> nor <*>ENERGYNORM</*> is simultanously set: Is almost equivalent to case
;                     (1.), except for a scaling factor N (N being the <*>x</*> and <*>y</*> epoch length). In other
;                     words, correlation values are divided by the <I>relative</I>, not by the <I>absolute</I> overlap
;                     lengths (relative to the maximal overlap length, which corresponds to zero-shift).<BR>
;                (3.) <*>ENERGYNORM</*> is simultaneously set: Each correlation value is normalized to the energies of
;                     the intervals that actually contributed to its computation. Without <*>OVERLAPNORM</*> being set,
;                     <I>all</I> values of one correlation function are normalized to the energies of the <I>whole</I>
;                     corresponding <*>x</*> and <*>y</*> epochs. Thus, strictly speaking, correlation values are
;                     normalized to "wrong" energies that are actually only partly related to the correlation values,
;                     except for the zero-shift value. Setting <*>OVERLAPNORM</*> does normalize each correlation value
;                     to the "right" energy, but this procedure is not very common in the scientific community, and it
;                     is also enormously time-consuming (it takes about 3 times as long as the conventional energy
;                     normalization). Note also that the edge values, of course, are always +/-1, because they represent
;                     the normalized correlation between two 1-element epochs, which is always +/-1.
;
; OUTPUTS:
;  cc:: A float array of the same dimensional structure as <*>x</*> and <*>y</*>, except that the first dimension contains
;       2*N-1 elements, N being the length of the first dimension of <*>x</*> and <*>y</*>. This array contains the
;       cross-correlation function(s) between <*>x</*> and <*>y</*>. The zero-shift correlation value is represented by
;       the middle sample of <*>cc</*> (cf. <*>ShiftAxis</*>).
;
; OPTIONAL OUTPUTS:
;  ShiftAxis::  A one-dimensional float array of the same length as one <*>cc</*> epoch, giving for each correlation value
;               the number of samples by which <*>x</*> and <*>y</*> were shifted to each other in order to obtain that
;               correlation value. A positive sign means "<*>y</*> comes later", i.e., for this correlation value, <*>y</*>
;               had to be shifted in the negative direction (= towards earlier times) relative to <*>x</*>.
;  XENERGY::    Set this keyword to a named variable which on return will be a float array giving the energy value(s) of
;               the epoch(s) <*>x</*> that was (were) used for normalizing the correlation function(s). It is, of course,
;               only returned if the keyword <*>ENERGYNORM</*> is set. If the keyword <*>OVERLAPNORM</*> is set at the
;               same time, <*>XENERGY</*> has the same dimensionality and size as <*>cc</*>, otherwise it has almost the
;               same dimensionality, but with the first dimension containing only one element.
;  YENERGY::    The analogue of <*>XENERGY</*> for the <*>y</*> argument.
;
; PROCEDURE:
;  Each signal epoch is doubled in length by zero-padding and then Fourier transformed. The complex <*>x</*> spectra are
;  multiplied by the conjugate complex <*>y</*> specta, and the cross-spectrum is transformed back to the time domain.
;  The result has to be shifted, reversed, truncated (by the last element), and scaled in order to represent the
;  correlation function appropriately.<BR>
;  The different types of normalization are implemented quite straightforward. In case of combining <*>ENERGYNORM</*> and
;  <*>OVERLAPNORM</*>, the cumulative energy values for each epoch are obtained by cross-correlating the epoch with a
;  boxcar (rectangular) window of equal length, which inludes a recursive call of <*>CCFFT</*>.
;
; EXAMPLE:
;* x = exp(-(FIndGen(100)/10-5)^2)
;* y = Shift(x, 20)
;* x = Shift(x,-20)
;* cc = CCFFT(x, y, tau, /ENERGYNORM)
;* Plot, tau, cc
;
;-



FUNCTION  CCFFT, X, Y,   ShiftAxis,  $
                 covariance = covariance, energynorm = energynorm, lengthnorm = lengthnorm, overlapnorm = overlapnorm,  $
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
   NS = DimsX[0]              ; number of sample points of one signal epoch (x or y)
   NC = 2*NS-1                ; number of sample points of one CC-function epoch
   N  = N_Elements(X) / NS    ; number of signal epochs
   IF  NS LT 2  THEN  Console, '  Signal epoch must have more than one element.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the cross-correlation or cross-covariance function in a FOR loop:
   ;----------------------------------------------------------------------------------------------------------------------

   ; If the covariance rather than the correlation is to be computed, the means of x and y epochs have to be subtracted.
   ; The input variables are temporarily saved in "backup copies" X_ and Y_, from which they are restored later on:
   IF  Keyword_Set(covariance)  THEN  BEGIN
     X_ = X
     Y_ = Y
     X  = RemoveMean(X_, 1)
     Y  = RemoveMean(Y_, 1)
   ENDIF

   ; All epochs are merged in the 2nd dimension, for easier handling of the arrays:
   X = Reform(X, NS, N, /overwrite)
   Y = Reform(Y, NS, N, /overwrite)
   C = FltArr(   NC, N, /nozero)

   ; The actual correlation procedure:
   Xi = FltArr(2*NS)
   Yi = FltArr(2*NS)
   FOR  i = 0L, N-1  DO  BEGIN
     Xi[0:NS-1] = X[*,i]
     Yi[0:NS-1] = Y[*,i]
     ; The result has to be shifted, reversed and truncated by the last element in order to establish the right order
     ; of the samples in the time domain.
     C[*,i] = (Reverse(Shift( Float(FFT(FFT(Xi)*Conj(FFT(Yi)), 1)) , NS )))[0:2*NS-2]
   ENDFOR
   C = 2*NS * Temporary(C)   ; The scaling factor is necessary because of the inherent scaling factor of the FFT.

   ;----------------------------------------------------------------------------------------------------------------------
   ; Normalizations:
   ;----------------------------------------------------------------------------------------------------------------------

   ShiftAxis = FIndGen(NC) - (NS-1)   ; The axis giving the shift length in samples.

   IF  Keyword_Set(energynorm)  THEN  BEGIN

     IF  Keyword_Set(overlapnorm)  THEN  BEGIN
       XPower  = Float(X)^2               ; power of x
       YPower  = Float(Y)^2               ; power of y
       BoxCar  = FltArr(NS,N) + 1         ; a rectangular window to get the energies of epoch sections by cross-correlation
       XEnergy = CCFFT(XPower , BoxCar)   ; cumulative sums of x power values, computed via cross-correlation
       YEnergy = CCFFT(BoxCar , YPower)   ; cumulative sums of y power values, computed via cross-correlation
       Energy  = sqrt(XEnergy * YEnergy)
       ; Only those epochs are valid whose energy is greater than zero (otherwise the correlation is left zero):
       Valid   = Where(Energy NE 0, NValid)
       IF  NValid GT 0  THEN  C[Valid] = C[Valid] / Energy[Valid]
       ; The energy arrays are reformed to the dimensions as they were implicitly specified through the x and y arrays:
       DimsE    = DimsX
       DimsE[0] = NC
       XEnergy  = Reform(XEnergy, DimsE, /overwrite)
       YEnergy  = Reform(YEnergy, DimsE, /overwrite)
     ENDIF  ELSE  BEGIN
       XEnergy = Total(Float(X)^2, 1)      ; energies of x signal epochs
       YEnergy = Total(Float(Y)^2, 1)      ; energies of y signal epochs
       Energy  = sqrt(XEnergy * YEnergy)   ; square root product of the x and y energies
       ; Only those epochs are valid whose energy is greater than zero (otherwise the correlation is left zero):
       Valid   = Where(Energy NE 0, NValid)
       FOR  i = 0L, NValid-1  DO  C[*,Valid[i]] = C[*,Valid[i]] / Energy[Valid[i]]
       ; The energy arrays are reformed to the dimensions as they were implicitly specified through the x and y arrays:
       DimsE    = DimsX
       DimsE[0] = 1
       XEnergy  = Reform([XEnergy], DimsE, /overwrite)
       YEnergy  = Reform([YEnergy], DimsE, /overwrite)
     ENDELSE

   ENDIF  ELSE  $
   IF  Keyword_Set(lengthnorm)  THEN  BEGIN

     IF  Keyword_Set(overlapnorm)  THEN  BEGIN
       NormAxis = NS - Abs(ShiftAxis)
       FOR  i = 0L, N-1  DO  C[*,i] = C[*,i] / NormAxis
     ENDIF  ELSE  BEGIN
       C = Temporary(C) / NS
     ENDELSE

   ENDIF  ELSE  $
   IF  Keyword_Set(overlapnorm)  THEN  BEGIN

     NormAxis = 1 - Abs(ShiftAxis)/NS
     FOR  i = 0L, N-1  DO  C[*,i] = C[*,i] / NormAxis

   ENDIF

   ;----------------------------------------------------------------------------------------------------------------------
   ; Making the results' structure ready for returning:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The cross-correlation array is reformed to the dimensions as they were implicitly specified through the x and y
   ; arrays; the latter are "reformed back", too:
   DimsC    = DimsX
   DimsC[0] = NC
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
