;+
; NAME:
;  OPlotMaximumFirst
;
; VERSION:
;  $Id$
;
; AIM:
;  Put several plots into a single coordinate system.
;  
; PURPOSE:
;  This routine displays several plots in a single coordinate system.
;  The y-axis is scaled such that the largest and smallest value of
;  all the plots are visible.
;  
; CATEGORY:
;  Array
;  Graphic
;  
; CALLING SEQUENCE:
;*  OPlotMaximumFirst, [xarray,] yarray 
;*                     [, LINESTYLE=...]
;*                     [, PSYM=...]
;*                     [, COLOR=...]
;*                     [, _EXTRA=...]
;  
; INPUTS:
;  yarray:: To plot n onedimensional arrays with x entries each, yarray
;          has to be of dimension (x,n). The first array yarray(*,0)
;          will be plottet using LINESTYLE=linestyle or PSYM=psym
;          respectively, the following using increasing LINESTYLE- and
;          PSYM-values. The order of the onedimensional subarrays in
;          yarray therefore determines the appearance of their
;          corresponding plots.<BR>
;          If the passed arrays are one-dimensional,
;          <C>OPlotMaximumFirst</C> simply calls the standard
;          <C>PLOT</C> routine and exits.
;  
; OPTIONAL INPUTS:
;  xarray::    X-values corresponding to the yarray entries.
;
; INPUT KEYWORDS:
;  linestyle:: Linestyle of the first plot (yarray(*,0)),<BR>
;              default: linestyle=0, special values are:<BR>
;              linestyle=-1 -> all lines are solid<BR>
;              linestyle=-2 -> no lines between data points
;
;  psym::      PSym of the first plot, special case and default:<BR>
;              psym=-1 -> no symbols
;
;  color::     Onedimensional array containing color indices of the
;             plots. If the number of colors supplied is less than the
;             number of subarrays, colors are used more than
;             once. special case and default:<BR>
;              color=-1 -> all plots white
;
;  _extra::     All other inputs and Keywords are passed the the
;               underlying Plot-procedure.
;  
; PROCEDURE:
;  1. Determine minimum and maximum of all subarrays to plot.<BR>
;  2. Plot, /NODTATA of array containing minimum and maximum and
;     therefore detemines sufficiently large y-axis.<BR>
;  3. OPlot of the arrays using specified linestyles, psyms or
;     colors.<BR>
; 
; RESTRICTIONS:
;  If the passed arrays are one-dimensional, <C>OPlotMaximumFirst</C>
;  simply calls the standard <C>PLOT</C> routine and exits.
;
; EXAMPLE:
;*  a = randomn(seed,50)
;*  b = randomn(seed,50)
;*  oplotmaximumfirst,[[a],[b]]
;*  oplotmaximumfirst,[[a],[b]],PSYM=5,LINESTYLE=-1
;*  oplotmaximumfirst,[[a],[b]],COLOR=[RGB(250,0,0),RGB(0,0,250)],LINESTYLE=-1
;  
; SEE ALSO:
;  Standard IDL-procedures <C>Plot</C> and <C>OPlot</C> with their
;  graphics keywords <*>LINESTYLE</*> and <*>PSYM</*>.
;-

PRO OPlotMaximumFirst, z, zz $
                       , LINESTYLE=linestyle, PSYM=psym, THICK=thick $
                       , COLOR=color, XRANGE=xrange $
                       , _EXTRA=_extra

   ;; Fallback to normal PLOT routine for oinedimensional arrays:
   If size(z, /N_Dimensions) eq 1 then begin
      Console, /Msg, "Passed onedimensional data. Fallback to normal " + $
        "PLOT routine."
      if set(color) then color_ = color[0]
      If set(zz) then $
        Plot, z, zz $
        , LINESTYLE=linestyle, PSYM=psym, THICK=thick $
        , COLOR=color_, XRANGE=xrange $
        , _EXTRA=_extra $
        else $
        Plot, z $
        , LINESTYLE=linestyle, PSYM=psym, THICK=thick $
        , COLOR=color_, XRANGE=xrange $
        , _EXTRA=_extra
      return
   endif


   Default, LINESTYLE, 0
   Default, PSYM, -1
   Default, COLOR, [GetForeground()]

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
 
   Default, xrange, [min(x), max(x)]

   xri = [(Where(x GE xrange(0)))(0), last((Where(x LE xrange(1))))] 

   maxvalue = Max(IMax(y(xri(0):xri(1),*),1));, index)
   minvalue = Min(IMin(y(xri(0):xri(1),*),1));, index)

   plotnr = (Size(y))(2)


   nodata = y
   IF maxvalue EQ minvalue THEN nodata(xri(0)) = maxvalue $
    ELSE nodata(xri(0):xri(0)+1) = [minvalue,maxvalue]

   Plot, x, nodata, /NODATA, THICK=thick, XRANGE=xrange, _EXTRA=_extra

   FOR n=0,plotnr-1 DO $
    OPlot, x, y(*,n) $
    , PSYM=((psym+1)<1)*(((psym+n) MOD maxpsym)- $
                         2*((linestyle+2)<1)*((psym+n) MOD maxpsym)) $
    , LINESTYLE=(linestyle+n) MOD maxlinestyle $
    , THICK=thick, COLOR=color(n MOD maxcolor)

END



   

   
