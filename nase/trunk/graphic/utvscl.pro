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
;  + Color clipping at bounds of available colormap<BR>
;  + Handling of the special NASE value !NONE<BR>
;
;  <I>Note on clipping:</I><BR>
;    Clipped values will be indicated by dark yellow for the upper
;    bound and very dark yellow for the lower bound. This function
;    displays all entries inside the array that lie (after a possible
;    scaling) above <*>!TOPCOLOR</*> or below 0 in the special
;    yellowish colors. The value <*>!NONE</*> is always displayed in
;    the standard blue color.
;    If <C>/ALLOWCOLORS</C> is set, at the upper end of the palette,
;    only colors above the color table size are clipped, leaving the
;    indices between <*>!TOPCOLOR</*> and <*>!D.TABLE_SIZE-1</*>
;    untouched. This allows using the NASE colors that can be set
;    using the <A>RGB()</A> command.<BR>
;    No clipping is done in any way for truecolor images.<BR>
;
;  <I>Note on truecolor images:</I><BR>
;    <C>/POLY</C> is not supported for truecolor images.<BR>
;    No handling of <*>!NONE</*> is done in any way for truecolor images.<BR>
;    No clipping is done in any way for truecolor images.<BR>
;       
;
; CATEGORY:
;  Array
;  Graphic
;  Image
;  NASE
;  Color
;
; CALLING SEQUENCE:   
;* UTvScl, Image [,XNorm [,YNorm [,Dimension]]]
;*               [,/XCENTER] [,/YCENTER] [,/CENTER]
;*               [,X_SIZE=x_size | ,NORM_X_SIZE] 
;*               [,Y_SIZE=y_size | ,NORM_Y_SIZE]
;*               [,STRETCH=stretch][,H_STRETCH=h_stretch][,V_STRETCH=v_stretch]
;*               [,/NOSCALE] [,DIMENSIONS=dimensions] [,/DEVICE]
;*               [,CUBIC=...][,/INTERP][,/MINUS_ONE]
;*               {[,/NORDER] [,/NSCALE]} | [,/NASE]
;*               [,/ALLOWCOLORS]
;*               [,TOP=...] [,RANGE_IN=[..., ...]]
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
;                 von XNorm nebeneinander positioniert, siehe Docu von TV
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
; TOP:: Only color indices ranging from 0 to <*>TOP</*> are used for
;       coloring. <*>TOP</*> is automatically limited to !TOPCOLOR (to !D.TABLE_SIZE-1 for
;       truecolor images). This mimicks the bahaviour of <C>TVScl</C>.
;       See also IDL online help for this routine.
; RANGE_IN:: 2-element array specifying the correspondance range for
;            color scaling: The first value will be scaled to color
;            index <*>0</*>, the second value will be scaled to color
;            index <*>!TOPCOLOR</*> (or <*>TOP</*>, if set). This
;            parameter defaults to <*>[min(Image),max(Image)]</*>,
;            mimicking the behaviour of IDL's <C>TvScl</C>.
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
; /NASE:: Array is in NASE coordinates (array will be rotated suitably before output).
; /NORDER   ::
; /NSCALE   ::
; /ALLOWCOLORS:: If <C>/ALLOWCOLORS</C> is set, at the upper end of the
;               palette, only colors above the color table size are
;               clipped, leaving the indices between <*>!TOPCOLOR</*>
;               and <*>!D.TABLE_SIZE-1</*> untouched. This allows
;               using the NASE colors that can be set using the
;               <A>RGB()</A> command.
;
;
; OPTIONAL OUTPUTS:
; DIMENSIONS:: This keyword can be used to return the display
;              parameters. These are <*>[xpos, ypos, xsize, ysize]</*>
;              in normal coordinates. <*>xypos</*> always return the
;              coordinates of the lower left corner, even with
;              <*>CENTER</*> set.
; Dimension:: This positional argument returns the exact same
;             information as the <*>DIMENSIONS=...</*> keyword.
;             <B>The use of this positional argument is
;             depricated.</B> Use <*>DIMENSIONS=...</*> instead.
; 
; 
; RESTRICTIONS:
;  Does not work completely correct with a shared 8bit color
;  table.<BR>
;  Note that interpolation of an array containing <*>!NONE</*>
;  elements is not recommended, as <*>!NONE</*>s tend to disappear
;  due to the interpolation process.
;<BR>
;  BUGS/TODO:<BR>
;  o Handling of 1-dim arrays is broken.<BR>
;  o Handling of arrays with trailing dimensions of 1 is broken.
;  o When /POLY is set, and only one positioning-argument is given, it
;    is interpreted as the x-coordinate, and y defaults to zero. This
;    is wrong, positions in the window should be counted in this case,
;    see documentation of IDL's <C>TV</C> or POLY=0-behaviour.
;  o (more see the NASE ToDo list).
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
;-



; Gibt ein auf die vorhandene Palettengroesse (bzw. auf 0..top falls top gesetzt)
; skalierte Version eines Arrays A zurueck.
; NONEs are preserved.
Function __ScaleArray, A, TOP=top, TRUE=true, RANGE_IN=range_in
   ;; for truecolor, just do scaling to [0,TOP], no special
   ;; handling at all (mimick behaviour of IDL's TVSCL).
   If Keyword_Set(TRUE) then begin
      Default, top, !D.TABLE_SIZE
      _top = top < !D.TABLE_SIZE
      Default, range_in, [min(A), max(A)]
      return, Scl(A, [0, _top], range_in)
   endif

   Default, top, !TOPCOLOR
   _top = top < !TOPCOLOR

   ;; keep nones and NO-nones in mind:
   nones   = where(A eq !NONE, nonecount)
   nonones = where(A ne !NONE, nononecount)

   if nononecount ne 0 then begin
      ;; there is at least one value that is not !NONE
      min = min(A[nonones])
      max = max(A[nonones])
      Default, range_in, [min, max]
      result = Scl(A, [0, _top], range_in)

      ;; restore nones:
      if nonecount ne 0 then result[nones] = !NONE
   endif else begin
      ;; all entries are !NONE
      result = A
   endelse


   Return, result
End


; This function clips all entries inside an array that lie above
; !TOPCOLOR or below 0, or are !NONE, and replaces them by the
; special colors. If /ALLOWCOLROS is set, only colors above the color
; table size are clipped, leaving the indices between !TOPCOLOR and
; !D.TABLE_SIZE-1 untouched. This allows using the NASE colors that can
; be set using the RGB() command.
Function __ClipArray, A, ALLOWCOLORS=allowcolors, TRUE=true
   ;; do nothing at all for truecolor.
   If Keyword_Set(TRUE) then return, A


   result = A

   If Keyword_Set(ALLOWCOLORS) then $
      TOPCLIP = !D.TABLE_SIZE-1 else TOPCLIP = !TOPCOLOR 
     
   ;; keep nones in mind:
   nones = where(result eq !NONE, nonecount)
   
   clips = where(result gt TOPCLIP, count)
   if (count gt 0) then result[clips] = rgb("dark yellow")
   
   clips = where(result lt 0, count)
   if (count gt 0) then result[clips] = rgb("very dark yellow")
   
   ;; restore nones to the correct color:
   if (nonecount gt 0) then result[nones] = rgb("none")

   Return, result
End




;; --- Plot polygons instead of pixels
;; Note: This routine performs scaling and clipping by itself.
PRO __MultiPolyPlot, A ,XNorm ,Ynorm ,Xsize=X_size, ysize=y_size $
                     , NOSCALE=NOSCALE, DEVICE=device $
                     , TOP=TOP ,ORDER=ORDER, ALLOWCOLORS=allowcolors, $
                     RANGE_IN=range_in, $
                     _EXTRA=extra

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
   default,order,0

   IF (NOSCALE EQ 1) THEN BEGIN
      ARRAY = __ClipArray(A, ALLOWCOLORS=allowcolors, TRUE=true)
   END ELSE BEGIN
      ARRAY = __ClipArray(__ScaleArray(A, TOP=top, TRUE=true, RANGE_IN=range_in), TRUE=true)
      TVLCT,R,G,B,/GET   
   ENDELSE

   ;; Position of the origin is passed to MultiPolyPlot either in cm
   ;; coordinates (DEVICE=0) or in device coordinates (DEVICE=1). It
   ;; has to be transformed into device coordinates before passing it
   ;; to PolyTV. Size of the plot is ALWAYS passed to MultiPolyPlot in
   ;; cm coordinates, it has to be transformed to device coordinates
   ;; in any case.
   IF DEVICE EQ 0 THEN BEGIN
      X_PX_CM = !D.X_PX_CM
      Y_PX_CM = !D.Y_PX_CM
   END ELSE BEGIN
      X_PX_CM = 1.0
      Y_PX_CM = 1.0
   ENDELSE

   PolyTV, array, XSIZE=x_size*!D.X_PX_CM, YSIZE=y_size*!D.Y_PX_CM $
    , XORPOS=xnorm*X_PX_CM, YORPOS=ynorm*Y_PX_CM $
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
            , TOP=top $
            , NASE=nase, NORDER=norder, NSCALE=nscale $
            , ALLOWCOLORS=allowcolors $
            , RANGE_IN=range_in $
            , _EXTRA=e


   ON_ERROR, 2
   IF !D.Name EQ 'NULL' THEN RETURN

   ;;NASE implies NORDER and NSCALE:
   Default, NASE, 0
   Default, NORDER, NASE
   Default, NSCALE, NASE

   Default, DEVICE, 0

;   ;; correct handling of top keyword;
;   ;; NASE standard is that TV and partners use the palette
;   ;; only from 0..!TOPCOLOR, this is ensured here if nothing
;   ;; else is specified
;   IF Keyword_Set(TRUE) THEN BEGIN
;       ;; TRUE color images also uses a color palette! Have to set it properly...later
;      IF ExtraSet(E, 'TOP') THEN Console, '/TRUE and TOP simultaneously set, hope you know what you are doing!', /WARN
;       SetTag, E, "TOP", 255
;   END ELSE BEGIN
;       IF NOT ExtraSet(E, 'TOP') THEN SetTag, E, "TOP", !TOPCOLOR
;   END

   IF Keyword_Set(CENTER) THEN BEGIN
       XCENTER = 1
       YCENTER = 1
   END

   ; don't modify the original image, and
   ; do NASE-transpose if /NASE or /NORDER was set:
   IF N_Params() LT 1 THEN Console, 'at least one positional argument expected', /FATAL
   If Keyword_Set(NORDER) then $
     Image = Rotate(REFORM(__Image), 3) $
    else $
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
   Default, cubic, 0.

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
      ;; BUT if the user wants interpolation, resizing has to be done.
      IF NOT(Keyword_Set(POLYGON)) THEN BEGIN
         ;; Congrid when POLYGON is not set
         _Image = DblArr((xsize*_smooth(0)) > 1 $
                         , (ysize*_smooth(1)) > 1, TRUE > 1)
         FOR i=0, 2 * (TRUE GT 0) DO $
          _Image(*,*,i) = Congrid(Image(*,*,i), (xsize*_smooth(0)) > 1 $
                                  , (ysize*_smooth(1)) > 1, $
                                  CUBIC=cubic, INTERP=interp $
                                  , MINUS_ONE=minus_one)
         Image = Temporary(_Image)
      ENDIF ELSE BEGIN
         IF (CUBIC NE 0.) OR Keyword_Set(INTERP) OR $
          Keyword_Set(MINUS_ONE) THEN BEGIN
            ;; Congrid when POLYGON is set but INTERPOLATION is desired
            _Image = DblArr((xsize*_smooth(0)) > 1 $
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
               TV, __ClipArray(Image, ALLOWCOLORS=allowcolors, TRUE=true), xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e 
            END ELSE BEGIN
               TV, __ClipArray(__ScaleArray(Image, TOP=top, TRUE=true, RANGE_IN=range_in), TRUE=true), xnorm, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, __ClipArray(Image, ALLOWCOLORS=allowcolors, TRUE=true), xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END ELSE BEGIN
               TV, __ClipArray(__ScaleArray(Image, TOP=top, TRUE=true, RANGE_IN=range_in), TRUE=true), xpos, ypos, XSIZE=xsize, YSIZE=ysize, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END
         END
      END ELSE BEGIN ;; polygons instead of pixels
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                , /NOSCALE, DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e 
            END ELSE BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                , DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                , /NOSCALE, DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e
            END ELSE BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                , DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e
            END
         END 
      ENDELSE
      IF Keyword_Set(TRUE) THEN TVLCT, sp
 
   END ELSE BEGIN   ;; it is a WINDOW
      IF NOT KEYWORD_SET(POLYGON) THEN BEGIN
         
         IF N_Params() EQ 2 THEN BEGIN ;; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, __ClipArray(Image, ALLOWCOLORS=allowcolors, TRUE=true), xnorm, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END ELSE BEGIN
               TV, __ClipArray(__ScaleArray(Image, TOP=top, TRUE=true, RANGE_IN=range_in), TRUE=true), xnorm, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               TV, __ClipArray(Image, ALLOWCOLORS=allowcolors, TRUE=true), xpos, ypos, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END ELSE BEGIN
               TV, __ClipArray(__ScaleArray(Image, TOP=top, TRUE=true, RANGE_IN=range_in), TRUE=true), xpos, ypos, CENTIMETERS=centi, TOP=top, TRUE=true, _EXTRA=e
            END
         END
      END ELSE BEGIN ;; polygons instead of pixels
         IF N_Params() EQ 2 THEN BEGIN ; position implicitely
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                , /NOSCALE, DEVICE = device, TOP=top, RANGE_IN=range_in $
                ;;, TRUE=true $ ;; TRUE not supported for polygons
               , _EXTRA=e 
            END ELSE BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xnorm, XSIZE=xsize, YSIZE=ysize $
                , DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e
            END
         END ELSE BEGIN
            IF Keyword_Set(NOSCALE) THEN BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                , /NOSCALE, DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e
            END ELSE BEGIN
               __MultiPolyPlot, ALLOWCOLORS=allowcolors, Image, xpos, ypos, XSIZE=xsize, YSIZE=ysize $
                , DEVICE = device, TOP=top, RANGE_IN=range_in, _EXTRA=e
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



