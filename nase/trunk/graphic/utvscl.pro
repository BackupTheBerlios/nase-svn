;+
; NAME:               UTvScl
;
; VERSION: $Id$
;
; AIM:
;  Device independent, color coded display of two-dimensional array
;  contents.
;
; PURPOSE:            Ersetzt TvScl und hat folgende tolle, neue Features:
;*                         + Device-unabhaegige Darstellung
;*                         + Positionierung in Normalkoordinaten
;*                         + Vergroesserung via STRETCH
;                     UTvScl gibt (fuer UTvScl) unbekannte Optionen an
;                     TvScl weiter, z.B. /ORDER
;
; CATEGORY:           GRAPHIC
;
; CALLING SEQUENCE:   
;*                     UTvScl, Image [,XNorm [,YNorm [,Dimension]]] [,/CENTER]
;*                             [,X_SIZE=x_size | ,NORM_X_SIZE] [,Y_SIZE=y_size | ,NORM_Y_SIZE]
;*                             [,STRETCH=stretch] [,H_STRETCH=h_stretch] [,V_STRETCH=v_stretch]
;*                             [,/NOSCALE] [,DIMENSIONS=dimensions] [,/DEVICE]
;*                             [,CUBIC=cubic] [,/INTERP] [,/MINUS_ONE]
;
; INPUTS:             image:: ein ein- oder zweidimensionales Array
;
; OPTIONAL INPUTS:    XNorm, YNORM:: linke untere Ecke der Bildposition in Normalkoordinaten (Def.: 0.0)
;                                    bzw. Mitte des Bildes mit Keyword /CENTER (dann ist Def.: 0.5)
;                                    ;wird nur XNorm angegeben werden die Bilder entsprechend dem Wert
;                                    von XNorm nebeneinander positioniert, siehe Docu von TV
; OPTIONAL OUTPUTS:   Dimension::    die Darstellungsparameter werden in Normal-Koordinaten zurueckgegeben: 
;                                    (xpos, ypos, xsize, ysize)
;                                    Dabei gegen xpos und ypos immer die linke untere Ecke an (auch bei
;                                    gesetztem CENTER-Keyword)
;                         
;
; KEYWORD PARAMETERS: 
;              CENTER::              Bild wird an den angegebenen Koordinaten zentriert ausgerichtet
;              X_SIZE, Y_SIZE::      Es kann die gewuenschte Groesse des Bildes in CM angegeben werden,
;                                    wobei 1cm !D.PX_CM Pixeln entspricht. (40 für das X-Device.) Wird
;                                    nur einer der beiden Parameter angegeben, so wird der andere so
;                                    gewaehlt, dass keine Verzerrungen auftreten. Achtung, die
;                                    Stretch-Keywords koennen die endgueltige Groesse noch veraendern,
;                                    daher besser nicht zusammen verwenden.
;              NORM_X/Y_SIZE::       Wie X/Y_SIZE nur in Normalkoordinaten.
;              STRETCH::             Vergroessert bzw. verkleinert das Originalbild um Faktor
;              H_STRETCH,V_STRETCH:: Das Bild kann mit diesen Parametern verzerrt werden. Alle 3 STRETCH
;                                    Parameter koennen gleichzeitig angegeben werden
;              NOSCALE::             Das Bild wird analog zu TV nicht skaliert
;              DIMENSIONS::          wird dem Keyword Dimensions eine definierte Variable uebergeben
;                                    (egal welchen Typs), werden die Darstellungsparameter in Normal-
;                                    Koordinaten zurueckgegeben: (xpos, ypos, xsize, ysize)
;                                    Dabei gegen xpos und ypos immer die linke untere Ecke an (auch bei
;                                    gesetztem CENTER-Keyword)
;                     DEVICE::       falls gesetzt werden [XY]Norm als Device-Koordinaten ausgewertet. Eigentlich
;                                    sollte das Ding nicht benutzt werden, da der Witz von UTvScl ja gerade
;                                    die Deviceunabhaegigkeit ist.
;                     POLYGON::      Statt Pixel werden Polygone gezeichnet (Empfehlenswert bei Postscript-Ausgabe)  
;                     TOP::          es werden nur die Farbindices von 0..TOP belegt (siehe IDL5 Hilfe von TvSCL)
;       CUBIC, INTERP, MINUS_ONE::   werden an ConGrid uebergeben (s. IDL_Hilfe)
;                                    Man beachte, daß die Interpolation eines Arrays, das !NONE-Elemente enthält,
;                                    nicht sinnvoll ist! Die NONEs gehen i.d.R. durch die Interpolation veroren!
;
;                     
; RESTRICTIONS:       Arbeitet nicht ganz korrekt mit einer Shared-8Bit-Color-Table
;
;                     Man beachte, daß die Interpolation (Keyw. CUBIC oder INTERP) eines Arrays,
;                     das !NONE-Elemente enthält,
;                     nicht sinnvoll ist! Die NONEs gehen i.d.R. durch die Interpolation veroren!
;                
; EXAMPLE:
;*          bild = FIndgen(100,100)
;*          ULoadCt, 5
;*          UTvScl, bild
;*          UTVScl, bild, /CENTER, STRETCH=2.0
;*          UTvScl, bild, 0.8, 0.8, /CENTER, STRETCH=0.5, H_STRETCH=2.0
;*          UTvScl, bild, /CENTER, XSIZE=5  ; erzeugt 5cm langes Bild auf PS und 200 Pixel auf Screen
;
; SEE ALSO:           <A HREF="#UTV">UTv</A>
; 
;-



