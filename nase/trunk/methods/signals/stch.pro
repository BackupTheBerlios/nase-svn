;+
; NAME: STCH
;
; AIM:                 two dimensional time resolved spatiotemporal correalation histogramm (STCH)
;
;
; PURPOSE:              A two dimensional spatiotemporal correalation function with sliding windows. The result is normed 
;                       in relation to spatial overlap.
;
; CATEGORY: 
;     Signals
;
;
; CALLING SEQUENCE:      
;* result=stch(A [,distance_ax][,delay_ax][,time_ax][,xpshift=xpshift][,tpshift=tpshift] [,ssize=ssize]
;              [,sshift=_sshift][,SAMPLEPERIOD=SAMPLEPERIOD][,xsample=xsample],[POWER=POWER][,/VERBOSE])
; 
; 
; INPUTS:                A::    two dimensioonal array (space,time)
;
;
; KEYWORD PARAMETERS:    XPSHIFT::       the amount the window is spatially shifted against the origin window (spatial correlation interval)
;                        TPSHIFT::       the amount the window is temporally shifted against the origin window (temporal correlation interval)
;                        SSIZE::         the size of the sliding time window, default is 20ms
;                        SSHIFT::        the amount the sliding window is shifted, default is SSIZE/2
;                        SAMPLEPERIOD::  the period of one sampled time value, default is 1ms 
;                        XSAMPLE::       the period of one sampled space value, default is 1mm 
;                        SENORM::        single channel energy norm (default: 1)
;                                
;                        VERBOSE::       (default: 0)
;                                       
;
; OUTPUTS:               RESULT:: three dimensional array  (spatial correlation, temporal correlation, time)
;
;
; OPTIONAL OUTPUTS:      DISTANCE_AX:: axis values for each correlation window in relation to spatial correlation
;                        delay_ax:: axis values for each correlation window in relation to temporal correlation
;                        time_ax:: time axis values for center position of each correlation window  
;                        POWER::    the power of each sliding window as an array of time 
;
;
; EXAMPLE:               s. <A>STCHFIT</A>
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  2003/05/16 14:08:54  gabriel
;           initial commit
;
;
;
FUNCTION stch,A,distance_ax,delay_ax,time_ax,xpshift=xpshift,tpshift=_tpshift,ssize=_ssize,verbose=verbose, $
                        sshift=_sshift,SAMPLEPERIOD=SAMPLEPERIOD, xsample=xsample,POWER=POWER, senorm=senorm
   on_Error, 2
   sa = size(a)

   IF sa(0) NE 2 THEN console, /fatal,"Array isn't a two dimensional array A(space,time)"
   default, verbose, 0
   default,xpshift,FLOOR(sa(1)-1)
   default, senorm, 1
   default,SAMPLEPERIOD,0.001
   default,_ssize,20
   default,_sshift,_ssize/2
   default,_tpshift,_ssize/2
   default,xsample,0.001

   ssize =  round(_ssize/SAMPLEPERIOD/1000.)
   tpshift= round(_tpshift/SAMPLEPERIOD/1000.)
   sshift = round(_sshift/SAMPLEPERIOD/1000.)

   ;;print,tpshift
   tsize = FLOOR((sa(2)-ssize-2*(tpshift))/sshift)
   erg = make_array(size=[sa(0),xpshift*2+1,tpshift*2+1,tsize,sa(3),(xpshift*2+1)*tsize*(2*tpshift+1)])
   
   subSize = (xpshift*2+1)*(tpshift*2+1)

   power =  fltarr(tsize,2)

   distance_ax = (lindgen(xpshift*2+1)-xpshift)*FLOAT(xsample*1000)
   delay_ax = (lindgen(tpshift*2+1)-tpshift)/FLOAT(tpshift)*_tpshift
   time_ax = (tpshift+ssize/2+findgen(tsize)*sshift)*SAMPLEPERIOD*1000.
   
   ;windata = FLTARR(sa(1),2*tpshift+ssize,tsize)
   ;var_c1 = DOUBLE(ssize-1)
   ;var_c2 = DOUBLE((ssize*sa(1))-1)

   ones_vec = replicate(1.0d, ssize)

   j = 0L

   if sa(sa(0)+1) NE 5 then A = double(temporary(A))

   FOR i=tpshift ,FLOOR((tsize*sshift+tpshift)/sshift)*sshift-1 , sshift DO BEGIN
     
      data1 = (A(*,i:i+ssize-1))
      ;;mean energy
      power(j,*) = sqrt((umoment(imean(data1^2,dim=2)))(0:1))
      
      ;;zeilenweise mittelwerfrei + energie normieren (ort)
      ;;single chan energy norm
      if senorm eq 1 then begin
         column_mean = (ones_vec ## data1 )/double(ssize)
         data1 = (temporary(data1) - ones_vec ## column_mean )
         SD = sqrt(ones_vec ## (data1*data1)) 
         data1 = temporary(data1)/(ones_vec ## SD ) 
      endif;;senorm

      FOR tshift=-tpshift , tpshift DO BEGIN
         data2 = (A(*,i+tshift:i+tshift+ssize-1))

         ;;single chan energy norm
         ;;zeilenweise mittelwerfrei + energie normieren (ort)
         if senorm eq 1 then begin
            column_mean = (ones_vec ## data2 )/double(ssize)
            data2 = (temporary(data2) - ones_vec ## column_mean )
            SD = sqrt(ones_vec ## (data2*data2)) 
            data2 = temporary(data2)/(ones_vec ## SD ) 
         endif;;senorm
            
         FOR xshift=-xpshift,xpshift DO BEGIN
            tmpdata2 = norot_shift(data2,xshift,0)
            ;;single chan energy norm case
            if senorm eq 1 then begin 
                  erg(xpshift+xshift,tshift+tpshift,j) = total(data1*tmpdata2)/$
                   ((FLOAT(sa(1)-abs(xshift))))
            end else begin
               ;;global energy norm case
               ;;shift, zero fill and back shift
               tmpdata1 = shift(norot_shift(data1,-xshift,0), xshift,0)
               m1 = umoment(tmpdata1)
               m2 = umoment(tmpdata2)
               ;;test for zero in energy norm term
                  erg(xpshift+xshift,tshift+tpshift,j) = total((tmpdata1-m1(0))*(tmpdata2-m2(0)))/$
                   sqrt(total((tmpdata1-m1(0))^2)*total((tmpdata2-m2(0))^2))
            end
         ENDFOR
         ;;ENDELSE
      ENDFOR
      
      ;;test for zero in energy norm term
      if total(FINITE(erg(*,*,j))) NE subSize then begin
         if verbose eq 1 then console,/warn, "energy norm term is zero, set result to zero!"
         erg(*,*,j) = 0 
      endif

      j = j+1
   ENDFOR

   if sa(sa(0)+1) NE 5 then A = float(temporary(A))

   time_ax = time_ax(0:j-1)
   return,erg(*, *, 0:j-1)
END


;delta = 2
;mult = 2
;test = fltarr(7,100*delta)
;smovie = size(test)
;x = sin(lindgen(100*delta)/20.*2*!Pi/FLOAT(delta))
;j = (2*(delta))
;test(0,*) = shift(x(*),0)
;test(1,*) = shift(x(*),1*j)
;test(2,*) = shift(x(*),2*j)
;test(3,*) = shift(x(*),3*j)
;test(4,*) = shift(x(*),2*j)
;test(5,*) = shift(x(*),1*j)
;test(6,*) = shift(x(*),0*j)
;xx=congrid(test,smovie(1)*mult,smovie(2),/cubic) 
;erg1 = spacecorr(xx,yind,tind,tpshift=10,xsample=0.001/FLOAT(MULT),SAMPLEPERIOD=0.002/FLOAT(DELTA),ssize=20,sshift=7)
;;;;mm = max(smooth(erg(*,3),2),index)
;;;;;print,yind(index)

;END
