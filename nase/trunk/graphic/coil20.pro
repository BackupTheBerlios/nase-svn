;+
; NAME:
;  COIL20()
;
; VERSION:
;  $Id$
;
; AIM:
;  Load an image from the COIL-20 database.
;
; PURPOSE:
;  This function returns a 128x128 pixel greyscale image, taken from
;  the Columbia Object Image Library COIL-20 [1]. This database
;  contains images of 20 single objects against a black background,
;  rotated in depth at pose intervals of 5 degrees. Images are
;  normalized to size and grey range. Object number and
;  rotation angle are supplied as positional parameters to
;  <C>COIL20()</C>.<BR><BR>
;  [1] Sameer, A. Nene AND Shree, K. Nayar AND Hiroshi Murase,
;  <I>"Columbia Object Image Library"</I>, Dep. Computersci.,
;  Columbia University, New York, N.Y. 10027, Tech. Rep. CUCS-006-96,
;  1996.
;
; CATEGORY:
;  Animation
;  Image
;  Input
;
; CALLING SEQUENCE:
;*image = COIL20(object, angle, [,/FLOAT] [,/NASE])
;
; INPUTS:
;  object:: Number of the object, ranging from 1 to 20.
;  angle :: Angle of the pose, given in deegrees. The value is <I>not</I>
;           restricted to the range [0, 360). Note that images are
;           available in steps of 5 degrees. The value given will be
;           appropriately rounded. 
;
; INPUT KEYWORDS:
;  FLOAT:: If this keyword is set, a float array containing values in
;          the range of [0.0, 1.0] will be returned, 0.0 corresponding to
;          black, 1.0 corresponding to white pixels.<BR>
;          If this keyword is not set (which is the default), a byte
;          array containing values in the range of [0, 255] will be
;          returned, 0 corresponding to black, 255 corresponding to
;          white pixels.
;
;  NASE :: Transpose array according to NASE array indexing
;          conventions: An image retrieved with <*>/NASE</*> set can directly
;          be passed through <A>Spassmacher()</A> and fed into a NASE
;          layer.
;
; OUTPUTS:
;  image:: A 128x128 array of byte values, or float values, if <*>/FLOAT</*>
;          was set.
;
; RESTRICTIONS:
;  The COIL-20 database needs to be installed in the local file system,
;  and the variable <*>!COILPATH</*> must point to its location.
;  The <*>!COILPATH</*> system variable is initialized to a value
;  suitable for use at location in Marburg, but can be user-adjusted.<BR>
;  The COIL-20 and COIL-100 databases can be obtained from
;  <A HREF=http://www.cs.columbia.edu/CAVE/>http://www.cs.columbia.edu/CAVE/</A>. 
;  See [1] for further details.
;
; PROCEDURE:
;  Compute filename, extract image from PPM file and return in array.
;
; EXAMPLE:
;*plottvscl, coil20(1,0), cubic=-0.5
;*for i=0,360,5 do plottvscl, coil20(1,i), cubic=-0.5, update_info=ui
;
; SEE ALSO:
;  <A>COIL100()</A>
;-

Function Coil20, object, angle, NASE=NASE, FLOAT=FLOAT

   assert, (object le 20) and (object gt 0), $
     "Object numbers must be in the range of [1, 20]."

   pose=fix(cyclic_value(round(angle/5.0),[0,72]))
   assert, (pose lt 72) and (pose ge 0)
   
   Read_PPM, $
     !COILPATH+!FILESEP+"coil-20"+!FILESEP+"processed_images"+!FILESEP+ $
     "obj"+str(object)+"__"+str(pose)+".pgm", $
     pic

   ;; we now that maxval is 255 in the COIL-100 database:
   If Keyword_Set(FLOAT) then pic=Temporary(pic)/255.0
     
   If Keyword_Set(NASE) then $
     return, rotate(pic, 4) $
   else return, rotate(pic, 7)
   
End
