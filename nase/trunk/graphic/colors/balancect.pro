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
;  color code, which can be displayed using <A>PlotTvSCL</A> or
;  others. The main advantage to using a fixed colormap is that you
;  do not have to scale your data to match the color table.
;  The colors are best matched to the individual data, in
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
;* BalanceCT, data [,TOP=...]  [, {/TOPRED | /TOPGREEN | /TOPBLUE} ]
;*                             [, {/ZEROBLACK | /ZEROWHITE} ]
;*                             [, {/BOTTOMRED | /BOTTOMGREEN | /BOTTOMBLUE} ]
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
;  TOPRED,TOPGREEN,TOPBLUE :: positive values are displayed red, green
;                             or blue (default: <*>TOPRED</*>)
;  ZEROBLACK, ZEROWHITE    :: value zero will be black (good for
;                             screen display) or white (good for
;                             postscripts), respectively. Default is <*>ZEROBLACK</*>. 
;  BOTTOMRED,BOTTOMGREEN,BOTTOMBLUE :: negative values are displayed red, green
;                             or blue (default: <*>BOTTOMBLUE</*>)
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
PRO BALANCECT, data, TOP=maci, TOPRED=topred, TOPGREEN=topgreen, TOPBLUE=topblue, ZEROWHITE=zerowhite, ZEROBLACK=zeroblack, $
               BOTTOMRED=bottomred, BOTTOMGREEN=bottomgreen, BOTTOMBLUE=bottomblue

   ON_ERROR, 2


   IF Set(bottomred)+Set(bottomgreen)+Set(bottomblue) GT 1 THEN Console, 'only one bottom color a time', /FATAL
   IF Set(bottomred)+Set(bottomgreen)+Set(bottomblue) EQ 0 THEN bottomblue=1
   IF Set(topred)+Set(topgreen)+Set(topblue) GT 1 THEN Console, 'only one top color a time', /FATAL
   IF Set(topred)+Set(topgreen)+Set(topblue) EQ 0 THEN topred=1
   IF Set(zeroblack)+Set(zerowhite) GT 1 THEN Console, 'only one zero color a time', /FATAL
   IF Set(zeroblack)+Set(zerowhite) EQ 0 THEN zeroblack=1

   Default, maci, !TOPCOLOR        ;max used color index
   Default, mici, 0                ;min used color index
  

   cid = maci-mici+1             ;number of color indices used

   mid = MIN(data)
   mad = MAX(data)
   
   ; nuf : negative upstroke flank
   ; puf : positive upstroke flank
   ; ndf : negative downstroke flank
   ; pdf : positive downstroke flank
   puf = intarr(cid)
   nuf = intarr(cid)
   pdf = intarr(cid)+255
   ndf = intarr(cid)+255
   IF mid GE 0.0 THEN BEGIN
       perc = 0.0
       puf = FIX(FIndGen(cid)/(cid-1)*255)
       pdf = REVERSE(puf)
   END ELSE BEGIN
       IF mad LE 0.0 THEN BEGIN
           perc = 1.0
           ndf = FIX(FIndGen(cid)/(cid-1)*255)
           nuf = REVERSE(ndf)
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
           
           puf(border:maci) = FIX( FindGen(maci+1-border) / (maci+1-1-border) * scale_r )
           pdf(border:maci) = REVERSE(FIX( FindGen(maci+1-border) / (maci+1-1-border) * scale_r )) + (255-scale_r)
           nuf(mici:border) = REVERSE(FIX( FindGen(border-mici+1) / Float(border-mici) * scale_b ))
           ndf(mici:border) = (FIX( FindGen(border-mici+1) / Float(border-mici) * scale_b)) + (255-scale_b)
       END
   END

   IF Keyword_Set(ZEROBLACK) THEN BEGIN
       R = intarr(cid)
       G = intarr(cid)
       B = intarr(cid)

       IF Keyword_Set(TOPRED)   THEN R = R + puf
       IF Keyword_Set(TOPGREEN) THEN G = G + puf
       IF Keyword_Set(TOPBLUE)  THEN B = B + puf

       IF Keyword_Set(BOTTOMRED)   THEN R = R + nuf
       IF Keyword_Set(BOTTOMGREEN) THEN G = G + nuf
       IF Keyword_Set(BOTTOMBLUE)  THEN B = B + nuf

   END ELSE BEGIN
       R = ndf+pdf-MIN(ndf+pdf)
       G = ndf+pdf-MIN(ndf+pdf)
       B = ndf+pdf-MIN(ndf+pdf)

       IF Keyword_Set(TOPRED)   THEN R = R + ndf
       IF Keyword_Set(TOPGREEN) THEN G = G + ndf
       IF Keyword_Set(TOPBLUE)  THEN B = B + ndf

       IF Keyword_Set(BOTTOMRED)   THEN R = R + pdf
       IF Keyword_Set(BOTTOMGREEN) THEN G = G + pdf
       IF Keyword_Set(BOTTOMBLUE)  THEN B = B + pdf
   END
   UTVLCT, R, G, B
   
END

