;+
; NAME:
;  UTvScl
;
; VERSION:
;  $Id$
;
; AIM:
;  Device independent, color coded display of two-dimensional array
;  contents.
;
; PURPOSE:
;  <C>UTVScl</C> substitutes IDL's <C>TVScl</C> routine because it
;  offers some nice advantages and extras.<BR>
;  + Device-independent display<BR>
;  + Positioning in normal coordinates<BR>
;  + Arbitrary size<BR>
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;
; CALLING SEQUENCE:   
;* UTvScl, Image [,XNorm [,YNorm [,Dimension]]]
;*               [,/XCENTER] [,/YCENTER] [,/CENTER]
;*               [,X_SIZE=x_size | ,NORM_X_SIZE] 
;*               [,Y_SIZE=y_size | ,NORM_Y_SIZE]
;*               [,STRETCH=stretch][,H_STRETCH=h_stretch][,V_STRETCH=v_stretch]
;*               [,/NOSCALE] [,DIMENSIONS=dimensions] [,/DEVICE]
;*               [,CUBIC=...][,/INTERP][,/MINUS_ONE]
;
;  <C>UTvScl</C> passes unknown options to <C>TvScl</C>, e.g. <*>/ORDER</*>.
;
; INPUTS:
;  image:: One or two dimensional array.
;
; OPTIONAL INPUTS:
;  XNorm, YNorm:: linke untere Ecke der Bildposition in Normalkoordinaten (Def.: 0.0)
;                 bzw. Mitte des Bildes mit Keyword /CENTER (dann ist Def.: 0.5)
;                 wird nur XNorm angegeben werden die Bilder entsprechend dem Wert
;                                    von XNorm nebeneinander positioniert, siehe Docu von TV
;
; INPUT KEYWORDS: 
;              [X|Y]CENTER:: image will be
;                            horizontally/vertically centered around <*>XNorm</*>/<*>YNorm</*>
;              CENTER:: shortcut for setting <*>/XCENTER</*> and <*>/YCENTER</*>
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
; DEVICE:: If set, <*>[XY]Norm</*> are evaluated as device
;          coordinates. In fact, this option should not be needed,
;          because it is the purpose of <C>UTVScl</C> to offer device
;          independent display properties.
; /POLYGON:: Instead of composing the final image of a large number of pixels
;           depending on the desired size, this option uses colored
;           rectangles that are sufficiently large. This is
;           recommended for Postscript output. This option invokes the
;           <A>PolyTV</A> routine.
; TOP:: Only color indices ranging from 0 to <*>top</*> are used for
;       coloring. See also IDL online help for <C>TVScl</C>.
; CUBIC, /INTERP, /MINUS_ONE:: These keywords are used to interpolate
;                            the final image. They are passed to the
;                            <C>Congrid</C> routine that accomplishes
;                            the interpolation. See also IDL online help
;                            for <C>Congrid</C>. Note that
;                            interpolation of an array containing
;                            <*>!NONE</*> elements is not recommended,
;                            as <*>!NONE</*>s tend to disappear due to
;                            the interpolation process. Note also that
;                            interpolation with <*>POLYGON</*> set
;                            results in very large Postscript output
;                            files.
;
; OPTIONAL OUTPUTS:
; DIMENSIONS:: This keyword can be used to return the display
;              parameters. These are <*>[xpos, ypos, xsize, ysize]</*>
;              in normal coordinates. <*>xypos</*> always return the
;              coordinates of the lower left corner, even with
;              <*>CENTER</*> set.
; 
; RESTRICTIONS:
;  Does not work completely correct with a shared 8bit color
;  table.<BR>
;  Note that interpolation of an array containing <*>!NONE</*>
;  elements is not recommended, as <*>!NONE</*>s tend to disappear
;  due to the interpolation process.
;                
; EXAMPLE:
;* bild = FIndgen(100,100)
;* ULoadCt, 5
;* UTvScl, bild
;* UTVScl, bild, /CENTER, STRETCH=2.0
;* UTvScl, bild, 0.8, 0.8, /CENTER, STRETCH=0.5, H_STRETCH=2.0
;* UTvScl, bild, /CENTER, X_SIZE=5  ; erzeugt 5cm langes Bild auf PS und 200 Pixel auf Screen
;
; SEE ALSO:
;  <A>UTv</A>, <A>PolyTV</A>.
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


;; --- Plot polygons instead of pixels
PRO __MultiPolyPlot, A ,XNorm ,Ynorm ,Xsize=X_size, ysize=y_size $
                     , NOSCALE=NOSCALE, DEVICE=DEVICE $
                     ;,CENTIMETERS=centimeters $ ;;Not used in this routine!
                     , TOP=TOP ,ORDER=ORDER
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
;   default,centimeters,0 ;; Not used!
   default,order,0

   IF (NOSCALE EQ 1) THEN BEGIN
      ARRAY = A
   END ELSE BEGIN
      ARRAY = __ScaleArray(A, TOP=top)
      TVLCT,R,G,B,/GET   
   ENDELSE

;   xpix = FLOAT(X_size)/FLOAT(xsize) No longer necessary!
;   ypix = FLOAT(Y_size)/FLOAT(ysize)

   IF  DEVICE EQ 1 THEN BEGIN
      X_PX_CM = !D.X_PX_CM
      Y_PX_CM = !D.Y_PX_CM
   END ELSE BEGIN
      X_PX_CM = 1.0
      Y_PX_CM = 1.0
   ENDELSE

;; No longer needed and substituted by PolyTV
;   IF ORDER EQ 1 THEN BEGIN
;      Y_START = ysize -1
;      Y_END = 0
;      Y_STEP =  -1
;   END ELSE BEGIN
;      Y_START = 0
;      Y_END = ysize -1
;      Y_STEP =  1
;   ENDELSE
;      FOR j = Y_START , Y_END,Y_STEP DO BEGIN
;         FOR i = 0L , xsize -1 DO BEGIN
;         x = [ i  , i + 1 , i + 1 , i  ] 
;         y = [ Y_START +  Y_STEP * j  , Y_START +  Y_STEP *j   , Y_START +  Y_STEP *j + 1 , Y_START +  Y_STEP *j + 1 ]
;         x(*) = (x(*)*xpix + Xnorm) * X_PX_CM
;         y(*) = (y(*)*ypix + Ynorm) * Y_PX_CM
         
;         IF  (NOSCALE EQ 1) THEN BEGIN
;            polyfill,x,y,COLOR=ROUND(ARRAY(i,j)), /DEVICE 
          
           
;         END ELSE BEGIN
;           polyfill,x,y,COLOR=ROUND(ARRAY(i,j)), /DEVICE 
;           colorindex = RGB(R(ARRAY(i,j)) ,G(ARRAY(i,j)) ,B(ARRAY(i,j)),/NOALLOC)
;           polyfill,x,y,COLOR=colorindex ,/DEVICE
            
;         ENDELSE
;      ENDFOR
;   ENDFOR

   PolyTV, array, XSIZE=x_size* X_PX_CM, YSIZE=y_size* X_PX_CM $
    , XORPOS=xnorm* X_PX_CM, YORPOS=ynorm* X_PX_CM $
    , DEVICE=1, ORDER=order

END



;; --- Main routine starts here

PRO UTvScl, __Image, XNorm, YNorm, Dimension $
            , XCENTER=xcenter, YCENTER=ycenter, CENTER=center $
            , STRETCH=stretch, V_STRETCH=v_stretch, H_STRETCH=h_stretch $
            , X_SIZE=x_size, Y_SIZE=y_size $
            , NORM_X_SIZE=norm_x_size, NORM_Y_SIZE=norm_y_size $
            , DIMENSIONS=dimensions $
            , NOSCALE=noscale $
            , DEVICE=device $
            , POLYGON=POLYGON $
            , CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one $
            , TRUE=_true $
            , _EXTRA=e

   ON_ERROR, 2
   IF !D.Name EQ 'NULL' THEN RETURN


   ;; correct handling of top keyword;
   ;; NASE stanard is that TV and partners use the palette
   ;; only from 0..!TOPCOLOR, this is ensured here if nothing
   ;; else is specified
   IF Keyword_Set(TRUE) THEN BEGIN
       ;; TRUE color images also uses a color palette! Have to set it properly...later
       IF ExtraSet(E, 'TOP') THEN Console, '/TRUE and TOP simultaneously set, hope you what you are doing!', /WARN
       SetTag, E, "TOP", 255
   END ELSE BEGIN
       IF NOT ExtraSet(E, 'TOP') THEN SetTag, E, "TOP", !TOPCOLOR
   END

   IF Keyword_Set(CENTER) THEN BEGIN
       XCENTER = 1
       YCENTER = 1
   END

   ; don't modify the original image
   IF N_Params() LT 1 THEN Console, 'at leat one positional argument expected', /FATAL
   Image = REFORM(__Image)
   

   ; TRUE stands for TRUE color support, see IDL help of TV
   Default, _TRUE, 0
   IF _TRUE GT 0 THEN BEGIN
       IF Keyword_Set(POLYGON) THEN Console, 'TRUE color option not supported for /POLYGON', /FATAL
       IF _TRUE EQ 1 THEN Image = Transpose(Image, [1,2,0])
       IF _TRUE EQ 2 THEN Image = Transpose(Image, [0,2,1])
       IF _TRUE GT 3 THEN Console, 'invalid value for TRUE', /FATAL
       IF (SIZE(Image))(3) NE 3 THEN Console, 'TRUE color option expects (3,x,y), (x,3,y) or (x,y,3) array, see IDLs TV help'
       TRUE=3
   END ELSE BEGIN
       IF (SIZE(Image))(0) GT 2 THEN Console, 'array has more than 2 dimensions', /FATAL
       Image = REFORM(Image, (SIZE(image))(1), (SIZE(image))(2), 1, /OVERWRITE)
       TRUE=0
   END


   IF N_Params() LT 3 AND     Keyword_Set(YCENTER) THEN YNorm = 0.5
   IF N_Params() LT 3 AND NOT Keyword_Set(YCENTER) THEN YNorm = 0.0
   IF N_Params() LT 2 AND     Keyword_Set(XCENTER) THEN XNorm = 0.5
   IF N_Params() LT 2 AND NOT Keyword_Set(XCENTER) THEN XNorm = 0.0
   
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
   IF Keyword_Set(XCENTER) THEN xpos = xpos - xsize/2.
   IF Keyword_Set(YCENTER) THEN ypos = ypos - ysize/2.
   
   IF Set(STRETCH) OR Set(V_STRETCH) OR Set(H_STRETCH) OR Set(X_SIZE) OR Set(Y_SIZE) THEN begin
      im_max = max(Image)
      im_min = min(Image)
      IF !D.NAME EQ "PS" THEN begin
         ;; a dot in postscript is 1/72 inch and 1 inch is approx. 2.54cm
         ;; so we have a constant resolution for the bitmap 
         _smooth = 1./(2.54/72.)*[1, 1] 
      END ELSE BEGIN
         _smooth = [!D.X_PX_CM, !D.Y_PX_CM]
      END

      ;; If POLYGON is set, the image array need not be resized,
      ;; because POLYTV later resizes the pixels, not the array.
      ;; BUT if the user wants interpolation, resizing has to done.
      IF NOT(Keyword_Set(POLYGON)) THEN BEGIN
         ;; Congrid when POLYGON is not set
         _Image = FltArr((xsize*_smooth(0)) > 1 $
                         , (ysize*_smooth(1)) > 1, TRUE > 1)
         FOR i=0, 2 * (TRUE GT 0) DO $
          _Image(*,*,i) = Congrid(Image(*,*,i), (xsize*_smooth(0)) > 1 $
                                  , (ysize*_smooth(1)) > 1, $
                                  CUBIC=cubic, INTERP=interp $
                                  , MINUS_ONE=minus_one)
         Image = Temporary(_Image)
      ENDIF ELSE BEGIN
         IF Set(CUBIC) OR Keyword_Set(INTERP) OR $
          Keyword_Set(MINUS_ONE) THEN BEGIN
            ;; Congrid when POLYGON is set but INETRPOLATION is desired
            _Image = FltArr((xsize*_smooth(0)) > 1 $
                            , (ysize*_smooth(1)) > 1, TRUE > 1)
            FOR i=0, 2 * (TRUE GT 0) DO $
             _Image(*,*,i) = Congrid(Image(*,*,i), (xsize*_smooth(0)) > 1 $
                                     , (ysize*_smooth(1)) > 1, $
                                     CUBIC=cubic, INTERP=interp $
                                     , MINUS_ONE=minus_one)
            Image = Temporary(_Image)
         ENDIF
      ENDELSE

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
      IF NOT Keyword_Set(POLYGON) THEN BEGIN 
          IF Keyword_Set(TRUE) THEN BEGIN
              UTVLCT, sp, /GET
              LoadCT, 0
          END

         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TRUE=true, _EXTRA=e 
            END ELSE BEGIN
               __HelpTVScl, Image, xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END ELSE BEGIN
               __HelpTVScl, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END
         END
      END ELSE BEGIN ;; polygons instead of pixels
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $ Not used by MultiPolyPlot anyway
               , /NOSCALE, _EXTRA=e 
            END ELSE BEGIN
               __MultiPolyPlot, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $
               , _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $ Not used by MultiPolyPlot anyway
               , /NOSCALE, _EXTRA=e
            END ELSE BEGIN
               __MultiPolyPlot, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $
               , _EXTRA=e
            END
         END 
      ENDELSE
      IF Keyword_Set(TRUE) THEN TVLCT, sp
 
  END ELSE BEGIN   ;; it is a WINDOW
      IF NOT KEYWORD_SET(POLYGON) THEN BEGIN
      
         IF N_Params() EQ 2 THEN BEGIN ;; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xnorm, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END ELSE BEGIN
               __HelpTVScl, Image, xnorm, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, Image, xpos, ypos, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END ELSE BEGIN
               __HelpTVScl, Image, xpos, ypos, CENTIMETERS=centi, TRUE=true, _EXTRA=e
            END
         END
      END ELSE BEGIN ;; polygons instead of pixels
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $
               , /NOSCALE $
                ;;, TRUE=true $ ;; TRUE not supported for polygons
               , _EXTRA=e 
            END ELSE BEGIN
               __MultiPolyPlot, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $
               ;;, TRUE=true $
               , _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $
               , /NOSCALE $
                ;;, TRUE=true $
               , _EXTRA=e
            END ELSE BEGIN
               __MultiPolyPlot, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                ;;, CENTIMETERS=centi $
               ;;, TRUE=true $
               , _EXTRA=e
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



