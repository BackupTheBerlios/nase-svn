;+
; NAME:                PloTopo
;
; AIM:
;  Display topology of a set of two-element weight vectors, as known
;  from Kohonen nets.
;
; PURPOSE:
;  Plottet die Topologie von zweikomponentigen Gewichtsvektoren wie
;  bei Kohonen-Netzen ueblich.
;
; CATEGORY:            GRAPHICS
;
; CALLING SEQUENCE:    Plotopo, T [,_EXTRA=e]
;
; INPUTS:              T: ein (w,h,2) Array.
;                         (x,y,0) gibt den x-Wert (x,y,1) den y-Wert des GewichtsVektors and
;                         der Stellen (x,y) an. Benachbarte Position werden durch Linienzuege verbunden.
;
; KEYWORDS:            e: alle Keywords werden an plot weitergereicht
;
; EXAMPLE:
;                      ; plot noisy retinotopy
;                      T = fltarr(20,20,2)
;                      T(*,*,0) = REBIN(Indgen(20)+1, 20, 20)+0.3*(2*randomu(seed,20,20)-1)
;                      T(*,*,1) = TRANSPOSE(REBIN(Indgen(20)+1, 20, 20)+0.3*(2*randomu(seed,20,20)-1))
;                      plotopo, T
;
; SEE ALSO:            <A HREF=http://neuro.physik.uni-marburg.de/nase/graphic/#SYMBOLPLOT>SYMBOLPLOT</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.2  2000/10/01 14:50:42  kupper
;     Added AIM: entries in document header. First NASE workshop rules!
;
;     Revision 1.1  1999/12/02 15:24:53  saam
;            + huhu, its me
;
;
;-
PRO Plotopo, T, _EXTRA=e

   ON_ERROR,2 
   
   IF NOT Set(T) THEN Message, 'argument undefined'
   S = Size(T)
   IF (S(0) NE 3) THEN Message, 'array dimensions have to be (n,m,2)' 
   IF (S(3) NE 2) THEN Message, 'array dimensions have to be (n,m,2)' 

   w = S(1)
   h = S(2)

   dminx = MIN([MIN(T(*,*,0)),0])
   dmaxx = MAX([MAX(T(*,*,0)),w])-w
   dminy = MIN([MIN(T(*,*,1)), 0])
   dmaxy = MAX([MAX(T(*,*,1)),h])-w
   dx = FIX(MAX(ABS(dminx),dmaxx)+2)
   dy = FIX(MAX(ABS(dminy),dmaxy)+2)
   
   Plot, [0,1], [0,1], /NODATA, XRANGE=[-dx, w+dx-1], YRANGE=[-dy, h+dy-1], XSTYLE=1, YSTYLE=1, _EXTRA=e
   

   FOR i=0,h-1 DO PlotS, TRANSPOSE(REFORM(T(*,i,*)))
   FOR i=0,w-1 DO PlotS, TRANSPOSE(REFORM(T(i,*,*)))
      
END

