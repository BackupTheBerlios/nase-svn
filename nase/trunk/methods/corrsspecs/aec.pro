;+
; NAME:
;  AEC()
;
; VERSION:
;  $Id$
;
; AIM:
;  Computes the amplitude envelope correlation(s) of two signals in different frequency bands.
;
; PURPOSE:
;  This function computes the amplitude envelope correlation(s) (<B>AEC</B>) between one or more epoch(s) (arranged in a
;  multi-dimensional array) of signal <*>x</*> on the one hand and one or more epoch(s) of signal <*>y</*> on the other
;  hand. In the multi-dimensional case, each epoch is treated independently of the others, and the first dimension is
;  interpreted as the variable parameter within each epoch (e.g., time). If you have several signal epochs of equal length
;  to be "envelope-correlated", it is advisable to pass all of them in one array instead of using a <C>FOR</C> loop in
;  your program, so that the queries at the beginning of this routine are run through only once.<BR>
;  This routine already includes analysis with a sliding time window and therefore returns one AEC value for each
;  combination of <*>x</*> frequency band, <*>y</*> frequency band, time slice, and any parameter combination that is
;  implied by the dimensional structure of <*>x</*> and <*>y</*>.<BR>
;  For reasons of simplicity and clarity, <*>AEC</*> does not pass on to the user every option of the routines it calls;
;  only those parameters can be manipulated for which this usually makes sense. Actually, this routine is suited for real
;  data analysis purposes only when the number of (signal) channels is very small. <I>Never ever</I> use it when you want
;  to compute all pair-wise AEC values among more than, say, 10 channels; this would be much too time-consuming, because
;  for each channel the envelope signals and their slices would be computed several times. In this case, write your own
;  program, taking over the main steps from this source code.<BR>
;  Since computing the envelopes includes calculating FFTs, the length of the passed signal epochs should be a power
;  of 2. By using the discrete Fourier transform, the algorithm implicitly assumes that each signal epoch is repeated
;  periodically to infinity in both directions. This might lead to counter-intuitive results near the edges of the signal
;  epoch(s).<BR>
;
; CATEGORY:
;  Math
;  Signals
;  Statistics
;
; CALLING SEQUENCE:
;* aecxy = AEC(x, y, fX, fY, fS  [, BANDWIDTH=...] [, FLANKWIDTH=...]
;                                [, SSIZE=...] [, SSHIFT=...] [/SQUARED] [,/DIAG]
;
; INPUTS:
;  x::   An integer or float array containing in the first dimension (!) the vector(s) which is (are) to be
;        "envelope-correlated" with the vector(s) in <*>y</*>.
;  y::   An integer or float array of the same dimensional structure as x.
;  fX::  An integer or float scalar or array giving the centre frequency (frequencies) of the pass-band(s) which is (are)
;        to be used for computing the <*>x</*> envelopes. You may
;        specify <*>!NONE</*> to use the signal itself instead of the envelope.
;  fY::  An integer or float scalar or array giving the centre frequency (frequencies) of the pass-band(s) which is (are)
;        to be used for computing the <*>y</*> envelopes. You may
;        specify <*>!NONE</*> to use the signal itself instead of the envelope.
;  fS::  An integer or float scalar giving the frequency (in Hz) which was used for sampling the signal epoch(s).
;
; INPUT KEYWORDS:
;  BANDWIDTH::    An integer or float scalar giving the full width (in Hz) of the pass-band(s) which is (are) to be used
;                 for computing the envelopes. By default, <*>BANDWIDTH</*> is set to 10 (Hz) if <*>SSIZE</*> is not set;
;                 otherwise it is set to 5000/<*>SSIZE</*> (Hz).
;  DIAG     ::    The standard behaviour of this routine is to compute
;                 the correlation between all combinations of
;                 <*>fX</*> and <*>fY</*>. With this option, only
;                 correlations between fX[i] and fY[i] are calculated.
;  FLANKWIDTH::   An integer or float scalar giving the width (in Hz) of the filter flanks when computing the envelopes.
;                 By default, <*>FLANKWIDTH</*> is set to <*>BANDWIDTH</*>/2.
;  SSIZE::        Set this keyword to an integer or float scalar giving the length (in ms) of one time-slice for the
;                 sliding-window analysis (cf. <A>Slices</A>). By default, <*>SSIZE</*> is set to 500 (ms) if
;                 <*>BANDWIDTH</*> is not set; otherwise it is set to 5000/<*>BANDWIDTH</*> (ms).
;  SSHIFT::       Set this keyword to an integer or float scalar giving the step size (in ms) between two time-slices
;                 for the sliding-window analysis (cf. <A>Slices</A>). By default, <*>SSHIFT</*> is set to <*>SSIZE</*>/4.
;  SQUARED::      Set this keyword in order to obtain the squared, but still signed (!), correlation values. This is
;                 especially useful when comparing the AEC values with results from coherence analyses, since the latter
;                 correspond to squared correlation values.
;
; OUTPUTS:
;  aecxy::  A float array containing the AEC values. The first dimension represents the <*>x</*> pass-band centre
;           frequency (-ies), the second dimension the <*>y</*> pass-band centre frequency (-ies), the third dimension
;           the different time-slices, and the remaining dimensions correspond to the 2nd (and higher) dimension(s) of
;           <*>x</*> and <*>y</*>.
;
; RESTRICTIONS:
;  If signal epochs are not thought of to be repeated periodically, undesired effects will occur near the edges. In this
;  case, it is advisable to pass somewhat longer epochs and use only the AEC values for the central time slices.
;
; PROCEDURE:
;  The implementation is quite straightforward (with the usual difficulties in the details...); in principle, signals
;  <*>x</*> and <*>y</*> are enveloped with <A>Envelope</A>, time-sliced with <A>Slices</A>, made mean-free with
;  <A>RemoveMean</A>, and the sliced envelopes are correlated with <A>Correlation</A>.
;
; EXAMPLE:
;  Generate two stochastic signals (100 trials à ca. 2 seconds each, with sampling rate 500 Hz) and correlate their
;  amplitude envelopes for several frequencies in the gamma-range; note that even random correlation values can be very
;  high and approach their expectation value of zero only after averaging over the trials:
;
;* X = RandomN(seed, 1024,100)
;* Y = RandomN(seed, 1024,100)
;* AECxy  = AEC(X, Y, 5*FIndGen(9)+30, 5*FIndGen(9)+30, 500.0)
;* AECxyM = FZT( Total(FZT(AECxy),4)/100, 1 )
;* Print, StdDev(AECxy), StdDev(AECxyM)
;
;  IDL prints (for example):
;
;* >     0.366945     0.043577774
;
; SEE ALSO:
;  For details on the computing of envelopes and the like, see the documentations for <A>Envelope</A>, <A>Slices</A>,
;  <A>RemoveMean</A>, and <A>Correlation</A>.
;-



FUNCTION  AEC,   X, Y, fX_, fY_, fS_,  DIAG=diag, $
                 bandwidth = bandwidth_, flankwidth = flankwidth_, ssize = ssize_, sshift = sshift_, squared = squared


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters for errors:
   ;----------------------------------------------------------------------------------------------------------------------

;   On_Error, 2

   IF  NOT(Set(X) AND Set(Y) AND Set(fX_) AND Set(fY_) AND Set(fS_))  THEN  Console, '   Not all arguments defined.', /fatal

   SizeX  = Size([X])
   SizeY  = Size([Y])
   DimsX  = Size([X], /dim)
   DimsY  = Size([Y], /dim)
   TypeX  = SizeX[SizeX[0]+1]
   TypeY  = SizeY[SizeY[0]+1]
   TypefX = Size(fX_, /type)
   TypefY = Size(fY_, /type)
   TypefS = Size(fS_, /type)
   IF  (SizeX[0] NE SizeY[0]) OR (Max(DimsX NE DimsY) EQ 1)  THEN  Console, '  x and y must have the same size.', /fatal
   IF  (TypeX  GE 6) AND (TypeX  LE 11)  THEN  Console, '  x is of wrong type.' , /fatal
   IF  (TypeY  GE 6) AND (TypeY  LE 11)  THEN  Console, '  y is of wrong type.' , /fatal
   IF  (TypefX GE 6) AND (TypefX LE 11)  THEN  Console, '  fX is of wrong type.', /fatal
   IF  (TypefY GE 6) AND (TypefY LE 11)  THEN  Console, '  fY is of wrong type.', /fatal
   IF  (TypefS GE 6) AND (TypefS LE 11)  THEN  Console, '  fS is of wrong type.', /fatal

   N = DimsX[0]    ; number of data points in one signal epoch
   IF  N LT 2  THEN  Console, '  Signal epoch must have more than one element.', /fatal
   IF  SizeX[0] EQ 1  THEN  NEpochs = 1  $
                      ELSE  NEpochs = Product(DimsX[1:*])   ; number of signal epochs in the whole array

   IF  Set(bandwidth_)   THEN  IF  (Size(bandwidth_ , /type) GE 6) AND (Size(bandwidth_ , /type) LE 11)  THEN  Console, '  Keyword BANDWIDTH is of wrong type' , /fatal
   IF  Set(flankwidth_)  THEN  IF  (Size(flankwidth_, /type) GE 6) AND (Size(flankwidth_, /type) LE 11)  THEN  Console, '  Keyword FLANKWIDTH is of wrong type', /fatal
   IF  Set(ssize_)       THEN  IF  (Size(ssize_     , /type) GE 6) AND (Size(ssize_     , /type) LE 11)  THEN  Console, '  Keyword SSIZE is of wrong type', /fatal
   IF  Set(sshift_)      THEN  IF  (Size(sshift_    , /type) GE 6) AND (Size(sshift_    , /type) LE 11)  THEN  Console, '  Keyword SSHIFT is of wrong type', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Assigning default values, converting types, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   ; To avoid integer division traps, the arguments are converted to float type:
   fX = Float(fX_)
   fY = Float(fY_)
   fS = Float(fS_[0])   ; If fS is an array, only the first value is taken seriously.

   ; If not set, the default values for the keywords BANDWIDTH and FLANKWIDTH are defined; if set, they are type-converted
   ; if necessary, and only the numerical (positive) value is taken:
   BWSet = Set(bandwidth_)
   SSSet = Set(ssize_)
   IF  BWSet  THEN  BandWidth = Abs(Float(bandwidth_[0]))
   IF  SSSet  THEN  SSize     = Abs(Float(ssize_[0]))
   IF  NOT BWSet  THEN  IF  SSSet  THEN  BandWidth = 5000.0 / SSize  $
                                   ELSE  BandWidth =   10.0
   IF  NOT SSSet  THEN  SSize = 5000.0 / BandWidth

   IF  Set(flankwidth_)  THEN  FlankWidth = Abs(Float(flankwidth_[0]))  ELSE  FlankWidth = BandWidth/2
   IF  Set(sshift_)      THEN  SShift     = Abs(Float(sshift_[0]))      ELSE  SShift     = SSize/4

   ; The number of envelope frequency bands both for the X and the Y signals:
   NfX = N_Elements(fX)
   NfY = N_Elements(fY)

   ;----------------------------------------------------------------------------------------------------------------------
   ; Computing the amplitude envelopes and their correlations:
   ;----------------------------------------------------------------------------------------------------------------------

   EX = Make_Array(dimension = [NfX,DimsX], type = 4, /nozero)   ; array for the X envelopes (frequency bands in 1st dimension)
   EY = Make_Array(dimension = [NfY,DimsX], type = 4, /nozero)   ; array for the Y envelopes (frequency bands in 1st dimension)
   ; Determination of the envelopes:
   FOR  ifX = 0, NfX-1  DO  $
     IF fX[ifX] EQ !NONE THEN EX[ifX,*,*,*,*,*,*,*] = Float(X) ELSE $ 
        EX[ifX,*,*,*,*,*,*,*] = Envelope(Float(X), fS, flow = fX[ifX]-BandWidth/2, fhigh = fX[ifX]+BandWidth/2,  $
                                                       wlow = FlankWidth, whigh = FlankWidth, /hertz)
   FOR  ifY = 0, NfY-1  DO  $
     IF fY[ifY] EQ !NONE THEN EY[ifY,*,*,*,*,*,*,*] = Float(Y) ELSE $ 
        EY[ifY,*,*,*,*,*,*,*] = Envelope(Float(Y), fS, flow = fY[ifY]-BandWidth/2, fhigh = fY[ifY]+BandWidth/2,  $
                                                       wlow = FlankWidth, whigh = FlankWidth, /hertz)
   ; The dimension coding the different frequency bands is now shifted to the last position, because time is needed
   ; in the first dimension:
   Permutation = [IndGen(SizeX[0])+1 , 0]
   EX = Transpose(EX, Permutation)
   EY = Transpose(EY, Permutation)
   ; The envelopes signals are "time-sliced" and made mean-free:
   EXSlices = RemoveMean(Slices(EX, ssize = SSize, sshift = SShift, sampleperiod = 1/fS, /tfirst), 1)
   EYSlices = RemoveMean(Slices(EY, ssize = SSize, sshift = SShift, sampleperiod = 1/fS, /tfirst), 1)
   ; Now the dimension coding the different frequency bands is needed in the first position again:
   IF  NfX EQ 1  THEN  EXSlices = Reform(EXSlices, [1, Size(EXSlices, /dim)], /overwrite)  $
                 ELSE  EXSlices = Transpose(EXSlices, [SizeX[0]+1 , IndGen(SizeX[0]+1)])
   IF  NfY EQ 1  THEN  EYSlices = Reform(EYSlices, [1, Size(EYSlices, /dim)], /overwrite)  $
                 ELSE  EYSlices = Transpose(EYSlices, [SizeY[0]+1 , IndGen(SizeY[0]+1)])

   IF Keyword_Set(DIAG) THEN BEGIN
       ; array for the correlation values:
       IF SizeX(0) GT 1 THEN AECxy = Make_Array(dimension = [ NfX , (Size(EXSlices, /dim))[2] , DimsX[1:*] ], type = 4, /nozero) $
                        ELSE AECxy = Make_Array(dimension = [ NfX , (Size(EXSlices, /dim))[2] ]             , type = 4, /nozero)
       ; The correlation values are computed:
       FOR  ifX = 0, NfX-1  DO  AECxy[ifX,*,*,*,*,*,*] =  $
         Correlation(Reform(EXSlices[ifX,*,*,*,*,*,*,*], /over), Reform(EYSlices[ifX,*,*,*,*,*,*,*], /over), 1, /energynorm)
       
       IF  Keyword_Set(squared)  THEN  Return, AECxy^2 * Signum(AECxy)  $
                                 ELSE  Return, AECxy
   END ELSE BEGIN
       ; array for the correlation values:
       IF SizeX(0) GT 1 THEN AECxy = Make_Array(dimension = [ NfX , NfY , (Size(EXSlices, /dim))[2] , DimsX[1:*] ], type = 4, /nozero) $
                        ELSE AECxy = Make_Array(dimension = [ NfX , NfY , (Size(EXSlices, /dim))[2] ]             , type = 4, /nozero)
       ; The correlation values are computed:
       FOR  ifX = 0, NfX-1  DO  FOR  ifY = 0, NfY-1  DO  AECxy[ifX,ifY,*,*,*,*,*,*] =  $
         Correlation(Reform(EXSlices[ifX,*,*,*,*,*,*,*], /over), Reform(EYSlices[ifY,*,*,*,*,*,*,*], /over), 1, /energynorm)
       
       IF  Keyword_Set(squared)  THEN  Return, AECxy^2 * Signum(AECxy)  $
                                 ELSE  Return, AECxy
   END

END