; Gibt ein auf die vorhandene Palettengroesse (bzw. auf 0..top falls top gesetzt)
; skalierte Version eines Arrays A zurueck
Function __ScaleArray, A, TOP=top

   Default, top, !D.TABLE_SIZE-1
   _top = top < (!D.TABLE_SIZE-1)
   Return, long(Scl(A, [0, _top]))

End




; TvSCL-Version die das TOP-Keyword richtig behandelt
PRO __HelpTvScl, A, p1, p2, _EXTRA=e

;   IF ExtraSet(e, 'TOP') THEN _A = __ScaleArray(A, TOP=e.top) ELSE _A = __ScaleArray(A)
;   DelTag, e, 'TOP'
;_A = A
; the lower routines then called tv, _a
   CASE N_Params() OF
      1: TVSCL, A, _EXTRA=e
      2: TVSCL, A, p1, _EXTRA = e
      3: TVSCL, A, p1, p2, _EXTRA=e
      ELSE: Message, 'something wrong in UTVSCL'
   END

END


;; plottet polygone statt pixel
PRO __multipolyplot ,A ,XNorm , Ynorm ,Xsize=X_size, ysize=y_size ,NOSCALE=NOSCALE ,DEVICE=DEVICE $
                     ,CENTIMETERS=centimeters , TOP=TOP ,ORDER=ORDER
   ON_ERROR, 2
   as = size(A)
   xsize = as(1)
   ysize = as(2)
   default,Xnorm,0
   default,Ynorm,0
   default,X_size,xsize
   default,Y_size,ysize
   default,noscale,0
   default,device,1
   default,centimeters,0 ;;dummy
   default,order,0
   IF  (NOSCALE EQ 1) THEN BEGIN
      ARRAY = A
   END ELSE BEGIN
      ARRAY = __ScaleArray(A, TOP=top)
      TVLCT,R,G,B,/GET   
   ENDELSE

   xpix = FLOAT(X_size)/FLOAT(xsize)
   ypix = FLOAT(Y_size)/FLOAT(ysize)

   IF  DEVICE EQ 1 THEN BEGIN
      X_PX_CM = !D.X_PX_CM
      Y_PX_CM = !D.Y_PX_CM
   END ELSE BEGIN
      X_PX_CM = 1.0
      Y_PX_CM = 1.0
   ENDELSE
   IF ORDER EQ 1 THEN BEGIN
      Y_START = ysize -1
      Y_END = 0
      Y_STEP =  -1
   END ELSE BEGIN
      Y_START = 0
      Y_END = ysize -1
      Y_STEP =  1
   ENDELSE
      FOR j = Y_START , Y_END,Y_STEP DO BEGIN
         FOR i = 0L , xsize -1 DO BEGIN
         x = [ i  , i + 1 , i + 1 , i  ] 
         y = [ Y_START +  Y_STEP * j  , Y_START +  Y_STEP *j   , Y_START +  Y_STEP *j + 1 , Y_START +  Y_STEP *j + 1 ]
         x(*) = (x(*)*xpix + Xnorm) * X_PX_CM
         y(*) = (y(*)*ypix + Ynorm) * Y_PX_CM
         
         IF  (NOSCALE EQ 1) THEN BEGIN
            polyfill,x,y,COLOR=ROUND(ARRAY(i,j)), /DEVICE 
          
           
         END ELSE BEGIN
           polyfill,x,y,COLOR=ROUND(ARRAY(i,j)), /DEVICE 
           colorindex = RGB(R(ARRAY(i,j)) ,G(ARRAY(i,j)) ,B(ARRAY(i,j)),/NOALLOC)
           polyfill,x,y,COLOR=colorindex ,/DEVICE
            
         ENDELSE
      ENDFOR
   ENDFOR
