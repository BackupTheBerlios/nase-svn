;+
; NAME:
;  BalanceCT
;
; VERSION:
;  $Id$
;
; AIM:
;  Loads a suitable colortable to display positive and negative data.
;
; PURPOSE:
;  Creates a colortable to display your two dimensional data with a
;  color code. The colors are best matched to the individual data, in
;  the sense that no entries in the colortable are wasted, because the
;  data is not equally distributed around zero. The routine assures
;  that MAX(ABS(data)) is displayed with maximal saturation, but in
;  general the colortable is not symmetric around zero. However, zero is
;  assured to be black.
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE:
;* BalanceCT, data [,TOP=...]  [{, /GREENBLACKRED | /BLUEBLACKRED} ]
;
; INPUTS:
;  data :: the color table is adapted to this specific data
;
; OPTIONAL INPUTS:
;  TOP :: The colortable will occupy the elements <*>0..TOP</*> in the
;          colormap. To be compliant with the NASE color management,
;          the default is <*>!TOPCOLOR</*>.
;
; INPUT KEYWORDS:
;  GREENBLACKRED:: creates a colortable assigning different hues of
;                  green to negative values, black for zero, and red
;                  for positive values
;  BLUEBLACKRED:: creates a colortable assigning different hues of
;                  blue to negative values, black for zero, and red
;                  for positive values (Default)
;
; SIDE EFFECTS:
;  overwrites the existing colormap
;
; EXAMPLE:
;*  n=randomu(seed,20,20)-0.3
;*  balancect, n              
;*  plottvscl, n,/legend     
;
;-
PRO BALANCECT, data, TOP=maci, GREENBLACKRED=gbr, BLUEBLACKRED=bbr;

   ON_ERROR, 2

   IF (Set(gbr)+Set(bbr)) GT 1 THEN Console, 'only one colormap a time', /FATAL
   IF (Set(gbr)+Set(bbr)) EQ 0 THEN bbr=1 ; BLUEBLACKRED is default

   Default, maci, !TOPCOLOR        ;max used color index
   Default, mici, 0                ;min used color index
  

   cid = maci-mici+1             ;number of color indices used

   mid = MIN(data)
   mad = MAX(data)
   
   R = intarr(cid)
   G = intarr(cid)
   B = intarr(cid)
   
   IF mid GE 0.0 THEN BEGIN
       perc = 0.0
       R = FIX(FIndGen(cid)/(cid-1)*255)
   END ELSE BEGIN
       IF mad LE 0.0 THEN BEGIN
           perc = 1.0
           B = FIX(FIndGen(cid)/(cid-1)*255)
       END ELSE BEGIN
           perc = mid / (mid-mad) 
           border = mici + fix (cid * perc)
           
           IF perc LT 0.5 THEN BEGIN
               scale_r = 255 
               scale_b = FIX(perc*cid/(1-perc))
           END ELSE BEGIN
               scale_r = FIX(cid*(1-perc)/perc)
               scale_b = 255
           END
           
           R(border:maci) = FIX( FindGen(maci+1-border) / (maci+1-1-border) * scale_r )
           B(mici:border) = REVERSE(FIX( FindGen(border-mici+1) / Float(border-mici) * scale_b))
           
       END
   END
   
   IF Set(BBR) THEN UTVLCT,R,G,B 
   IF Set(GBR) THEN UTVLCT,R,B,G
   
END

