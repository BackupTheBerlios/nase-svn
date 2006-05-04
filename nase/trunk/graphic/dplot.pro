;+
; NAME:
;  DPlot  
;
; VERSION:
;  $Id$
;
; AIM:
;  Generates two graphs with different ordinate scaling in the same plot.
;
; PURPOSE:
;  Generates two graphs with different ordinate scaling in the same plot.
;  The scaling for the first plot is on the left side, while the
;  second is placed on the right side.
;
; CATEGORY:
;  Graphic
;
; CALLING SEQUENCE:
;* DPlot, x, y1, y2, _EXTRA=e
;
; INPUTS:
;  x  :: common absizza values
;  y1 :: ordinate values for the first plot (left axis)
;  y2 :: ordinate values for the second plot (right axis)
;
; INPUT KEYWORDS:
;  + all standard plot keyword are passed to the first plot<BR>
;  + plot keywords with an additional '2' like <*>YRANGE2</*> are
;    passed to the second plot
;
; EXAMPLE:            
;* x=findgen(100)/10.
;* y1=sin(x)
;* y2=0.25*randomu(seed,100)
;* dplot, x, y1, y2, ytitle='sinus', yrange2=[0,1], ytitle2='noise'
;
;-

PRO DPlot, x, y1, y2, _EXTRA=e

   ON_ERROR, 2
   
   ;; divide keywords for different axes
   IF SET(e) THEN BEGIN
      
      rax2 = ExtraDiff(e, '2', /SUBSTRING)

      IF TypeOf(rax2) EQ 'STRUCT' THEN BEGIN
         
         ;; delete '2' from tagnames
         TN = Tag_Names(rax2)
         FOR i=0, N_ELEMENTS(TN)-1 DO BEGIN
            IF Set(rax) THEN SetTag, rax $
             , STRMID(TN(i), 0, STRLEN(TN(i))-1), rax2.(i) $
            ELSE rax = Create_Struct(STRMID(TN(i), 0 $
                                            , STRLEN(TN(i))-1), rax2.(i))
         ENDFOR
      
      ENDIF

   ENDIF


   ;; start old version---------------

; mOld = !P.Multi

; PLOT, x, y1, YSTYLE=8, XMARGIN=[10, 10], _EXTRA=e

; mAct = !P.Multi
; !P.Multi = mOld

; IF !P.MULTI(0) EQ 0 THEN !P.MULTI(0) = !P.MULTI(1)+!P.MULTI(2)
; PLOT, x, y2, XSTYLE=4, YSTYLE=4, XMARGIN=[10, 10], _EXTRA=rax
; AXIS, YAXIS=1, YRANGE = !Y.CRANGE, _EXTRA=rax

; !P.Multi = mAct

   ;; end old version---------------------


   newxmarg=[!X.MARGIN[0],!X.MARGIN[0]] 

   Plot, x, y1, YSTYLE=24, XMARGIN=newxmarg, _EXTRA=e

   Plot, x, y2, XSTYLE=5, YSTYLE=20, /NOERASE, XMARGIN=newxmarg $
         , XRANGE=!X.CRANGE, _EXTRA=rax

   Axis, YAXIS=1, YRANGE = !Y.CRANGE, _EXTRA=rax


END
