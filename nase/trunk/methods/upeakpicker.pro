;+
; NAME:               PeakPicker
;
; PURPOSE:            identifying maximas and minimas in noisy data
;
; CATEGORY:           STAT
;
; CALLING SEQUENCE:   UPeakPicker, ydata,tdata, ymax,tmax,maxnumber [, ymin=ymin, tmin=tmin, minnumber=minnumber] $
;                                   [, RelativCrit=RelativeCrit] [, DataCrit=DataCrit] $
;                                   [ ,DELTA=delta][ ,MaxIndex=MaxIndex][ ,MinIndex=MinIndex]
;
; INPUTS:             ydata: Vector of data values.
;                     tdata: Vector of corresponding times (,or whatever)
;
; KEYWORD PARAMETERS:     
;                     ymin:           Like ymax for minimas.
;                     tmin:           Like tmax for minimas.
;                     minnumber:      Like maxnumber for minimas.
;
;                     RelativeCrit:   An optional criterion for peak/noise discrimination
;                                     given in fraction of maximal data range (Def.: 5%)
;                     DataCrit:       An optional criterion for peak/noise discrimination
;                                     given in absolute data coordinates.
;                     Delta:          Intervallbreite, ueber die die 1. Ableitung von ydata
;                                     gemittelt wird  (default 5)
;                     MaxIndex:       vector subscript to select maximas of ydata, tdata                                                                            
;                     MinIndex:       vector subscript to select minimas of ydata, tdata
;
; OUTPUTS:            If no significant extremas are found, -1 is returned in 
;                     'maxnumber', otherwise the number of maximas found. If no information about 
;                     minimas is required,keywords 'ymin' and 'tmin' needn't be given when 
;                     calling the upeakpicker function.
; 
;                     ymax:          Vector of peaks heights found.
;                     tmax:          Vector of corresponding peak times.
;                     maxnumber:     See above.
;
;                     The lengths of the resulting vectors are according to the number of
;                     peaks and valleys found.
;

;
; AUHTOR:             A.Gabriel
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/02/27 11:20:29  gabriel
;          ein PeakPicker mit Methoden aus der Analysis
;
;
;-
PRO UPeakPicker, ydata,tdata, ymax,tmax,maxnumber,ymin=ymin,tmin=tmin,minnumber=minnumber,$
             RelativCrit=RelativeCrit,DataCrit=DataCrit,DELTA=delta,MAXINDEX=maxIndex,MININDEX=minIndex

   ;;Initialization
   IF SET(RelativeCrit) AND SET(DataCrit) THEN message,"Don't use both keywords: RelativeCrit,DataCrit"
   default,RelativeCrit,0.05
   default,DataCrit,0
   default,delta, 5
   ymin=Min(ydata)  &  ymax=Max(ydata)
   IF delta LE 0 THEN message,"Keyword DELTA must be greater than 0"
   If RelativeCrit Then ycrit=RelativeCrit*(ymax-ymin) ; criterion into data range
   If DataCrit Then ycrit=DataCrit

   dydata = FLTARR(N_ELEMENTS(ydata))
   ;;erste Ableitung mitteln über delta
   deltarr = FLTARR(delta)
   deltarr(*) = 1/FLOAT(delta) 
   ;;Ableitung glaetten
   dydata = convol(ydata-shift(ydata,1),deltarr,/CENTER)
   dydata = (dydata GT 0) + (dydata LT 0)*(-1) 
   ;;zweite Ableitung bilden (maximum bei -2, mimimum bei +2, wendepunkt bei +-1)
   ddydata = shift(dydata,-1) - dydata

   cutmax = (ydata - min(ydata))  GT ycrit
   cutmin = (- ydata + max(ydata)) GT ycrit
   ;;minima und maxima suchen
   maxindex = where((ddydata *cutmax)EQ -2, maxcount)
   minindex = where((ddydata *cutmin)EQ  2, mincount)

   IF maxcount GT 0 AND set(maxnumber) THEN BEGIN 
      ymax = ydata(maxindex)
      tmax = tdata(maxindex)
      maxnumber =  maxcount
   END ELSE BEGIN
      maxnumber =  -1
   ENDELSE

   IF (mincount GT 0) AND set(minnumber) THEN BEGIN
      ymin = ydata(minindex)
      tmin = tdata(minindex)
      minnumber = mincount
   END ELSE BEGIN
      minnumber =  -1
   ENDELSE
   
   
   
  

End

