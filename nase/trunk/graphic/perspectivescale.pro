;+
; NAME:
;  PerspectiveScale()
;
; VERSION:
;  $Id$
;
; AIM:
;  Scale the size of an image linearly, according to a given visual distance.
;
; PURPOSE:
;  Scale the size of an image linearly, by a factor computed from a
;  given eye position, and a given visual distance from the eye (along
;  the z-axis).<BR>
;  Optionally, an additional linear scaling factor (specifying the
;  image's "realworld size") may be defined.<BR>
;  This procedure works for greyscale or truecolor images.
;*
;*                                  .
;*                             .    |
;*                        .         | p
;*                   .              | i
;*              .    | re           | c
;*         .         | sult         |
;*-----o-------------+--------------+------> z
;*     0 
;*     |---- eye ----|        
;*                   |-- distance --|   
;*
;
; CATEGORY:
;  Image
;  Input
;
; CALLING SEQUENCE:
;*result = ImageScale( pic, distance [,eye] [,SIZEFACTOR=...] [,BACKGROUND=...] )
;
; INPUTS:
;  pic:: The image to be scaled. This must eithe be a 2-dimensional
;        (greyscale) array, or a 3-dimensional truecolor array (first
;        dimension=3) of numeric type.
;
;  distance:: The visual distance of the original image, measured from
;             the eye position.
;
;  eye:: The eye (i.e., the projecting-) position. Default: <*>1.0</*>
;
; INPUT KEYWORDS:
;  SIZEFACTOR:: An optional linear scaling factor, which is applied in
;               addition (i.e., multiplicatively) to the computed
;               factor. This allows specifying the (relative) size in
;               real-world-coordinates of the input image. Hence, the
;               two parameters <I>real world distance</I> and <I>real
;               world size</I> of the input image can be specified
;               independently.<BR>
;               See the examples below for further carification.
;
;  BACKGROUND:: The value to fill into the space that becomes
;               available when the image is shrunken. Default is
;               <*>0</*>.
;
; OUTPUTS:
; result:: The scaled image. The result has the same dimensions as
;          the input image. I.e., overlapping portions of an enlarged
;          image are clipped, new portions of a shrunken image are
;          filled in with value <C>BACKGROUND</C>.
;
; RESTRICTIONS:
;  <*>eye NE 0</*>, <*>(eye+distance) NE 0</*>
;
; PROCEDURE:
;  compute scaling factor, then call <A>ImageScale</A>, plus some
;  special magic for truecolor images.
;
; EXAMPLE:
;*PlotTvScl, PerspectiveScale( Coil20(1,0), 0.0 )
;*PlotTvScl, PerspectiveScale( Coil20(1,0), 1.0 )
;*PlotTvScl, PerspectiveScale( Coil20(1,0), 10.0, BACKGROUND=100 )
;*PlotTvScl, PerspectiveScale( Coil20(1,0), -0.5 )
;*undef, ui & for i=5.0,-0.5,-0.05 do PlotTvScl, PerspectiveScale( Coil20(1,0), i), update_info=ui
;*
;*; examples for the SIZESCALE keyword:
;*; This is a duck at distance 1.0, and of relative size 1.0:
;*PlotTvScl, PerspectiveScale( Coil20(1,0), 1.0, SIZEFACTOR=1.0 )
;*; This is the same duck at distance 2.0:
;*PlotTvScl, PerspectiveScale( Coil20(1,0), 2.0, SIZEFACTOR=1.0 )
;*; This is a duck at distance 1.0 again, but which is half the SIZE (in real-world):
;*PlotTvScl, PerspectiveScale( Coil20(1,0), 1.0, SIZEFACTOR=0.5 )
;*;Note that the last two images do NOT LOOK THE SAME!
;
; SEE ALSO:
;  <A>ImageScale</A>
;-


Function PerspectiveScale, pic, d, e, BACKGROUND=background,  SIZEFACTOR=sizefactor

   Default, e, 1.0

   assert, Set(d), "Distance parameter was not given or is undefined."

   assert, InSet( Size(pic, /N_Dimensions), [2,3] ), $
     "Argument must be a Greyscale or a Truecolor picture, i.e. a " + $
     '2-element-array,  or a 3-element-array with the first ' + $
     "dimension=3."
   
   Default, SIZEFACTOR, 1.0

   fac = float(e)/(e+d) * SIZEFACTOR

   If Size(pic, /N_Dimensions) eq 2 then begin
      ;; It's a greyscale picture

      Default, BACKGROUND, 0
      assert, Size(BACKGROUND, /N_Dimensions) eq 0, $
        "BACKGROUND must be a scalar for greyscale images."

      
      Return, ImageScale(pic, fac, BACKGROUND=background)
;      dims = Size(pic, /Dimensions)
;      scaledpic = Congrid(pic, dims[0]*fac, dims[1]*fac, $
;                          Cubic=-0.5, /Minus_One)
;      If fac le 1.0 then $
;        Return, InsSubarray(pic*0+BACKGROUND, Temporary(scaledpic), /Center) $
;      else $
;        Return, GetSubarray(Temporary(scaledpic), dims[0], dims[1], /Center)
      
   endif else begin
      ;; It's a Truecolor picture

      assert, (Size(pic, /Dimensions))[0] eq 3, $
        "Argument must be a Greyscale or a Truecolor picture, i.e. a " + $
        '2-element-array,  or a 3-element-array with the first ' + $
        "dimension==3."
      dims = Size(pic, /Dimensions)

      Default, BACKGROUND, [0, 0, 0]
      assert, Size(BACKGROUND, /N_Dimensions) eq 1, $
        "BACKGROUND must be an [R,G,B]-triple for Truecolor images, " + $
        "given in according units."
      assert, (Size(BACKGROUND, /Dimensions))[0] eq 3, $
        "BACKGROUND must be an [R,G,B]-triple for Truecolor images," + $
        "given in according units."

      temppic = pic;; don't change original argument
      ;;Sorry, we can't do this with a TEMPORARY:
      for channel=0,2 do temppic[channel,*,*] = $
        perspectivescale(reform(temppic[channel,*,*]), d, e, $
                        BACKGROUND = BACKGROUND[channel])
      return, temppic

   EndElse
   
End
