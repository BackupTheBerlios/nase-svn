;+
; NAME:
;  Spectrum()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the spectrum of a signal via the fast Fourier transform.
;
; PURPOSE:
;  This function computes the complex, amplitude-, or power-density discrete Fourier spectrum of a signal epoch or of
;  several signal epochs arranged in a multi-dimensional array. The main differences to <A>PowerSpec</A> are computational
;  speed (this routine is faster), scaling factor (explained below), and the padding- and windowing-options (see the
;  respective keywords).<BR>
;  The scaling factor is chosen in such a way that -- if the keyword <*>AMPLITUDE</*> is set -- each value represents the
;  <I>mean amplitude A per Hertz</I> within the corresponding frequency bin ("A" denoting the unit in which the signal is
;  measured). The important thing here is that the amplitude density is given as bin-mean amplitude per Hertz (be sure
;  that you get the meaning of this phrase) and not as total amplitude per bin (which would actually be the correct
;  handling of discrete time series of finite length). The great advantage of the former variant is that a given continuous
;  stationary signal will always lead to the same scaling of discrete spectral values, irrespective (1.) of the sampling
;  rate used used in recording, (2.) of the length of the time window used for the analysis, and (3.) of the extent of
;  (zero-) padding used for interpolating the spectrum. Thus, spectral analyses using different sample rates, window
;  lengths or interpolation factors can nevertheless be directly compared. Please note that, on the other hand, in order
;  to get the total power (not energy!) of the signal, it is not sufficient to just add up all squared spectral bins
;  (using, e.g., IDL's <*>Total</*> procedure), but a numerical integration has to be performed, i.e., each bin has to be
;  weighted with the bin width in Hertz. The physical unit "second" is passed to this function implicitly by specifying
;  the sample rate <*>fS</*> in Hertz. Note also that seemingly contradictory results will be obtained when computing the
;  spectra of sinusoidal signals, in which case the height of the spectral peak <I>does</I> depend on the (physical)
;  window length. This paradox is easily explained by remembering that each spectral amplitude value gives the <I>mean</I>
;  amplitude density within the whole corresponding frequency bin. Ideally, the spectral peak of a sinusoid has an infinite
;  amplitude density (a delta peak weighted by the amplitude of the sinusoid). However, the bin-mean, i.e., the integral
;  over the whole frequency bin around the sinusoid frequency, divided by the bin width, yields a finite value, which
;  becomes smaller as the frequency bin width increases (or as the length of the time window decreases, respectively).
;  Thus, <B>be careful:</B> The discrete Fourier transform (<B>DFT</B>) yields meaningful spectral values as long as there
;  are no "delta", i.e., very narrow peaks in the "real" spectrum. "Very narrow" here means "narrow compared to the inverse
;  of the (physical) window length". (This problem, of course, has nothing to do with the special scaling used in this
;  routine, but is a general property of the DFT, which only becomes quite apparent here because this routine claims to
;  deliver spectra which are independent of the parameters used in the analysis.)<BR>
;  Another important aspect with respect to the scaling of the spectrum is explained in connection with the keyword
;  <*>NEGATIVEFREQUENCIES</*> (see below). Please also read that paragraph carefully.
;
; CATEGORY:
;  Signals
;
; CALLING SEQUENCE:
;* s = Spectrum(x, fS, f, phase,  [, /AMPLITUDE | /POWER] [, /NEGATIVEFREQUENCIES]
;*                                [, PADDING=...] [, /CENTER] [, /WIDEWINDOW | /NOWINDOW]
;
; INPUTS:
;  x::   An integer, float or complex array containing in the first dimension the signal epoch(s) of which the spectrum
;        (spectra) is (are) to be computed.
;  fS::  An integer or float scalar giving the sample frequency (in Hertz) which was used in sampling the signal epoch(s).
;
; INPUT KEYWORDS:
;  AMPLITUDE::            Set this keyword if you want to receive the amplitude density spectrum (default: complex Fourier
;                         spectrum).
;  POWER::                Set this keyword if you want to receive the power density spectrum (default: complex Fourier
;                         spectrum). Setting this keyword overrides the keyword <*>AMPLITUDE</*>.
;  NEGATIVEFREQUENCIES::  Set this keyword if you want to receive the whole spectrum, including the values for the
;                         negative frequencies, which will be attached to the upper end of the positive frequency axis
;                         in reverse order (just the way in which it is output by IDL's <*>FFT</*> function). By default,
;                         only the positive frequency branch is returned.<BR>
;                         Very often, one is not interested in the negative-frequency branch, because for real signals
;                         it is symmetrical (amplitude, power, or real part of the complex spectrum) or antisymmetrical
;                         (imaginary part of the complex spectrum) to the positive-frequency branch. On the other hand,
;                         one would like the <I>total</I> contribution of the signal at a certain frequency to be
;                         represented in the spectrum. Therefore, if only the positive-frequency branch is returned,
;                         the complex spectral values are multiplied by 2 (leading to a factor 4 for the power spectrum),
;                         in order to represent the amplitudes that actually contribute to the signal at each frequency.
;                         Since the zero-frequency ("DC") bin occurs only once in the whole discrete Fourier spectrum,
;                         this bin must <I>not</I> be multiplied by 2. The same holds for the Nyquist-frequency bin if
;                         the total number of frequency bins is even (otherwise, there <I>is</I> no Nyquist-frequency bin,
;                         but some frequency slightly below is represented twice). <B>WARNING</B>: This correction does
;                         not have the desired effect when padding is performed! The reason is that the interpolation
;                         values near the zero- and the Nyquist-bin always run towards the uncorrected values of these
;                         bins, and correcting only the zero- and Nyquist-bins themselves afterwards introduces
;                         discontinuities at the edges of the spectrum. I (Andreas) have not found a solution for this
;                         problem so far, but I will think about it.
;  PADDING::              "Padding" means artificially extending the length of the analysis time window in order to get
;                         a higher frequency resolution, which, of course, can only be a "pseudo-resolution", because
;                         the non-padded DFT spectrum already contains all information that is available from the given
;                         signal epoch. Interpolation-by-padding only better visualizes this information. Set this keyword
;                         to an integer or float scalar >=1 giving the desired interpolation factor (default: 1, i.e.,
;                         no interpolation-by-padding). Two different kinds of padding may be chosen by setting or not
;                         setting the keyword <*>CENTER</*>.<BR>
;  CENTER::               Set this keyword if you want the epoch to be continued symmetrically to both sides by repeating
;                         its first and last value, respectively. This type of padding is recommended when analyzing
;                         transient signals, especially transients which end at a different value than they start (e.g.,
;                         saccades, cf. Harris, CM: The Fourier analysis of biological transients, J Neurosci Meth 83,
;                         15-34). In that case, the keyword <*>WIDEWINDOW</*> should always be set.<BR>
;                         By default, padding of a signal epoch is achieved by simply pasting the required number of
;                         zeroes to the end of the epoch.
;  WIDEWINDOW::           By default, each signal epoch is multiplied by a hamming window before padding and discrete
;                         Fourier transform. Set this keyword if you want the window to be as wide as one <I>padded</I>
;                         signal epoch (i.e., windowing is performed <I>after</I> padding). This keyword only makes sense
;                         if the keywords <*>PADDING</*> and <*>CENTER</*> are also set; it has therefore no effect in all
;                         other cases.
;  NOWINDOW::             Set this keyword if you do not want the signal epoch to be multiplied by a hamming window
;                         function. Setting this keyword overrides the keyword <*>WIDEWINDOW</*>. It is not recommended
;                         except for particular purposes, since leaving a signal epoch "unwindowed" is equivalent to using
;                         a rectangular window, which usually has much less favourable properties.
;
; OUTPUTS:
;  s::  A complex (default) or float (<*>AMPLITUDE</*> or <*>POWER</*> being set) array of the same dimensional structure
;       as <*>x</*> (except for the number of elements in the first dimension), containing the spectrum (spectra) of the
;       signal epoch(s) <*>x</*>.
;
; OPTIONAL OUTPUTS:
;  f::      A 1-dimensional float array of the same length as the 1st dimension of <*>s</*>, giving the frequency (in Hz)
;           for each spectral sample point.
;  phase::  A float array of the same dimensional structure as <*>s</*>, containing the spectral phase values (in rad).
;
; RESTRICTIONS:
;  Note that the spectrum of real signals has an antisymmetric imaginary part. Therefore, phase information will be
;  insufficient unless the keyword <*>NEGATIVEFREQUENCIES</*> is set. This is important when having the complex spectrum
;  and/or the <*>phase</*> values returned. At least you will always have to bear in mind that phase values for the
;  negative-frequency branch have the opposite sign of those for the positive-frequency branch (for real signals).
;
; PROCEDURE:
;  The dimensionality of <*>x</*> is reformed to <=2 (with the 1st dimension preserved, and all others merged in the 2nd),
;  then the spectra are computed, and the result as well as <*>x</*> is reformed back.
;
; EXAMPLE:
;  Generate 100 time windows of a 10-Hz-lowpass signal, sampled at a very high rate (4000 Hz), which plays the role of
;  a continuous, physical signal:
;
;*  x0 = 7.3*RandomN(seed, 16384, 100)
;*  x0 = FilteringFFT(x0, 4000, fH = 10, wH = 0)
;
;  Sample this signal at different rates and with different window lengths:
;
;*  x1 = x0(9*IndGen( 384),*)
;*  x2 = x0(5*IndGen(1440),*)
;*  x3 = x0(8*IndGen( 768),*)
;*  x4 = x0(6*IndGen(1875),*)
;
;  Compute the mean spectra (to eliminate random fluctuations) of the different signals and display them together in one
;  diagram:
;
;*  s1 = IMean(Spectrum(x1, 4000/9, f1, padding = 4.5, /amplitude), dim = 2)
;*  s2 = IMean(Spectrum(x2, 4000/5, f2, padding = 6  , /amplitude), dim = 2)
;*  s3 = IMean(Spectrum(x3, 4000/8, f3, padding = 3  , /amplitude), dim = 2)
;*  s4 = IMean(Spectrum(x4, 4000/6, f4, padding = 1  , /amplitude), dim = 2)
;*  Plot , f1, s1, xrange = [0,20], yrange = [0,0.3], xtitle = 'f / Hz', ytitle = 'amplitude density / 1/Hz'
;*  OPlot, f2, s2, color = RGB('red')
;*  OPlot, f3, s3, color = RGB('green')
;*  OPlot, f4, s4, color = RGB('blue')
;
; SEE ALSO:
;  <A>PowerSpec</A>
;
;-



FUNCTION  Spectrum,    X, fS_, f, Phase,  $
                       amplitude = amplitude, power = power, negativefrequencies = negativefrequencies,  $
                       padding = padding, center = center, widewindow = widewindow, nowindow = nowindow


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors, assigning default values, converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(X))  THEN  Console, '   Argument X not defined.', /fatal
   SizeX  = Size(X)
   DimsX  = Size(X , /dim)
   TypeX  = Size(X , /type)
   TypefS = Size(fS_, /type)
   NX     = DimsX(0)
   IF  (TypeX  GE 7) AND (TypeX  LE 11) AND (TypeX NE 9)  THEN  Console, '  X is of wrong type.', /fatal
   IF  (TypefS GE 6) AND (TypefS LE 11)                   THEN  Console, '  fS is of wrong type.', /fatal
   IF  NX LT 2  THEN  Console, '  X epoch must have more than one element.', /fatal
   N = N_Elements(X) / NX

   IF  TypefS EQ 0  THEN  fS = 1.0  $
                    ELSE  fS = Float(fS_(0))   ; If fS is an array, only the first value is taken seriously.

   ; Checking and "defaulting" the keyword PADDING:
   IF  Set(padding)  THEN  BEGIN
     IF  (Size(padding, /type) GE 6) AND (Size(padding, /type) LE 11)  THEN  Console, '  Keyword PADDING is of wrong type' , /fatal
     IF  (Padding(0) LT 1) AND (Padding(0) NE 0)  THEN  Console, '  Keyword PADDING must be >=1. Set to 1.', fatal
     Padding = Float(Padding(0)) > 1.0
   ENDIF  ELSE  Padding = 1.0

   ; Establishing the size parameters for the spectrum array S:
   NS = Round(Padding * NX)
   DimsS    = DimsX
   DimsS(0) = NS
   ; The array that will contain the spectra:
   S  = Make_Array(dim = DimsS, /complex)
   ; An array that will temporarily contain a long (padded) signal epoch in the FOR loop (see below):
   Xi = Make_Array(NS, type = TypeX)

   ; The frequency axis is constructed:
   f = fS * FIndGen(NS) / NS
   f = f < (fS-f)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the spectrum (spectra):
   ;----------------------------------------------------------------------------------------------------------------------

   ; All epochs are merged in one dimension, for easier handling of the arrays:
   X = Reform(X, NX, N, /overwrite)
   S = Reform(S, NS, N, /overwrite)

   IF  Keyword_Set(center)  THEN  BEGIN

     ; The number of data points for the left and right flank parts of each padded (elongated) signal epoch:
     NFlankL = Ceil( 0.5*(NS-NX))
     NFlankR = Floor(0.5*(NS-NX))
     ; The indices for addressing the center and the left and right flank parts of each padded (elongated) signal epoch:
     iCenter = LIndGen(NX) + NFlankL
     IF  NFlankL GT 0  THEN  iFlankL = LIndGen(NFlankL)                 $
                       ELSE  iFlankL = [0]
     IF  NFlankR GT 0  THEN  iFlankR = LIndGen(NFlankR) + NFlankL + NX  $
                       ELSE  iFlankR = [NFlankL + NX - 1]
     ; Defining the window function:
     W = FltArr(NS)
     W(iCenter) = Hamming(NX)
     IF  Keyword_Set(widewindow)  THEN  W = Hamming(NS)
     IF  Keyword_Set(nowindow)    THEN  W = FltArr(NS) + 1
     ; Each epoch is pasted into the center of a long epoch, continued to both sides, and multiplied by the window
     ; function; then the spectrum is computed:
     FOR  i = 0, N-1  DO  BEGIN
       Xi(iCenter) = X(*,i)
       Xi(iFlankL) = X(0,i)
       Xi(iFlankR) = X(NX-1,i)
       S(*,i)      = FFT(Xi * W)
     ENDFOR

   ENDIF  ELSE  BEGIN

     ; Defining the window function:
     W = Hamming(NX)
     IF  Keyword_Set(nowindow)  THEN  W = FltArr(NX) + 1
     ; Each epoch is multiplied by the window function and pasted into the beginning of a long epoch, the rest being
     ; zeroes; then the spectrum is computed:
     FOR  i = 0, N-1  DO  BEGIN
       Xi(0:NX-1) = X(*,i) * W
       S(*,i)     = FFT(Xi)
     ENDFOR

   ENDELSE

   ;----------------------------------------------------------------------------------------------------------------------
   ; Cutting-away the negative-frequency branch (unless desired) and correcting the phase shifts caused by padding:
   ;----------------------------------------------------------------------------------------------------------------------

   ; Unless the negative frequency branch is desired, only the values corresponding to positive frequencies are retained.
   ; However, in order to preserve the physical meaning of the scaling (see below), the spectrum has to be multiplied
   ; by sqrt(2) (yielding factor 2 for the power), because one usually would like to see the SUM of the contributions
   ; from positive and negative frequencies (which are physically equivalent). Since the DC-bin, on the other hand, occurs
   ; only once in the whole spectrum, it must NOT be multiplied by this factor. And if the number of frequency bins is
   ; even, the same holds for the Nyquist-frequency bin:
   IF  NOT Keyword_Set(negativefrequencies)  THEN  BEGIN
     S = S(0:NS/2,*) * 2.0
     S(0,*) = S(0,*) / 2.0
     IF  (NS MOD 2) EQ 0  THEN  S(NS/2,*) = S(NS/2,*) / 2.0
     DimsS(0) = NS/2+1
     f = f(0:NS/2)
   ENDIF  ELSE  $
     f(NS/2+1:*) = - f(NS/2+1:*)

   ; Scaling such that the obtained values have the physical meaning described in the doc header:
   S = S * Float(NS) / sqrt(fS*NX)

   ; If phase values are returned in some way (either explicitly or in the complex spectrum), phases must be corrected
   ; for the time shift if centred padding was used:
   IF  Keyword_Set(center) AND ((N_Params() EQ 4) OR NOT(Keyword_Set(amplitude) OR Keyword_Set(power)))  THEN  BEGIN
     PhaseFactor = exp(Complex(0,1) * 2*!pi*f*NFlankL/fS)
     FOR  i = 0, N-1  DO  S(*,i) = S(*,i) * PhaseFactor
   ENDIF

   ; The arrays must be reformed back:
   X = Reform(X, DimsX, /overwrite)
   S = Reform(S, DimsS, /overwrite)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Determining the phase values and the amplitude or power:
   ;----------------------------------------------------------------------------------------------------------------------

   ; The phase values (if desired) are determined:
   IF  N_Params() EQ 4  THEN  Phase = Reform(atan(Imaginary(S), Float(S)), DimsS, /overwrite)

   ; Depending on which spectrum type is specified, further processing is possibly required:
   SpecType = 0
   IF  Keyword_Set(amplitude)  THEN  SpecType = 1
   IF  Keyword_Set(power)      THEN  SpecType = 2
   CASE  SpecType  OF
     1: S = Abs(Temporary(S))
     2: S = Abs(Temporary(S))^2
     ELSE:
   ENDCASE

   Return, S


END
