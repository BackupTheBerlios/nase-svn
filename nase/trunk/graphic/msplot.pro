;+
; NAME:                MSPlot
;
; PURPOSE:             Plottet den Mittelwert einer einparametrigen Abhaegigkeit
;                      und hinterlegt ihn mit einer Flaeche, die die Standard-
;                      abweichung darstellt.
;
; CATEGORY:            GRAPHIC STAT
;
; CALLING SEQUENCE:    MSPlot [,x] ,mean ,sd [,MCOLOR=mcolor] [,SDCOLOR=sdcolor]
;
;                      ----------
;                       ACHTUNG:  alle weiteren keywords werden an plot weitergereicht
;                      ----------
;
; INPUTS:              mean    : Array, das den Mittelwert enthaelt
;                      sd      : Array, das die Standardabweichunf enthaelt 
;
; OPTIONAL INPUTS:     x       : zu mean/sd gehoerige Abszissenwerte (equidistant, 0..n-1)
;
; KEYWORD PARAMETERS:  MCOLOR  : Farbindex fuer den Mittelwert         (Default: weiss)
;                      SDCOLOR : Farbindex fuer die Standardabweichung (Default: dunkelblau)
;
; PROCEDURE:           + plots an empty coordinate system
;                      + standard deviation via PolyFill
;                      + mean via oplot
;
; EXAMPLE:
;                      x  = Indgen(30)/10.
;                      m  = 0.02*randomu(seed,30)+0.4
;                      sd = 0.005*randomn(seed,30)+0.05
;                      MSPlot, m, sd
;                      MSPlot, x, m, sd, YRANGE=[0,1], MCOLOR=RGB(200,100,100,/NOALLOC), SDCOLOR=RGB(100,50,50,/NOALLOC)
;                       
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.1  1998/08/11 10:41:26  saam
;           simple
;
;
;-
PRO MSPLOT, z, zz, zzz, MCOLOR=mcolor, SDCOLOR=sdcolor, _EXTRA=e

   Default, MCOLOR , RGB(255,255,255,/NOALLOC)
   Default, SDCOLOR, RGB(100,100,200,/NOALLOC)
   
   IF N_Params() LT 2 THEN Message, 'wrong number of arguments'
   n = N_Elements(z)
   IF N_Params() EQ 3 THEN BEGIN
      x  = REFORM(z)
      m  = REFORM(zz)
      sd = REFORM(zzz)
   END ELSE BEGIN
      x  = LindGen(n)
      m  = REFORM(z)
      sd = REFORM(zz)
   END
   IF N_Elements(m) NE N_Elements(sd) THEN Message, 'mean and deviation values are of different count'
   IF N_Elements(m) NE N_Elements(x)  THEN Message, 'abszissa and ordinate values are of different count'
   
   plot, x, m, YRANGE=[MIN([m-sd]), MAX([m+sd])], /NODATA, _EXTRA=e

   PolyFill, [x,x(n-1),REVERSE(x), x(0)], [m+sd, m(n-1)-sd(n-1), REVERSE(m-sd), m(0)+sd(0)], COLOR=sdcolor
   oplot,  x, m   , COLOR=mcolor

END
