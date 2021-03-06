;+
; NAME:
;  SlidCC()
;
; VERSION:
;  $Id$
; 
; AIM:
;  computes the timeresolved cross correlation beetween two given signals
;
; PURPOSE:
;  Computes the cross correlation with a sliding window.
;
; CATEGORY:
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* cc = SlidCC( x,y [,PShift [,taxis]] [,SSIZE=...] [,SSHIFT=...] [,SAMPLEPERIOD=...] [,/PLOT] [,TITLE=...]
;
; INPUTS: 
;  x,y   :: the two signals to be cross correlated
;  PShift:: the maximal amount the signals are shifted against each other, default is 64ms
;
; INPUT KEYWORDS:
;  SSIZE        :: the size of the time window, default is 128ms  (see SLICES)
;  SSHIFT       :: the amount the window is shifted, default is SSIZE/2 (see SLICES)
;  SAMPLEPERIOD :: the period of one sampled value, default is 1ms (see SLICES)
;  PLOT         :: the result is plotted in a sheet
;
; OUTPUTS:
;  cc  :: two-dimensional array (slicenr, tau)
;
; OPTIONAL OUTPUTS: 
;   taxis:: the corresponding tau-axis is returned
;
; COMMON BLOCKS: 
;  SH_SLIDCC: contains the Sheet for the Plot
;
; PROCEDURE:
;  * cut the two signal in slices via SLICES function<BR>
;  * compute the correlation via the CrossCor function for each slice<BR>
;  * plot result if wanted
;                      
; SEE ALSO:
;  <A>Slices</A>, <A>CrossCor</A>
;
;-
FUNCTION SlidCC, A,B, PShift, taxis, SSIZE=ssize, SSHIFT=sshift, SAMPLEPERIOD=sampleperiod, PLOT=plot, TITLE=title, _EXTRA=e

   COMMON SH_SLIDCC, SLIDCCwins, SLIDCC_1

   On_Error, 2

   Default, SAMPLEPERIOD, 0.001
   Default, SSIZE       , 128
   Default, SSHIFT      , SSIZE/2
   Default, PSHIFT      , 64
   RShift = PShift/(1000*SAMPLEPERIOD) ; the actual shifts
   Default, TITLE, 'Sliding CCH'
   title = title + ', slice: '+STRCOMPRESS(SSIZE, /REMOVE_ALL)+' ms'

   ;----->
   ;-----> ORGANIZE THE SHEETS
   ;----->
   IF ExtraSet(e, 'NEWWIN') THEN BEGIN
      SLIDCCwins = 0
   END
   IF ExtraSet(e, 'NOGRAPHIC') THEN BEGIN
      SLIDCC_1 = DefineSheet(/NULL)
      SLIDCCwins = 0
   END ELSE IF ExtraSet(e, 'PS') THEN BEGIN
      plot = 1
      SLIDCC_1 = DefineSheet(/PS, FILENAME='slidcc', /INCREMENTAL)
      SLIDCCwins = 0
   END ELSE BEGIN
      IF Set(SLIDCCwins) THEN BEGIN
         IF SLIDCCwins EQ 0 THEN newW = 1 ELSE newW = 0
      END ELSE newW = 1
      IF newW THEN BEGIN
         SLIDCC_1 = DefineSheet(/Window, XSIZE=500, YSIZE=500, TITLE='Sliding Whatever')
         SLIDCCwins = 1
      END
   END



   IF (SIZE(A))(0) NE 1 THEN console, /fatal, 'only for 1-d arrays'

   SA = Slices(A, SAMPLEPERIOD=SAMPLEPERIOD, SSHIFT=sshift, SSIZE=ssize) ; SA(slice,time) 
   SB = Slices(B, SAMPLEPERIOD=SAMPLEPERIOD, SSHIFT=sshift, SSIZE=ssize) ; SB(slice,time)
   

   slicenr = (SIZE(SA))(1)
   SCC = FltArr(slicenr, 2*RShift+1)
   FOR i=0,slicenr-1 DO BEGIN
       slicea = REFORM(SA(i,*))
       sliceb = REFORM(SB(i,*))
       SCC(i, *) = CrossCor(slicea, sliceb, rshift)
   END


   IF Keyword_Set(PLOT) THEN BEGIN
      OpenSheet, SLIDCC_1
      PlotTvScl, SCC, /FULLSHEET, /LEGEND, XRANGE=[-PShift,PShift], YRANGE=[0,(SIZE(A))(1)*(1000*SAMPLEPERIOD)], /ORDER, /NASE, XTITLE='!7s!3 / ms', YTITLE='t / ms', TITLE=title
      CloseSheet, SLIDCC_1
   END

   taxis = (IndGen(2*RShift+1)-RShift)*(1000*SAMPLEPERIOD)
   RETURN, REFORM(SCC,/OVERWRITE)
END
