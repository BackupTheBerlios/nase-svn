;+
; NAME:
;  Resample()
;
; VERSION:
;  $Id$
;
; AIM:
;  A replacement for IDL's <C>CONGRID()</C> that gives better results when shrinking.
;
; PURPOSE:
;  IDL's <C>CONGRID()</C> does quite good interpolation when extending
;  an array (if <C>CUBIC</C> keyword is used), but it does simple pixel
;  selection when shrinking, which can introduce bad aliasing
;  artefacts. The NASE routine <A>Subsample</A> does a better job at
;  shrinking, but cannot extend arrays.<BR>
;  This routine is a simple wrapper that detects if an array shall be
;  extended or shrunken, and calls either <*>CONGRID</*> or <A>Subsample</A>. 
;
; CATEGORY:
;  Array
;  Image
;
; CALLING SEQUENCE:
;*result = Resample( image, xsize, ysize [,/EDGE_{TRUNCATE|WRAP}] )
;
; INPUTS:
;  image:: image to bre resampled. Must be a two-dimensional floating
;          point array.
;  {x|y}size:: new x and y size of the returned image.
;
; INPUT KEYWORDS:
;  EDGE_{TRUNCATE|WRAP}: passed to <A>Subsample()</A> for convolution, see IDL's <C>CONVOL</C>.
;
; EXAMPLE:
;*> utvscl, alison()
;*> utvscl, resample(alison(),100,100)
;*> utvscl, resample(alison(),400,400)
;*> utvscl, resample(alison(),100,400)
;*> utvscl, resample(alison(),400,100)
;
; SEE ALSO:
;  IDL's <C>CONGRID</C>, IDL's <C>REBIN</C>, <A>Subsample</A>
;-

Function Resample, A, x, y, edge_truncate=edge_truncate, edge_wrap=edge_wrap

   dim = Size(A, /Dimensions)

   if (x eq dim[0]) and (y eq dim[1]) then return, A

   if (x ge dim[0]) and (y ge dim[1]) then return, Congrid(A, x, y, $
                                                           /Minus_One, $
                                                           Cubic=-0.5)
   
   if (x le dim[0]) and (y le dim[1]) then return, Subsample(A, [dim[0]/float(x), dim[1]/float(y)], edge_truncate=edge_truncate, edge_wrap=edge_wrap)

   ;; now the more complicated case: shrink one dimension, extend
   ;;                                other:
   
   if (x le dim[0]) and (y ge dim[1]) then begin
      tmp = Congrid(A, dim[0], y, /Minus_One, Cubic=-0.5)
      return, Subsample(Temporary(tmp), [dim[0]/float(x), 1.0], edge_truncate=edge_truncate, edge_wrap=edge_wrap)
   endif

   if (x ge dim[0]) and (y le dim[1]) then begin
      tmp = Congrid(A, x, dim[1], /Minus_One, Cubic=-0.5)
      return, Subsample(Temporary(tmp), [1.0, dim[1]/float(y)], edge_truncate=edge_truncate, edge_wrap=edge_wrap)
   endif

   ;; if we reach this point, something went wrong:
   console, /Fatal, "This must not happen!"

End
