;+
; NAME:     SPHASEVELOCITY
;
; AIM:                 detecting linear phaseshifts within the timeresolved <A NREF=spatiotempcorr >STCH</A>  
;
; PURPOSE:             A function for detecting linear phaseshifts (incl. phase velocity) from a spatiotemporal correlation.
;                      The points used for the linear regression fit are the maxima of each spatiotemporal correlation window
;                      in relation to the delay axis.
;                      SEE ALSO: <A>SPATIOTEMPCORR</A>           
;
;
; CATEGORY: Signals
;
;
; CALLING SEQUENCE:    vel = SPHASEVELOCITY(  A [, distance_ax] [, delay_ax][, time_ax][, ICHISQ=ICHISQ],[ISUPPORTP=ISUPPORTP]
;                                                    [,CORRSTRENGHTH_CRIT=CORRSTRENGHTH_CRIT][,IMED_CORRSTRENGTH=IMED_CORRSTRENGTH]
;                                                    [,SUPPORTPOINTS_CRIT=SUPPORTPOINTS_CRIT][,CHISQ_CRIT=CHISQ_CRIT,] [PLOT=PLOT],[INTERPOL=INTERPOL],[PHASE=PHASE])
;
; 
; INPUTS:              three dimensional array  (spatial correlation, temporal correlation, time)
;
;
; OPTIONAL INPUTS:
;                      distance_ax:  axis values for each correlation window in relation to spatial correlation [mm]
;                      delay_ax:      axis values for each correlation window in relation to temporal correlation [ms]
;                      time_ax :      temporal axis values for each correlation window [ms]
;	
; KEYWORD PARAMETERS:
;                      CHISQ_CRIT: The criterion for the linear regression fit. The standard deviation must be lower 
;                                  than CHISQ_CRIT to obtain successfull fit (default: 1.0).
;                      SUPPORTPOINTS_CRIT: The minimum of points, which should be  used for the fit in percent (default: 0.5)
;                      CORRSTRENGTH_CRIT: The maximum of the standard deviation of the correllation strenght, which (default: 0.05ä)
;                      PLOT: plots the actual processing results
;                      INTERPOL: zoom factor of result's spatiotemporal  dimensions (interpolation after correlation is systemtheoretical allowed) 
;
; OUTPUTS:             vel: reciprocal phase velocity
;
;
; OPTIONAL OUTPUTS:
;                      ICHISQ:            standard deviation of the linear regression fit for each spatiotemporal 
;                                         correlation window
;                      ISUPPORTP:         the number of points, which were used for the linear regression fit in percent 
;                                         for each spatiotemporal correlation window
;                      IMED_CORRSTRENGTH: median correlation strength of the points, which were used for the linear regression fit,
;                                         for each spatiotemporal correlation window (range: [0,1])
;                      PHASE:             phase shift as function of distance for each spatiotemporal correlation window
;                                         
;                      all arrays above have the dimension type (time[,data])
;
; COMMON BLOCKS:
;                COMMON SPHASEVELOCITY_BLOCK, SHEET_1, PLOTFLAG
;                only for plotting.
;
; EXAMPLE:
;                
;                mult = 2
;                test = fltarr(7,200)
;                smovie = size(test)
;                x = sin(lindgen(smovie(2))/20.*2*!Pi)
;                sinus signal shifted above 2ms over space
;                j = 2
;                test(0,*) = shift(x(*),0)
;                test(1,*) = shift(x(*),1*j)
;                test(2,*) = shift(x(*),2*j)
;                test(3,*) = shift(x(*),3*j)
;                test(4,*) = shift(x(*),4*j)
;                test(5,*) = shift(x(*),5*j)
;                test(6,*) = shift(x(*),6*j);
;
;                signal interpolated in the direction of space
;                signal=congrid(test,smovie(1)*mult,smovie(2),/cubic) 
;                erg1 = spatiotempcorr(signal,distance_ax,delay_ax,time_ax,xsample=0.001/FLOAT(MULT),SAMPLEPERIOD=0.001)
;                vel = sphasevelocity(erg1,distance_ax,delay_ax,time_ax,ICHISQ=ICHISQ,/PLOT)
;                index = where(ICHISQ NE -1)
;                sheet=definesheet(/WINDOW,XSIZE=600,YSIZE=400,COLOR=256)
;                opensheet,sheet
;                !P.MULTI=[0,2,1]
;                plottvscl,transpose(signal),/FULL,XRANGE=[time_ax(0),last(time_ax)],XTITLE="time / ms",YTITLE="channel No.",TITLE="Signal"
;                plot,time_ax(index),vel(index),XTITLE="time / ms",YTITLE="recipr. phase velocity / s per m",TITLE="Reziprocal Phase Velocity",YRANGE=[-4,4],/XSTYLE
;                closesheet,sheet
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.9  2000/09/28 12:09:29  gabriel
;          AIM tag added , message <> console, CORRSTRENGTH_CRIT now uses FZT
;
;     Revision 1.8  2000/09/01 14:52:06  gabriel
;           Bug fixed: SUPPORTPOINTS_CRIT for small electrode arrays
;
;     Revision 1.7  2000/07/04 17:48:28  saam
;           + defaults in docheader didn't match
;             implementation
;
;     Revision 1.6  2000/07/04 15:13:31  gabriel
;          FIX for slow velocities
;
;     Revision 1.5  1999/03/21 13:33:43  gabriel
;          Phase Null Korrektur
;
;     Revision 1.4  1999/03/21 09:55:54  gabriel
;          Phase Keyword new
;
;     Revision 1.3  1999/03/12 10:07:50  gabriel
;          INTERPOL Keyword new
;
;     Revision 1.2  1999/02/12 15:52:49  gabriel
;          An Handle sheets angepasst
;
;     Revision 1.1  1999/02/02 14:32:28  gabriel
;          was neues
;
;
;
FUNCTION SPHASEVELOCITY, A, distance_ax, delay_ax, time_ax, ICHISQ=ICHISQ,SUPPORTPOINTS_CRIT=SUPPORTPOINTS_CRIT,$
                         ISUPPORTP=ISUPPORTP, CORRSTRENGTH_CRIT=CORRSTRENGTH_CRIT,$
                         IMED_CORRSTRENGTH=IMED_CORRSTRENGTH,CHISQ_CRIT=CHISQ_CRIT, PLOT=PLOT,$
                         VERBOSE=VERBOSE,INTERPOL=INTERPOL,PHASE=PHASE

