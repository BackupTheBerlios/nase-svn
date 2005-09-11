;+
; NAME:
;  UBar_Plot
;
; VERSION:
;  $Id$
;
; AIM:
;  Plots dataset using a histogram style.
;
; PURPOSE:
;  Plot dataset with values depicted as bar heights. <*>UBar_Plot</*>
;  offers several options for positioning and coloring the bars. 
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;*ubar_plot, xdata, ydata
;*           [,COLORS=...][,OFFSET=...][,BARSPACE=...]
;*           [/CENTER][/OPLOT][/SYMMETRIC]
;*           [,_EXTRA=...]
;
; INPUTS:
;  xdata:: Onedimensional array of bar positions on the abscissa.
;  ydata:: Onedimensional array of Corresponding bar heights.
;
; OPTIONAL INPUTS:
;  xbase:: The complete onedimensional array of abscissa values used
;          for bar width computation. 
;
; INPUT KEYWORDS:
;  COLORS:: Onedimensional array of color indices corresponding to the
;           values supplied in <*>xdata</*>. The same color for all bars can
;           be obtained by setting <*>COLORS</*> to a scalar value.
;  OFFSET:: Set origin of bars to <*>OFFSET</*> rather than y=0. 
;  BARSPACE:: Gap size between bars, default: 0.2 (= 20% of classwidth).
;  CENTER:: Bars are centered around their x-position, default: 1,
;           needs to be explicitly set to 0 to be turned off.
;  OPLOT:: Don't clear window before new plot, also draw axis once more.
;  SYMMETRIC:: Generate abscissa with values ranging from
;              <*>-Max(xdata)</*> to <*>Max(xdata)</*>.
;  _EXTRA:: All conventional options of <*>Plot</*>.
;                  
; OUTPUTS:
;  Bar diagram of <*>ydata</*>.
;
; EXAMPLE:
;* xdata = IndGen(20)
;* ydata = RandomU(s,20)
;* UBar_Plot, xdata, ydata, OFFSET=0.5, COLORS=255*randomn(s,20)
;
;-

PRO UBar_Plot, xdata, ydata, xbase $
               , COLORS=COLORS, OFFSET=OFFSET ,CENTER=CENTER $
               , BARSPACE=BARSPACE, SYMMETRIC=SYMMETRIC, OPLOT=OPLOT $
               , _EXTRA=e


   On_Error, 2


   DEFAULT,offset,0
   DEFAULT,OPLOT,0
   DEFAULT,colors,!P.COLOR
   DEFAULT,center,1
   DEFAULT,BARSPACE,0.2
   __xdata = xdata

   IF NOT set(ydata) THEN BEGIN 
      ydata = __xdata
      __xdata = lindgen(N_ELEMENTS(ydata))
   END

   IF NOT set(xbase) THEN BEGIN
      xbase = __xdata
   END

   IF set(colors) AND N_ELEMENTS(colors) EQ 1 THEN BEGIN
      tmp = intarr(N_ELEMENTS(ydata))
      tmp(*) = colors
      colors = tmp(*)
   END

   IF CENTER THEN BEGIN
      stepl = (Float(xbase[1]-xbase[0])/2.)*(1.-barspace/2)
      ;; setting stepr equal to stepl gives equal space on either side
      ;; of the bar, which looks nicer, so the 1-barspve/2 part has
      ;; been commented out
      stepr = stepl;*(1.-barspace/2) 
   END ELSE BEGIN 
      stepl = barspace/2
      stepr = Float(xbase[1]-xbase[0])*(1.-barspace/2)
   END

   PTMP = !P.MULTI
   IF OPLOT EQ 0 THEN BEGIN

      CASE 1 OF
         ExtraSet(e, 'XRANGE'): plot,__xdata,ydata,/NODATA,/XSTYLE,_EXTRA=e
         ExtraSet(e, 'XSTYLE'): plot,__xdata,ydata $
          ,/NODATA,XRANGE=[__xdata(0)-stepl,MAX(__xdata)+stepr],_EXTRA=e
         ELSE: IF Keyword_Set(SYMMETRIC) THEN BEGIN
            maxr = MAX([ABS(__xdata(0)-stepl),ABS(MAX(__xdata)+stepr)])
            plot,__xdata,ydata,/NODATA,XRANGE=[-maxr,maxr],/XSTYLE,_EXTRA=e
         END ELSE BEGIN
            plot,__xdata,ydata,/NODATA $
             ,XRANGE=[__xdata(0)-stepl,MAX(__xdata)+stepr],/XSTYLE,_EXTRA=e
         END 
      ENDCASE

   ENDIF ;; OPLOT EQ 0 


   PTMP2 = !P.MULTI
   FOR i= 0 , N_ELEMENTS(ydata)-1 DO BEGIN 
      x = [ __xdata(i)-stepl,__xdata(i)-stepl,__xdata(i)+ $
            stepr,__xdata(i)+stepr ]
      y = [ offset ,ydata(i),ydata(i),offset ]
      polyfill,x,y,COLOR=COLORS(i),NOCLIP=0
   ENDFOR


   IF ((OPLOT EQ 0) AND NOT Contains(!D.Name, 'PS', /IGNORECASE)) THEN BEGIN
      ;; redraw tickmarks on a screen device
      ;; not when using postscript, because overplotted
      ;; lines are annoying in corel
      
      !P.MULTI = PTMP 
      CASE 1 OF
         ExtraSet(e, 'XRANGE'): plot,__xdata,ydata $
          ,/NODATA,/NOERASE,/XSTYLE,_EXTRA=e
        ExtraSet(e, 'XSTYLE'): plot,__xdata,ydata,/NODATA $
         ,/NOERASE,XRANGE=[__xdata(0)-stepl,MAX(__xdata)+stepr],_EXTRA=e
        ELSE: IF Keyword_Set(SYMMETRIC) THEN BEGIN
           maxr = MAX([ABS(__xdata(0)-stepl),ABS(MAX(__xdata)+stepr)])
           plot,__xdata,ydata,/NODATA,/NOERASE,XRANGE=[-maxr,maxr] $
            ,/XSTYLE,_EXTRA=e
        END ELSE BEGIN
           plot,__xdata,ydata,/NODATA,/NOERASE $
            ,XRANGE=[__xdata(0)-stepl,MAX(__xdata)+stepr],/XSTYLE,_EXTRA=e
        END
     ENDCASE
  
  ENDIF ;;(OPLOT EQ 0) AND NOT Contains(!D.Name, 'PS', /IGNORECASE)
  
  !P.MULTI = PTMP2

END
