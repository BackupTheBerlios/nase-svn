;+
; NAME:
;  Inscription
;
; VERSION:
;  $Id$
; 
; AIM:
;  Annotate a plot using predefined positions
;
; PURPOSE:
;  A procedure for plotting text inside, outside, left, right, ...  of a data plot box
;  with automatical aligment.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*inscription, text [,/INSIDE | ,/OUTSIDE ] 
;*                  [,/LEFT   | ,/CENTER | ,/RIGHT]
;*                  [,/BOTTOM | ,/MIDDLE | ,/TOP  ]
;*                  [,XCORR=...] [,YCORR=...]
;*
; all additional keywords will be passed to IDL's <*>XYOuts</*>
; 
; INPUTS: 
;  text:: string variable
;
; INPUT KEYWORDS:      
;  INSIDE,OUTSIDE   :: text is either positioned inside or outside the
;                      data plot box (default: <*>/OUTSIDE</*>)
;  LEFT,CENTER,RIGHT:: text is placed on the left, center or right
;                      side of data plot box (default: <*>/LEFT</*>)
;  TOP,MIDDLE,BOTTOM:: text is placed at the top, center or bottom of
;                      the data plot box (default: <*>/TOP</*>). The
;                      <*>/MIDDLE</*> option rotates the text 90 degree
;                      (counter) clockwise, if the horizontal
;                      alignment is <*>/LEFT</*> or <*>/RIGHT</*>.
;  XCORR,YCORR::       coordinate correction of the text position in
;                      horizontal/vertical direction (multiples of
;                      !D.X_CH_SIZE). Positive <*>X/YCORR</*> shifts
;                      text to the top/right of the plot.
;
; RESTRICTIONS:
;  Before using this procedure, a plot routine with a data plot box must be used.
;
; EXAMPLE:
;*plot, indgen(10) 
;*inscription,"left top inside",/INSIDE,/LEFT,/TOP
;*inscription,"right bottom outside ",/OUTSIDE,/RIGHT,/BOTTOM
;
;-
PRO inscription ,TEXT,INSIDE=INSIDE,OUTSIDE=OUTSIDE,LEFT=LEFT,RIGHT=RIGHT,CENTER=CENTER,BOTTOM=BOTTOM,TOP=TOP,$
                 CHARSIZE=_CHARSIZE,MIDDLE=MIDDLE,ORIENTATION=ORIENTATION,ALIGNMENT=ALIGNMENT,XCORR=XCORR,$
                 YCORR=ycorr,_EXTRA=e
   On_ERROR,2

   IF NOT Keyword_Set(left)   AND NOT Keyword_Set(right)   AND NOT Keyword_Set(center) THEN Default, left, 1
   IF NOT Keyword_Set(top)    AND NOT Keyword_Set(bottom)  AND NOT Keyword_Set(middle) THEN Default, top , 1
   IF NOT Keyword_Set(inside) AND NOT Keyword_Set(outside) THEN Default,outside,1 
   Default, xcorr,0
   Default, ycorr,0
   Default, _CHARSIZE, !P.Charsize
   CHARSIZE = _CHARSIZE*sqrt(1./MAX([1.,(!P.MULTI(1)), (!P.MULTI(2))])) 
   
   ; pr : plotregion
   pr_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
   pr_dev = UCONVERT_COORD(pr_norm,/NORM,/TO_DEVICE)

   tick_norm = [(!X.Window(1)-!X.Window(0))*!Y.Ticklen, (!Y.Window(1)-!Y.Window(0))*!X.Ticklen]
   tick_dev  = UCONVERT_COORD(tick_norm,/NORM,/TO_DEVICE)

   char_dev  = Charsize*[!D.X_CH_SIZE, !D.Y_CH_SIZE]

   hw = reform(pr_dev(*,1)-pr_dev(*,0)) ; height-to-width ratio


   ;; determine ordinate of text
   CASE 1 OF 
       Keyword_Set(BOTTOM): BEGIN
           IF Keyword_Set(INSIDE) THEN y0 = pr_dev(1,0)+tick_dev(1)+char_dev(1)/2. $
                                  ELSE y0 = pr_dev(1,0)-char_dev(1) 
           default, ORIENTATION, 0
       END
       Keyword_Set(TOP): BEGIN
           IF Keyword_Set(INSIDE) THEN y0 = pr_dev(1,1)-tick_dev(1)-char_dev(1) $
                                  ELSE y0 = pr_dev(1,1)+char_dev(1)/2. 
           Default, ORIENTATION, 0
       END
       Keyword_Set(MIDDLE): BEGIN 
           y0 = pr_dev(1,0)+hw(1)/2.
           default,ORIENTATION,90
       END
   ENDCASE
   

   ;; and now the abscissa
   CASE 1  OF 
       Keyword_Set(LEFT): BEGIN 
           IF Keyword_Set(MIDDLE) THEN BEGIN
               Default, ALIGNMENT, 0.5
               IF Keyword_Set(INSIDE) THEN x0=pr_dev(0,0)+tick_dev(0)+char_dev(1) $
                                      ELSE x0=pr_dev(0,0)-char_dev(1)/2. 
           END ELSE BEGIN
               Default, ALIGNMENT, 0
               x0 = pr_dev(0,0)+tick_dev(0)+char_dev(0)/2. 
           END
       END
       Keyword_Set(RIGHT): BEGIN 
           IF Keyword_Set(MIDDLE) THEN BEGIN
               Default, ALIGNMENT, 0.5
               IF Keyword_Set(INSIDE) THEN x0=pr_dev(0,1)-tick_dev(0)-char_dev(1) $
                                      ELSE x0=pr_dev(0,1)+char_dev(1)/2.
           END ELSE BEGIN
               Default, ALIGNMENT, 1
               x0 = pr_dev(0,1)-tick_dev(0)-char_dev(0)/2. 
           END
           Orientation = Orientation*(-1)
       END
       Keyword_Set(CENTER): BEGIN 
           x0 = pr_dev(0,0)+hw(0)/2.
           Default, ALIGNMENT, 0.5
       END
   ENDCASE

   xyouts,xcorr*CHARSIZE*!D.X_CH_SIZE+x0,ycorr*CHARSIZE*!D.y_CH_SIZE+y0,TEXT,$
     /DEVICE,ALIGNMENT=ALIGNMENT,ORIENTATION=ORIENTATION,CHARSIZE=CHARSIZE,_EXTRA=e
END


;plot, indgen(10)
;inscription,"inside left top", /INSIDE,/LEFT,/TOP
;inscription,"inside center top", /INSIDE,/CENTER,/TOP
;inscription,"inside right top", /INSIDE,/RIGHT,/TOP
;inscription,"outside left top", /outSIDE,/LEFT,/TOP
;inscription,"outside center top", /OUTSIDE,/CENTER,/TOP
;inscription,"outside right top", /outSIDE,/RIGHT,/TOP
;inscription,"outside right bottom", /OUTSIDE,/RIGHT,/BOTTOM
;inscription,"outside center bottom", /OUTSIDE,/CENTER,/bottom
;inscription,"outside left bottom", /OUTSIDE,/LEFT,/BOTTOM
;inscription,"inside left bottom", /INSIDE,/LEFT,/BOTTOM
;inscription,"inside center bottom", /inSIDE,/CENTER,/bottom
;inscription,"inside right bottom", /INSIDE,/RIGHT,/bottom
;inscription,"outside right middle", /OUTSIDE,/RIGHT,/MIDDLE
;inscription,"outside center middle", /OUTSIDE,/CENTER,/middle
;inscription,"outside left middle", /OUTSIDE,/LEFT,/MIDDLE
;inscription,"inside left middle", /INSIDE,/LEFT,/MIDDLE
;inscription,"inside center middle", /inSIDE,/CENTER,/middle
;inscription,"inside right middle", /INSIDE,/RIGHT,/MIDDLE

;END