COMMON SPHASEVELOCITY_BLOCK, SHEET_1,PLOTFLAG

sa = size(a)
IF sa(0) NE 3 THEN console, /fatal,"Array isn't a three dimensional array A(distance,delay,time)"
default,INTERPOL,1
default,distance_ax,lindgen(sa(1))-sa(1)/2.
default,delay_ax,lindgen(sa(2))-sa(2)/2.
default, time_ax,lindgen(sa(3))
default,CHISQ_CRIT,1.0
default,SUPPORTPOINTS_CRIT,0.5
default,CORRSTRENGTH_CRIT,0.05
default,PLOTFLAG,0
default,plot,0
default,verbose,0
interpoldim = [(sa(1)/2*interpol*2)+1,(sa(2)/2*interpol*2)+1]

;distance_ax = (lindgen(interpoldim(0))/FLOAT(interpol)-sa(1)/2.)/FLOAT(sa(1))*last(distance_ax)*2.
;delay_ax = (lindgen(interpoldim(1))/FLOAT(interpol)-sa(2)/2.)/FLOAT(sa(2))*last(delay_ax)*2.
distance_ax = (lindgen(interpoldim(0))/FLOAT(interpoldim(0)-1)-0.5)*last(distance_ax)*2
delay_ax =(lindgen(interpoldim(1))/FLOAT(interpoldim(1)-1)-0.5)*last(delay_ax)*2

