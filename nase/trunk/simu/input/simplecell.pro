;+
; NAME:
;  Simplecell()
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute activation of a layer of simplecells of given properties from
;  an input image.
;
; PURPOSE:
;  <C>Simplecell</C> returns the convolution of an input picture with a
;  simplecell-RF. The simplecell-RF is computed from the specified cell
;  characteristics (preferred <I>orientation</I>, <I>wavelength</I>,
;  and <I>phase</I>).<BR>
;  Optionally, the RF used for convolution can be returned.
;
; CATEGORY:
;  Connections
;  Image
;  Input
;  Layers
;  NASE
;  Signals
;  Simulation
;
; CALLING SEQUENCE:
;*activation = Simplecell( pic, orientation, wavelength, phase
;*                         [,/NORM] [,/POWERNORM] [,/ABSNORM]
;*                         [,/MAXONE] [,/NICEDETECTOR]
;*                         [,GET_FILTER=...] )
;
; INPUTS:
;  pic        :: The input picture to be processed. This may be seen
;                as the input fed into the simplecell layer.
;  orientation:: The preferred orientation of the simplecells,
;                specified in degrees.
;  wavelength :: The preferred spacial wavelength of the simplecells,
;                specified in pixels.
;  phase      :: The preferred spatial phase shift of the simplecells,
;                specified in radians.
;
; INPUT KEYWORDS:
;  NORM, POWERNORM, ABSNORM, MAXONE, NICEDETECTOR:: These keywords
;                                                   influence the
;                                                   exact form of the
;                                                   gabor patch to be
;                                                   used. See
;                                                   <A>Gabor()</A>.
;
; OUTPUTS:
;  activation:: The convolution result. This may be seen as the
;               activation of the simplecell layer.<BR>
;               Note: <I>No transfer function is applied. To cumpute the
;                     actual cell output, it may (or may not) be
;                     required to pass the result through some
;                     activation function, or to feed it into a layer
;                     of model neurons!</I>
;
; OPTIONAL OUTPUTS:
;  GET_FILTER:: The RF used for convolution.
;
; RESTRICTIONS:
;  Wavelength must be at least 2 pixels.<BR>
; 
; PROCEDURE:
;  The RF used for convolution is an appropriate <A>Gabor</A>
;  patch (see there). The RF is computed from the characteristics, and convolution
;  is performed using <A>Convol2dFFT</A>.
;
; EXAMPLE:
;*input=Coil20(1,0, /Float, /Nase)
;*plottvscl, input, /Nase
;*act1=Simplecell(input, 20, 16, 0, GET_FILTER=f1)
;*act2=Simplecell(input, 80, 32, !PI/2.0, GET_FILTER=f2)
;*plottvscl, act1, /Nase
;*plottvscl, f1, /Nase
;*plottvscl, act2, /Nase
;*plottvscl, f2, /Nase
;*>
;
; SEE ALSO:
;  <A>Gabor</A>
;-

Function Simplecell, pic, orientation, wavelength, phase, $
                     NORM=norm, POWERNORM=powernorm, ABSNORM=absnorm, $
                     MAXONE=maxone, NICEDETECTOR=nicedetector, $
                     GET_FILTER = filter

   Default, phase, 0

   assert, Set(pic), "Specify a greyscale picture for filtering."
   assert, Set(orientation), "Specify filter orientation as second " + $
     "argument."
   assert, Set(wavelength), "Specify filter wavelength as third " + $
     "argument."
   assert, wavelength ge 2, "Wavelength needs to be at least 2 pixels " + $
           "to be correctly sampled!"
   assert, Set(phase)

   ;; The width of the gabor filter mask is computed as to allow for
   ;; one cycle, i.e. 3*sigma == wavelength.
   size = 2*wavelength
   hmw = !sigma2hwb*wavelength/3.0;; triple sigma == wavelength

   filter = Gabor(size, Orientation=orientation, $
                  Wavelength=wavelength, Hmw=hmw, phase=phase, $
                  NORM=norm, POWERNORM=powernorm, ABSNORM=absnorm, $
                  MAXONE=maxone, NICEDETECTOR=nicedetector)

   return, Convol2dFFT(pic, filter)

end
 
