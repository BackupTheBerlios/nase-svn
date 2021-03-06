;+
; NAME:
;  Gabor()
;
; VERSION:
;  $Id$
;
; AIM:
;  Construct a 2-dimensional gabor patch.
;
; PURPOSE:
;  <C>Gabor()</C> returns a square array containing a (real value)
;  Gabor patch of zero mean, and of arbitrary wavelength, size, and
;  orientation. Optionally, the peak amplitude, or the power of the
;  whole patch, can be normalized to <*>1.0</*>.<BR>
;  See the <A>Gabor1d()</A> function for constructing 1-dimensional
;  gabor wavelets.
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;  Math
;  Signals
;
; CALLING SEQUENCE:
;*result = Gabor( size
;*                [,HMW=...] [,ORIENTATION=...] [,PHASE=...] [,WAVELENGTH=...]
;*                [,/NORM] [,/POWERNORM] [,/ABSNORM] [,/MAXONE] [,/NICEDETECTOR] )
;
; INPUTS:
;  size:: Size of the (square) array to be returned.
;
; OPTIONAL INPUTS:
;  HMW        :: Width of the gabor patch (half mean width of the
;                gaussmask), specified in array points (pixels). <BR>
;                <I>Default value:</I> Will be taken from <A>Gauss_2d</A>'s
;                default. 
;
;  ORIENTATION:: Orientation of the gabor patch, specified in
;                degrees. If omitted, a concentric patch without
;                orientation is generated. To get a patch of
;                <*>0�</*> orientation, set <*>ORIENTATION=0</*> explicitely.
;
;  PHASE      :: Phase shift of the gabor patch, specified in
;                radians. For a <*>0�</*> oriented patch, positive values
;                will shift upwards (for NASE array conventions).<BR>
;                <I>Default value:</I> Miximum at center of the patch.
;
;  WAVELENGTH :: Wavelength of underlying cosine function, specified
;                in array points (pixels). <BR>
;                <I>Default value:</I> Array size (as specified in
;                <*>size</*> parameter).
;
; INPUT KEYWORDS:
;  NORM        :: Normalize the gaussian mask that is used to build
;                 the gabor patch, for image processing purposes. If
;                 <*>/NORM</*> is set, the gaussian mask that is
;                 multiplied to the cosine function is normalized to a
;                 total volume of 1.0 (see also <*>/NORM</*> option of
;                 the <A>Gauss_2d</A> function).  This makes
;                 convolution results for different wavelengths
;                 comparable, because the results will be independent
;                 of the gabor patch size.
;
;  POWERNORM   :: Normalize the power of the whole gabor patch for
;                 filtering purposes. If <*>/POWERNORM</*> is set, the
;                 gabor wavelet is scaled to a total power of
;                 <*>1.0</*>. I.e., <*>Total(Gabor(...)^2.0) eq
;                 1.0</*>.
;
;  ABSNORM     :: Normalize the gabor patch to its total absolute value.
;                 This means that its response to the optimal stimulus
;                 (which is a square grid of optimal frequency and of
;                 range <*>[-1,1]</*>) is <*>1.0</*>.<BR>
;                 Note that this means that if the input picture
;                 values have mean <*>m</*> and max. amplitude <*>a</*>,
;                 the filtering result will have mean <*>0</*> and
;                 max. amplitude <*>a</*>. (Independent of wavelength
;                 and patch size.) 
;
;  MAXONE      :: If <*>PHASE</*> is different from <*>0</*>, the
;                 maximum values of the cosine function and the gauss
;                 mask used to create to gabor patch will not be
;                 aligned. By default, amplitudes of both functions
;                 are <*>1.0</*>, which means that the maximum of the
;                 resulting gabor patch will be smaller than
;                 <*>1.0</*> in these cases. If the maximum of the
;                 resulting gabor patch is desired to equal
;                 <*>1.0</*>, regardless of phase shift, set the
;                 <*>/MAXONE</*> switch. <BR>
;                 Note that <*>/MAXONE</*> overrides <*>/NORM</*>.
;
;  NICEDETECTOR:: Gabor wavelets have only restricted use as
;                 orientation detectors, as, for instance, in a <*>0�</*>
;                 oriented patch the integral (total) of the whole
;                 patch equals zero, but not so the individual column
;                 integrals. As a result, a <*>0�</*> oriented detector will
;                 also detect, to a small amount, <*>90�</*>
;                 edges.<BR>
;                 If <*>/NICEDETECTOR</*> is set, the individual
;                 columns will be scaled to have zero integrals. The
;                 resulting array is not an exact gabor wavelet, but
;                 represents a "clean" edge detector. <BR>
;                 A problem occuring with the <*>/NICEDETECTOR</*>
;                 option is that of standardization: Individual
;                 columns are standardized prior to a possible
;                 rotation of the patch. The total integral of the
;                 array may differ slightly from zero due to discretization
;                 errors during rotation. Note that no such errors
;                 will occur for orientations that are multiples of
;                 <*>90�</*>.
;
; OUTPUTS:
;  A <*>size x size</*> array of type DOUBLE, containing the gabor
;  patch. The result is shifted to have zero mean.
;
; RESTRICTIONS:
;  Like all other routines using array rotations, this routine suffers
;  from discretization errors. When using the <*>/NICEDETECTOR</*>
;  option, this may cause the total integral of the resulting array to
;  differ slightly from zero.
;
;  <C>Gabor()</C> now behaves like <A>Hill</A> or <A>Distance</A>, as
;  regards centering:
;  If, for example, a 0� shifted detecor is requested in an array of even
;  width, the maximum will not actually be contained in the array, but
;  values will be adjusted as to virtually meat the correct maximum in
;  between the middle two points. As a fact, <A>Hill</A> and
;  <A>Distance</A> are called to produce the correct cosine function.
;
; PROCEDURE:
;  Create a shifted linear or concentric cosine function, and multiply
;  it by a gaussian mask.
;
; EXAMPLE:
;*1. PlotTVScl, /NASE, Gabor(100)
;*2. PlotTVScl, /NASE, Gabor(100, ORIENTATION=0)
;*3. PlotTVScl, /NASE, Gabor(100, ORIENTATION=30, PHASE=0.5*!DPI)
;*4. PlotTVScl, /NASE, Gabor(100, ORIENTATION=30, PHASE=0.5*!DPI, WAVELENGTH=50)
;
; SEE ALSO:
;  <A>Gabor1d</A>, <A>Dog</A>, <A>Gauss_2d</A>
;-

Pro Gabor_rotate_array, result, orientation
   COMPILE_OPT HIDDEN
   ;;we use "rotate" where possible, as it works cleaner
   case orientation of 
      90 : result = rotate(temporary(result), 1)
      180: result = rotate(temporary(result), 2)
      270: result = rotate(temporary(result), 3)
      else: begin
         missing = result(0, 0) ; This is hopefully a better substitute for missing pixels than zero
         result = rot(temporary(result), -ORIENTATION, CUBIC=-0.5, MISSING=missing)
      endelse
   endcase
End

Function Gabor, size, PHASE=phase, ORIENTATION=orientation, $
                WAVELENGTH=wavelength, $
                HWB=hwb, HMW=hmw, NORM=norm, POWERNORM=powernorm, ABSNORM=absnorm, $
                MAXONE=maxone, NICEDETECTOR=nicedetector

   Default, WAVELENGTH, size
   Default, PHASE, 0
   Default, HWB, HMW ;; should be english according to NASE conventions.

   If Set(ORIENTATION) then begin
      result = Ramp(size, Mean=0, Slope=1)
      result = rebin(temporary(result), size, size, /SAMPLE)
   Endif else begin
      result = distance(size)
   Endelse

   result  = cos(phase + temporary(result)*2*!PI/float(wavelength)) $
     * gauss_2d(size, size, HWB=hwb, NORM=norm)
   


   If Keyword_Set(NICEDETECTOR) then begin ; adjust eauch column to have total 0
      ;; in this case, we rotate last

      If not set(ORIENTATION) then begin
         on_error, 2            ;return to caller
         message, "Option NICEDETECTOR used on non-oriented patch."
      endif
      correction = total(result, 1)/float(size)
      for col=0, size-1 do result(*, col) = result(*, col)-correction(col)

      center_offset = correction(size/2)

      If keyword_set(ORIENTATION) then begin ;nothing to be done for orientation=0...
         Gabor_rotate_array, result, orientation
      endif

   endif else begin; adjust whole array to have total 0 (remove mean)
      ;; in this case, we can rotate first!
      
      If keyword_set(ORIENTATION) then begin ;nothing to be done for orientation=0...
         Gabor_rotate_array, result, orientation
      endif

      ;;max of gaussmask was 1
      total_offset = total(result)/(size^2.) ;Volume of gabor
      result = temporary(result)-total_offset ;Volume=0
   endelse


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

   If Keyword_Set(ABSNORM) then begin
      fac = total(abs(result))
      result = Temporary(result)/fac 
   endif
   
   return, result
End