iCHISQ = fltarr(sa(3))
iMED_CORRSTRENGTH = fltarr(sa(3))
ISUPPORTP =  fltarr(sa(3))
vel = fltarr(sa(3))
default, XSIZE , 300
IF PLOTFLAG EQ 0 AND PLOT EQ 1 THEN BEGIN
   sheet_1 =  definesheet(/window,XSIZE=XSIZE,YSIZE=1.5*XSIZE,colors=255)
   plotflag = 1
ENDIF

IF PLOT EQ 1 THEN BEGIN 
   pix_1 = definesheet( /WINDOW ,XSIZE=XSIZE,YSIZE=XSIZE,/PIXMAP)
  
   pix_2 = definesheet( /WINDOW ,XSIZE=XSIZE,YSIZE=.5*XSIZE,/PIXMAP)
ENDIF
phase = fltarr(sa(3),N_ELEMENTS(distance_ax))
FOR i=0 ,sa(3)-1 DO BEGIN
  
   

   IF interpol EQ 1 THEN BEGIN
      tmparray = a(*,*,i)
   END ELSE BEGIN 
      tmparray = congrid(a(*,*,i),N_ELEMENTS(distance_ax),N_ELEMENTS(delay_ax),cubic=-0.5,/minus)
      ;spezial correktur, interpolation verschmiert das Maximum der Autokorrelation 
      maxofarr = max(tmparray)
      tmparray = tmparray/maxofarr
      tmparray(N_ELEMENTS(distance_ax)/2,N_ELEMENTS(delay_ax)/2) = maxofarr
      tmparray = tmparray/maxofarr
   ENDELSE   
   tmpmax =  imax(tmparray,0,index)
   t_indtmp = DELAY_AX(index) 
   phase(i,*) = t_indtmp
   X_indtmp = DISTANCE_AX
   ;stop
   IF PLOT EQ 1 THEN BEGIN
     
      opensheet,pix_1
      !p.multi = 0
      plottvscl,(1+BYTSCL(tmparray)/255.*FLOAT(!D.TABLE_SIZE-3)),$
       /full,xrange=[ROUND(distance_ax(0))+1,ROUND(last(distance_ax))-1],YRANGE=[delay_ax(0),last(delay_ax)],YTITLE="delay / !8ms!X",$
       XTITLE="distance / !8mm!X",TITLE="Spatiotemporal Correlation",/NOSCALE
      inscription,STRING(FORMAT='("Time:", (I5)," ")',ROUND(time_ax(i))),/INSIDE,/RIGHT,/BOTTOM
     
   ENDIF
   findex = lindgen(N_ELEMENTS(x_indtmp))
   CHISQ = 200
   max_sdev = 1.
   steig = (last(delay_ax)-delay_ax(0))/(distance_ax(last(findex))-distance_ax(findex(0)))
   ;;max_moment = umoment(tmpmax(findex),SDEV=MAX_SDEV)
   IF verbose EQ 1 THEN console,/info,"-------------------------------------------------------------"

   WHILE (MAX_SDEV GT CORRSTRENGTH_CRIT) OR (CHISQ GT CHISQ_CRIT) DO BEGIN
      ;;Verteilung der Maxima ohne autocorr
      ;;if (N_ELEMENTS(findex)-1)-1*interpol LT 0 then stop
      tmpfindex = (shift(findex,-N_ELEMENTS(findex)/2))(1*interpol:*) 
      ;stop
      
      max_moment_fzt= umoment(FZT(tmpmax(tmpfindex),-1))
      max_moment = FZT(max_moment_FZT(0),1)
      MAX_SDEV_ARR =  [(FZT(max_moment_FZT(0)+sqrt(max_moment_FZT(1)),1), $
                   FZT(max_moment_FZT(0)-sqrt(max_moment_FZT(1)),1))]
      ;max_moment = umoment(tmpmax(tmpfindex),SDEV=MAX_SDEV )
      MAX_SDEV=(MAX_SDEV_ARR(0)- MAX_SDEV_ARR(1))/2.
      ;;TMP_MAX_SDEV=MAX_SDEV
      ;;linearer Fit
      regtmp = linfit(x_indtmp(findex),t_indtmp(findex),CHISQ=CHISQ)  
      CHISQ = CHISQ/FLOAT(N_ELEMENTS(findex))
      steig = (last(delay_ax)-delay_ax(0))/(distance_ax(last(findex))-distance_ax(findex(0)))
      IF verbose EQ 1 THEN console,/info,"CHISQ:",CHISQ,'  MEDIAN:',max_moment(0),'  MAX_SDEV:',MAX_SDEV ,'  SUPPORTP:',N_ELEMENTS(findex)/FLOAT(N_ELEMENTS(DISTANCE_AX))
      IF (MAX_SDEV GT CORRSTRENGTH_CRIT)  OR  (CHISQ GT CHISQ_CRIT) THEN findex = findex(1:N_ELEMENTS(findex)-2)
      
      IF N_ELEMENTS(findex) LT ((SUPPORTPOINTS_CRIT*N_ELEMENTS(DISTANCE_AX)) > 3) THEN BEGIN
         CHISQ = -1
         MAX_SDEV = 0
          
         IF verbose EQ 1 THEN console,/info,'--------> TO THE TRUSH'
      ENDIF
   ENDWHILE
   ;;steigungkriterium
   IF N_ELEMENTS(findex)+1 LT N_ELEMENTS(DISTANCE_AX) AND abs(regtmp(1)) LT abs(steig) THEN BEGIN
      CHISQ = -1
      MAX_SDEV = 0
      IF verbose EQ 1 THEN console,/info,'Steigung --------> TO THE TRUSH'
   ENDIf
   IF PLOT EQ 1 THEN BEGIN
      oplot,X_indtmp(findex),t_indtmp(findex),PSYM=1
      IF CHISQ NE -1 THEN oplot,distance_ax,regtmp(0)+regtmp(1)*distance_ax
      
      closesheet,pix_1
      opensheet,pix_2
      !P.MULTI = 0
      plot,distance_ax,tmpmax,YRANGE=[0,1.5],/YSTYLE,/XSTYLE,XTITLE="distance / !8mm!X",$
       YTITLE="corr. strength",TITLE="Maxima Signed Above"
      IF CHISQ NE -1 THEN SCOLOR =RGB(255,0,0,/noalloc) $
      ELSE SCOLOR=RGB(0,0,255,/noalloc)
 
      oplot,distance_ax,REPLICATE(MAX_SDEV_ARR(0),N_ELEMENTS(distance_ax)),COLOR=SCOLOR
      oplot,distance_ax,REPLICATE(MAX_SDEV_ARR(1),N_ELEMENTS(distance_ax)),COLOR=SCOLOR


      closesheet,pix_2 
      opensheet,sheet_1
      !p.multi = 0
      device,copy=[0,0,XSIZE-1,XSIZE-1,0,.5*XSIZE,getwinid(pix_1)]
      device,copy=[0,0,XSIZE,.5*XSIZE-1,0,0,getwinid(pix_2)]
      closesheet,sheet_1
   ENDIF
;;   IF N_ELEMENTS(findex)+(1*interpol) LT N_ELEMENTS(DISTANCE_AX) AND abs(regtmp(1)) GE abs(steig) AND CHISQ NE -1 THEN BEGIN
;;      stop
 ;;  ENDIF
   vel(i) = regtmp(1)
   iCHISQ(i) = CHISQ
   iMED_CORRSTRENGTH(i) = max_moment(0)
   ISUPPORTP(i) = N_ELEMENTS(findex)/FLOAT(N_ELEMENTS(DISTANCE_AX))
      
;stop
ENDFOR
IF PLOT EQ 1 THEN DestroySheet, pix_1
return, VEL
END
