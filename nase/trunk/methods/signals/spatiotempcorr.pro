;+
; NAME: SPATIOTEMPCORR
;
; AIM:                 two dimensional timeresolved spatiotemporal correalation histogramm
;
;
; PURPOSE:              A two dimensional spatiotemporal correalation function with sliding windows. The result is normed 
;                       in relation to spatial overlap.
;
; CATEGORY: CORRS + SPECS
;
;
; CALLING SEQUENCE:      result=spatiotempcorr(A [,distance_ax][,delay_ax][,time_ax][,xpshift=xpshift][,tpshift=tpshift] [,ssize=ssize]
;                                         [,sshift=_sshift][,SAMPLEPERIOD=SAMPLEPERIOD][,xsample=xsample],[POWER=POWER])
; 
; 
; INPUTS:                A:    two dimensioonal array (space,time)
;
;
; KEYWORD PARAMETERS:    XPSHIFT:       the amount the window is spatially shifted against the origin window (spatial correlation interval)
;                        TPSHIFT:       the amount the window is temporally shifted against the origin window (temporal correlation interval)
;                        SSIZE:         the size of the sliding time window, default is 20ms
;                        SSHIFT:        the amount the sliding window is shifted, default is SSIZE/2
;                        SAMPLEPERIOD:  the period of one sampled time value, default is 1ms 
;                        XSAMPLE:       the period of one sampled space value, default is 1mm 
;
; OUTPUTS:               RESULT: three dimensional array  (spatial correlation, temporal correlation, time)
;
;
; OPTIONAL OUTPUTS:      DISTANCE_AX: axis values for each correlation window in relation to spatial correlation
;                        delay_ax: axis values for each correlation window in relation to temporal correlation
;                        time_ax : time axis values for center position of each correlation window  
;                        POWER:    the power of each sliding window as an array of time 
;
;
; EXAMPLE:               SEE: <A HREF="#SPHASEVELOCITY">SPHASEVELOCITY</A>
;
;-
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.4  2000/09/28 11:49:57  gabriel
;          AIM tag added , message <> console
;
;     Revision 1.3  2000/07/04 15:09:53  gabriel
;          POWER keyword new
;
;     Revision 1.2  1999/02/18 09:43:21  gabriel
;          Korrektur bzgl. umoment und deren Varianzberechng.
;
;     Revision 1.1  1999/02/02 14:32:14  gabriel
;          was neues
;
;
;
FUNCTION spatiotempcorr,A,distance_ax,delay_ax,time_ax,xpshift=xpshift,tpshift=_tpshift,ssize=_ssize,$
                        sshift=_sshift,SAMPLEPERIOD=SAMPLEPERIOD, xsample=xsample,POWER=POWER
   sa = size(a)

   IF sa(0) NE 2 THEN console, /fatal,"Array isn't a two dimensional array A(space,time)"
   default,xpshift,FLOOR(sa(1)-1)
   default,SAMPLEPERIOD,0.001
   default,_ssize,20
   default,_sshift,_ssize/2
   default,_tpshift,10
   default,xsample,0.001
   ssize =  _ssize/SAMPLEPERIOD/1000
   tpshift= _tpshift/SAMPLEPERIOD/1000
   sshift = _sshift/SAMPLEPERIOD/1000
   ;;print,tpshift
   tsize = FLOOR((sa(2)-ssize-2*(tpshift))/sshift)
   erg = make_array(size=[sa(0),xpshift*2+1,tpshift*2+1,tsize,sa(3),(xpshift*2+1)*tsize*(2*tpshift+1)])
   power =  fltarr(tsize,2)
   distance_ax = (lindgen(xpshift*2+1)-xpshift)*FLOAT(xsample*1000)
   delay_ax = (lindgen(tpshift*2+1)-tpshift)/FLOAT(tpshift)*_tpshift
   time_ax = (tpshift+ssize/2+findgen(tsize)*sshift)*SAMPLEPERIOD*1000
   ;windata = FLTARR(sa(1),2*tpshift+ssize,tsize)
   var_c1 = FLOAT(ssize-1)
   var_c2 = FLOAT((ssize*sa(1))-1)
   j = 0L
   FOR i=tpshift ,FLOOR((tsize*sshift+tpshift)/sshift)*sshift-1 , sshift DO BEGIN
     
      data1 = (A(*,i:i+ssize-1))
      ;;zeilenweise
      power_tmp = total(data1^2,2)/FLOAT(ssize)
      power(j,*) = (umoment(power_tmp))(0:1)

      FOR ss=0,sa(1)-1 DO BEGIN
         m1 = umoment(data1(ss,*))
         data1(ss,*) = (data1(ss,*)-m1(0))/sqrt((m1(1)*var_c1))
      ENDFOR
      ;;total
       m1 = umoment(data1(*))
       data1 = data1-m1(0)   
       var1 = sqrt(m1(1) * var_c2)
      ;m1 = total(data1)/FLOAT(N_ELEMENTS(data1))
      ;ar1 = sqrt(total((data1(*)-m1)^2))
      ;ata1 = data1(*,*)-m1
      FOR tshift=-tpshift , tpshift DO BEGIN

 
         data2 = (A(*,i+tshift:i+tshift+ssize-1))
         ;;zeilenweise
         FOR ss=0,sa(1)-1 DO BEGIN 
            m2 = umoment(data2(ss,*))
            data2(ss,*) = (data2(ss,*)-m2(0))/sqrt(m2(1)*var_c1)
         ENDFOR
      
      
      
         ;;total
          m2 = umoment(data2(*))
          data2 = data2-m2(0)
          var2 = sqrt(m2(1) * var_c2)
;        m2 = total(data2)/FLOAT(N_ELEMENTS(data2))
;        var2 = sqrt(total((data2(*)-m2)^2))
;        data2 = data2(*,*)-m2
         testzero = total(var1 EQ 0 + (var2 EQ 0)) 
         IF testzero GT 0 THEN erg(*,tshift+tpshift,j) = 0 $
         ELSE BEGIN
            FOR xshift=-xpshift,xpshift DO BEGIN
           
           
               tmpdata2 = norot_shift(data2,xshift,0)
                       
               erg(xpshift+xshift,tshift+tpshift,j) = total(data1*tmpdata2)*sa(1)/$
                (var1*var2*(FLOAT(sa(1)-abs(xshift))))
               ;IF xshift EQ 0 AND tshift EQ 0 THEN print,total(data1(*)*tmpdata2(*)),DOUBLE(var1*var2)

            ENDFOR
         ENDELSE
      ENDFOR 
      j = j+1
   ENDFOR
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
