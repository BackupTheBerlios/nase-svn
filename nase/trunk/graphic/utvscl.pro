;+
; NAME:               UTvScl
;
; PURPOSE:            Ersetzt TvScl und hat folgende tolle, neue Features:
;                         + Device-unabhaegige Darstellung
;                         + Positionierung in Normalkoordinaten
;                         + Vergroesserung via STRETCH
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   UTvScl, Image [,XNorm] [,YNorm] [,/CENTER]
;                             [,STRETCH=stretch] [,H_STRETCH=h_stretch] [,V_STRETCH=v_stretch]
;                             [,DIMENSIONS=dimensions]
;
; INPUTS:             image: ein zweidimensionales Array
;
; OPTIONAL INPUTS:    XNorm, YNORM: linke untere Ecke der Bildposition in Normalkoordinaten (Def.: 0.0)
;                                   bzw. Mitte des Bildes mit Keyword /CENTER (dann ist Def.: 0.5)
;
; KEYWORD PARAMETERS: CENTER    : Bild wird an den angegebenen Koordinaten zentriert ausgerichtet
;                     STRETCH   : Vergroessert bzw. verkleinert das Originalbild um Faktor
;                     H_STRETCH ,
;                     V_STRETCH : Das Bild kann mit diesen Parametern verzerrt werden. Alle 3 STRETCH
;                                 Parameter koennen gleichzeitig angegeben werden
;                     DIMENSIONS: wird dem Keyword Dimensions eine definierte Variable uebergeben
;                                 (egal welchen Typs), werden die Darstellungsparameter in Normal-
;                                 Koordinaten zurueckgegeben: (xpos, ypos, xsize, ysize)
;                                 Dabei gegen xpos und ypos immer die linke untere Ecke an (auch bei
;                                 gesetztem CENTER-Keyword)
;                     
; EXAMPLE:
;          bild = FIndgen(100,100)
;          ULoadCt, 5
;          UTvScl, bild
;          UTVScl, bild, /CENTER, STRETCH=2.0
;          UTvScl, bild, 0.8, 0.8, /CENTER, STRETCH=0.5, H_STRETCH=2.0
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.2  1997/11/06 15:22:26  saam
;           schaut nicht zu viel TV, UTvScl ist besser
;
;
;-
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
      ; flip array-values if wanted because B/W-Postcript doesn't use colortables
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

   IF Set(Dimensions) THEN dimensions = [xpos*!D.X_PX_CM/FLOAT(!D.X_Size), ypos*!D.Y_PX_CM/FLOAT(!D.Y_SIZE), $
                                         xsize*!D.X_PX_CM/FLOAT(!D.X_Size), ysize*!D.Y_PX_CM/FLOAT(!D.Y_SIZE)]
   
END


