;+
; NAME: ubar_PLOT
;
;
; PURPOSE:       Routine zum plotten von Histogrammen
;
;
; CATEGORY:      GRAPHIC
;
;
; CALLING SEQUENCE:
;                  ubar_plot,xdata,ydata,[COLORS=COLORS],[OFFSET=OFFSET],[CENTER=CENTER],[BARSPACE=BARSPACE],[_EXTRA=e]
; 
; INPUTS:
;                  xdata: 1d-Array von der X-Achse 
;                  ydata: 1d-Array von der Y-Achse
;
; OPTIONAL INPUTS:
;                  COLORS: 1d-Array der Farben pro X-Wert. Eine Farbe fuer alle X-Werte erhaelt man,
;                          in dem  man COLORS auf einen Farbwert setzt.         
;	
; KEYWORD PARAMETERS:
;                  OFFSET   : Abstand der Balken von der Nullachse
;                  CENTER   : Balken werden zentriert um den x-Wert
;                  BARSPACE : Abstand zwischen den Balken (default: 0.2 [= 20% der Klassenbreite])
;                  SYMMETRIC: Darstellung symmetrisch um die Null 
;                  _EXTRA   : alle gewoehnlichen PLOT-OPTIONEN
;                  
; OUTPUTS:
;                  Balkendiagramm von YDATA
;
; EXAMPLE:
;           xdata = indgen(20)
;           ydata = RANDOMU(S,20)
;           ubar_plot,xdata,ydata,/CENTER,COLORS=RGB(255,0,0,/NOALLOC)
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.5  1998/07/21 15:41:31  saam
;           new keyword SYMMETRIC implemented
;
;     Revision 2.4  1998/07/20 14:30:01  gabriel
;          Verbessert und an die Routine hist angepasst
;
;     Revision 2.3  1998/05/12 17:48:24  gabriel
;          kleinen !P.MULTI Fehler behoben
;
;     Revision 2.2  1998/05/12 14:10:11  gabriel
;          Docu erweitert bei COLORS
;
;     Revision 2.1  1998/05/12 13:58:09  gabriel
;          Eine kleine neue Routine
;
;
;-


PRO ubar_plot,xdata,ydata,COLORS=COLORS,OFFSET=OFFSET,CENTER=CENTER,BARSPACE=BARSPACE,SYMMETRIC=SYMMETRIC,_EXTRA=e

DEFAULT,offset,0
DEFAULT,colors,!P.COLOR
DEFAULT,center,1
DEFAULT,BARSPACE,0.2
IF NOT set(ydata) THEN BEGIN 
   ydata = xdata
   xdata = indgen(N_ELEMENTS(ydata))
END

IF set(colors) AND N_ELEMENTS(colors) EQ 1 THEN BEGIN
   tmp = intarr(N_ELEMENTS(ydata))
   tmp(*) = colors
   colors = tmp(*)
END


IF CENTER THEN BEGIN
   stepl = (FLOAT(xdata(1)-xdata(0))/2.)*(1.-barspace/2) &  stepr = stepl*(1.-barspace/2) 
END ELSE BEGIN 
      stepl = barspace/2 & stepr = FLOAT(xdata(1)-xdata(0))*(1.-barspace/2)
END
PTMP = !P.MULTI
;print,!P.MULTI
CASE 1 OF
   ExtraSet(e, 'XRANGE'): plot,xdata,ydata,/NODATA,/XSTYLE,_EXTRA=e
   ExtraSet(e, 'XSTYLE'): plot,xdata,ydata,/NODATA,XRANGE=[xdata(0)-stepl,MAX(xdata)+stepr],_EXTRA=e
   ELSE : IF Keyword_Set(SYMMETRIC) THEN BEGIN
             maxr = MAX([ABS(xdata(0)-stepl),ABS(MAX(xdata)+stepr)])
             plot,xdata,ydata,/NODATA,XRANGE=[-maxr,maxr],/XSTYLE,_EXTRA=e
          END ELSE BEGIN
             plot,xdata,ydata,/NODATA,XRANGE=[xdata(0)-stepl,MAX(xdata)+stepr],/XSTYLE,_EXTRA=e
          END 
ENDCASE
PTMP2 = !P.MULTI
;print,!P.MULTI

FOR i= 0 , N_ELEMENTS(ydata)-1 DO BEGIN 
   x = [ xdata(i)-stepl,xdata(i)-stepl,xdata(i)+stepr,xdata(i)+stepr ]
   y = [ offset ,ydata(i),ydata(i),offset ]
   polyfill,x,y,COLOR=COLORS(i),NOCLIP=0

END

;;Und Nochmal Drueber
;print,!P.MULTI
!P.MULTI = PTMP 
CASE 1 OF
   ExtraSet(e, 'XRANGE'): plot,xdata,ydata,/NODATA,/NOERASE,/XSTYLE,_EXTRA=e
   ExtraSet(e, 'XSTYLE'): plot,xdata,ydata,/NODATA,/NOERASE,XRANGE=[xdata(0)-stepl,MAX(xdata)+stepr],_EXTRA=e
   ELSE : IF Keyword_Set(SYMMETRIC) THEN BEGIN
             maxr = MAX([ABS(xdata(0)-stepl),ABS(MAX(xdata)+stepr)])
             plot,xdata,ydata,/NODATA,XRANGE=[-maxr,maxr],/XSTYLE,_EXTRA=e
          END ELSE BEGIN
             plot,xdata,ydata,/NODATA,/NOERASE,XRANGE=[xdata(0)-stepl,MAX(xdata)+stepr],/XSTYLE,_EXTRA=e
          END
ENDCASE
!P.MULTI = PTMP2
;print,!P.MULTI


END

;xdata = indgen(20)
;ydata = RANDOMN(S,20)
;ubar_plot,xdata,ydata,/CENTER
;END
