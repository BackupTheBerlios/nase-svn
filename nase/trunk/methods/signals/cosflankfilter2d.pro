;+
; NAME:
;  CosFlankFilter2D()
;
; VERSION:
;  $Id$
;
; AIM:
;  Constructs a 2-dimensional bandpass or bandstop filter as a frequency-domain transfer function or a time-domain kernel.
;
; PURPOSE:
;  This routine returns a 2-dimensional bandpass or bandstop filter (e.g., for image processing) as a frequency-domain
;  transfer function. The transfer function has a plateau of value =1 within the pass-band and is zero at frequencies
;  outside the pass-band. However, the value of the filter does not change abruptly at the margins of the pass-band, but
;  changes smoothly within transition zones of finite width, called the <I>flanks</I> of the filter. The flanks have a
;  sigmoidal shape, realized by the [0,pi/2]-branch of the sin<SUP>2</SUP> function for the ascending flank, and by the
;  equivalent cos<SUP>2</SUP>-branch for the descending flank (hence the name of the routine). The filter function is
;  purely real and therefore causes no phase shifts of the contributing signal (e.g., image) components.<BR>
;  The two cut-off frequencies are set via the corresponding keywords. If neither keyword is set, the transfer function
;  will be =1 everywhere and will have no filtering effect. The non-trivial possibilities are the following (values
;  denoting fractions of the Nyquist frequency):<BR>
;  Lowpass:  0 < <*>FHIGH</*> < 1  (<*>FLOW </*> not set)<BR>
;  Highpass: 0 < <*>FLOW </*> < 1, (<*>FHIGH</*> not set)<BR>
;  Bandpass: 0 < <*>FLOW </*> < <*>FHIGH</*> < 1<BR>
;  Bandstop: 0 < <*>FHIGH</*> < <*>FLOW </*> < 1<BR>
;  By default, the cut-off frequencies denote the 3-dB points of the filter (i.e., those points where the flanks reach
;  the 3-dB value (ca. 0.5). Thus, signal components at the specified cut-off frequency are already attenuated by 3 dB.
;  (Note that this attenuation refers to the signal <I>amplitude</I>; the attenuation of the signal <I>power</I> is
;  always the square of this, i.e., 6 dB, corresponding to ca. 0.25.) If a different attenuation value is desired at the
;  cut-off frequencies, this can be specified by the keyword <*>ATTENUATION</*>.<BR>
;  The widths of the two flanks may also be set via keywords unless the default values are acceptable. By default, the
;  width of each flank is chosen to be exactly one octave (i.e., the ratio of the "begin" and "end" frequencies of each
;  flank is 1:2). The numbers specifying the flank widths can be interpreted as the number of octaves (default) or as
;  fractions of the Nyquist frequency (by setting the keyword ABSOLUTEWIDTHS). (Note that the cut-off frequencies, in
;  contrast, are <I>always</I> given as fractions of the Nyquist frequency.)<BR>
;  All parameters (<*>FLOW</*>, <*>FHIGH</*>, <*>WLOW</*>, <*>WHIGH</*>, <*>ATTENTION</*>) may be specified separately
;  for the two dimensions, in which case they are passed as a 2-element array in the form [ParameterX,ParameterY];
;  otherwise a scalar value is sufficient and will be applied to both dimensions.<BR>
;  The transfer function has a radial symmetry, i.e., the edges of the flank zones are generally of elliptic shape
;  (circular if parameters are identical for both dimensions). In the case of a real elliptic (not circular) filter,
;  it might be desirable to change its orientation from axis-aligned to any other orientation. This can be achieved via
;  the keyword <*>ORIENTATION</*>.
;
; CATEGORY:
;  Image
;  Signals
;
; CALLING SEQUENCE:
;* filter = CosFlankFilter2D(N, [, FLOW=...] [, FHIGH=...] [, WLOW=...] [, WHIGH=...] [, /ABSOLUTEWIDTHS]
;*                              [, ATTENUATION=...] [, ORIENTATION=...]
;
; INPUTS:
;  N::  An integer scalar or 2-element array giving the number(s) of sample points of the signal or image array for which
;       the filter is constructed.
;
; INPUT KEYWORDS:
;  FLOW::            A float scalar or 2-element array giving the lower cut-off frequency (-ies) (i.e., the highpass
;                    cut-off), as a fraction of the Nyquist frequency. Setting <*>FLOW</*> to a value <=0 is equivalent
;                    to omitting it, and the filter function is solely determined by <*>FHIGH</*>. Setting <*>FLOW</*> to
;                    a value >=1 results in a lowpass filter if 0<<*>FHIGH</*><1, otherwise it results in a zero-filter.
;  FHIGH::           A float scalar or 2-element array giving the upper cut-off frequency (-ies) (i.e., the lowpass
;                    cut-off), as a fraction of the Nyquist frequency. Setting <*>FHIGH</*> to a value >=1 is equivalent
;                    to omitting it, and the filter function is solely determined by <*>FLOW</*>. Setting <*>FHIGH</*> to
;                    a value <=0 results in a highpass filter if 0<<*>FLOW</*><1, otherwise it results in a zero-filter.
;  WLOW::            A float scalar or 2-element array giving the lower (i.e., the highpass) flank width(s), in multiples
;                    of one octave (default: 1). If you want to specify the flank width as a fraction of the Nyquist
;                    frequency, set the keyword /ABSOLUTEWIDTHS. Setting <*>WLOW</*> explicitly to zero results in an
;                    ideal highpass with a discontinuous cut-off.
;  WHIGH::           A float scalar or 2-element array giving the upper (i.e., the lowpass) flank width(s), in multiples
;                    of one octave (default: 1). If you want to specify the flank width as a fraction of the Nyquist
;                    frequency, set the keyword /ABSOLUTEWIDTHS. Setting <*>WHIGH</*> explicitly to zero results in an
;                    ideal lowpass with a discontinuous cut-off.
;  ABSOLUTEWIDTHS::  Set this keyword if you want the <*>WLOW</*> and <*>WHIGH</*> values to be interpreted as fractions
;                    of the Nyquist frequency (default: the flank widths are assumed to be given in multiples of one
;                    octave).
;  ATTENUATION::     A float scalar giving the desired attenuation value(s) at the cut-off frequencies (default: 3 dB,
;                    i.e. 0.5012). This keyword may also be explicitly set to zero, in which case the cut-off frequencies
;                    exactly mark the edges of the plateau of the transfer function.
;  CARTESIAN::       Set this keyword if you want the filter function to have cartesian (rectangular) symmetry (not
;                    recommended). By default, radial (elliptic) symmetry is used.
;  ORIENTATION::     A float scalar specifying the desired orientation angle (in degrees) of the filter function. Note
;                    that <I>first</I> the function is generated and <I>then</I> it is rotated by the angle specified, in
;                    the mathematically positive sense. This is important because the x- and y-parameters refer to the
;                    x- and y-directions <I>before</I> the rotation is performed.
;
; OUTPUTS:
;  filter::  A 2-dimensional <*>N</*>x<*>N</*> (resp. <*>N[0]</*>x<*>N[1]</*>) float array containing the desired filter
;            function. Positive and negative frequencies are already arranged in an FFT-compatible way, i.e., the filter
;            can be directly used for multiplication with a spectrum resulting from an FFT operation.
;
; RESTRICTIONS:
;  Setting the keywords <*>FHIGH</*>, <*>WLOW</*>, <*>WHIGH</*> or <*>ATTENUATION</*> explicitly to zero is not equivalent
;  to omitting them! Please refer to the descriptions of these arguments for further details.<BR>
;  If values for <*>FLOW</*> and <*>FHIGH</*> are not within the interval [0,1], they are confined to it, and a
;  corresponding warning message is given.<BR>
;  Negative values for the flank widths (<*>WLOW</*>, <*>WHIGH</*>) and for the attenuation at the cut-off frequencies
;  (<*>ATTENUATION</*>) are assumed to be intended to be positive, without an error message (i.e., only the numerical
;  value is regarded relevant).<BR>
;
; PROCEDURE:
;  The routine constructs the frequency-domain transfer function section by section with quite basic operations. Most
;  of the source code refers to the handling of the parameters and the different combinations of cut-off frequencies
;  and flank widths.
;
; EXAMPLE:
;  Generate a filter as a frequency-domain transfer function and use it to low-pass filter an image:
;
;* Image  = RandomN(seed, 500, 400)
;* Filter = CosFlankFilter2D([500,400], FHIGH = 0.1)
;* ImageF = Float(FFT(FFT(Image)*Filter, 1))
;* Window, /free, xsize=500, ysize=400
;* TVScl, Image
;* Window, /free, xsize=500, ysize=400
;* TVScl, ImageF
;
; SEE ALSO:
;  The two steps of first generating a frequency-domain transfer function and then filtering a signal using the FFT
;  are combined in the routine <A>Filtering2DFFT</A>, which also allows to pass multi-dimensional image arrays.
;-



FUNCTION  CosFlankFilter2D,  N_,  $
                             flow = flow_, fhigh = fhigh_, wlow = wlow_, whigh = whigh_, absolutewidths = absolutewidths,  $
                             attenuation = attenuation_, cartesian = cartesian, orientation = orientation_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(N_))  THEN  Console, '   Argument N not defined.', /fatal
   IF  (Size(N_, /type) GE 6) AND (Size(N_, /type) LE 11)  THEN  Console, '  Argument N is of wrong type', /fatal

   N  = Round(N_)
   ; Parameter is used for both dimensions if only one dimension is specified:
   IF  N_Elements(N) EQ 1  THEN  N = Replicate(N, 2)  ELSE  N = N(0:1)

   ; The type of each keyword (if set) is checked:
   IF  Set(flow_)         THEN  IF  (Size(flow_       , /type) GE 6) AND (Size(flow_       , /type) LE 11)  THEN  Console, '  Keyword FLOW is of wrong type'       , /fatal
   IF  Set(fhigh_)        THEN  IF  (Size(fhigh_      , /type) GE 6) AND (Size(fhigh_      , /type) LE 11)  THEN  Console, '  Keyword FHIGH is of wrong type'      , /fatal
   IF  Set(wlow_)         THEN  IF  (Size(wlow_       , /type) GE 6) AND (Size(wlow_       , /type) LE 11)  THEN  Console, '  Keyword WLOW is of wrong type'       , /fatal
   IF  Set(whigh_)        THEN  IF  (Size(whigh_      , /type) GE 6) AND (Size(whigh_      , /type) LE 11)  THEN  Console, '  Keyword WHIGH is of wrong type'      , /fatal
   IF  Set(attenuation_)  THEN  IF  (Size(attenuation_, /type) GE 6) AND (Size(attenuation_, /type) LE 11)  THEN  Console, '  Keyword ATTENUATION is of wrong type', /fatal
   IF  Set(orientation_)  THEN  IF  (Size(orientation_, /type) GE 6) AND (Size(orientation_, /type) LE 11)  THEN  Console, '  Keyword ORIENTATION is of wrong type', /fatal
   ; If not set, the default values for each keyword are defined; if set, they are type-converted if necessary. For
   ; "wlow", "whigh" and "attenuation", only the numerical (positive) value is taken:
   IF  Set(flow_)         THEN  fLow        = Float(flow_)              ELSE  fLow        = 0.0
   IF  Set(fhigh_)        THEN  fHigh       = Float(fhigh_)             ELSE  fHigh       = 1.0
   IF  Set(wlow_)         THEN  wLow        = Abs(Float(wlow_))         ELSE  wLow        = 1.0
   IF  Set(whigh_)        THEN  wHigh       = Abs(Float(whigh_))        ELSE  wHigh       = 1.0
   IF  Set(attenuation_)  THEN  Attenuation = Abs(Float(attenuation_))  ELSE  Attenuation = 3.0
   IF  Set(orientation_)  THEN  Orientation = Float(orientation_(0))    ELSE  Orientation = 0.0
   ; Parameters are used for both dimensions if only one dimension is specified:
   IF  N_Elements(fLow)        EQ 1  THEN  fLow        = Replicate(fLow       , 2)  ELSE  fLow        = fLow(0:1)
   IF  N_Elements(fHigh)       EQ 1  THEN  fHigh       = Replicate(fHigh      , 2)  ELSE  fHigh       = fHigh(0:1)
   IF  N_Elements(wLow)        EQ 1  THEN  wLow        = Replicate(wLow       , 2)  ELSE  wLow        = wLow(0:1)
   IF  N_Elements(wHigh)       EQ 1  THEN  wHigh       = Replicate(wHigh      , 2)  ELSE  wHigh       = wHigh(0:1)
   IF  N_Elements(Attenuation) EQ 1  THEN  Attenuation = Replicate(Attenuation, 2)  ELSE  Attenuation = Attenuation(0:1)

   ; If the cut-off frequencies are out of the sensible range, they are confined to the interval [0,1.0]:
   IF  (Min(fLow)  LT 0)  THEN  Console, '  FLOW was negative. Now set to zero.' , /warning
   IF  (Min(fHigh) LT 0)  THEN  Console, '  FHIGH was negative. Now set to zero.', /warning
   IF  (Max(fLow)  GT 1)  THEN  Console, '  FLOW was greater than Nyquist frequency. Now set to Nyquist frequency.' , /warning
   IF  (Max(fHigh) GT 1)  THEN  Console, '  FHIGH was greater than Nyquist frequency. Now set to Nyquist frequency.', /warning
   fLow  = fLow  > 0 < 1   ; limitation of the lower  cut-off frequency
   fHigh = fHigh > 0 < 1   ; limitation of the higher cut-off frequency
   ; If one of the lower cut-off frequencies is zero, the other one is also set to zero, because the algorithm uses an
   ; elliptic interpolation between the cut-off frequencies in the x- and y-direction, respectively, and an ellipse one
   ; of whose diameters is zero has also zero-area, thus being practically equivalent to an ellipse with both diameters
   ; equal to zero (a single point):
   IF  Min(fLow)  EQ 0  THEN  fLow  = [0.,0.]
   IF  Min(fHigh) EQ 0  THEN  fHigh = [0.,0.]
   ; The upper cut-off frequencies must either BOTH be greater or BOTH be lower than the corresponding lower cut-off
   ; frequencies, i.e., the filter must not be a bandpass in one direction and a bandstop in the other direction (which
   ; is not realizable):
   IF  (fLow(0) LE fHigh(0)) NE (fLow(1) LE FHigh(1))  THEN  Console, '  Filter cannot be bandpass and bandstop at the same time.', /fatal

   ;----------------------------------------------------------------------------------------------------------------------
   ; Constructing the frequency-domain transfer function:
   ;----------------------------------------------------------------------------------------------------------------------

   ; Relative widths of the "flank tail" (the part of the flank between its minimum (=0) and the cut-off frequency)
   ; and of the "flank body" (the part of the flank between the cut-off frequency and its maximum (=1)):
   wTail = ASin( 10^(-0.05*Attenuation) ) * 2/!pi   ; lies between 0 and 1
   wBody = 1 - wTail
   ; Flank widths are needed as absolute values for the algorithm below.
   ; If the keyword ABSOLUTEWIDTHS is set, the default value of 1.0 octave has to be expressed in "Hz" for each flank
   ; width that is not explicitly specified via WLOW or WHIGH.
   ; Furthermore, if ABSOLUTEWIDTHS is not set, both widths are interpreted as given in multiples of 1 octave and have
   ; to be transformed to "Hz". (To understand the transformation formulas, make a drawing and some calculations.
   ; Or leave it.)
   IF  Keyword_Set(absolutewidths)  THEN  BEGIN
     IF  NOT Set(wlow_)   THEN  wLow  = fLow  / (1 + wTail)
     IF  NOT Set(whigh_)  THEN  wHigh = fHigh / (1 + wBody)  ; (These formulas are special cases of the formulas in the ELSE condition.)
   ENDIF  ELSE  BEGIN
     wLow  = (2^wLow -1) / (1 + (2^wLow -1)*wTail)  *  fLow
     wHigh = (2^wHigh-1) / (1 + (2^wHigh-1)*wBody)  *  fHigh
   ENDELSE

   ; The "begin" (B) and "end" (E) frequencies of the low flank (LF) and the high flank (HF) are determined:
   LFB = fLow  - wLow  * wTail
   HFB = fHigh - wHigh * wBody
   LFE = LFB + wLow
   HFE = HFB + wHigh
   ; Like with the cut-off frequencies, if one of the entries is zero, the other one is also set to zero:
   IF  Total(LFB EQ 0) NE 0  THEN  LFB = [0.,0.]
   IF  Total(HFB EQ 0) NE 0  THEN  HFB = [0.,0.]
   IF  Total(LFE EQ 0) NE 0  THEN  LFE = [0.,0.]
   IF  Total(HFE EQ 0) NE 0  THEN  HFE = [0.,0.]
   ; Furthermore, if one of the entries is positive and the other negative, this cannot be treated appropriately by the
   ; algorithm, because the latter uses an elliptic interpolation between the frequency parameters in the x- and
   ; y-direction, respectively, and the elliptic equation only makes sense if both diameters are positive or if both
   ; diameters are negative (the latter being a straightforward abstraction of the positive case, though not in
   ; accordance with the usual conventions):
   IF  (Signum(LFB(0)) NE Signum(LFB(1))) OR (Signum(LFE(0)) NE Signum(LFE(1))) OR  $
       (Signum(HFB(0)) NE Signum(HFB(1))) OR (Signum(HFE(0)) NE Signum(HFE(1)))     $
       THEN  Console, '  Flank edge has different signs in different directions. Cannot interpolate elliptically. Choose other parameters.', /fatal

   ; Initializing the frequency-domain transfer function:
   TransFunc  = Make_Array(dim = N, /float)
   ; Constructing two 2-dimensional frequency "maps" (as an analogue to axes):
   fX = 2.0 * FIndGen(N(0)) / N(0)
   fY = 2.0 * FIndGen(N(1)) / N(1)
   fX = fX < (2.0-fX)
   fY = fY < (2.0-fY)
   fX(N(0)/2+1:*) = - fX(N(0)/2+1:*)
   fY(N(1)/2+1:*) = - fY(N(1)/2+1:*)
   fX =           ReBin(fX, N(0), N(1), /sample)
   fY = Transpose(ReBin(fY, N(1), N(0), /sample))
   ; The coordinate grid (fX,fY) is converted to polar coordinates. The azimuth angle does not vary between -pi and pi,
   ; but only between 0 and pi/2, because fX and fY are always positive (also in "negative frequency" directions). This
   ; is no problem, however, since an ellipse is symmectrically repeated in each quadrant.
   f   = Sqrt(fX^2 + fY^2)   ; frequency (= radius in frequency space)
   phi = atan(fY, fX)        ; direction (= azimuth angle) in frequency space
   ; If an orientation different from 0 of the transfer function is desired, here it comes:
   IF  Keyword_Set(orientation)  THEN  phi = Cyclic_Value(phi - Orientation*!pi/180, [-!pi,!pi])
   tanphi = tan(phi)

   ; Each point in frequency space represents a certain direction (i.e., value of phi). The elliptic interpolation
   ; between the flank edges in the x- and y-direction yields a function r(phi), i.e., the radius r of an ellipse for
   ; each direction phi in frequency space (r being either always positive or always negative). In the following, each
   ; sample point in frequency space is assigned the radii in the corresponding direction of the four ellipses
   ; representing the begin and end edges of the low and high flank, respectively. The formula for the radius of an
   ; ellipse as a function of the direction phi is obtained by combining the equations:
   ; (1.) x^2/x0^2 + y^2/y0^2 = 1   (elliptic equation),
   ; (2.) tan(phi) = y/x,
   ; (3.) r = sqrt(x^2+y^2).
   IF  LFB(0) EQ 0  THEN  LFlankBegin = Make_Array(dim = N, /float)  $
                    ELSE  LFlankBegin = LFB(1) * Sqrt(1 + (LFB(0)^2-LFB(1)^2) / (LFB(1)^2 + (LFB(0)*tanphi)^2))
   IF  HFB(0) EQ 0  THEN  HFlankBegin = Make_Array(dim = N, /float)  $
                    ELSE  HFlankBegin = HFB(1) * Sqrt(1 + (HFB(0)^2-HFB(1)^2) / (HFB(1)^2 + (HFB(0)*tanphi)^2))
   IF  LFE(0) EQ 0  THEN  LFlankEnd   = Make_Array(dim = N, /float)  $
                    ELSE  LFlankEnd   = LFE(1) * Sqrt(1 + (LFE(0)^2-LFE(1)^2) / (LFE(1)^2 + (LFE(0)*tanphi)^2))
   IF  HFE(0) EQ 0  THEN  HFlankEnd   = Make_Array(dim = N, /float)  $
                    ELSE  HFlankEnd   = HFE(1) * Sqrt(1 + (HFE(0)^2-HFE(1)^2) / (HFE(1)^2 + (HFE(0)*tanphi)^2))

   ; The indices of the filter flanks are determined:
   iLF = WHERE((f GE LFlankBegin) AND (f LE LFlankEnd))
   iHF = WHERE((f GE HFlankBegin) AND (f LE HFlankEnd))
   IF  Total(wLow)  EQ 0  THEN  iLF = -1
   IF  Total(wHigh) EQ 0  THEN  iHF = -1

   ; Some abbreviations are introduced:
   fLowZero        = Max(fLow)  EQ 0
   fHighZero       = Max(fHigh) EQ 0
   fLowNyquist     = Min(fLow)  EQ 1
   fHighNyquist    = Min(fHigh) EQ 1
   fLowTrivial     = fLowZero  OR fLowNyquist
   fHighTrivial    = fHighZero OR fHighNyquist
   fLowNonTrivial  = NOT fLowTrivial
   fHighNonTrivial = NOT fHighTrivial

   ; There are different possible combinations of keyword settings:
   CASE  1 OF

     fLowTrivial AND fHighNonTrivial :  BEGIN   ; lowpass
       iZero = Where(f GT HFlankEnd)
       TransFunc(*) = 1
       IF  iHF(0)   NE -1  THEN  TransFunc(iHF)   = cos(!pi/2*(f(iHF)-HFlankBegin(iHF))/(HFlankEnd(iHF)-HFlankBegin(iHF)))^2
       IF  iZero(0) NE -1  THEN  TransFunc(iZero) = 0
     END

     fHighTrivial AND fLowNonTrivial :  BEGIN   ; highpass
       iZero = Where(f LT LFlankBegin)
       TransFunc(*) = 1
       IF  iLF(0)   NE -1  THEN  TransFunc(iLF)   = sin(!pi/2*(f(iLF)-LFlankBegin(iLF))/(LFlankEnd(iLF)-LFlankBegin(iLF)))^2
       IF  iZero(0) NE -1  THEN  TransFunc(iZero) = 0
     END

     fLowNonTrivial AND fHighNonTrivial AND (fLow(0) LE fHigh(0)) :  BEGIN   ; bandpass
       iZero = Where((f LT LFlankBegin) OR (f GT HFlankEnd))
       TransFunc(*) = 1
       IF  iLF(0)   NE -1  THEN  TransFunc(iLF)   = sin(!pi/2*(f(iLF)-LFlankBegin(iLF))/(LFlankEnd(iLF)-LFlankBegin(iLF)))^2
       IF  iHF(0)   NE -1  THEN  TransFunc(iHF)   = cos(!pi/2*(f(iHF)-HFlankBegin(iHF))/(HFlankEnd(iHF)-HFlankBegin(iHF)))^2 < TransFunc(iHF)
       IF  iZero(0) NE -1  THEN  TransFunc(iZero) = 0
     END

     fLowNonTrivial AND fHighNonTrivial AND (fLow(0) GT fHigh(0)) :  BEGIN   ; bandstop
       iOne = Where((f LE HFlankBegin) OR (f GE LFlankEnd))
       IF  iLF(0)   NE -1  THEN  TransFunc(iLF)  = sin(!pi/2*(f(iLF)-LFlankBegin(iLF))/(LFlankEnd(iLF)-LFlankBegin(iLF)))^2
       IF  iHF(0)   NE -1  THEN  TransFunc(iHF)  = cos(!pi/2*(f(iHF)-HFlankBegin(iHF))/(HFlankEnd(iHF)-HFlankBegin(iHF)))^2 > TransFunc(iHF)
       IF  iOne(0)  NE -1  THEN  TransFunc(iOne) = 1
     END

     fLowZero AND fHighNyquist :  TransFunc(*,*) = 1   ; no filter

     ELSE:   ; zero-filter for all other cases (trivial cases except fLowZero & fHighNyquist)

   ENDCASE

   Return, TransFunc


END
