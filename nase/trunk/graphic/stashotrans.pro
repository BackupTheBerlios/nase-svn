;+
; NAME:
;  StashOTrans()
;
; VERSION:
;  $Id$
;
; AIM:
;  places a transparent image in front of another image
;
; PURPOSE:
;  This routine places an true-color image in front of another
;  true-color image, using an inherent alpha channel or an explicitely
;  defined opacity array for the front image. The result is returned
;  as another true-color image that may be viewed using <A>UTv</A> or
;  <A>PTVs</A> with enabled <*>/TRUE</*> option.
;
; CATEGORY:
;  Graphic
;  Image
;
; CALLING SEQUENCE:
;*mix = StashOTrans(front, back [,mask] [,TRUE=...] [,TRANS=...])
;
; INPUTS:
;  front :: true-color image placed in the front. If it contains an
;           alpha channel this will be used for transparency. In this
;           case neither <*>mask</*> nor <*>TRANS</*> are allowed.
;  back  :: true-color image placed behind the partly tranparent
;           <*>front</*> image. Its (optional) alpha channel is
;           ignored. It has to have same width and height as <*>front</*>.
;
; OPTIONAL INPUTS:
;  mask :: two-dimensional array specifying the alpha channel
;          (opacity of the image) for the <*>front</*> image, if <*>front</*>
;          doesn't already include one. <*>0</*> means maximal
;          transparency (object invisible), while <*>255</*> stands
;          for maximal opacity. It has to have same width and height
;          as <*>front</*> and <*>back</*>.
;
; INPUT KEYWORDS:
;  TRUE  :: Set this keyword to a nonzero value to indicate that a
;               TrueColor (16-, 24-, or 32-bit) image is to be
;               displayed. The value assigned to TRUE specifies the
;               index of the dimension over which color is
;               interleaved. The image parameter must have three
;               dimensions, one of which must be equal to three. For
;               example, set <*>TRUE</*> to 1 to display an image that
;               is pixel interleaved and has dimensions of (3, m, n).
;               Specify 2 for row-interleaved images, of size (m, 3,
;               n), and 3 for band-interleaved images of the form (m,
;               n, 3). Default is 1.
;  TRANS :: <*>front</*> image is set to constant transparency
;           (<*>[0..1]</*>), if neither an alpha channel nor
;           <*>mask</*> is set. Default: 0.5
;
; OUTPUTS:
;  mix :: resulting true-color image as (3,width,height) array
;  
; RESTRICTIONS:
;  needs Object Graphics and will only work for IDL version > 5.?  
;
; PROCEDURE:
;  The front image is extended by an alpha channel, if none is present
;  or <*>mask</*>/<*>TRANS</*> is specified. Both images are put into
;  an Object Graphics hierarchy, using an <*>IDLgrBuffer</*> as
;  parent. Alpha blending is turned on for <*>front</*>. The scene is
;  realized and extracted back into an array.
;
; EXAMPLE:
;create front rgb image (two dimensional gaussian, STD-GAMMA II as
;color palette):
;*front = i2rgbs(gauss_2d(200,100),pal=5)
;create back image (noise, b/w)
;*back=i2rgbs(randomu(seed,200,100),pal=0)
;plot using constant transparency:
;*ptvs, StashOTrans(front, back, TRANS=0.5),/true,/qua 
;uses high transparency for low values of <*>front</*>:
;*ptvs, StashOTrans(front, back, 255*gauss_2d(200,100)),/true,/qua
;
; SEE ALSO:
;  <A>I2RGBS</A> to transform indexed into true-color images,
;  <A>PTvS</A> or <A>UTvScl</A> to display to result properly.
;
;-


FUNCTION StashOTrans, _fa, ba, mask, TRANS=trans, TRUE=true

On_Error, 2

Default, TRUE, 1
IF NOT TVInfo(_fa, TRUE=true, ALPHA=alpha, W=wfa, H=hfa) THEN Console, 'first argument is not a valid rgb image', /FATAL
IF NOT TVInfo( ba, TRUE=true, W=wba, H=hba)              THEN Console, 'second argument is not a valid rgb image', /FATAL

IF ((hba NE hfa) OR (wba NE wfa)) THEN Console, 'image dimensions differ', /FATAL


IF NOT alpha THEN BEGIN
    IF (Set(trans)+(N_Params() EQ 3)) GT 1 THEN Console, 'specify either mask or TRANS', /FATAL
    ; front image has no alpha channel, use default or user mask

    Default, trans, 0.5
    IF (trans LT 0) OR (trans GT 1) THEN Console, '0 <= TRANS <= 1 required', /FATAL
    Default, mask, Make_Array(/BYTE, wba, hba, VALUE=FIX(255*(1-trans))) ; half transparent as default

    IF NOT TVInfo(mask, TRUE=0, W=wm, H=hm) THEN Console, 'invalid mask dimensions', /FATAL
    IF ((hm NE hfa) OR (wm NE wfa)) THEN Console, 'wrong dimensions for mask', /FATAL
    fa = [_fa,reform(mask,1,wm,hm)]

END ELSE BEGIN
    IF Set(mask) THEN Console, "can't handle mask and alpha channel simultaneously", /FATAL
    fa = _fa
END



mywindow = OBJ_NEW('IDLgrBuffer', DIMENSIONS=[wfa,hfa])
myview = OBJ_NEW('IDLgrView', VIEW=[0,0,wfa,hfa])
model = OBJ_NEW('IDLgrModel')
myview -> Add, model

back = OBJ_NEW('IDLgrImage', ba, INTERLEAVE=0)
model -> Add, back

front = OBJ_NEW('IDLgrImage', fa, INTERLEAVE=0)
front->setproperty, blend_function=[3,4] ; enable alpha channel for front image
model -> Add, front

mywindow -> Draw, myview 
mywindow->getproperty, image_data=u
RETURN, u

END
