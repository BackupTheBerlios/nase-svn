PRO UTvScl, _Image, XNorm, YNorm $
            , CENTER=center $
            , STRETCH=stretch, V_STRETCH=v_stretch, H_STRETCH=h_stretch $
            , DIMENSIONS=dimensions $
            , _EXTRA=e

   IF N_Params() LT 1 THEN Message, 'argument expected'
   IF (Size(_Image))(0) NE 2 THEN Message, 'two dimensional array expected'
   IF N_Params() LT 3 AND     Keyword_Set(CENTER) THEN YNorm = 0.5
   IF N_Params() LT 3 AND NOT Keyword_Set(CENTER) THEN YNorm = 0.0
   IF N_Params() LT 2 AND     Keyword_Set(CENTER) THEN XNorm = 0.5
   IF N_Params() LT 2 AND NOT Keyword_Set(CENTER) THEN XNorm = 0.0
   
   Default, stretch  , 1.0
   Default, v_stretch, 1.0
   Default, h_stretch, 1.0
   
   ; don't modify the original image
   Image = _Image

   ; 40 Pixels are One-Centimeter
   ; size in Centimeters
   xsize =  (SIZE(Image))(1)/40.*stretch*h_stretch
   ysize =  (SIZE(Image))(2)/40.*stretch*v_stretch 
      
   ; pos in Centimeters
   xpos = (xnorm * !D.X_Size / !D.X_PX_CM)
   ypos = (ynorm * !D.Y_Size / !D.Y_PX_CM)
   IF Keyword_Set(CENTER) THEN BEGIN
      xpos = xpos - xsize/2.
      ypos = ypos - ysize/2.
   END

   IF !D.Name EQ 'PS' THEN BEGIN ; a Postscript-Device
      ; flip array-values because B/W-Postcript doesn't use colortables
      IF !REVERTPSCOLORS THEN BEGIN
         MinPix = MIN(Image)
         MaxPix = MAX(Image)
         Image = MaxPix - Image 
      END
      TVScl, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, /CENTIMETERS, _EXTRA=e

   END ELSE BEGIN ; it is a WINDOW
      IF Set(STRETCH) OR Set(V_STRETCH) OR Set(H_STRETCH) THEN Image = Congrid(Image, xsize*!D.X_PX_CM, ysize*!D.Y_PX_CM)
      Device, BYPASS_TRANSLATION=0
      TVScl, Image, xpos, ypos, /CENTIMETERS, _EXTRA=e
      Device, /BYPASS_TRANSLATION
   END

   IF Set(Dimensions) THEN dimensions = [xpos, ypos, xsize, ysize]
   
END


