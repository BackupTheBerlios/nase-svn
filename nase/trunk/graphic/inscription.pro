;+
; NAME:
;  Inscription
;
; VERSION:
;  $Id$
; 
; AIM:
;  Add text to a plot, with easy positioning.
;
; PURPOSE:
;  A procedure for plotting text inside, outside, left, right, ...  of a data plot box
;  with automatical arrangement.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*  inscription ,TEXT [,INSIDE=...] [,OUTSIDE=...] [,/LEFT | ,/RIGHT | ,/CENTER]
;*                    [,/BOTTOM | ,/TOP | ,/MIDDLE] [,XCORR=...] [,YCORR=...]
;*                    [,_EXTRA=e]
; 
; INPUTS: 
;  TEXT:: a string variable
;
; INPUT KEYWORDS:      
;  INSIDE::  inside of data plot box
;  OUTSIDE:: outside of data plot box (default)
;  LEFT::    near to the left border of data plot box (default)
;  CENTER::  in the vertical center of data plot box
;  RIGHT::   near to the right border of data plot box
;  TOP::     near to the top  of data plot box (default)
;  MIDDLE::  in the horizontal center of data plot box
;  BOTTOM::  near to the bottom of data plot box
;  XCORR::   coordinate correction of the text position in x direction (multiples of !D.X_CH_SIZE)
;  YCORR::   coordinate correction of the text position in y direction (multiples of !D.Y_CH_SIZE)
;  _EXTRA::  see the XYOUTS procedure
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
                  CHARSIZE=CHARSIZE,MIDDLE=MIDDLE,ORIENTATIOn=ORIENTATION,ALIGNMENT=ALIGNMENT,XCORR=XCORR,$
                 YCORR=ycorr,_EXTRA=e
   on_ERROR,2

   IF NOT set(left) AND NOT set(right) AND NOT set(center) THEN  default,left,1
   IF NOT set(top) AND NOT set(bottom) AND NOT set(middle) THEN  default,top,1
   IF NOT set(inside) AND NOT set(outside)  THEN  default,outside,1 
   default,xcorr,0
   default,ycorr,0
   default,inside,0
   default,outside,0
   default,LEFT,0
   default,RIGHT,0
   default,CENTER,0
   DEFAULT,BOTTOM,0
   DEFAULT,TOP,0
   DEFAULT,CHARSIZE,1.0
   DEFAULT,MIDDLE,0
   plotregion_norm = [[!X.WINDOW(0),!Y.WINDOW(0)],[!X.WINDOW(1),!Y.WINDOW(1)]] 
   ;print,plotregion_norm
   plotregion_device = UCONVERT_COORD(plotregion_norm,/NORM,/TO_DEVICE)
   ;print,plotregion_device
   top_rand =  !D.Y_VSIZE - plotregion_device(1,1)
   bottom_rand = plotregion_device(1,0)
   left_rand =  !D.X_VSIZE - plotregion_device(0,1)
   right_rand = plotregion_device(0,0)

   hw = reform(plotregion_device(*,1)-plotregion_device(*,0)) ; hoehe und breite 
;stop
   facy = 1
   facx = 1
   CASE 1 OF 
      BOTTOM EQ 1: BEGIN
         y0 = plotregion_device(1,0)
         facy = -1
         default,ORIENTATION,0
     END
      TOP EQ 1: BEGIN
         y0 = plotregion_device(1,1)
         facy = +2
         default,ORIENTATION,0
      END
      MIDDLE EQ 1: BEGIN 
         y0 = plotregion_device(1,0) + hw(1)/2.
         facy = 0
         
         default,ORIENTATION,90
      END
   ENDCASE
   CASE 1  OF 
      LEFT EQ 1: BEGIN 
         x0 = plotregion_device(0,0)
         facx = -1
         IF MIDDLE EQ 1 THEN default ,ALIGNMENT , 0.5
         default ,ALIGNMENT , 0
         ORIENTATION = ORIENTATION
      END
      RIGHT EQ 1: BEGIN 
         x0 = plotregion_device(0,1)
         facx = 1
         IF MIDDLE EQ 1 THEN default ,ALIGNMENT , 0.5
         default,ALIGNMENT ,1
         ORIENTATION = ORIENTATION*(-1)
      END
      CENTER EQ 1:BEGIN 
         x0 = plotregion_device(0,0) + hw(0)/2.
         default,ALIGNMENT ,0.5
         facx = 0
      END
   ENDCASE
   CASE  1 OF
      INSIDE EQ 1:BEGIN
         facx = facx*(-1)
         facy = facy*(-1)
         IF MIDDLE EQ 1 THEN facx =  facx *4
         x0 = x0 +facx*!D.X_CH_SIZE & y0 = y0 + facy *!D.Y_CH_SIZE
      END
   
      OUTSIDE EQ 1 :BEGIN
         IF TOP EQ 1 THEN FACy = facy/2.
         IF BOTTOM EQ 1 THEN FACy = facy*3.
         IF (RIGHT EQ 1 OR left EQ 1) AND (MIDDLE EQ 0) THEN facx = 0
         IF MIDDLE EQ 1 AND LEFT EQ 1 THEN facx = -4
         x0 = x0 + facx*!D.X_CH_SIZE & y0 = y0 + facy *!D.Y_CH_SIZE
        ; stop
      END
   ENDCASE
   ;print,x0,y0,hw
   
   xyouts,xcorr*CHARSIZE*!D.X_CH_SIZE+x0,ycorr*CHARSIZE*!D.y_CH_SIZE+y0,TEXT,$
    /DEVICE,ALIGNMENT=ALIGNMENT,ORIENTATION=ORIENTATION,CHARSIZE=CHARSIZE,_EXTRA=e
END
