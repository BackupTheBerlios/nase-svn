;+
; NAME:
;  CosFlankFilter()
;
; VERSION:
;  $Id$
;
; AIM:
;  Constructs a bandpass or bandstop filter as a frequency-domain transfer function or a time-domain kernel.
;
; PURPOSE:
;  This routine returns a bandpass or bandstop filter either as a frequency-domain transfer function (default) or
;  alternatively as a time-domain convolution kernel (by setting the keyword <*>TIME</*>). The transfer function has a
;  plateau of value =1 within the pass-band and is zero at frequencies outside the pass-band. However, the value of the
;  filter does not change abruptly at the margins of the pass-band, but changes smoothly within transition zones of
;  finite width, called the <I>flanks</I> of the filter. The flanks have a sigmoidal shape, realized by the
;  [0,pi/2]-branch of the sin<SUP>2</SUP> function for the ascending flank, and by the equivalent cos<SUP>2</SUP>-branch
;  for the descending flank (hence the name of the routine). The filter function is purely real and therefore causes no
;  phase shifts of the contributing signal components. For the same reason, on the other hand, the filter is not
;  causal.<BR>
;  The two cut-off frequencies are set via the corresponding keywords. If neither keyword is set, the transfer function
;  will be =1 everywhere and will have no filtering effect. The non-trivial possibilities are the following (<*>fS</*>
;  denoting the sampling frequency):<BR>
;  Lowpass:  0 < <*>FHIGH</*> < <*>fS</*>/2  (<*>FLOW </*> not set)<BR>
;  Highpass: 0 < <*>FLOW </*> < <*>fS</*>/2, (<*>FHIGH</*> not set)<BR>
;  Bandpass: 0 < <*>FLOW </*> < <*>FHIGH</*> < <*>fS</*>/2<BR>
;  Bandstop: 0 < <*>FHIGH</*> < <*>FLOW </*> < <*>fS</*>/2<BR>
;  By default, the cut-off frequencies denote the 3-dB points of the filter (i.e., those points where the flanks reach
;  the 3-dB value (ca. 0.5). Thus, signal components at the specified cut-off frequency are already attenuated by 3 dB.
;  (Note that this attenuation refers to the signal <I>amplitude</I>; the attenuation of the signal <I>power</I> is
;  always the square of this, i.e., 6 dB, corresponding to ca. 0.25.) If a different attenuation value is desired at the
;  cut-off frequencies, this can be specified by the keyword <*>ATTENUATION</*>.<BR>
;  The widths of the two flanks may also be set via keywords unless the default values are acceptable. By default, the
;  width of each flank is chosen to be exactly one octave (i.e., the ratio of the "begin" and "end" frequencies of each
;  flank is 1:2). The numbers specifying the flank widths are usually interpreted as the number of octaves (default) or
;  as absolute values in Hertz (by setting the keyword HERTZ). (Note that the cut-off frequencies, in contrast, are
;  <I>always</I> given as absolute values in Hertz.)<BR>
;  If the filter is returned as a time-domain kernel, its order can be specified via the keyword <*>ORDER</*>. The length
;  of the kernel is <*>2*ORDER+1</*>. By default, the order is chosen such that the kernel contains more than 99% of
;  the RMS amplitude of the "ideal" kernel (which results from the inverse DFT of the frequency-domain transfer function).
;  Since the DFT assumes the signal to be periodic, the time-domain filtering will be equivalent to the frequency-domain
;  filtering only if the signal epoch is continued periodically.
;
; CATEGORY:
;  Signals
;
; CALLING SEQUENCE:
;* filter = CosFlankFilter(N, fS [, FLOW=...] [, FHIGH=...] [, WLOW=...] [, WHIGH=...] [, /HERTZ] [, ATTENUATION=...]
;*                               [, /TIME [, ORDER=...]]
;
; INPUTS:
;  N::   An integer scalar giving the number of data points of the signal epoch for which the filter is constructed.
;        The frequency-domain transfer function will have this number of data points as well.
;  fS::  A float scalar giving the frequency (in Hz) which was used for sampling the signal.
;
; INPUT KEYWORDS:
;  FLOW::         A float scalar giving the lower cut-off frequency (i.e., the highpass cut-off), in Hertz. Setting
;                 <*>FLOW</*> to a value <=0 is equivalent to omitting it, and the filter function is solely determined
;                 by <*>FHIGH</*>. Setting <*>FLOW</*> to a value >=<*>fS</*>/2 results in a lowpass filter if
;                 0<<*>FHIGH</*><<*>fS</*>/2, otherwise it results in a zero-filter.
;  FHIGH::        A float scalar giving the upper cut-off frequency (i.e., the lowpass cut-off), in Hertz. Setting
;                 <*>FHIGH</*> to a value >=<*>fS</*>/2 is equivalent to omitting it, and the filter function is
;                 solely determined by <*>FLOW</*>. Setting <*>FHIGH</*> to a value <=0 results in a highpass filter if
;                 0<<*>FLOW</*><<*>fS</*>/2, otherwise it results in a zero-filter.
;  WLOW::         A float scalar giving the lower (i.e., the highpass) flank width, in multiples of one octave
;                 (default: 1). If you want to specify the flank width in Hertz, set the keyword /HERTZ. Setting
;                 <*>WLOW</*> explicitly to zero results in an ideal highpass with a discontinuous cut-off.
;  WHIGH::        A float scalar giving the upper (i.e., the lowpass) flank width, in multiples of one octave
;                 (default: 1). If you want to specify the flank width in Hertz, set the keyword /HERTZ. Setting
;                 <*>WHIGH</*> explicitly to zero results in an ideal lowpass with a discontinuous cut-off.
;  HERTZ::        Set this keyword if you want the <*>WLOW</*> and <*>WHIGH</*> values to be interpreted as absolute
;                 values in Hertz (default: the flank widths are assumed to be given in multiples of one octave).
;  ATTENUATION::  A float scalar giving the desired attenuation value at the cut-off frequencies (default: 3 dB, i.e.
;                 0.5012). This keyword may also be explicitly set to zero, in which case the cut-off frequencies exactly
;                 mark the edges of the plateau of the transfer function.
;  TIME::         Set this keyword if you want the filter to be returned as a time-domain convolution kernel.
;  ORDER::        An integer scalar giving the order (i.e., half of the length) of the time-domain kernel; this keyword
;                 has no effect unless the keyword <*>TIME</*> is set simultaneously. The default value used by the
;                 algorithm depends on the filter parameters and is chosen such that the kernel contains more than 99% of
;                 the ideal kernel. (The "ideal" kernel is the result of the inverse DFT of the frequency-domain transfer
;                 function. It is then truncated on both sides as long as not more than 1% of its RMS amplitude is lost.)
;                 If <*>ORDER</*> is explicitly set to zero using a named variable, <*>CosFlankFilter</*> determines the
;                 optimal filter order as just described and returns the result in the named variable.
;
; OUTPUTS:
;  filter::  A one-dimensional (float) array containing the desired filter function. If <*>filter</*> is returned as a
;            frequency-domain transfer function, its length (in data points) is <*>N</*>. Positive and negative
;            frequencies are already arranged in an FFT-compatible way, i.e., the filter can be directly used for
;            multiplication with a spectrum resulting from an FFT operation. If <*>filter</*> is returned as a
;            time-domain convolution kernel, its length is 2*<*>ORDER</*>+1. It can be directly used for convolution
;            with a time-domain signal epoch.
;
; SIDE EFFECTS:
;  If the keyword <*>ORDER</*> is set to a named variable which is zero, the value of this named variable will usually
;  be changed on return, giving the order which was actually used for the time-domain convolution kernel.
;
; RESTRICTIONS:
;  Setting the keywords <*>FHIGH</*>, <*>WLOW</*>, <*>WHIGH</*> or <*>ATTENUATION</*> explicitly to zero is not
;  equivalent to omitting them! Please refer to the descriptions of these arguments for further details.<BR>
;  If values for <*>FLOW</*> and <*>FHIGH</*> are not within the interval [0,fNyquist], they are confined to it, and
;  a corresponding warning message is given.<BR>
;  Negative values for the flank widths (<*>WLOW</*>, <*>WHIGH</*>), for the attenuation at the cut-off frequencies
;  (<*>ATTENUATION</*>) and for the filter order (<*>ORDER</*>) are assumed to be intended to be positive, without
;  an error message (i.e., only the numerical value is regarded relevant).<BR>
;  Since the time-domain convolution kernel length is always an odd number (2*order+1), whereas the length <*>N</*> of the
;  inverse DFT of the frequency-domain transfer function typically is an even number, the longest kernel version has
;  only N-1 data points, and in rare cases this might not be enough to capture 99% of the RMS amplitude. This problem
;  however will only arise when a very narrow bandpass or a very broad bandstop contains low frequencies.
;
; PROCEDURE:
;  The routine constructs the frequency-domain transfer function section by section with quite basic operations. Most
;  of the source code refers to the handling of the parameters and the different combinations of cut-off frequencies
;  and flank widths.
;
; EXAMPLE:
;  Generate a filter as a frequency-domain transfer function and as a time-domain convolution kernel, use them to filter
;  a signal, and compare the two results (the keyword <*>EDGE_WRAP</*> in the <*>Convol</*> function call takes into
;  account the implicit assumption of periodicity of the signal; in practice, however, one would rather continue the
;  signal periodically by array concatenation instead of setting <*>EDGE_WRAP</*>, because the latter is very
;  time-consuming):
;
;* Order   = 0
;* Signal  = RandomN(seed, 500)
;* FilterF = CosFlankFilter(500, 500, FLOW = 5.0, FHIGH = 10.0)
;* FilterT = CosFlankFilter(500, 500, FLOW = 5.0, FHIGH = 10.0, /TIME, ORDER = Order)
;* SignalF = Float(FFT(FFT(Signal)*FilterF, 1))
;* SignalT = Convol(Signal, FilterT, /EDGE_WRAP)
;* Plot , SignalF
;* OPlot, SignalT, color = RGB('red')
;* Print, Order
;
;  IDL prints:
;
;* >         181
;
; SEE ALSO:
;  The two steps of first generating a frequency-domain transfer function and then filtering a signal using the FFT
;  are combined in the routine <A>FilterSignal</A>, which also allows to pass multi-dimensional signal arrays.
;-



FUNCTION  CosFlankFilter,  N_, fS_,  $
                           flow = flow_, fhigh = fhigh_, wlow = wlow_, whigh = whigh_, hertz = hertz,  $
                           attenuation = attenuation_, time = time, order = order_


   ;----------------------------------------------------------------------------------------------------------------------
   ; Checking parameters and errors, initializing variables:
   ;----------------------------------------------------------------------------------------------------------------------

   On_Error, 2

   IF  NOT(Set(N_) AND Set(fS_))  THEN  Console, '   Not all arguments defined.', /fatal
   IF  (Size(N_ , /type) GE 6) AND (Size(N_ , /type) LE 11)  THEN  Console, '  Argument N is of wrong type', /fatal
   IF  (Size(fS_, /type) GE 6) AND (Size(fS_, /type) LE 11)  THEN  Console, '  Argument fS is of wrong type', /fatal

   N  = Round(N_(0))    ; If N  is an array, only the first value is taken seriously.
   fS = Float(fS_(0))   ; If fS is an array, only the first value is taken seriously.
   fN = fS/2            ; the Nyquist frequency

   ; The type of each keyword (if set) is checked:
   IF  Set(flow_)         THEN  IF  (Size(flow_       , /type) GE 6) AND (Size(flow_       , /type) LE 11)  THEN  Console, '  Keyword FLOW is of wrong type'       , /fatal
   IF  Set(fhigh_)        THEN  IF  (Size(fhigh_      , /type) GE 6) AND (Size(fhigh_      , /type) LE 11)  THEN  Console, '  Keyword FHIGH is of wrong type'      , /fatal
   IF  Set(wlow_)         THEN  IF  (Size(wlow_       , /type) GE 6) AND (Size(wlow_       , /type) LE 11)  THEN  Console, '  Keyword WLOW is of wrong type'       , /fatal
   IF  Set(whigh_)        THEN  IF  (Size(whigh_      , /type) GE 6) AND (Size(whigh_      , /type) LE 11)  THEN  Console, '  Keyword WHIGH is of wrong type'      , /fatal
   IF  Set(attenuation_)  THEN  IF  (Size(attenuation_, /type) GE 6) AND (Size(attenuation_, /type) LE 11)  THEN  Console, '  Keyword ATTENUATION is of wrong type', /fatal
   IF  Set(order_)        THEN  IF  (Size(order_      , /type) GE 6) AND (Size(order_      , /type) LE 11)  THEN  Console, '  Keyword ORDER is of wrong type'      , /fatal
   ; If not set, the default values for each keyword are defined; if set, they are type-converted if necessary. For
   ; "wlow", "whigh", "attenuation" and "order", only the numerical (positive) value is taken:
   IF  Set(flow_)         THEN  fLow        = Float(flow_(0))              ELSE  fLow        = 0.0
   IF  Set(fhigh_)        THEN  fHigh       = Float(fhigh_(0))             ELSE  fHigh       = fN
   IF  Set(wlow_)         THEN  wLow        = Abs(Float(wlow_(0)))         ELSE  wLow        = 1.0
   IF  Set(whigh_)        THEN  wHigh       = Abs(Float(whigh_(0)))        ELSE  wHigh       = 1.0
   IF  Set(attenuation_)  THEN  Attenuation = Abs(Float(attenuation_(0)))  ELSE  Attenuation = 3.0
   IF  Set(order_)        THEN  Order       = Abs(Round(order_(0)))        ELSE  Order       = 0L

   ; If the cut-off frequencies are out of the sensible range, they are confined to the interval [0,fN]:
   IF  (fLow  LT 0)   THEN  Console, '  FLOW was negative. Now set to zero.' , /warning
   IF  (fHigh LT 0)   THEN  Console, '  FHIGH was negative. Now set to zero.', /warning
   IF  (fLow  GT fN)  THEN  Console, '  FLOW was greater than Nyquist frequency. Now set to Nyquist frequency.' , /warning
   IF  (fHigh GT fN)  THEN  Console, '  FHIGH was greater than Nyquist frequency. Now set to Nyquist frequency.', /warning
   fLow  = fLow  > 0 < fN   ; limitation of the lower  cut-off frequency
   fHigh = fHigh > 0 < fN   ; limitation of the higher cut-off frequency

   ; Relative widths of the "flank tail" (the part of the flank between its minimum (=0) and the cut-off frequency)
   ; and of the "flank body" (the part of the flank between the cut-off frequency and its maximum (=1)):
   wTail = ASin( 10^(-0.05*Attenuation) ) * 2/!pi   ; lies between 0 and 1
   wBody = 1 - wTail

   ; Flank widths are needed as absolute values in Hz for the algorithm below.
   ; If the keyword HERTZ is set, the default value of 1.0 octave has to be expressed in Hz for each flank width
   ; that is not explicitly specified via WLOW or WHIGH.
   ; Furthermore, if HERTZ is not set, both widths are interpreted as given in multiples of 1 octave and have to be
   ; transformed to Hz. (To understand the transformation formulas, make a drawing and some calculations. Or leave it.)
   IF  Keyword_Set(Hertz)  THEN  BEGIN
     IF  NOT Set(wlow_)   THEN  wLow  = fLow  / (1 + wTail)
     IF  NOT Set(whigh_)  THEN  wHigh = fHigh / (1 + wBody)  ; (These formulas are special cases of the formulas in the ELSE condition.)
   ENDIF  ELSE  BEGIN
     wLow  = (2^wLow -1) / (1 + (2^wLow -1)*wTail)  *  fLow
     wHigh = (2^wHigh-1) / (1 + (2^wHigh-1)*wBody)  *  fHigh
   ENDELSE

   ; The "begin" and "end" frequencies of the low flank (LFlank) and the high flank (HFlank) are determined:
   LFlankBegin = fLow  - wLow  * wTail
   HFlankBegin = fHigh - wHigh * wBody
   LFlankEnd   = LFlankBegin + wLow
   HFlankEnd   = HFlankBegin + wHigh

   ;----------------------------------------------------------------------------------------------------------------------
   ; Constructing the frequency-domain transfer function:
   ;----------------------------------------------------------------------------------------------------------------------

   ; Initializing the frequency-domain transfer function and constructing a frequency axis:
   TransFunc = FltArr(N)
   Frequency = fS * FIndGen(N) / N
   Frequency = Frequency < (fS-Frequency)

   ; The indices of the filter flanks are determined:
   LFlankInd = WHERE((Frequency GE LFlankBegin) AND (Frequency LE LFlankEnd))
   HFlankInd = WHERE((Frequency GE HFlankBegin) AND (Frequency LE HFlankEnd))
   IF  wLow  EQ 0  THEN  LFlankInd = -1
   IF  wHigh EQ 0  THEN  HFlankInd = -1


   ; There are different possible combinations of keyword settings:
   CASE  1 OF

     ((fLow EQ 0) OR (fLow EQ fN)) AND ((fHigh GT 0) AND (fHigh LT fN)) :  BEGIN   ; lowpass
       TransFunc(*) = 1
       ZeroInd = WHERE( Frequency GT HFlankEnd )
       IF  HFlankInd(0) NE -1  THEN  TransFunc(HFlankInd) = COS(!pi/2*(Frequency(HFlankInd)-HFlankBegin)/wHigh)^2
       IF  ZeroInd(0)   NE -1  THEN  TransFunc(ZeroInd)   = 0
     END

     ((fLow GT 0) AND (fLow LT fN)) AND ((fHigh EQ 0) OR (fHigh EQ fN)) :  BEGIN   ; highpass
       TransFunc(*) = 1
       ZeroInd = WHERE( Frequency LT LFlankBegin )
       IF  LFlankInd(0) NE -1  THEN  TransFunc(LFlankInd) = SIN(!pi/2*(Frequency(LFlankInd)-LFlankBegin)/wLow)^2
       IF  ZeroInd(0)   NE -1  THEN  TransFunc(ZeroInd)   = 0
     END

     (fLow GT 0) AND (fLow LT fN) AND (fHigh GT 0) AND (fHigh LT fN) AND (fLow LE fHigh) :  BEGIN   ; bandpass
       TransFunc(*) = 1
       ZeroInd = WHERE((Frequency LT LFlankBegin) OR (Frequency GT HFlankEnd))
       IF  LFlankInd(0) NE -1  THEN  TransFunc(LFlankInd) = SIN(!pi/2*(Frequency(LFlankInd)-LFlankBegin)/wLow)^2
       IF  HFlankInd(0) NE -1  THEN  TransFunc(HFlankInd) = COS(!pi/2*(Frequency(HFlankInd)-HFlankBegin)/wHigh)^2 < TransFunc(HFlankInd)
       IF  ZeroInd(0)   NE -1  THEN  TransFunc(ZeroInd)   = 0
     END

     (fLow GT 0) AND (fLow LT fN) AND (fHigh GT 0) AND (fHigh LT fN) AND (fLow GT fHigh) :  BEGIN   ; bandstop
       OneInd = WHERE((Frequency LE HFlankBegin) OR (Frequency GE LFlankEnd))
       IF  LFlankInd(0) NE -1  THEN  TransFunc(LFlankInd) = SIN(!pi/2*(Frequency(LFlankInd)-LFlankBegin)/wLow)^2
       IF  HFlankInd(0) NE -1  THEN  TransFunc(HFlankInd) = COS(!pi/2*(Frequency(HFlankInd)-HFlankBegin)/wHigh)^2 > TransFunc(HFlankInd)
       IF  OneInd(0)    NE -1  THEN  TransFunc(OneInd)    = 1
     END

     (fLow EQ  0) AND (fHigh EQ fN) :  TransFunc(*) = 1   ; no filter

     ELSE:   ; zero-filter for all other cases (fLow=0 & fHigh=0;  fLow=fN & fHigh=0;  fLow=fN & fHigh=fN)

   ENDCASE

   ;----------------------------------------------------------------------------------------------------------------------
   ; Constructing the time-domain convolution kernel (if keyword TIME is set):
   ;----------------------------------------------------------------------------------------------------------------------

   ; If Total(TransFunc) is 0, the filter is a zero-filter, and the corresponding time-domain kernel is just one 0.
   ; If Total(TransFunc) is N, the filter is =1 everywhere, and the corresponding time-domain kernel is just one 1.
   ; In the other cases, the time-domain kernel must be explicitly calculated via an inverse FFT; then afterwards the
   ; optimal order is determined (unless explicitly given by the caller).
   IF  Keyword_Set(time)  THEN  BEGIN

     CASE  Total(TransFunc)  OF

       0   :  Kernel = [0.0]

       N   :  Kernel = [1.0]

       ELSE:  BEGIN
                Kernel = Float(Shift(FFT(TransFunc,1), N/2)) / N   ; "ideal" time-domain kernel
                IF  Order EQ 0  THEN  BEGIN
                  Power  = Kernel^2                               ; instantaneous power of the kernel
                  Energy = Total(Power)                           ; energy of the kernel
                  ; The optimal kernel order is determined using a binary search algorithm; OMin and OMax mark the edges
                  ; of the search inverval for the current iteration. Order is set to the interval mean, and depending on
                  ; whether the energy error of the kernel with the current order is greater or less than 0.01% (which is
                  ; equivalent to 1% RMS-amplitude error), OMin or OMax are set to Order, and the next iteration begins.
                  ; This is repeated until Order does not change any more.
                  OMin   = 0
                  OMax   = N/2
                  Order  = Ceil((OMin+OMax)/2.0)
                  REPEAT  BEGIN
                    Error = 1.0 - Total(Power(N/2-Order : N/2+Order)) / Energy
                    IF  Error LE 0.0001  THEN  OMax = Order  ELSE  OMin = Order
                    Order = Ceil((OMin+OMax)/2.0)
                  ENDREP  UNTIL  (Order EQ OMin) OR (Order EQ OMax)
                  ; The kernel length is confined to N if N is odd, and to N-1 if N is even:
                  Order  = Order < Ceil(N/2.0-1)
                  Order_ = Order
                ENDIF
                Kernel = Kernel(N/2-Order : N/2+Order)
              END

     ENDCASE

     Return, Kernel

   ENDIF  ELSE  $

     Return, TransFunc


END


;*************************************************************************************************************************
;*************************************************************************************************************************
