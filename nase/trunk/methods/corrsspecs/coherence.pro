;+
; NAME:
;  Coherence()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the squared coherence between two signals <*>x</*> and <*>y</*>.
;
; PURPOSE:
;  This function computes the squared coherence between two ensembles of signal epochs or between several such ensembles,
;  arranged in a multi-dimensional array.<BR>
;  The coherence is a measure which quantifies the coupling of phases as well as of amplitudes between two signals <*>x</*>
;  and <*>y</*> separately for each discrete frequency value <*>f</*>. It can vary between 0 (linear independence of the
;  signals at that frequency) and 1 (perfect phase- and amplitude-coupling at that frequency). The squared coherence
;  <*>c^2(f)</*> is defined as <*>|Sxy(f)|^2 / (Sxx(f)*Syy(f))</*>, where <*>Sxy(f)</*>, <*>Sxx(f)</*> and <*>Syy(f)</*>
;  are estimators of the complex cross-spectrum (<*>Sx(f)*Sy<SUP>*</SUP>(f)</*>) and of the autospectra (<*>|Sx(f)|^2</*>
;  and <*>|Sy(f)|^2</*>) of <*>x</*> and <*>y</*>, respectively. There are different approaches to get the spectral
;  estimators. The approach used in this function is called the "Bartlett estimation". It consists in (1.) calculating
;  the respective (cross- and auto-) spectra separately for each single pair of signal epochs via the (discrete) Fourier
;  transform, and (2.) averaging the spectra across the <*>N<SUB>Ens</SUB></*> different realizations (trials) of the
;  ensemble.<BR>
;  Note that for <*>N<SUB>Ens</SUB>=1</*> (only one realization), <*>c^2(f)=1</*> for all frequencies <*>f</*>, because
;  <*>|Sxy(f)|^2 = (|Sx(f)|*|Sy(f)|)^2</*>, and thus the numerator and the denominator in the above formula are identical.
;  By averaging across several realizations, however, the numerator generally becomes smaller than the denominator,
;  because for a given frequency <*>f</*>, the different realizations <*>Sxy<SUB>i</SUB>(f)</*> have different phases
;  (i.e., point into different directions in the complex number plane) and thus average out for large <*>N<SUB>Ens</SUB></*>;
;  averaging across the auto-spectra <*>|Sx<SUB>i</SUB>(f)|^2</*> and <*>|Sy<SUB>i</SUB>(f)|^2</*> in the denominator, by
;  contrast, does not have this destructive effect, since each realization yields a positive real number. Therefore, a
;  necessary condition for a high coherence at a given frequency <*>f</*> is a constant phase across the realizations of
;  the cross-spectrum, which is equivalent to a constant phase <I>difference</I> across the realizations of the single
;  spectra, i.e., the signals themselves. This condition alone, however, is not sufficient to yield perfectly coherent
;  signals, which can be easily understood: Let the two signals <*>x</*> and <*>y</*> be perfectly phase-coupled, with
;  both of them having zero-phase in all realizations. In that case, <*>Sx<SUB>i</SUB>(f)</*> and <*>Sy<SUB>i</SUB>(f)</*>
;  are purely real, and the above expression for the squared coherence is nothing else than the squared normalized
;  correlation of the amplitude values across the realizations. Since the amplitudes are always positive real values,
;  there will still be a squared correlation of around 0.5 even if the amplitudes are perfectly independent of each other
;  (it would be zero if their covariance was determined, which, however, is not the case in this algorithm). Thus, a
;  constant phase difference in conjunction with a co-varying amplitude across realizations is needed to yield a high
;  coherence; pure phase-coupling will only achieve intermediate coherence values; the coherence expectation value will be
;  zero, on the other hand, with pure amplitude-coupling or no coupling at all. Both coupling types, of course, may be
;  present but noisy, which will lead to intermediate coherence values, too.<BR>
;
;
; CATEGORY:
;  Signals
;
; CALLING SEQUENCE:
;* c = Coherence(x, y,   [, Sxy] [, ConfInt] [, DIMENSION=...] [, /CORRECTION] [, CFVALUE=...] [, PADDING=...]
;*                                           [, /NEGFREQ] [, SAMPLEPERIOD=...] [, F=...]
;
; INPUTS:
;  x::  An integer or float array of 2 or more dimensions, representing the first of the two signal ensembles between
;       which the coherence is to be determined. The independent variable of the signal epochs (e.g., time) is always
;       assumed to be represented in the 1st dimension. By default, the 2nd dimension is interpreted to represent the
;       different realizations, i.e., the members of the ensemble(s) of signal epochs. This can be changed via the
;       keyword <*>DIMENSION</*>.
;  y::  An integer or float array of the same dimensional structure as <*>x</*>, representing the second argument for the
;       coherence.
;
; INPUT KEYWORDS:
;  DIMENSION::     Set this keyword to an integer scalar giving the dimension which is to be interpreted as the dimension
;                  containing the different realizations, i.e., "trials" (default: 2). Since the 1st dimension is reserved
;                  for the signal epochs themselves, <*>DIMENSION</*> must be >=2, and of course it must be
;                  <=<*>N<SUB>Dim</SUB></*>, where <*>N<SUB>Dim</SUB></*> is the number of dimensions of <*>x</*> or
;                  <*>y</*>.
;  CORRECTION::    Set this keyword if you want coherence values to be corrected for the expected random coherence,
;                  which depends on the number of realizations. For a small number of realizations, even perfectly
;                  incoherent signals will on average show a relatively high random coherence (because the few randomly
;                  fluctuating values do not always totally cancel out each other). An estimator of this random
;                  contribution to the obtained coherence value <*>c^2(f)</*> is <*>(1-c^2(f))/N<SUB>Ens</SUB></*>. The
;                  latter expression is subtracted from each coherence value if <*>CORRECTION</*> is set.
;  CFVALUE::       Set this keyword to a float scalar within the interval (0,1), giving the confidence value characterizing
;                  the confidence intervals returned in the positional parameter <*>ConfInt</*>, i.e., set <*>CFVALUE</*>
;                  to 0.98 in order to have the 98%-intervals returned in <*>ConfInt</*> (default: 0.95). Setting
;                  <*>CFVALUE</*> to any value has no effect unless a variable for the positional parameter <*>ConfInt</*>
;                  is supplied at the same time.
;  PADDING::       "Padding" means artificially extending the length of the analysis time window by adding zeroes to the
;                  end of each epoch. The purpose is to get a higher frequency resolution, which, of course, can only be a
;                  "pseudo-resolution", because the non-padded coherence already contain all information available from
;                  the given signal epochs. Interpolation-by-padding only better visualizes this information. Set this
;                  keyword to an integer or float scalar >=1 giving the desired interpolation factor (default: 1, i.e.,
;                  no interpolation-by-padding).
;  NEGFREQ::       Set this keyword if you want to receive the whole coherence function, including the values for the
;                  negative frequencies, which will be attached to the upper end of the positive frequency axis in reverse
;                  order (just the way in which it is output by IDL's <*>FFT</*> routine). By default, only the positive
;                  frequency branch is returned, because in most cases one is not interested in the negative-frequency
;                  branch, which for real signals is simply symmetric to the positive-frequency branch.
;  SAMPLEPERIOD::  Set this keyword to an integer or float scalar giving the sample period (in seconds) which is assumed
;                  to have been used in sampling the signals <*>x</*> and <*>y</*> (default: 0.001). The only effect of
;                  this parameter is on the scaling of the frequency axis <*>f</*>.
;
; OUTPUTS:
;  c::  A float array of the same dimensional structure as <*>x</*> or <*>y</*>, but with the <*>DIMENSION</*>th dimension
;       missing, and containing the coherence function(s) in the 1st dimension. Moreover, unless the keyword <*>NEGFREQ</*>
;       is set, the 1st dimension is reduced to half of its original length (i.e., compared to <*>x</*> or <*>y</*>).
;
; OPTIONAL OUTPUTS:
;  Sxy::      A complex array of the same dimensional structure as <*>c</*>, containing the estimated (i.e., mean)
;             cross-spectrum <*>Sxy(f)</*> for each pair of signal ensembles, or, in other words, the complex expression
;             in the numerator of the squared-coherence formula (see above).
;  ConfInt::  A float array of the same dimensional structure as <*>c</*>, but with an additional 2-element dimension in
;             the last place, giving the confidence interval for each single coherence value. The confidence value
;             characterizing the confidence interval(s) can be specified via the keyword <*>CFVALUE</*>.
;  F::        Set this keyword to a named variable which on return will be a 1-dimensional array of the same length as the
;             1st dimension of <*>c</*>, providing the frequency axis for the coherence function(s).
;
; RESTRICTIONS:
;  Execution is halted if <*>x</*> and <*>y</*> are of different size or contain only one epoch in the specified dimension.
;
; PROCEDURE:
;  The spectra <*>Sx</*> and <*>Sy</*> are obtained via the fast Fourier transform. The coherence is then computed
;  according to the above formulas. Most of the source code is simply checking of parameters and handling of the
;  (possibly) multi-dimensional arrays.
;
; EXAMPLE:
;  Generate two stochastic processes with a coherent oscillation at 60 Hz, and determine their coherence:
;
;* x = FltArr(seed, 128, 20)
;* y = FltArr(seed, 128, 20)
;* RandomPhases = RandomU(seed, 20) * 2*!pi
;* FOR  i = 0, 19  DO  x[*,i] = RandomN(seed, 128) + Cosine(60.0, RandomPhases[i]           , 500.0, 128, /samples)
;* FOR  i = 0, 19  DO  y[*,i] = RandomN(seed, 128) + Cosine(60.0, RandomPhases[i] + 0.79*!pi, 500.0, 128, /samples)
;* c = Coherence(x, y, PADDING = 16, SAMPLEPERIOD = 0.002, F = f)
;* Plot, f, c, yrange = [0,1]
;
; SEE ALSO:
;  For other coupling measures, cf. <A>CCFFT</A> or <A>AEC</A>.
;
;-



FUNCTION  Coherence,  X, Y,   Sxy, ConfInt,  $
                      dimension = dimension_, correction = correction, cfvalue = cfvalue_,  $
                      padding = padding_, negfreq = negfreq, sampleperiod = sampleperiod_, f = f


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
   NX   = DimsX[0]             ; number of sample points of one signal epoch (x or y)
   NTot = N_Elements(X) / NX   ; total number of signal epochs (realizations) altogether
   IF  NX   LT 2  THEN  Console, '  Signal epoch must have more than one element.', /fatal
   IF  NTot LT 2  THEN  Console, '  Ensembles must consist of at least two signal epochs each for estimating the coherence.', /fatal

   ; The type of each keyword (if set) is checked:
   IF  Set(dimension_   )  THEN  IF  (Size(dimension_   , /type) GE 6) AND (Size(dimension_   , /type) LE 11)  THEN  Console, '  Keyword DIMENSION is of wrong type'       , /fatal
   IF  Set(cfvalue_     )  THEN  IF  (Size(cfvalue_     , /type) GE 6) AND (Size(cfvalue_     , /type) LE 11)  THEN  Console, '  Keyword CFVALUE is of wrong type'       , /fatal
   IF  Set(padding_     )  THEN  IF  (Size(padding_     , /type) GE 6) AND (Size(padding_     , /type) LE 11)  THEN  Console, '  Keyword PADDING is of wrong type'       , /fatal
   IF  Set(sampleperiod_)  THEN  IF  (Size(sampleperiod_, /type) GE 6) AND (Size(sampleperiod_, /type) LE 11)  THEN  Console, '  Keyword SAMPLEPERIOD is of wrong type'       , /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking the keywords for sensible values or assigning default values; converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   IF  Keyword_Set(dimension_)  THEN  BEGIN
     Dimension = Long(dimension_[0])
     IF  (Dimension LT 2) OR (Dimension GT SizeX[0])  THEN  Console, '  Keyword DIMENSION out of allowed range.', /fatal
   ENDIF  ELSE  $
     Dimension = 2

   IF  Keyword_Set(cfvalue_)  THEN  BEGIN
     CfValue = Float(cfvalue_[0])
     IF  (CfValue LE 0) OR (CfValue GE 1)  THEN  Console, '  Specified confidence must lie within (0,1).', /fatal
   ENDIF  ELSE  $
     CfValue = 0.95

   IF  Keyword_Set(padding_)  THEN  BEGIN
     IF  padding_[0] LT 1  THEN  Console, '  Keyword PADDING must be >=1. Set to 1.', fatal
     Padding = Float(padding_[0]) > 1.0
   ENDIF  ELSE  $
     Padding = 1.0

   IF  Keyword_Set(sampleperiod_)  THEN  SamplePeriod = abs(Float(sampleperiod_[0]))  $
                                   ELSE  SamplePeriod = 0.001
   fS = 1.0 / SamplePeriod   ; the sample frequency

   ; Establishing the size parameters for the spectrum arrays Sx and Sy:
   NS       = Round(Padding * NX)   ; number of sample points of one spectrum
   DimsS    = DimsX
   DimsS[0] = NS
   ; The arrays that will contain the spectra:
   Sx = ComplexArr(NS, NTot, /nozero)
   Sy = ComplexArr(NS, NTot, /nozero)
   ; An array that will temporarily contain a long (padded) signal epoch in the FOR loop (if PADDING is set, see below):
   Xi = Make_Array(NS, type = TypeX)
   Yi = Make_Array(NS, type = TypeY)
   ; Hamming window used for estimating the spectra:
   W = Hamming(NX)

   ; The frequency axis is constructed:
   f = fS * FIndGen(NS) / NS
   f = f < (fS-f)

   ; Number of signal epochs (realizations within one ensemble) used for estimating the coherence:
   NEns = DimsX[Dimension-1]
   IF  NEns LT 2  THEN  Console, '  Ensembles must consist of at least two signal epochs each for estimating the coherence.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the complex spectra of X and Y:
   ;----------------------------------------------------------------------------------------------------------------------

   ; Reforming the signal arrays for easier FOR-loop handling:
   X = Reform(X, NX, NTot, /overwrite)
   Y = Reform(Y, NX, NTot, /overwrite)

   ; Computing the spectra:
   IF  Padding GT 1  THEN  FOR  i = 0L, NTot-1  DO  BEGIN
     Xi[0:NX-1] = X[*,i] * W
     Yi[0:NX-1] = Y[*,i] * W
     Sx[*,i]    = FFT(Xi)
     Sy[*,i]    = FFT(Yi)
   ENDFOR  ELSE  FOR  i = 0L, NTot-1  DO  BEGIN
     Sx[*,i] = FFT(X[*,i] * W)
     Sy[*,i] = FFT(Y[*,i] * W)
   ENDFOR

   ; Unless the negative frequency branch is desired, only the values corresponding to positive frequencies are retained;
   ; the size vector for the S array is correspondingly changed:
   IF  NOT Keyword_Set(negfreq)  THEN  BEGIN
     Sx = Sx[0:NS/2,*]
     Sy = Sy[0:NS/2,*]
     f  = f[ 0:NS/2]
     DimsS[0] = NS/2+1
   ENDIF  ELSE  $
     f[NS/2+1:*] = - f[NS/2+1:*]   ; making the negative frequencies really negative

   ; Reforming back the signal and spectra arrays to the original dimensional structure:
   X  = Reform(X , DimsX, /overwrite)
   Y  = Reform(Y , DimsX, /overwrite)
   Sx = Reform(Sx, DimsS, /overwrite)
   Sy = Reform(Sy, DimsS, /overwrite)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the coherence function(s) (and the confidence intervals, if desired):
   ;----------------------------------------------------------------------------------------------------------------------

   ; Computing the mean complex cross and auto spectra:
   Sxy = Total( Sx * Conj(Sy)        , Dimension )
   Sxx = Total( abs(Temporary(Sx))^2 , Dimension )
   Syy = Total( abs(Temporary(Sy))^2 , Dimension )

   ; Computing and correcting the coherence:
   C = abs(Sxy)^2 / (Sxx*Syy)
   IF  Keyword_Set(correction)  THEN  C = ((NEns+1.0)/NEns * Temporary(C) - 1.0/NEns) > 0
   ; Getting the confidence intervals:
   IF  N_Params() EQ 4  THEN  ConfInt = ChConfidence(C, NEns, CfValue)

   Return, C


END
