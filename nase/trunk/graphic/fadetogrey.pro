;+
; NAME:
;  FadeToGrey()
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute greylevel image from an image file, or from truecolor
;  data stored in an IDL variable. 
;  
; PURPOSE:
;  This routine computes greylevel images from two possible sources:<BR>
;  1. From an image file of any type <C>Query_Image</C>, <C>Read_Image</C> and
;  <C>Write_Image</C> support (see IDL help).<BR>
;  2. From a <*>3</*> x <*>n</*> x <*>m</*> numeric array containing
;  truecolor data.<BR>
;  It returns a twodimensional (<*>n</*> x <*>m</*>) array containing
;  greylevel values, according to the Y channel of the YIC color
;  model (see <A>New_Color_Convert</A>).<BR>
;  If data was read from an image file, the greylevel data can be
;  rewritten as a file of the same type and format, with a linearly sorted greyscale
;  colormap. This allows using <C>Read_Image</C> on the new file and use
;  the result as greyscale image, whithout bothering for the color
;  map. Note that this procedure may also be used to sort the colormap
;  of a greyscale image file with an unsorted colormap.
;
; CATEGORY:
;  Color
;  Image
;  IO
;
; CALLING SEQUENCE:
;*result = FadeToGrey(imagefilename ,[/NOSAVE])
;*result = FadeToGrey(truecolor_array)
;
; INPUTS:
;  imagefilename:: image file of any type <C>Query_Image</C>, <C>Read_Image</C> and
;                  <C>Write_Image</C> support.
;  truecolor_array:: A <*>3</*> x <*>n</*> x <*>m</*> numeric array containing
;                    truecolor data. Data range is <I>not</I>
;                    restricted to bytes. Output data will be of the
;                    same numeric type as input data.
;
; INPUT KEYWORDS:
;  NOSAVE:: In case of file-input, setting this keyword prevents the
;           greyscale data from being written to an image file with a
;           sorted greyscale colormap. If this keyword is not set,
;           the result will be written to the file
;           <*>imagefilename_greyscale.ext</*> (respective extension).
;
; OUTPUTS:
;  result:: Two-dimensional numerical array containing the greylevel
;           data. Output data type will be the same as input data
;           type. (In case of file-input, this means type BYTE).
;
; OPTIONAL OUTPUTS:
;  If keyword <*>NOSAVE</*> was not set, the result will be written to
;  an image file with a sorted greyscale colormap.
;  This allows using <C>Read_Image</C> on the new file and use
;  the result as greyscale image, whithout bothering for the color
;  map. Note that this procedure may also be used to sort the colormap
;  of a greyscale image file with an unsorted colormap.
;  Output filename will be <*>imagefilename_greyscale.ext</*> (respective extension).
;
; SIDE EFFECTS:
;  If keyword <*>NOSAVE</*> was not set, the result will be written to
;  an image file with a sorted greyscale colormap.
;  Output filename will be <*>imagefilename_greyscale.ext</*> (respective extension).
;
; RESTRICTIONS:
;  Input image filetype must be supported by IDL's <C>Query_Image</C>, <C>Read_Image</C> and
;  <C>Write_Image</C>.
;
; PROCEDURE:
;  For file input:<BR>
;  1. read bitmap and colortable.<BR>
;  2. Convert RGB colormodel to YIC (created for transition form b/w
;  to color-tv, according to Manfred Sommer :-) ). See
;  <A>New_Color_Convert</A>.<BR>
;  3. Optional Write_Image with a linear colormap.<BR>
;  4. return result.<BR>
;  For array input, only steps 2. and 4. are performed.
;
; EXAMPLE:
;  Reading a color-bmp while ignoring colortable (looking strange):
;*bitmap=Read_BMP(Getenv('NASEPATH')+'/graphic/alison.bmp')
;*UTV, bitmap
;
;  Reading a color-bmp whith colortable:
;*bitmap=Read_BMP(Getenv('NASEPATH')+'/graphic/alison.bmp', r,g,b)
;*UTVlct, R,G,B, /OVER
;*UTV, bitmap
;
;  Using the great <C>FadeToGrey()</C> function:
;*ULoadCt, 0
;*bitmap=fadetogrey(Getenv('NASEPATH')+'/graphic/alison.bmp')
;*UTV, bitmap
;
;  Now we can simply use Read_BMP on the sorted image!
;*bitmap=Read_BMP(Getenv('NASEPATH')+'/graphic/alison_greyscale.bmp')
;*UTV, bitmap
;
;  Example for operation on array:
;*plot, indgen(10),color=rgb("green")
;*a=tvrd(/true)
;*erase
;*tvscl,a,/true
;*utvscl,fadetogrey(a)
;
; SEE ALSO:
;  IDL's <C>Query_Image</C>, <C>Read_Image</C> and <C>Write_Image</C>, <A>New_Color_Convert</A>.
;-

Function FadeToGrey_True, pic
   assert, Size(pic, /N_Dimensions) eq 3, $
     "Argument must be a Truecolor picture, i.e. a 3-element-array " + $
     "with the first dimension==3."
   assert, (Size(pic, /Dimensions))[0] eq 3, $
     "Argument must be a Truecolor picture, i.e. a 3-element-array " + $
     "with the first dimension==3."
   
   dims = Size(pic, /Dimensions)
   n_pixels = Product(dims[1:2])
   
   New_Color_Convert, $
     reform(pic[0,*,*], n_pixels), $
     reform(pic[1,*,*], n_pixels), $
     reform(pic[2,*,*], n_pixels), $
     y, i, c, /RGB_YIC
   
   return, reform(y, dims[1:2], /overwrite)
End


FUNCTION FadeToGrey, filename, NOSAVE=nosave

   If size(filename, /tname) ne "STRING" then begin
      ;; argument "filename" is a true color array:
      
      return, FadeToGrey_True(filename)


   endif else begin
      ;; argument "filename" is an image file:
      
      assert, size(filename, /tname) eq "STRING"
      sepfilename = Str_Sep(filename, '.')
      filenameparts = N_Elements(sepfilename)
      
      IF filenameparts EQ 1 THEN BEGIN
         loadfilename = filename
         savefilename = filename+'_greyscale'
      ENDIF ELSE BEGIN
            loadfilename = filename
            savefilename = sepfilename[filenameparts-2]+'_greyscale'+'.'+sepfilename[filenameparts-1]
      ENDELSE
      
      dummy = Query_Image(loadfilename, info)
      bitmap = Read_Image(loadfilename, r, g, b)
      
      if info.CHANNELS eq 3 then begin
         ;; it's a trucolor pic:
         bitmap = FadeToGrey_True(temporary(bitmap))
      endif
      if info.HAS_PALETTE then begin
         ;; it's a coloured palette pic:
         New_Color_Convert, r, g, b, y, i, c, /RGB_YIC
         bitmap = y(Temporary(bitmap))
      endif

      If not Keyword_Set(NOSAVE) then begin
         Write_Image, savefilename, info.type, bitmap 
         ;; we specify no colormap: IDL assumes grey ramp.
         Console, 'Wrote new file '+savefilename, /MSG
      EndIf


      RETURN, bitmap

   endelse

END
