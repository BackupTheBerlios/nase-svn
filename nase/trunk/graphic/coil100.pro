;+
; NAME:
;  COIL100()
;
; VERSION:
;  $Id$
;
; AIM:
;  Load an image from the COIL-100 database.
;
; PURPOSE:
;  This function returns a 128x128 pixel color or greyscale image,
;  taken from the Columbia Object Image Library COIL-100 [1]. This
;  database contains color images of 100 single objects against a black
;  background, rotated in depth at pose intervals of 5 degrees. Images
;  are normalized to size and color range. Object number and rotation
;  angle are supplied as positional parameters to
;  <C>COIL100()</C>.<BR><BR>
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
;*image = COIL100(object, angle, [,/GREY] [,/FLOAT] [,/NASE])
;
; INPUTS:
;  object:: Number of the object, ranging from 1 to 100.
;  angle :: Angle of the pose, given in degrees. The value is <I>not</I>
;           restricted to the range [0, 360). Note that images are
;           available in steps of 5 degrees. The value given will be
;           appropriately rounded. 
;
; INPUT KEYWORDS:
;  GREY :: If this keyword is set, images are converted to greyscale
;          using the <A>FadeToGrey()</A> function. The result will be
;          a 128x128 array.<BR>
;          If this keyword is not set (which is the default), a
;          3x128x128 array containing the red, green and blue values
;          is returned.
;
;  FLOAT:: If this keyword is set, a float array containing values in
;          the range of [0.0, 1.0] will be returned, 0.0 corresponding to
;          black, 1.0 corresponding to white (or maximum color)
;          pixels.<BR>
;          If this keyword is not set (which is the default), an
;          unsigned integer array containing values in the range of
;          [0, 65535] will be returned, 0 corresponding to black, 255
;          corresponding to white (or maximum color) pixels. (Note
;          that the database uses the somewhat unusual format of
;          16-bit values for each color channel.)
;
;  NASE :: Transpose array according to NASE array indexing
;          conventions: An image retrieved with <*>/NASE</*> and
;          <*>/GREY</*> set can directly be passed through
;          <A>Spassmacher()</A> and fed into a NASE layer.
;
; OUTPUTS:
;  image:: A 3x128x128 array containing the red, green and blue values
;          of the color image, or a 128x128 array containing greyscale
;          values, if <*>/GREY</*> was set.<BR>
;          The array will be of type unsigned integer (16-bit for each
;          color channel), or of type float, if <*>/FLOAT</*> was set.
;
; RESTRICTIONS:
;  The COIL-100 database needs to be installed in the local file system,
;  and the variable <*>!COILPATH</*> must point to its location. (The
;  actual *.ppm files are expected to be found in directory
;  <*>!COILPATH/coil-100</*>, which accords to the directory
;  structure in which the database comes when downloaded.)<BR>
;  The <*>!COILPATH</*> system variable is initialized to a value
;  suitable for use at location in Marburg, but can be user-adjusted.<BR>
;  The COIL-20 and COIL-100 databases can be obtained from
;  <I>http://www.cs.columbia.edu/CAVE/</I>.
;  See [1] for further details.
;
; PROCEDURE:
;  Compute filename, extract image from PPM file, fade-to-grey if
;  necessary, and return in array.
;
; EXAMPLE:
;*plottvscl, coil100(1,0), cubic=-0.5
;*for i=0,360,5 do plottvscl, coil100(1,i), cubic=-0.5, update_info=ui
;
; SEE ALSO:
;  <A>COIL20(), FadeToGrey()</A>
;-

Function Coil100, object, angle, NASE=NASE, FLOAT=FLOAT, GREY=GREY

   assert, (object le 100) and (object gt 0), $
     "Object numbers must be in the range of [1, 100]."

   pose=fix(cyclic_value(round(angle/5.0),[0,72]))
   assert, (pose lt 72) and (pose ge 0)
   pose=pose*5


   Read_PPM2, $
     !COILPATH+!FILESEP+"coil-100"+!FILESEP+ $
     "obj"+str(object)+"__"+str(pose)+".ppm", $
     pic

   ;; we now that maxval is 65535 in the COIL-100 database:
   If Keyword_Set(FLOAT) then pic=Temporary(pic)/65535.0
     


   If Keyword_Set(GREY) then begin 

      pic = FadeToGrey(Temporary(pic))
      If Not Keyword_Set(FLOAT) then pic = UInt(Temporary(pic))

      If Keyword_Set(NASE) then $
        return, rotate(pic, 4) $
      else return, rotate(pic, 7)

   endif else begin             ; Keyw. GREY not set:
      
      If Keyword_Set(NASE) then begin
         ;;Sorry, we can't do this with a TEMPORARY:
         for channel=0,2 do pic[channel,*,*] = $
           rotate(reform(pic[channel,*,*]), 4)
         return, pic
      endif

      ;; no NASE
      ;;Sorry, we can't do this with a TEMPORARY:
      for channel=0,2 do pic[channel,*,*] = $
        rotate(reform(pic[channel,*,*]), 7)
      
   endelse
   return, pic
   
End
