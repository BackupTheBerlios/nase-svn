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
;                             [,CUBIC=cubic] [,/INTERP] [,/MINUS_ONE]
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
;                     NORM_X/Y_SIZE : Wie X/Y_SIZE nur in Normalkoordinaten.
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
;                     POLYGON   : Statt Pixel werden Polygone gezeichnet (Empfehlenswert bei Postscript-Ausgabe)  
;                     TOP       : es werden nur die Farbindices von 0..TOP belegt (siehe IDL5 Hilfe von TvSCL)
;                     CUBIC,
;                     INTERP,
;                     MINUS_ONE : werden an ConGrid uebergeben (s. IDL_Hilfe)
;                                 Man beachte, daß die Interpolation eines Arrays, das !NONE-Elemente enthält,
;                                 nicht sinnvoll ist! Die NONEs gehen i.d.R. durch die Interpolation veroren!
;
;                     
; RESTRICTIONS:       Arbeitet nicht ganz korrekt mit einer Shared-8Bit-Color-Table
;
;                     Man beachte, daß die Interpolation (Keyw. CUBIC oder INTERP) eines Arrays,
;                     das !NONE-Elemente enthält,
;                     nicht sinnvoll ist! Die NONEs gehen i.d.R. durch die Interpolation veroren!
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
;     Revision 2.31  1999/09/23 12:23:19  kupper
;     Replaced weird looking __ScaleArray-Function.
;     Hope nothing broke...
;
;     Revision 2.30  1999/07/16 14:22:58  kupper
;     Bug fix: Min & Max of array were allways recomputed, not only in the
;     case of CUBIC interpolation. This led to vanishing NONEs and
;     misbehaviour of showweights/tomwaits. Fixed.
;
;     Revision 2.29  1999/06/10 12:35:27  kupper
;     Added Correction of Minimum/Maximum if CUBIC Interpolation was used (to prevent color-table-artefacts!)
;
;     Revision 2.28  1999/06/07 14:40:44  kupper
;     Added CUBIC,INTERP,MINUS_ONE-Keywords for ConGrid.
;
;     Revision 2.27  1999/03/17 16:29:58  saam
;           TOP keyword implemented
;
;     Revision 2.26  1998/08/10 08:37:15  gabriel
;           ORDER Keyword fuer Polygon-Plot neu
;
;     Revision 2.25  1998/08/07 19:08:01  gabriel
;           TOP Keyword implementiert
;
;     Revision 2.24  1998/08/07 15:33:39  gabriel
;          PolyPlot implementiert
;
;     Revision 2.23  1998/04/18 15:09:02  kupper
;            Fehler bei der !Revertpscolors-Verarbeitung.
;
;     Revision 2.22  1998/04/09 12:35:59  kupper
;            Bug: Der Congrid-Aufruf stürzte ab bei zu kleinen Ausmaßen.
;
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



; Gibt ein auf die vorhandene Palettengroesse (bzw. auf 0..top-1 falls top gesetzt)
; skalierte Version eines Arrays A zurueck
;FUNCTION __ScaleArray, A, TOP=top

;   DEFAULT, top, !D.TABLE_SIZE
;   _TOP = ROUND(TOP)
;   _TOP = _TOP < 255.

;   FAC = (_TOP/FLOAT(!D.TABLE_SIZE))
;   _A = BYTE(FLOAT(A(*,*)-MIN(a))/FLOAT(MAX(a)-MIN(a))*FLOAT(_TOP-1))
;   IF FAC GT 1. THEN BEGIN
;      index = where(_A GT MAX(1./FAC *_A),count)
;      IF count GT 0 THEN  _A(index) = MAX(1./FAC *_A)
;   ENDIF

;   RETURN, _A
;END


;; Neue Version von __ScaleArray, R Kupper, Sep 23 1999
;; Die obige, alte Version scheint mir sehr
;; "strange"... Außerdem skaliert sie auf TOP-1 und nicht auf
;; TOP, wie das TvScl tut. Das ist inkonsistent. Der IF-Teil
;; hätte auch in einer "<" Anweisung erledigt werden können,
;; aber das Abschneiden oberhalb von !D.TABLE_SIZE, falls
;; TOP>!D.TABLE_SIZE scheint mir ohnehin nicht geheuer. Eher
;; sollte dann eben auf deisen Wert skaliert werden.
;; Auch das Kopieren des Arrays in _A ist nicht nötig und
;; braucht ev. viel Speicher.
;; Wieauchimmer, falls die neue Version Probleme hervorruft kann 
;; man das wieder ändern...
Function __ScaleArray, A, TOP=top

   Default, top, !D.TABLE_SIZE-1

   _top = top < (!D.TABLE_SIZE-1)

   Return, Scl(A, [0, _top])

End


; TvSCL-Version die das TOP-Keyword richtig behandelt
PRO __HelpTvScl, A, p1, p2, _EXTRA=e

   IF ExtraSet(e, 'TOP') THEN _A = __ScaleArray(A, TOP=e.top) ELSE _A = __ScaleArray(A)
   DelTag, e, 'TOP'

   CASE N_Params() OF
      1: TV, _A, _EXTRA=e
      2: TV, _A, p1, _EXTRA = e
      3: TV, _A, p1, p2, _EXTRA=e
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
   DEFAULT, POLYGON  , 0

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
;         MinPix = MIN(Image)
;         MaxPix = MAX(Image)
;         Image = MaxPix - Image 
         Image = !D.Table_Size-1-Image
      END
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
      Device, BYPASS_TRANSLATION=0
      IF NOT KEYWORD_SET(POLYGON) THEN BEGIN
         IF Set(STRETCH) OR Set(V_STRETCH) OR Set(H_STRETCH) OR Set(X_SIZE) OR Set(Y_SIZE) THEN begin
            im_max = max(Image)
            im_min = min(Image)
            Image = Congrid(Image, (xsize*!D.X_PX_CM) > 1, (ysize*!D.Y_PX_CM) > 1, CUBIC=cubic, INTERP=interp, MINUS_ONE=minus_one)
                                ;If CUBIC was used, the maximum or
                                ;minimum may have been changed by
                                ;congrid. This may produce color
                                ;artefacts. So rescale to have the
                                ;same min and max as before:
            If Keyword_Set(CUBIC) then begin
               Image = Image-min(Image)
               Image = Image/float(max(Image))*(im_max-im_min)
               Image = Image+im_min
            EndIf
         EndIf
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
      Device, /BYPASS_TRANSLATION
   END

   IF Set(Dimensions) THEN dimensions = [xpos*!D.X_PX_CM/FLOAT(!D.X_Size), ypos*!D.Y_PX_CM/FLOAT(!D.Y_SIZE), $
                                         xsize*!D.X_PX_CM/FLOAT(!D.X_Size), ysize*!D.Y_PX_CM/FLOAT(!D.Y_SIZE)]
   IF N_Params() EQ 4 THEN dimension = [xpos*!D.X_PX_CM/FLOAT(!D.X_Size), ypos*!D.Y_PX_CM/FLOAT(!D.Y_SIZE), $
                                         xsize*!D.X_PX_CM/FLOAT(!D.X_Size), ysize*!D.Y_PX_CM/FLOAT(!D.Y_SIZE)]

END



