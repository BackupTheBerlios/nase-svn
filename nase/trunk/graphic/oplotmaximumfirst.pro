;+
; NAME:
;  OPlotMaximumFirst
;
; AIM:
;  Put several plots in a single coordinate system.
;  
; PURPOSE:
;  This routine displays several plots in a single coordinate system.
;  The y-axis is scaled such that the largest and smallest value of
;  all the plots is visible.
;  
; CATEGORY:
;  GRAPHICS
;  
; CALLING SEQUENCE:
;  OPlotMaximumFirst, [xarray,] yarray 
;                     [, LINESTYLE=linestyle]
;                     [, PSYM=psym], [COLOR=color]
;                     [, _EXTRA=_extra]
;  
; INPUTS:
;  yarray: To plot n onedimensional arrays with x entries each, yarray
;          has to be of dimension (x,n). The first array yarray(*,0)
;          will be plottet using LINESTYLE=linestyle or PSYM=psym
;          respectively, the following using increasing LINESTYLE- and
;          PSYM-values. The order of the onedimensional subarrays in
;          yarray therefore determines the appearance of their
;          corresponding plots.
;  
; OPTIONAL INPUTS:
;  xarray:    X-values corresonding to the yarray entries.
;
;  linestyle: Linestyle of the first plot (yarray(*,0)), default:
;             linestyle=0, special values are:
;              linestyle=-1 -> all lines are solid (linestyle=0)
;              linestyle=-2 -> no line between data points
;
;  psym:      PSym of the first plot, special case and default:
;              psym=-1 -> no symbols
;
;  color:     Onedimensional array containing color indices of the
;             plots. If the number of colors supplied is less than the
;             number of subarrays, colors are used more than
;             once. special case and default: 
;              color=-1 -> all plots white
;
; _extra:     All other inputs and Keywords are passed the the
;             underlying Plot-procedure.
;  
; PROCEDURE:
;  1. Determine minimum and maximum of all subarrays to plot.
;  2. Plot, /NODTATA of array containing minimum and mximum and
;     therefore detemines sufficiently large y-axis.
;  3. OPlot of the arrays using specified linestyles, psyms or
;     colors.
; 
; EXAMPLE:
;  a = randomn(seed,50)
;  b = randomn(seed,50)
;  oplotmaximumfirst,[[a],[b]]
;  oplotmaximumfirst,[[a],[b]],PSYM=5,LINESTYLE=-1
;  oplotmaximumfirst,[[a],[b]],COLOR=[RGB(250,0,0),RGB(0,0,250)],LINESTYLE=-1
;  
; SEE ALSO:
;  Standard IDL-procedures Plot and OPlot with their graphics keywords
;  LINESTYLE and PSYM.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.6  2000/10/01 14:50:42  kupper
;        Added AIM: entries in document header. First NASE workshop rules!
;
;        Revision 1.5  2000/08/01 12:10:28  thiel
;            Now also handles multiple colored oplots.
;            Header translated.
;
;        Revision 1.4  1999/05/24 15:24:04  thiel
;            THICK-Keyword wird jetzt auch an OPlot weitergegeben.
;
;        Revision 1.3  1999/04/29 13:17:18  thiel
;            Und noch besser: kann jetzt auch PlotSymbols.
;
;        Revision 1.2  1999/04/29 09:49:48  thiel
;            Jetzt wird auch das Minimum beachtet.
;
;        Revision 1.1  1999/04/28 12:52:37  thiel
;            Neu!
;
;-

PRO OPlotMaximumFirst, z, zz, LINESTYLE=linestyle, PSYM=psym, THICK=thick $
                       , COLOR=color, _EXTRA=_extra

   Default, LINESTYLE, 0
   Default, PSYM, -1
   Default, COLOR, [-1]

   IF linestyle EQ -1 THEN maxlinestyle = 1 $
   ELSE maxlinestyle = 6
   maxpsym = 7

   maxcolor = N_Elements(color)

   IF N_Params() LT 1 THEN Message, 'Wrong number of arguments.'
   n = (Size(z))(1)
   IF N_Params() EQ 2 THEN BEGIN
      x = z
      y = zz
   END ELSE BEGIN
      x = LindGen(n)
      y = z
   END
 
   plotnr = (Size(y))(2)

   maxvalue = Max(IMax(y,1), index)
   minvalue = Min(IMin(y,1), index)

   nodata = y
   IF maxvalue EQ minvalue THEN nodata(0) = maxvalue $
    ELSE nodata(0:1) = [minvalue,maxvalue]

   Plot, x, nodata, /NODATA, THICK=thick, _EXTRA=_extra

   FOR n=0,plotnr-1 DO $
    OPlot, x, y(*,n) $
    , PSYM=((psym+1)<1)*(((psym+n) MOD maxpsym)- $
                         2*((linestyle+2)<1)*((psym+n) MOD maxpsym)) $
    , LINESTYLE=(linestyle+n) MOD maxlinestyle $
    , THICK=thick, COLOR=color(n MOD maxcolor)

END



   

   