END
PRO UTvScl, __Image, XNorm, YNorm, Dimension $
            , CENTER=center $
            , STRETCH=stretch, V_STRETCH=v_stretch, H_STRETCH=h_stretch $
            , X_SIZE=x_size, Y_SIZE=y_size $
            , NORM_X_SIZE=norm_x_size, NORM_Y_SIZE=norm_y_size $
            , DIMENSIONS=dimensions $
            , NOSCALE=noscale $
            , DEVICE=device $
            , POLYGON=POLYGON $
            , CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one $
            , _EXTRA=e

   ON_ERROR, 2
   IF !D.Name EQ 'NULL' THEN RETURN


   ;; correct handling of top keyword;
   ;; NASE stanard is that TV and partners use the palette
   ;; only from 0..!TOPCOLOR, this is ensured here if nothing
   ;; else is specified
   IF NOT ExtraSet(E, 'TOP') THEN SetTag, E, "TOP", !TOPCOLOR


   ; don't modify the original image
   Image = __Image

   IF N_Params() LT 1 THEN Message, 'argument expected'
   IF (Size(Image))(0) GT 2 THEN BEGIN
      Image = Reform(Image, /OVERWRITE)
      IF (Size(Image))(0) GT 2 THEN Message, 'array has more than 2 effective dimensions'
   END
   IF (Size(Image))(0) NE 1 AND (Size(Image))(0) NE 2 THEN Message, 'array with one or two dimensions expected'
   IF N_Params() LT 3 AND     Keyword_Set(CENTER) THEN YNorm = 0.5
   IF N_Params() LT 3 AND NOT Keyword_Set(CENTER) THEN YNorm = 0.0
   IF N_Params() LT 2 AND     Keyword_Set(CENTER) THEN XNorm = 0.5
   IF N_Params() LT 2 AND NOT Keyword_Set(CENTER) THEN XNorm = 0.0
   
   Default, stretch  , 1.0
   Default, v_stretch, 1.0
   Default, h_stretch, 1.0
   Default, centi    , 1   ; default is to TV with centimeters (disabled with DEVICE Keyword)
   DEFAULT, POLYGON  , 0

   If Set(NORM_X_SIZE) then X_SIZE = (NORM_X_SIZE * !D.X_Size / !D.X_PX_CM)
   If Set(NORM_Y_SIZE) then Y_SIZE = (NORM_Y_SIZE * !D.Y_Size / !D.Y_PX_CM)


  IF (Size(Image))(0) EQ 1 THEN Image = Reform(/OVERWRITE, Image, N_Elements(Image), 1)

   ; !D.X_PX_CM Pixels are One Centimeter (40 for the X Device)
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
            IF !D.NAME EQ "PS" THEN BEGIN
               xsize = (SIZE(Image))(1)/40.
               ysize = (SIZE(Image))(2)/40.
            END ELSE begin 
               xsize = (SIZE(Image))(1)/!D.X_PX_CM
               ysize = (SIZE(Image))(2)/!D.Y_PX_CM
            ENDELSE
      END
   END
   ;;only hole pixels or points are allowed
   xsize = floor(xsize*stretch*h_stretch*!D.X_PX_CM)/!D.X_PX_CM
   ysize = floor(ysize*stretch*v_stretch*!D.Y_PX_CM)/!D.Y_PX_CM

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
   
   IF Set(STRETCH) OR Set(V_STRETCH) OR Set(H_STRETCH) OR Set(X_SIZE) OR Set(Y_SIZE) THEN begin
      im_max = max(Image)
      im_min = min(Image)
      IF !D.NAME EQ "PS" THEN begin
           ; a dot in postscript is 1/72 inch and 1 inch is approx. 2.54cm
           ; so we have a constant resolution for the bitmap 
          _smooth = 1./(2.54/72.)*[1, 1] 
      END ELSE BEGIN
          _smooth = [!D.X_PX_CM, !D.Y_PX_CM]
      END
      Image = Congrid(Image, (xsize*_smooth(0)) > 1, (ysize*_smooth(1)) > 1, $
                      CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one)

     ;;If CUBIC was used, the maximum or
      ;;minimum may have been changed by
      ;;congrid. This may produce color
      ;;artefacts. So rescale to have the
      ;;same min and max as before:
      If Keyword_Set(CUBIC) then begin
         Image = Image-min(Image)
         Image = Image/float(max(Image))*(im_max-im_min)
         Image = Image+im_min
      EndIf
   EndIf
   IF !D.Name EQ 'PS' THEN BEGIN ; a Postscript-Device
      ; flip array-values if wanted because B/W-Postcript doesn't use colortables
