;+
; NAME:
;  FadeToGrey()  [without .pro!]
;
; VERSION:
;  $Id$
;
; AIM:
;  Compute greylevel image from a *.bmp-file, or from truecolor
;  data stored in an IDL variable. 
;  
; PURPOSE:
;  This routine computes greylevel images from two possible sources:<BR>
;  1. From a *.bmp (indexed color table) file.<BR>
;  2. From a <*>3</*> x <*>n</*> x <*>m</*> numeric array containing
;  truecolor data.<BR>
;  It returns a twodimensional (<*>n</*> x <*>m</*>) array containing
;  greylevel values, according to the Y channel of the YIC color
;  model (see <A>New_Color_Convert</A>).<BR>
;  If data was read from a *.bmp-file, the greylevel data can be
;  rewritten in a *.bmp-file with a linearly sorted greyscale
;  colormap. This allows using <C>Read_BMP</C> on the new file and use
;  the result as greyscale image, whithout bothering for the color
;  map. Note that this procedure may also be used to sort the colormap
;  of a greyscale *.bmp-file with an unsorted colormap.
;
; CATEGORY:
;  Color
;  Image
;  IO
;
; CALLING SEQUENCE:
;*result = FadeToGrey(bmpfilename ,[/NOSAVE])
;*result = FadeToGrey(truecolor_array)
;
; INPUTS:
;  bmpfilename:: An 8-bit *.bmp file. (Extension <*>.bmp</*> will be added if
;                omitted).
;  truecolor_array:: A <*>3</*> x <*>n</*> x <*>m</*> numeric array containing
;                    truecolor data. Data range is <I>not</I>
;                    restricted to bytes. Output data will be of the
;                    same numeric type as input data.
;
; INPUT KEYWORDS:
;  NOSAVE:: In case of file-input, setting this keyword prevents the
;           greyscale data from being written to a *.bmp file with a
;           sorted greyscale colormap. If this keyword is not set,
;           the result will be written to the file
;           <*>bmpfilename_greyscale.bmp</*>.
;
; OUTPUTS:
;  result:: Two-dimensional numerical array containing the greylevel
;           data. Output data type will be the same as input data
;           type. (In case of file-input, this means type BYTE).
;
; OPTIONAL OUTPUTS:
;  If keyword <*>NOSAVE</*> was not set, the result will be written to
;  a *.bmp file with a sorted greyscale colormap.
;  This allows using <C>Read_BMP</C> on the new file and use
;  the result as greyscale image, whithout bothering for the color
;  map. Note that this procedure may also be used to sort the colormap
;  of a greyscale *.bmp-file with an unsorted colormap.
;  Output filename will be <*>bmpfilename_greyscale.bmp</*>.
;
; SIDE EFFECTS:
;  If keyword <*>NOSAVE</*> was not set, the result will be written to
;  a *.bmp file with a sorted greyscale colormap.
;  Output filename will be <*>bmpfilename_greyscale.bmp</*>.
;
; RESTRICTIONS:
;  Input *.bmp files need to be of 8bit indexed colortable type.
;
; PROCEDURE:
;  For file input:<BR>
;  1. read bitmap and colortable.<BR>
;  2. Convert RGB colormodel to YIC (created for transition form b/w
;  to color-tv, according to Manfred Sommer :-) ). See
;  <A>New_Color_Convert</A>.<BR>
;  3. Optional Write_BMP with a linear colormap.<BR>
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
;  IDL's <C>Read_BMP</C> and <C>Write_BMP</C>, <A>New_Color_Convert</A>.
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
      ;; argument "filename" is a *.bmp-file:
      
      assert, size(filename, /tname) eq "STRING"
      sepfilename = Str_Sep(filename, '.')
      filenameparts = N_Elements(sepfilename)
      
      IF filenameparts EQ 1 THEN BEGIN
         loadfilename = filename+'.bmp'
         savefilename = filename+'_greyscale.bmp'
      ENDIF ELSE BEGIN
         IF sepfilename(filenameparts-1) EQ 'bmp' THEN BEGIN
            loadfilename = filename
            savefilename = StrMid(filename, 0, StrLen(filename)-4)+'_greyscale.bmp'
         ENDIF ELSE Message, 'Sorry, this seems to be no BMP-File.'
      ENDELSE
      
      bitmap = Read_Bmp(loadfilename, r, g, b)
      
      New_Color_Convert, r, g, b, y, i, c, /RGB_YIC
      
      bitmap = y(Temporary(bitmap))

      If not Keyword_Set(NOSAVE) then begin
         colortable = Indgen(256)
         Write_BMP, savefilename, bitmap, colortable, colortable, colortable
         Console, 'Wrote new Bitmap-File '+savefilename, /MSG
      EndIf


      RETURN, bitmap

   endelse

END
