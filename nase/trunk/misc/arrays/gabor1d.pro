;+
; NAME:
;  Gabor1d()
;
; VERSION:
;  $Id$
;
; AIM:
;  Construct a 1-dimensional gabor wavelet.
;
; PURPOSE:
;  <C>Gabor1d()</C> returns a 1-dimensional array containing a (real
;  value) Gabor wavelet of zero mean, and of arbitrary wavelength, and
;  size.  Optionally, the peak amplitude, or the power of the whole
;  patch, can be normalized to <*>1.0</*>.<BR>
;  See the <A>Gabor()</A> function for constructing 2-dimensional,
;  oriented gabor patches.
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;  Math
;  Signals
;
; CALLING SEQUENCE:
;*result = Gabor1d( size
;*                  [,HMW=...] [,PHASE=...] [,WAVELENGTH=...]
;*                  [,/NORM] [,/MAXONE] )
;
; INPUTS:
;  size:: Size of the array to be returned.
;
; OPTIONAL INPUTS:
;  HMW        :: Width of the gabor wavelet (half mean width of the
;                gaussmask), specified in array points (pixels). <BR>
;                <I>Default value:</I> Will be taken from <A>Gauss_2d</A>'s
;                default. 
;
;  PHASE      :: Phase shift of the gabor wavelet, specified in
;                radians. Positive values will shift left (i.e., in -x
;                direction).<BR>
;                <I>Default value:</I> Miximum at center of the
;                wavelet.
;
;  WAVELENGTH :: Wavelength of underlying cosine function, specified
;                in array points (pixels). <BR>
;                <I>Default value:</I> Array size (as specified in
;                <*>size</*> parameter).
;
; INPUT KEYWORDS:
;  NORM        :: Normalize the gaussian mask that is used to build
;                 the gabor wavelet, for signal processing purposes. If
;                 <*>/NORM</*> is set, the gaussian mask that is
;                 multiplied to the cosine function is normalized to a
;                 total volume of 1.0 (see also <*>/NORM</*> option of
;                 the <A>Gauss_2d</A> function).  This makes
;                 convolution results for different wavelengths
;                 comparable, because the results will be independent
;                 of the gabor wavelet size.
;
;  POWERNORM   :: Normalize the power of the whole gabor wavelet for
;                 filtering purposes. If <*>/POWERNORM</*> is set, the
;                 gabor wavelet is scaled to a total power of
;                 <*>1.0</*>. I.e., <*>Total(Gabor(...)^2.0) eq
;                 1.0</*>.
;
;  MAXONE      :: If <*>PHASE</*> is different from <*>0</*>, the
;                 maximum values of the cosine function and the gauss
;                 mask used to create to gabor wavelet will not be
;                 aligned. By default, amplitudes of both functions
;                 are <*>1.0</*>, which means that the maximum of the
;                 resulting gabor wavelet will be smaller than
;                 <*>1.0</*> in these cases. If the maximum of the
;                 resulting gabor wavelet is desired to equal
;                 <*>1.0</*>, regardless of phase shift, set the
;                 <*>/MAXONE</*> switch. <BR>
;                 Note that <*>/MAXONE</*> overrides <*>/NORM</*>.
;
; OUTPUTS:
;  An array of <*>size</*> elements of type DOUBLE, containing the gabor
;  wavelet. The result is y-shifted to have zero mean.
;
; RESTRICTIONS: 
;  <C>Gabor()</C> now behaves like <A>Hill</A>, as regards centering:<BR>
;  If, for example, a 0° shifted wavelet is requested in an array of
;  even width, the maximum will not actually be contained in the
;  array, but values will be adjusted as to virtually meat the correct
;  maximum in between the middle two points. As a fact, <A>Hill</A> is
;  called to produce the correct cosine function.
;
; PROCEDURE:
;  Create a shifted cosine function, and multiply it by a gaussian
;  mask.
;
; EXAMPLE:
;*1. Plot, Gabor1d(100)
;*3. Plot, Gabor1d(100, PHASE=0.5*!DPI)
;*4. Plot, Gabor1d(100, PHASE=0.5*!DPI, WAVELENGTH=20)
;
; SEE ALSO:
;  <A>Gabor</A>, <A>Dog</A>, <A>Gauss_2d</A>
;-

Function Gabor1d, size, PHASE=phase, $
                WAVELENGTH=wavelength, $
                HWB=hwb, HMW=hmw, NORM=norm, POWERNORM=powernorm, $
                MAXONE=maxone

   Default, WAVELENGTH, size
   Default, PHASE, 0
   Default, HWB, HMW ;; should be english according to NASE conventions.

   result = Ramp(size, Mean=0, Slope=1)

   result = cos(phase + temporary(result)*2*!PI/float(wavelength)) $
     * gauss_2d(size, 1, HWB=hwb, NORM=norm)
   


   ;; adjust whole array to have total 0 (remove mean)
   
   ;;max of gaussmask was 1
   total_offset = total(result)/float(size) ;Volume of gabor
   result = temporary(result)-total_offset ;Volume=0


   if Keyword_Set(POWERNORM) then begin
      ;; Normalize power to 1.0
      A = sqrt(Total(result^2.))
      result = Temporary(result)/A
   endif

   If Keyword_Set(MAXONE) then begin
      ;; Normalize max amplitude to 1.0
      m = max(result)
      result = Temporary(result)/m 
   endif

   return, result
End
