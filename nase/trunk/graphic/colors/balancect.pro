;+
; NAME:
;  BalanceCT
;
; VERSION:
;  $Id$
;
; AIM:
;  generates a linear, exponential or logarrithmic colortable suitable to display positive and/or negative data
;
; PURPOSE:
;  Creates a colortable to display your two dimensional data with a
;  color code, which can be displayed using <A>PTvS</A> or
;  others. The main advantage to using a fixed colormap is that you
;  do not have to scale your data to match the color table.
;  The colors are best matched to the individual data, in
;  the sense that no entries in the colortable are wasted, because the
;  data is not equally distributed around zero. The routine assures
;  that MAX(ABS(data)) is displayed with maximal saturation, but in
;  general the colortable is not symmetric around the neutral
;  element. The neutral element (which will be either black or white)
;  is by default MIN(ABS(data)), but you can specify arbitrary values.
;  You may use a linear, logarithmic or
;  exponential distribution of color values.
;
; CATEGORY:
;  Color
;  Graphic
;
; CALLING SEQUENCE:
;*BalanceCT [,data] [,TOP=...] [, {/TOPRED | /TOPGREEN | /TOPBLUE} ]
;*                             [, {/ZEROBLACK | /ZEROWHITE} ]
;*                             [, NEUTRAL=...]
;*                             [, {/BOTTOMRED | /BOTTOMGREEN | /BOTTOMBLUE} ]
;*                             [ {,EXP=...} | {,LOG=...} ]
;
; INPUTS:
;  data :: the color table is adapted to this specific data. If not
;          specified, the colortable will be symmetric around zero.
;
; OPTIONAL INPUTS:
;  TOP :: The colortable will occupy the elements <*>0..TOP</*> in the
;          colormap. To be compliant with the NASE color management,
;          the default is <*>!TOPCOLOR</*>.
;
; INPUT KEYWORDS:
;  BOTTOMRED,BOTTOMGREEN,BOTTOMBLUE :: negative values are displayed red, green
;                             or blue (default: <*>BOTTOMBLUE</*>)
;  NEUTRAL                 :: specifies the data value that will be
;                             displayed either black or white (may
;                             exceed the data range and will then not be
;                             displayed). The default is <*>MIN(ABS(data))</*>.
;  TOPRED,TOPGREEN,TOPBLUE :: positive values are displayed red, green
;                             or blue (default: <*>TOPRED</*>)
;  ZEROBLACK,ZEROWHITE     :: value zero will be black (good for
;                             screen display) or white (good for
;                             postscripts), respectively. Default is <*>ZEROBLACK</*>. 
;  EXP,LOG :: allows an exponential or logarithmic scaling of the
;             otherwise linear color map. You may either enable the
;             nonlinearity using <*>/EXP</*> or <*>/LOG</*>, but if
;             you want more control, you can also give a positive
;             value to either <*>EXP</*> or <*>LOG</*>.   
;
; SIDE EFFECTS:
;  overwrites the existing colormap
;
; EXAMPLE:
;Given a set of data points that are not symmetrical distributed
;around zero, we get an asymmetric color table:
;*n=randomu(seed,20,20)-0.3
;*balancect, n & ptvs, n,/legend              
;
;You may change the neutral element of the color table  (that is white
;in this case) to be 0.5:
;*balancect, n, /topgreen, /zerowhite, neutral=0.5 & ptvs, n,/legend 
;All values above 0.5 will be slightly green. To emphasize small
;values you may use a logarithmic color table:
;*balancect, n, /log & ptvs, n,/legend 
;You can increase/decrease the effect of the nonlinearity by
;specifying values above or below 1:
;*balancect, n, log=3 & ptvs, n,/legend 
;If you have solely positive data, like
;*n=randomu(seed,20,20)+2  
;then the minimal value (black is this case) will be around 2:
;*balancect, n & ptvs, n,/legend
;by specifying
;*balancect, n, neutral=0 & ptvs, n,/legend
;you can set the origin of the color table to zero.
;-


; returns n elements scaled from 0 to 1 with linear, log, or exp scaling
FUNCTION _FINDGEN, n, LOG=logs, EXPS=exps

  ON_ERROR, 2

  z = Findgen(n)/(n-1)
  IF Set(LOGS) OR Set(EXPS) THEN BEGIN
      IF Set(LOGS) THEN f=logs ELSE f=exps
      IF F LE 0.0 THEN Console, 'EXP or LOG argument has to be positive', /FATAL
      z = alog(z*(exp(f*3)-1.)+1) 
  END
  IF Set(EXPS) THEN z = REVERSE(MAX(z)-z) ;;; this has to be the exact reverse of the log 
                                          ;;; setting because
                                          ;;; /ZEROWHITE relies on this
  RETURN, z/MAX(z)
END


PRO BALANCECT, data, TOP=maci, TOPRED=topred, TOPGREEN=topgreen, TOPBLUE=topblue, ZEROWHITE=zerowhite, ZEROBLACK=zeroblack, $
               BOTTOMRED=bottomred, BOTTOMGREEN=bottomgreen, BOTTOMBLUE=bottomblue, $
               NEUTRAL=neutral, $
               LOG=log, EXP=exp

   ON_ERROR, 2


   IF Set(LOG) AND Set(EXP) THEN Console, 'specify either EXP or LOG', /FATAL 
   IF Set(bottomred)+Set(bottomgreen)+Set(bottomblue) GT 1 THEN Console, 'only one bottom color a time', /FATAL
   IF Set(bottomred)+Set(bottomgreen)+Set(bottomblue) EQ 0 THEN bottomblue=1
   IF Set(topred)+Set(topgreen)+Set(topblue) GT 1 THEN Console, 'only one top color a time', /FATAL
   IF Set(topred)+Set(topgreen)+Set(topblue) EQ 0 THEN topred=1
   IF Set(zeroblack)+Set(zerowhite) GT 1 THEN Console, 'only one zero color a time', /FATAL
   IF Set(zeroblack)+Set(zerowhite) EQ 0 THEN zeroblack=1

   Default, maci, !TOPCOLOR        ;max used color index
   Default, mici, 0                ;min used color index

   cid = maci-mici+1             ;number of color indices used

   IF Set(data) THEN BEGIN
       mid = FLOAT(MIN(data))
       mad = FLOAT(MAX(data))
       Default, neutral, MIN(ABS(data))
   END ELSE BEGIN
       ; symmetric around zero if no data is given
       mid = -1.
       mad =  1.
       Default, neutral, 0.
   END

   mid = mid - neutral
   mad = mad - neutral


   ; nuf : negative upstroke flank
   ; puf : positive upstroke flank
   ; ndf : negative downstroke flank
   ; pdf : positive downstroke flank
   puf = intarr(cid)
   nuf = intarr(cid)
   pdf = intarr(cid)+255
   ndf = intarr(cid)+255

   perc = mid / (mid-mad) 
   border = mici + fix (cid * perc)
   
   IF perc LT 0.5 THEN BEGIN
       scale_r = 255 
       scale_b = FIX(perc*cid/(1-perc))
   END ELSE BEGIN
       scale_r = FIX(cid*(1-perc)/perc)
       scale_b = 255
   END
   
                                ; the expressions below may be
                                ; simplified, i guess, but they work and thinking
                                ; about this stuff is really ugly....
   IF (border LE maci) THEN BEGIN
       puf(MAX([0,border]):maci) = (FIX( _FindGen(maci+1-border, LOG=log, EXP=exp) * scale_r ))                         (MAX([0,-border]):maci-border)
       pdf(MAX([0,border]):maci) = REVERSE(((FIX( _FindGen(maci+1-border, LOG=exp, EXP=log) * scale_r )) + (255-scale_r))(MAX([0,-border]):maci-border))
   END
   IF (border GE mici) THEN BEGIN
       nuf(mici:MIN([border,maci])) = REVERSE((FIX( _FindGen(border-mici+1, LOG=log, EXP=exp) * scale_b ))                (MAX([0,border-maci]):border-mici))
       ndf(mici:MIN([border,maci])) =        (FIX(( _FindGen(border-mici+1, LOG=exp, EXP=log) * scale_b))  + (255-scale_b))(MAX([0,border-maci]):border-mici)
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

       IF perc LT 1. THEN BEGIN
           IF Keyword_Set(TOPRED)   THEN R = R > ndf
           IF Keyword_Set(TOPGREEN) THEN G = G > ndf
           IF Keyword_Set(TOPBLUE)  THEN B = B > ndf
       END

       IF perc GT 0. THEN BEGIN
           IF Keyword_Set(BOTTOMRED)   THEN R = R > pdf
           IF Keyword_Set(BOTTOMGREEN) THEN G = G > pdf
           IF Keyword_Set(BOTTOMBLUE)  THEN B = B > pdf
       END

   END
   UTVLCT, R, G, B

END