;      IF !REVERTPSCOLORS THEN BEGIN
;;         MinPix = MIN(Image)
;;         MaxPix = MAX(Image)
;;         Image = MaxPix - Image 
;         Image = !D.Table_Size-1-Image
;      END
      IF NOT Keyword_Set(POLYGON) THEN BEGIN 
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e 
            END ELSE BEGIN
               __HelpTVScl, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END ELSE BEGIN
               __HelpTVScl, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END
         END
      END ELSE BEGIN ;; polygone statt pixel
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
                __multipolyplot , Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, /NOSCALE, _EXTRA=e 
            END ELSE BEGIN
               __multipolyplot, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __multipolyplot , Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, /NOSCALE , _EXTRA=e
            END ELSE BEGIN
                __multipolyplot , Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END
         END 
      ENDELSE
   END ELSE BEGIN   ;; it is a WINDOW
      IF NOT KEYWORD_SET(POLYGON) THEN BEGIN
      
         IF N_Params() EQ 2 THEN BEGIN ;; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xnorm, CENTIMETERS=centi, _EXTRA=e
            END ELSE BEGIN
               __HelpTVScl, Image, xnorm, CENTIMETERS=centi, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xpos, ypos, CENTIMETERS=centi, _EXTRA=e
            END ELSE BEGIN
               __HelpTVScl, Image, xpos, ypos, CENTIMETERS=centi, _EXTRA=e
            END
         END
      END ELSE BEGIN ;; polygone statt pixel
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __multipolyplot , Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, /NOSCALE, _EXTRA=e 
            END ELSE BEGIN
               __multipolyplot, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __multipolyplot , Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, /NOSCALE , _EXTRA=e
            END ELSE BEGIN
               __multipolyplot , Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, _EXTRA=e
            END
         END 
         
      ENDELSE
   END

   IF Set(Dimensions) OR N_Params() EQ 4 THEN BEGIN 
      ;; raw dimensions
      dimension = [xpos*!D.X_PX_CM/FLOAT(!D.X_Size), ypos*!D.Y_PX_CM/FLOAT(!D.Y_SIZE), $
                    xsize*!D.X_PX_CM/FLOAT(!D.X_Size), ysize*!D.Y_PX_CM/FLOAT(!D.Y_SIZE)]

      ;;only hole pixels or points are allowed
      dim_dev = floor(uconvert_coord([dimension(0),dimension(0)+dimension(2)],$
                               [dimension(1),dimension(1)+dimension(3)], $
                               /normal, /to_device))
      dim_norm = uconvert_coord(dim_dev, /device, /to_normal)
      ;; cleaned dimensions
      dimensions = [dim_norm(0, 0), dim_norm(1, 0), dim_norm(0, 1)-dim_norm(0, 0), dim_norm(1, 1)-dim_norm(1, 0)]
      dimension = dimensions 
      
   endif   
 



END



