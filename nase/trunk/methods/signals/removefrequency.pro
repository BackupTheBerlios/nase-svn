;+
; NAME:
;  RemoveFrequency()
;
; VERSION:
;  $Id$
;
; AIM:
;  Precisely removes one sinusoidal component with a specified frequency from a signal.
;
; PURPOSE:
;  This function selectively removes from a signal epoch (or several signal epochs) the sinusoidal component at a
;  frequency specified by the caller, i.e., if the signal contains a component at the specified frequency
;  <*>FreqRemove</*>, this function determines its amplitude and phase, subtracts it from the signal, and returns the
;  signal without the component. The amplitude and phase values for each signal epoch are additionally returned when
;  the corresponding optional arguments are specified. Only that one contribution to the signal is removed which shows
;  a very stable phase over the whole signal epoch. A typical application of this routine would be to remove 50-Hz
;  line artifacts from a (physiological) signal. If you have several signal epochs of equal length to be processed,
;  it is advisable to pass all of them in one array instead of using a <C>FOR</C> loop in your program, so that the
;  queries at the beginning of this routine are run through only once.<BR>
;  This routine renders <*>FormCorrFilter</*> obsolete and is somewhat faster when the sample frequency is a "good"
;  multiple of <*>FreqRemove</*> ("good" means that the sample frequency divided by <*>FreqRemove</*> is an integer
;  number with a small sum of prime factors).<BR>
;  The amplitude and phase values of the sinusoidal component contained in each epoch are determined via cross-correlation
;  in the time domain. In the frequency domain, it would be much more difficult to estimate these values for a component
;  whose frequency lies somewhere between two frequency bins. Nevertheless, the closer other frequency components lie
;  to <*>FreqRemove</*>, the longer the signal epoch must be to get a reliable estimation.<BR>
;  If no sinusoidal component could be determined for one or several signal epochs, the routine gives a console warning.
;  The optional positional <*>amplitude</*> argument (see below) can be used to identify those epochs for which no
;  sinusoidal component at <*>FreqRemove</*> was found.
;
; CATEGORY:
;  Math
;  Signals
;
; CALLING SEQUENCE:
;* out = RemoveFrequency(signal, freqremove, freqsample [, amplitude] [, phase])
;
; INPUTS:
;  signal::     An array of any integer or float type, containing the signal epoch(s) in the 1st dimension.
;  freqremove:: An integer or float scalar giving the frequency (in Hz) which is to be removed from the signal (e.g. 50).
;  freqsample:: An integer or float scalar giving the frequency (in Hz) which was used for sampling the signal.
;
; OUTPUTS:
;  out:: An array of the same type and dimensional structure as <*>signal</*>, containing the original signal with
;        the sinusoidal component at the specified frequency removed.
;
; OPTIONAL OUTPUTS:
;  amplitude:: A float array containing for each signal epoch the amplitude of the respective signal component lying
;              at <*>FreqRemove</*>. The <*>amplitude</*> array has the same dimensional structure as <*>signal</*>,
;              but with the first dimension missing. Actual amplitude values are always positive. For those signal epochs
;              for which no sinusoidal component at <*>FreqRemove</*> could be determined, -1 is returned as the
;              amplitude value, which can be taken as an identifier of epochs that were not changed.
;  phase::     A float array containing for each signal epoch the phase value of the respective signal component lying
;              at <*>FreqRemove</*>. Each sinusoidal component can be (and here actually is) constructed in the form
;              <*>Amplitude * Cosine(FreqRemove, Phase, FreqSample, N)</*>, <*>N</*> denoting the number of data points
;              in one <*>signal</*> epoch (cf. <A>Cosine</A>). The <*>phase</*> array has the same dimensional structure
;              as <*>signal</*>, but with the first dimension missing. For those signal epochs for which no sinusoidal
;              component at <*>FreqRemove</*> could be determined, 0 is returned as the phase value. However, since this
;              may also be an actual phase value, identification of the valid signal epochs (i.e. those epochs containing
;              a sinusoidal component at <*>FreqRemove</*>) is only possible by means of the <*>amplitude</*> argument.
;
; RESTRICTIONS:
;  <*>Signal</*> has to be of integer or float type; other types will cause a fatal error.<BR>
;  The arguments <*>FreqRemove</*> and <*>FreqSample</*> have to be interpretable as float values (i.e., of integer,
;  float, complex or possibly string type). If they are arrays containing more than one element, only the first entry
;  is used.<BR>
;  <B>Caution:</B> The "cleaned" signal <*>out</*> is always of the same type as <*>signal</*>. This might lead to
;  undesired digitizing effects when <*>signal</*> is an integer array; in this case you would have to pass <*>signal</*>
;  as a float array.<BR>
;
; PROCEDURE:
;  A cosine function with amplitude=1 and phase=0 is constructed, which is 8 periods of <*>FreqRemove</*> longer than
;  one signal epoch. For each epoch, the cross-correlation function between this reference signal and the passed signal
;  is determined for lags between 0 and 8 periods of <*>FreqRemove</*>. The correlation function necessarily shows
;  a sinusoidal dependency on the lag. The mean position of the "ascending zeroes" (zeroes with positive slope) of the
;  sinusoidal correlation function is then used to determine its phase.<BR>
;  In the next step, the amplitude and the phase of the signal component lying at <*>FreqRemove</*> are determined from
;  the amplitude and the phase of the correlation function in a way that cannot be explained in a few words. The
;  difficulty occurs when the signal epoch does not contain an integer number of <*>FreqRemove</*> periods. Please ask
;  Andreas Bruns (NeuroPhysics Group, Physics Dept., University of Marburg, Germany; andreas.bruns@physik.uni-marburg.de)
;  for further information.<BR>
;  Finally, a <*>FreqRemove</*> sinusoid with the determined amplitude and phase is subtracted from the original signal
;  epoch.
;
; EXAMPLE:
;  Create a simple sinusoid and see whether it is eliminated accurately by this routine:
;
;* s = 1.77 * Cosine(25, -114, 500, 100, /deg)  &  sr = RemoveFrequency(s, 25, 500, Amp, Phi)
;* Plot, s  &  OPlot, sr, color=RGB('red')
;* Print, Amp, Phi*!RaDeg
;
;  IDL prints:
;
;* >      1.77000
;* >     -113.997
;
; SEE ALSO:
;  Among others, this routine uses <A>Cosine</A>, <A>Cyclic_Value</A>, <A>NextPowerOf2</A> and <A>SincerpolateFFT</A>.
;
;-

FUNCTION  RemoveFrequency,   Signal, FreqRemove, FreqSample, Amplitude, Phase


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  N_Params() LT 3  THEN  Console, '  Wrong number of arguments.', /fatal
   SizeSignal = Size([Signal])
   TypeSignal = SizeSignal[SizeSignal[0]+1]
   DimsSignal = Size([Signal], /dim)
   NSignal = DimsSignal[0]          ; number of data points in one signal epoch
   fRemove = Float(FreqRemove[0])   ; If FreqRemove is an array, only the first value is taken seriously
   fSample = Float(FreqSample[0])   ; If FreqSample is an array, only the first value is taken seriously
   IF  (TypeSignal GE 6) AND (TypeSignal LE 11)  THEN  Console, '  Signal is of wrong type', /fatal
   IF  NSignal       LT 2  THEN  Console, '  Signal epoch must have more than one element.', /fatal
   IF  SizeSignal[0] EQ 1  THEN  NEpochs = 1  $
                           ELSE  NEpochs = Product(DimsSignal[1:*])   ; number of signal epochs in the whole array

   ; NShift is the amount of data points by which the reference signal exceeds one signal epoch in length; it is
   ; therefore also the length of the usable part of the correlation function. This length should correspond to an
   ; integer multiple of one period of fRemove, in order to minimize errors when interpolating the correlation function
   ; afterwards (the interpolation routine SincerpolateFFT assumes the signal to be periodic). Additionally, data points
   ; near the edges are ignored later on (the first two and the last two zeroes are thrown away, see below), while the
   ; remaining sequence should still contain some periods of the correlation function to estimate its phase from the mean
   ; position of its zeroes. Therefore, NShift is chosen to correspond to 8 periods, so that 3 or 4 zeroes remain to be
   ; used for phase estimation.
   NShift = Ceil(8. * fSample / fRemove)
   ; A factor FInt for interpolating the correlation function is chosen. As empirically tested, one period should be
   ; represented by 30 or more sampling points to get a good estimation for the zero positions. Example: If fRemove=50
   ; and fSample=500, there are already 10 sampling points per period, and FInt should be >=3; since SincerpolateFFT
   ; operates faster with powers of 2, FInt is actually chosen to be =4.
   FInt = NextPowerOf2((30. * fRemove / fSample) > 1, /upper)
   RefSignal = Cosine(fRemove, 0, fSample, NSignal+NShift)   ; the reference signal for the cross-correlation

   SizeCorr    = SizeSignal   ; copy of IDL size vector of the signal array
   SizeCorr[1] = NShift       ; artificially created size vector for the correlation function array
   IF  NEpochs EQ 1  THEN  DimsEpochs = [1]  $
                     ELSE  DimsEpochs = DimsSignal[1:*]   ; dimension vector describing the dimensional structure of the epoch(s)
   CorrFunct = MAKE_ARRAY(size = SizeCorr  , /nozero)     ; array for the correlation function epoch(s)
   RemSignal = MAKE_ARRAY(size = SizeSignal, /nozero)     ; array for the signal epoch(s) after removing the fRemove component(s)
   Amplitude = MAKE_ARRAY(dim  = DimsEpochs, /float, /nozero)   ; array for the amplitude(s) of the fRemove component(s)
   Phase     = MAKE_ARRAY(dim  = DimsEpochs, /float, /nozero)   ; array for the phase(s)     of the fRemove component(s)

   ;----------------------------------------------------------------------------------------------------------------------
   ; The correlation function between the reference signal and each signal epoch is determined and interpolated.
   ;----------------------------------------------------------------------------------------------------------------------

   FOR  e = 0L, NEpochs-1  DO  BEGIN
     ; Start and stop indices for addressing the current epoch:
     s1 = e  * NSignal
     s2 = s1 + NSignal - 1
     c1 = e  * NShift
     c2 = c1 + NShift - 1
     ; Two "Reverse" calls are needed because the convolution routine "Convol" is used to calculate the cross-correlation:
     CorrFunct[c1:c2] = (Reverse(Convol(Reverse(RefSignal), Signal[s1:s2], NSignal, center = 0)))[0:NShift-1]
   ENDFOR
   CorrFunct  = SincerpolateFFT(CorrFunct, FInt)
   NCorrFunct = FInt * NShift   ; number of data points in one interpolated epoch of the correlation function

   ;----------------------------------------------------------------------------------------------------------------------
   ; Each signal epoch is treated separately in a FOR loop.
   ;----------------------------------------------------------------------------------------------------------------------

   NErrors = 0L

   FOR  e = 0L, NEpochs-1  DO  BEGIN

     ; Start and stop indices like above:
     s1 = e  * NSignal
     s2 = s1 + NSignal - 1
     c1 = e  * NCorrFunct
     c2 = c1 + NCorrFunct - 1
     ; The current epoch of the correlation function is isolated:
     CorrFunctEpoch = CorrFunct[c1:c2]

   ;----------------------------------------------------------------------------------------------------------------------
   ; The phase of the sinusoidal correlation function is most precisely estimated not from the positions of its maxima,
   ; but from the positions of its zeroes. These positions are obtained by the following steps.
   ;----------------------------------------------------------------------------------------------------------------------

     ; Determine the indices followed by an "ascending zero" (with positive slope) of the correlation function.
     Zero_Ind = Where( ((CorrFunctEpoch[1:*] GT 0) - (CorrFunctEpoch[0:NCorrFunct-2] GT 0)) EQ 1 )
     ; If obviously no fRemove component is present, the current signal epoch is left unchanged, and the rest
     ; of the processing for the current epoch is skipped.
     IF  N_Elements(Zero_Ind) LT 7  THEN  BEGIN
       NErrors          = NErrors + 1
       RemSignal[s1:s2] = Signal[s1:s2]
       Amplitude[e]     = -1
       Phase[e]         =  0
       GOTO, LoopEnd
     ENDIF
     ; The exact positions (Zero_Pos) of the ascending zeroes are obtained by linear interpolation; the values have to
     ; be devided by the interpolation factor FInt in order to be compatible with the initial variables:
     Zero_Pos = (Zero_Ind - CorrFunctEpoch[Zero_Ind] / (CorrFunctEpoch[Zero_Ind+1]-CorrFunctEpoch[Zero_Ind])) / FInt
     ; The first two and the last two zero positions are ignored, because they are possibly distorted due to the
     ; interpolation; the remaining positions are converted to phase values (Zero_Chi):
     Zero_Chi = 2*!pi*fRemove/fSample * Zero_Pos[2:N_Elements(Zero_Pos)-3]
     ; For correct averaging of the phase values, they are represented by complex numbers with modulus 1; the complex
     ; mean (Zero_ChiCpxMean) is then converted back to a phase value (Zero_ChiMean):
     Zero_ChiCpxMean = Total(Complex(Cos(Zero_Chi), Sin(Zero_Chi))) / N_Elements(Zero_Chi)
     Zero_ChiMean    = ATan(Imaginary(Zero_ChiCpxMean), Float(Zero_ChiCpxMean))

   ;----------------------------------------------------------------------------------------------------------------------
   ; From the phase value corresponding to the mean zero position, the phase value Chi describing the correlation
   ; function -- in the form CorrFunct(t)=c0*cos(w*t+Chi) -- is obtained. It is mapped onto the interval [-pi,pi].
   ;----------------------------------------------------------------------------------------------------------------------

     Chi = Cyclic_Value(1.5*!pi - Zero_ChiMean, [-!pi,!pi])

   ;----------------------------------------------------------------------------------------------------------------------
   ; The phase Chi of the correlation function cannot be directly taken as the phase Psi of the fRemove component.
   ; A correction of the phase value is necessary in cases where the length of the signal is not an integer multiple
   ; of one period of fRemove. The way to obtain Psi from Chi can be seen from the steps below, but it cannot be
   ; understood from that. In fact, the deduction of these results is quite complicated and not described here.
   ; Please ask Andreas Bruns (NeuroPhysics Group, Physics Dept., University of Marburg, Germany;
   ; andreas.bruns@physik.uni-marburg.de).
   ;----------------------------------------------------------------------------------------------------------------------

     ; The following variables are abbreviations to speed up calculation:
     wT_2     = (4*!pi*fRemove) * (NSignal/fSample)
     SinwT2_2 = 2 * Sin(0.5*wT_2)^2
     Sin2wT   =     Sin(    wT_2)
     TanChiPi = Tan(Chi+!pi/2)
     C = (wT_2 - Sin2wT) * TanChiPi + SinwT2_2
     D = (wT_2 + Sin2wT)            + SinwT2_2 * TanChiPi
     ; Psi is determined; due to the pi periodicity of the tan function, pi must be added when Chi and C have the same
     ; sign or when abs(Chi) = pi (this cannot be immediately understood, either; it requires some consideration):
     Psi = ATan(D/C)  +  !pi * ((Signum(C)*Signum(Chi) EQ 1) OR (Abs(Chi) EQ !pi))
     Psi = Cyclic_Value(Psi, [-!pi,!pi])

   ;----------------------------------------------------------------------------------------------------------------------
   ; Like the phase, the amplitude of the fRemove component has to be determined from that of the correlation function
   ; in a quite complicated way.
   ;----------------------------------------------------------------------------------------------------------------------

     ; Some more abbreviations:
     SinPsi = Sin(Psi)
     CosPsi = Cos(Psi)
     A = ((wT_2 - Sin2wT) * SinPsi - SinwT2_2 * CosPsi) / (2*wT_2)
     B = ((wT_2 + Sin2wT) * CosPsi - SinwT2_2 * SinPsi) / (2*wT_2)
     ; The amplitude of the fRemove component is determined from the amplitude of the correlation function:
     s0 = Sqrt( (2 * Total(CorrFunctEpoch^2) / (FInt*NShift)) / (A^2+B^2) )

   ;----------------------------------------------------------------------------------------------------------------------
   ; The fRemove component is constructed and subtracted from the current signal epoch; the result is put into the
   ; RemSignal array. Additionally, the amplitude and phase values are put into their corresponding variables (which
   ; are the optional arguments in the calling sequence).
   ;----------------------------------------------------------------------------------------------------------------------

     RemSignal[s1:s2] = Signal[s1:s2] - s0 * Cosine(fRemove, Psi, fSample, NSignal)
     Amplitude[e]     = s0
     Phase[e]         = Psi

     LoopEnd:

   ENDFOR

   ; A warning message appears if a sinusoidal component could not be detected in one or more of the epochs:
   IF  NErrors GT 0  THEN  Console, '  Sinusoidal component could not be detected in ' +  $
                                    Str(NErrors) + ' of ' + Str(NEpochs) + ' epochs.', /warning

   Return, RemSignal


END
