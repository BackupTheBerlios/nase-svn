;+
; NAME:
;  UPeakPicker 
;
; VERSION:
;  $Id$
;
; AIM:
;  Identifying maxima and minima in noisy data (math. method).
;
; PURPOSE:
;  Identifying maxima and minima in noisy data. 
;
; CATEGORY:
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* UPeakPicker, ydata, tdata, ymax, tmax, maxnumber 
;*              [, ymin, tmin, minnumber]
;*              [, RELATIVCRIT=...] [, DATACRIT=...]
;*              [, DELTA=...][, MAXINDEX=...][, MININDEX=...]
;
; INPUTS: ydata:: Vector of data values.
;         tdata:: Vector of corresponding times (,or whatever)
;
; INPUT KEYWORDS:
;  RELATIVCRIT:: An optional criterion for peak/noise discrimination
;                given in fraction of maximal data range (Def.: 5%).
;  DATACRIT:: An optional criterion for peak/noise discrimination
;             given in absolute data coordinates. 
;  DELTA:: Width for smoothing the 1. deviation of ydata (default 5).
;  MAXINDEX:: Vector subscript to select maxima of ydata, tdata.
;  MININDEX:: Vector subscript to select minima of ydata, tdata.  
;
; OUTPUTS:
;  ymax:: Vector of peaks heights found.
;  tmax::  Vector of corresponding peak times.
;  maxnumber:: If no significant extrema are found, -1 is returned in
;              <C>maxnumber</C>, otherwise the number of maxima found. The
;              lengths of the resulting vectors are according to the
;              number of peaks and valleys found. 
;
; OPTIONAL OUTPUTS:
;  ymin:: Like <C>ymax</C> for minima.
;  tmin:: Like <C>tmax</C> for minima.
;  minnumber:: Like <C>maxnumber</C> for minima. If no information
;              about minima is required, keywords <C>ymin</C> and <C>tmin</C>
;              needn't be given when calling the <C>UPeakPicker</C>
;              function.
;
; PROCEDURE:
;  Mathematics.
;
; EXAMPLE:
;* x=RandomN(s,100)
;* Plot, x
;* UPeakPicker, x, indgen(100), yp, tp, RELATIVCRIT=0.1
;* OPlot, tp, yp, COLOR=RGB("red")
;
; SEE ALSO:
;  <A>PeakPicker</A>
; 
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.4  2001/03/09 16:27:46  thiel
;        Just fixed the header.
;
;     Revision 1.3  2000/09/28 09:22:03  gabriel
;           AIM tag added
;
;     Revision 1.2  1998/03/02 16:08:53  gabriel
;          keywords wieder als argumente fuer ymin, tmin, minumber
;
;     Revision 1.1  1998/02/27 11:20:29  gabriel
;          ein PeakPicker mit Methoden aus der Analysis
;



PRO UPeakPicker, ydata,tdata, ymax,tmax,maxnumber,ymin,tmin,minnumber,$
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

   IF maxcount GT 0  THEN BEGIN 
      ymax = ydata(maxindex)
      tmax = tdata(maxindex)
      maxnumber =  maxcount
   END ELSE BEGIN
      maxnumber =  -1
   ENDELSE

   IF (mincount GT 0) THEN BEGIN
      ymin = ydata(minindex)
      tmin = tdata(minindex)
      minnumber = mincount
   END ELSE BEGIN
      minnumber =  -1
   ENDELSE
   
   
   
  

End

