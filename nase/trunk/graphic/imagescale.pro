;+
; NAME:
;  ImageScale()
;
; VERSION:
;  $Id$
;
; AIM:
;  Scale the size of an image linearly, by a given factor.
;
; PURPOSE:
;  Scale the size of an image linearly, by a given factor, with the
;  center of scaling in the middle of the array. The array dimensions
;  are left unchanged, i.e. the output has the same array dimensions
;  as the input.
;
; CATEGORY:
;  Image
;
; CALLING SEQUENCE:
;*result = ImageScale( pic, fac [,BACKGROUND=...] )
;
; INPUTS:
;  pic:: The image to be scaled. This must be a 2-dimensional array of
;        numeric type.
;  fac:: The scaling factor. <*>fac=1.0</*> leaves the array contents
;        unchanged.
;
; INPUT KEYWORDS:
;  BACKGROUND:: The value to fill into the space that becomes
;               available when the image is shrinked. Default is
;               <*>0</*>.
;
; OUTPUTS:
;  result:: The scaled image. The result has the same dimensions as
;           the input image. I.e., overlapping portions of an enlarged
;           image are clipped, new portions of a shrunken image are
;           filled in with value <C>BACKGROUND</C>.
;
; PROCEDURE:
;  Combine <C>CONGRID</C> and <A>GetSubArray</A>/<A>InsSubArray</A>.
;
; EXAMPLE:
;* PlotTvScl, coil20(1,0)
;* PlotTvScl, ImageScale( coil20(1,0), 0.5 )
;* PlotTvScl, ImageScale( coil20(1,0), 1.5 )the scaled
;* PlotTvScl, ImageScale( coil20(1,0), 0.5, BACKGROUND=100 )
;*>
;
; SEE ALSO:
;  <A>PerspectiveScale</A>, IDL's <C>CONGRID</C>.
;-


Function imagescale, pic, fac, BACKGROUND=background

   assert, Set(fac), "fac parameter was not given or is " + $
     "undefined."

   assert, Size(pic, /N_Dimensions) eq 2, $
     "pic argument must be a " + $
     '2-element-array.'
   
   Default, BACKGROUND, 0
   dims = Size(pic, /Dimensions)
   scaledpic = Congrid(pic, dims[0]*fac, dims[1]*fac, $
                       Cubic=-0.5, /Minus_One)
   If fac le 1.0 then $
     Return, InsSubarray(pic*0+BACKGROUND, Temporary(scaledpic), /Center) $
   else $
     Return, GetSubarray(Temporary(scaledpic), dims[0], dims[1], /Center)
   
End
