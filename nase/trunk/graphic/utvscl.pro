;+
; NAME:               UTvScl
;
; PURPOSE:            Ersetzt TvScl und hat folgende tolle, neue Features:
;                         + Device-unabhaegige Darstellung
;                         + Positionierung in Normalkoordinaten
;                         + Vergroesserung via STRETCH
;                     UTvScl gibt (fuer UTvScl) unbekannte Optionen an
;                     TvScl weiter, z.B. /ORDER
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   UTvScl, Image [,XNorm [,YNorm [,Dimension]]] [,/CENTER]
;                             [,X_SIZE=x_size | ,NORM_X_SIZE] [,Y_SIZE=y_size | ,NORM_Y_SIZE]
;                             [,STRETCH=stretch] [,H_STRETCH=h_stretch] [,V_STRETCH=v_stretch]
;                             [,/NOSCALE] [,DIMENSIONS=dimensions] [,/DEVICE]
;
; INPUTS:             image: ein ein- oder zweidimensionales Array
;
; OPTIONAL INPUTS:    XNorm, YNORM: linke untere Ecke der Bildposition in Normalkoordinaten (Def.: 0.0)
;                                   bzw. Mitte des Bildes mit Keyword /CENTER (dann ist Def.: 0.5)
;                                   ;wird nur XNorm angegeben werden die Bilder entsprechend dem Wert
;                                   von XNorm nebeneinander positioniert, siehe Docu von TV
; OPTIONAL OUTPUTS:   Dimension : die Darstellungsparameter werden in Normal-Koordinaten zurueckgegeben: 
;                                 (xpos, ypos, xsize, ysize)
;                                 Dabei gegen xpos und ypos immer die linke untere Ecke an (auch bei
;                                 gesetztem CENTER-Keyword)
;                         
;
; KEYWORD PARAMETERS: CENTER    : Bild wird an den angegebenen Koordinaten zentriert ausgerichtet
;                     X_SIZE    ,
;                     Y_SIZE    : Es kann die gewuenschte Groesse des Bildes in CM angegeben werden,
;                                 wobei 1cm 40 Pixeln entspricht. Wird nur einer der beiden Parameter
;                                 angegeben, so wird der andere so gewaehlt, dass keine Verzerrungen
;                                 auftreten. Achtung, die Stretch-Keywords koennen die endgueltige
;                                 Groesse noch veraendern, daher besser nicht zusammen verwenden.
;                 NORM_X/Y_SIZE : Wie X/Y_SIZE nur in Normalkoordinaten.
;                     STRETCH   : Vergroessert bzw. verkleinert das Originalbild um Faktor
;                     H_STRETCH ,
;                     V_STRETCH : Das Bild kann mit diesen Parametern verzerrt werden. Alle 3 STRETCH
;                                 Parameter koennen gleichzeitig angegeben werden
;                     NOSCALE   : Das Bild wird analog zu TV nicht skaliert
;                     DIMENSIONS: wird dem Keyword Dimensions eine definierte Variable uebergeben
;                                 (egal welchen Typs), werden die Darstellungsparameter in Normal-
;                                 Koordinaten zurueckgegeben: (xpos, ypos, xsize, ysize)
;                                 Dabei gegen xpos und ypos immer die linke untere Ecke an (auch bei
;                                 gesetztem CENTER-Keyword)
;                     DEVICE    : falls gesetzt werden [XY]Norm als Device-Koordinaten ausgewertet. Eigentlich
;                                 sollte das Ding nicht benutzt werden, da der Witz von UTvScl ja gerade
;                                 die Deviceunabhaegigkeit ist.
;                     
; RESTRICTIONS:       Arbeitet nicht ganz korrekt mit einer Shared-8Bit-Color-Table
;                
; EXAMPLE:
;          bild = FIndgen(100,100)
;          ULoadCt, 5
;          UTvScl, bild
;          UTVScl, bild, /CENTER, STRETCH=2.0
;          UTvScl, bild, 0.8, 0.8, /CENTER, STRETCH=0.5, H_STRETCH=2.0
;          UTvScl, bild, /CENTER, XSIZE=5  ; erzeugt 5cm langes Bild auf PS und 200 Pixel auf Screen
;
; SEE ALSO:           <A HREF="#UTV">UTv</A>
; 
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.21  1998/04/09 12:21:50  saam
;           first argument is not changed any more
;
;     Revision 2.20  1998/03/21 16:27:44  saam
;           now handles array of types like (1,m,n)
;
;     Revision 2.19  1998/03/14 17:34:52  saam
;           new Keywords [XY]_SIZE_NORM blocked the use of [XY]_SIZE
;           because of ambiguous keyword abbreviation, therefore
;           renamed it to NORM_[XY]_SIZE
;
;     Revision 2.18  1998/03/12 19:44:08  kupper
;            X/Y_SIZE_NORM-Keywords hinzugefügt.
;
;     Revision 2.17  1998/02/27 13:28:51  saam
;           verbesserte Implementierung der DEVICE section
;
;     Revision 2.16  1998/02/27 13:07:13  saam
;           Keyword DEVICE hinzugefuegt
;
;     Revision 2.15  1998/01/06 13:27:09  saam
;           fktioniert jetzt auch mit 1-d Arrays
;
;     Revision 2.14  1997/12/17 15:28:58  saam
;           Ergaenzung um optionalen Output Dimension
;
;     Revision 2.13  1997/12/17 14:47:18  saam
;          reden wir nicht davon
;
;     Revision 2.12  1997/12/17 14:41:58  saam
;           Wieder mal ein Bug bei den HREFs
;
;     Revision 2.11  1997/12/17 14:38:22  saam
;           Header geupdated
;
;     Revision 2.10  1997/12/17 14:26:00  saam
;           Keyword NOSCALE hinzugefuegt
;
;     Revision 2.9  1997/11/14 16:10:03  saam
;           Header ergaenzt
;
;     Revision 2.8  1997/11/13 13:15:41  saam
;           Device Null wird unterstuetzt
;
;     Revision 2.7  1997/11/12 15:00:38  saam
;           Keywords X_SIZE und Y_SIZE fktionierten fuer
;           Fenster nicht richtig
;
;     Revision 2.6  1997/11/07 16:10:48  saam
;          Doku ergaenzt
;
;     Revision 2.5  1997/11/07 16:08:11  saam
;           das Pos-Argument scheint zu fktionieren
;
;     Revision 2.4  1997/11/07 15:56:08  saam
;         Beginn des Einfuegens des Pos-Arguments
;
;     Revision 2.3  1997/11/06 18:47:17  saam
;           Keyword X_Size und Y_Size hinzugefuegt
;
;     Revision 2.2  1997/11/06 15:22:26  saam
;           schaut nicht zu viel TV, UTvScl ist besser
;
;
;-
PRO UTvScl, __Image, XNorm, YNorm, Dimension $
            , CENTER=center $
            , STRETCH=stretch, V_STRETCH=v_stretch, H_STRETCH=h_stretch $
            , X_SIZE=x_size, Y_SIZE=y_size $
            , NORM_X_SIZE=norm_x_size, NORM_Y_SIZE=norm_y_size $
            , DIMENSIONS=dimensions $
            , NOSCALE=noscale $
            , DEVICE=device $
            , _EXTRA=e

   IF !D.Name EQ 'NULL' THEN RETURN
   _Image = __Image

   IF N_Params() LT 1 THEN Message, 'argument expected'
   IF (Size(_Image))(0) GT 2 THEN BEGIN
      _Image = Reform(_Image)
      IF (Size(_Image))(0) GT 2 THEN Message, 'array has more than 2 effective dimensions'
   END
   IF (Size(_Image))(0) NE 1 AND (Size(_Image))(0) NE 2 THEN Message, 'array with one or two dimensions expected'
   IF N_Params() LT 3 AND     Keyword_Set(CENTER) THEN YNorm = 0.5
   IF N_Params() LT 3 AND NOT Keyword_Set(CENTER) THEN YNorm = 0.0
   IF N_Params() LT 2 AND     Keyword_Set(CENTER) THEN XNorm = 0.5
   IF N_Params() LT 2 AND NOT Keyword_Set(CENTER) THEN XNorm = 0.0
   
   Default, stretch  , 1.0
   Default, v_stretch, 1.0
   Default, h_stretch, 1.0
   Default, centi    , 1   ; default is to TV with centimeters (disabled with DEVICE Keyword)

   If Set(NORM_X_SIZE) then X_SIZE = (NORM_X_SIZE * !D.X_Size / !D.X_PX_CM)
   If Set(NORM_Y_SIZE) then Y_SIZE = (NORM_Y_SIZE * !D.Y_Size / !D.Y_PX_CM)


   ; don't modify the original image
   Image = _Image
   IF (Size(Image))(0) EQ 1 THEN Image = Reform(Image, N_Elements(Image), 1)

   ; 40 Pixels are One-Centimeter
   ; size in Centimeters
   IF Keyword_Set(X_SIZE) AND Keyword_Set(Y_SIZE) THEN BEGIN
      xsize = FLOAT(x_size)
      ysize = FLOAT(y_size)
   END ELSE BEGIN
      IF Keyword_Set(X_SIZE) THEN BEGIN
         xsize = FLOAT(x_size)
         ysize = x_size*(((SIZE(Image))(2))/FLOAT((SIZE(Image))(1)))
      END ELSE IF Keyword_Set(Y_SIZE) THEN BEGIN
         ysize = FLOAT(y_size)
         xsize = y_size*(((SIZE(Image))(1))/FLOAT((SIZE(Image))(2)))
      END ELSE BEGIN
         xsize = (SIZE(Image))(1)/40.
         ysize = (SIZE(Image))(2)/40.
      END
   END
   xsize = xsize*stretch*h_stretch
   ysize = ysize*stretch*v_stretch

   ; pos in Centimeters
   IF Keyword_Set(DEVICE) THEN BEGIN
      centi =  0
      xpos = xnorm
      ypos = ynorm
   END ELSE BEGIN
      xpos = (xnorm * !D.X_Size / !D.X_PX_CM)
      ypos = (ynorm * !D.Y_Size / !D.Y_PX_CM)
   END
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
      IF N_Params() EQ 2 THEN BEGIN; position implicitely
         IF Keyword_Set(NOSCALE) THEN BEGIN
            TV, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e 
         END ELSE BEGIN
            TVScl, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
         END
      END ELSE BEGIN
         IF Keyword_Set(NOSCALE) THEN BEGIN
            TV, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
         END ELSE BEGIN
            TVScl, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
         END
      END

   END ELSE BEGIN ; it is a WINDOW
      IF Set(STRETCH) OR Set(V_STRETCH) OR Set(H_STRETCH) OR Set(X_SIZE) OR Set(Y_SIZE) THEN Image = Congrid(Image, xsize*!D.X_PX_CM, ysize*!D.Y_PX_CM)
      Device, BYPASS_TRANSLATION=0
      IF N_Params() EQ 2 THEN BEGIN; position implicitely
         IF Keyword_Set(NOSCALE) THEN BEGIN
            TV, Image, xnorm, CENTIMETERS=centi, _EXTRA=e
         END ELSE BEGIN
            TVScl, Image, xnorm, CENTIMETERS=centi, _EXTRA=e
         END
      END ELSE BEGIN
         IF Keyword_Set(NOSCALE) THEN BEGIN
            TV, Image, xpos, ypos, CENTIMETERS=centi, _EXTRA=e
         END ELSE BEGIN
            TVScl, Image, xpos, ypos, CENTIMETERS=centi, _EXTRA=e
         END
      END
      Device, /BYPASS_TRANSLATION
   END

   IF Set(Dimensions) THEN dimensions = [xpos*!D.X_PX_CM/FLOAT(!D.X_Size), ypos*!D.Y_PX_CM/FLOAT(!D.Y_SIZE), $
                                         xsize*!D.X_PX_CM/FLOAT(!D.X_Size), ysize*!D.Y_PX_CM/FLOAT(!D.Y_SIZE)]
   IF N_Params() EQ 4 THEN dimension = [xpos*!D.X_PX_CM/FLOAT(!D.X_Size), ypos*!D.Y_PX_CM/FLOAT(!D.Y_SIZE), $
                                         xsize*!D.X_PX_CM/FLOAT(!D.X_Size), ysize*!D.Y_PX_CM/FLOAT(!D.Y_SIZE)]

END


