;+
; NAME:
;  Read_Image_as_True()
;
; VERSION:
;  $Id$
;
; AIM:
;  Same as IDL's READ_IMAGE, but always returns data in truecolor format.
;
; PURPOSE:
;  IDL's </C>READ_IMAGE()<C> yields different results for 8-bit
;  (paletted) and 24-bit (Truecolor) images, depending on the image
;  file. The user has to call </C>QUERY_IMAGE()<C> in order to
;  determine, what a call to </C>READ_IMAGE()<C> will return. For the
;  use of displaying the image, it is well sensible to return data in
;  whatever format it has been saved (paletted or truecolor), but for
;  computational aspects, the user often does not want to care for the
;  data format (paletted or not), and just get standard truecolor,
;  24-bit data. This is exactly what this routine will produce. The
;  result will always be a [3, n, m] array. The bit-depth will be
;  converted to Bytes (i.e. 3 x 8 = 24 bits). The routine will issue a
;  warning message if the bit-depth of the file data was different
;  from Byte.<BR>
;  This routine also corretcs the completely stupid bug in <C>IDL's
;  READ_PPM</C> routine, that reads all pictues bottom-up. This guys
;  at RSI are not worth their money.
;
;
; CATEGORY:
;  Image
;
; CALLING SEQUENCE:
;*result = Read_Image_as_True( filename [, IMAGE_INDEX=index] )
;
; INPUTS:
;  filename:: the image filename (including suffix).
;
; INPUT KEYWORDS:
;  IMAGE_INDEX:: Set this keyword to the index of the image to read
;                from the file. The default is 0, the first image.
;  
;
; OUTPUTS:
;  result:: Image data as [3, n, m] truecolor data. Bit depth will be
;           converted to Bytes (i.e. 3 x 8 = 24 bits). The routine
;           will issue a warning message if the bit-depth of the file
;           data was different from Byte.
;
; PROCEDURE:
;  
;
; EXAMPLE:
;*
;*> i=read_image_as_true(!NASEPATH+"/graphic/alison.bmp")
;*> tv, i, /true
;*> i=read_image_as_true(!NASEPATH+"/graphic/alison_greyscale.bmp")
;*> tv, i, /true
;
; SEE ALSO:
;  IDL's <C>READ_IMAGE()</C> and <C>QUERY_IMAGE()</C>.
;-

Function Read_Image_as_True, filename, IMAGE_INDEX=IMAGE_INDEX

      dummy = Query_Image(filename, info)
      bitmap = Read_Image(filename, r, g, b)
      
      if info.CHANNELS eq 3 then begin
         ;; it's already a truecolor pic:
         result = temporary(bitmap)
      endif

      if info.HAS_PALETTE then begin
         ;; it's a coloured palette pic. Blow it up!
         assert, (info.CHANNELS eq 1), $
                 "Image has palette, but more than one channel ("+str(info.CHANNELS)+"). Don't know what " + $
                 "to do!"
         result = make_array(dimension=[3, info.DIMENSIONS], $
                             type=info.PIXEL_TYPE, /Nozero)
         result[0, *, *] = r[bitmap]
         result[1, *, *] = g[bitmap]
         result[2, *, *] = b[temporary(bitmap)]
      endif
  
      ;; convert to Byte of not already:
      if info.PIXEL_TYPE ne 1 then begin
         console, /Warning, "Original bit depth was not 8bit/channel " + $
                  "(Byte), but PIXEL_TYPE is "+str(info.PIXEL_TYPE)+" " + $
                  "("+typeof(make_array(1, type=info.PIXEL_TYPE))+")"
         result = byte( temporary(result)*255.0 / $
                        (typerange(info.PIXEL_TYPE))[1] )
      endif

      ;; correct a bug in IDL's READ_PGM routine. It reads all images
      ;; updaide down. What does RSI do, hire a bunch of stupid
      ;; students as implementors or what? How can such a bug ever
      ;; have passed even the simplest betatesting??
      if (info.TYPE eq "PGM") or (info.TYPE eq "PPM") then begin
         result = reverse(result, 3, /overwrite)
      endif

      return, result
End
