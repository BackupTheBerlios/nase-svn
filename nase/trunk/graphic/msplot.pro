;+
; NAME:
;  MSPlot
;
; AIM:
;  Plotting error values as a coloured area around data.
;  
; PURPOSE:
;  MSPLot plots onedimensional data and depicts supplied error values
;  by drawing a coloured area around the data plot.
;  
; CATEGORY:
;  GRAPHICS
;  
; CALLING SEQUENCE:
;  MSPlot [,x] ,mean ,sd [,MCOLOR=mcolor] [,SDCOLOR=sdcolor]
;
;   All other keywords are passed to the underlying Plot-and
;   Axis-procedures.
;  
; INPUTS:
;  mean : onedimensional array containing data
;  sd   : array containing corresponding error values
;  
; OPTIONAL INPUTS:
;  x       : abscissa values corresponding to mean/sd (equidistant, 0..n-1)
;  mcolor  : colourindex used for plotting the data (default: white)
;  sdcolor : colourindex used to draw error area (default: darkblue)  
;  
; PROCEDURE:
;  + plot empty coordinate system
;  + error area via PolyFill
;  + mean via oplot
;  + plot axes again to overwrite error area
;  
; EXAMPLE:
;  x  = Indgen(30)/10.
;  m  = 0.02*randomu(seed,30)+0.4
;  sd = 0.005*randomn(seed,30)+0.05
;  MSPlot, m, sd
;  MSPlot, x, m, sd, YRANGE=[0,1],/XSTYLE $
;   , MCOLOR=RGB(200,100,100), SDCOLOR=RGB(100,50,50)
;  
; SEE ALSO:
;  Standard IDL routines: OPLOTERR, PLOT, PLOTERR
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.3  2000/07/31 15:52:33  thiel
;         Now XRANGE applies to error area also and
;         ticks are plotted over error area. Header translated.
;
;     Revision 2.2  1999/12/02 14:11:23  saam
;           returns on error
;
;     Revision 2.1  1998/08/11 10:41:26  saam
;           simple
;
;-



PRO MSPLOT, z, zz, zzz $
            , MCOLOR=mcolor, SDCOLOR=sdcolor, XRANGE=xrange $
            , _EXTRA=e

   On_Error, 2

   Default, SDCOLOR, RGB(100,100,200);,/NOALLOC)
   Default, MCOLOR, RGB(255,255,255);,/NOALLOC)

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

   IF N_Elements(m) NE N_Elements(sd) THEN $
    Message, 'Mean and deviation values are of different count.'
   IF N_Elements(m) NE N_Elements(x)  THEN $
    Message, 'Abszissa and ordinate values are of different count.'
   
   IF Set(XRANGE) THEN BEGIN
      xri = [(Where(x GE xrange(0)))(0), (Where(x GT xrange(1)))(0)] 
      xf = x > XRANGE(0) < XRANGE(1)
      yr = [MIN(m(xri(0):xri(1))-sd(xri(0):xri(1))) $
            , MAX(m(xri(0):xri(1))+sd(xri(0):xri(1)))]
   ENDIF ELSE BEGIN
      xf = x
      yr = [MIN(m-sd), MAX(m+sd)]
   ENDELSE


   Plot, x, m, YRANGE=yr, /NODATA, XRANGE=xrange, _EXTRA=e

   PolyFill, [xf,xf(n-1),REVERSE(xf), xf(0)] $
    , [m+sd, m(n-1)-sd(n-1), REVERSE(m-sd), m(0)+sd(0)] $
    , COLOR=sdcolor

   OPlot, x, m, COLOR=mcolor

   emptytickn = Make_Array(30, /STRING, VALUE=' ')

   Axis, XRANGE=xrange, XAXIS=0, _EXTRA=e
   Axis, YRANGE=yr, YAXIS=0, _EXTRA=e
   Axis, XRANGE=xrange, XAXIS=1, XTICKN=emptytickn, _EXTRA=e
   Axis, YRANGE=yr, YAXIS=1, YTICKN=emptytickn, _EXTRA=e

END
