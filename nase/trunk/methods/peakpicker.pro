;+
; NAME: 
;  Peakpicker
;  
; VERSION:
;  $Id$
;
; AIM:
;  Identifying peaks and valleys in noisy data (num. method).
;  
; PURPOSE:
;  Identifying peaks and valleys in noisy data (num. method).
;  Authors: K. Kopecz, A. Steinhage
;
; CATEGORY:
;  Array
;  Math
;  Signals
;  Simulation
;
; CALLING SEQUENCE:
;  PeakPicker, ydata, tdata, ypeak, tpeak, number 
;              [, yvalley, tvalley]
;              [, RELATIVCRIT=...] [, DATACRIT=...]
;              [, INTERVALL=...]
;  
; INPUTS:
;  ydata:: Vector of data values.
;  tdata:: Vector of corresponding times (,or whatever)
;  
; INPUT KEYWORDS:
;  RELATIVCRIT:: An optional criterion for peak/noise discrimination
;                given in fraction of maximal data range (Def.: 5%)
;  DATACRIT:: An optional criterion for peak/noise discrimination
;             given in absolute data coordinates.
;  
; OUTPUTS:
;  ypeak:: Vector of peaks heights found.
;  tpeak:: Vector of corresponding peak times.
;  number:: If no significant peaks and valleys are found, -1 is 
;           returned in 'number', otherwise the number of peaks
;           found. The lengths of the resulting vectors are according
;           to the number of peaks and valleys found.
;
; OPTIONAL OUTPUTS:
;  yvalley:: Vector of valley depths found.
;  tvalley:: Vector of corresponding valley times.
;            If no information about valleys is required, 'yvalley' 
;            and 'tvalley' needn't be given when calling the
;            peakpicker function.
;  
; EXAMPLE:
;* x=RandomN(s,100)
;* Plot, x
;* PeakPicker, x, indgen(100), yp, tp, RELATIVCRIT=0.1
;* OPlot, tp, yp, COLOR=RGB("red")
;  
; SEE ALSO:
;  <A>UPeakPicker</A>.
;-


PRO PeakPicker, ydata,tdata, ypeak,tpeak,number, yvalley,tvalley, $
             RelativCrit=RelativeCrit,DataCrit=DataCrit,Intervall=Intervall

   IF SET(RelativeCrit) AND SET(DataCrit) THEN $ 
    Console, /FATAL, "Don't use both keywords: RelativeCrit, DataCrit."
  
   Default, RelativeCrit, 0.05
   Default, DataCrit, 0
   Default, intervall, 0
   
   ymin=Min(ydata)
   ymax=Max(ydata)
   
   IF RelativeCrit GT 0 Then ycrit=RelativeCrit*(ymax-ymin) ; criterion into data range
   IF DataCrit GT 0  Then ycrit=DataCrit

;Initialization

   yPeakTemp=ydata(0)  &  yValleyTemp=ydata(0)
   tPeakTemp=tdata(0)  &  tValleyTemp=tdata(0)

   idata=0L                      ; counter of where in ydata we are.
   iPeaktemp=0L                  ; marker for indices inside peak interval.
   iValleyTemp=0L
   y=ydata(idata)
   t=tdata(idata)
   If_Increase=-1L               ; set to undetermined
   ypeak=0.0
   yvalley=0.0
   tpeak=0.0
   tvalley=0.0                  ; initialization of return lists.
   NPoints=LONG(N_Elements(ydata))


; First loop to get first significant increase or decrease.

   While (If_Increase EQ -1) AND (idata LT NPoints-1) Do Begin
      idata=idata+1
      y=ydata(idata)
      t=tdata(idata)
      If Intervall then Begin
         lo=1>(idata-Intervall) & hi=(Npoints-1)<(idata+Intervall)
         ycrit=RelativeCrit*(max(ydata(lo:hi))-min(ydata(lo:hi)))
      Endif
      If y GT (yPeakTemp+ycrit) Then Begin
         If_Increase=1
         yPeakTemp=y
         tPeakTemp=t
         iPeakTemp=idata
      EndIf Else Begin
         If y LT (yValleyTemp-ycrit) Then Begin
            IF_Increase=0
            yValleyTemp=y
            tValleyTemp=t
            iValleyTemp=idata
         EndIf
      EndElse
   EndWhile
   
   If idata EQ NPoints-1 Then Begin
      number=-1                 ; No significant peaks or valleys!
      Return
   EndIf
   
   ipeak=0  &  ivalley=0
   
   
; Loop through data ...
   
   For i=idata+1,NPoints-1 Do Begin
      yold=y
      y=ydata(i)  &  t=tdata(i)
      If IF_Increase EQ 1 then Begin
         If y lt yold then Begin
            If Intervall then Begin
               lo=1>(i-Intervall)
               hi=(Npoints-1)<(i+Intervall)
               ycrit=RelativeCrit*(max(ydata(lo:hi))$
                                   -min(ydata(lo:hi)))
            Endif
            If y LT (yPeakTemp-ycrit) Then Begin
               iPeak=iPeak+1    ; We found a peak!
               ypeak=[ypeak,yPeakTemp] ; extend peak lists.
               tpeak=[tpeak,tPeaktemp]
               For j=iPeakTemp, i-1 Do Begin
                  If ydata(j) GT ypeak(iPeak) Then Begin
                     yPeak(iPeak)=ydata(j)
                     tPeak(iPeak)=tdata(j)
                  EndIf
               EndFor
               IF_Increase=0    ; search for valley next time.
               yValleyTemp=y
               tValleyTemp=t
               iValleyTemp=i
            EndIf Else Begin
               If y GT (yPeakTemp+ycrit) Then Begin
                  yPeakTemp=y   ; keeps going up significantly!
                  tPeakTemp=t
                  iPeakTemp=i
               EndIf
            EndElse
         Endif
      EndIf Else If y gt yold then Begin
         If Intervall then Begin
            lo=1>(i-Intervall) & hi=(Npoints-1)<(i+Intervall)
            ycrit=RelativeCrit*(max(ydata(lo:hi))-min(ydata(lo:hi)))
         Endif
         If y GT (yValleyTemp+ycrit) Then Begin
            iValley=iValley+1   ; We found a valley.
            yValley=[yValley,yValleyTemp] ; extend valley lists.
            tValley=[tValley,tValleyTemp]
            For j=iValleyTemp,i-1 Do Begin
               If ydata(j) LT yValley(iValley) Then Begin
                  yvalley(ivalley)=ydata(j)
                  tvalley(ivalley)=tdata(j)
               EndIf
            EndFor
            IF_Increase=1       ; search for peak next time.
            ypeaktemp=y
            tpeaktemp=t
            ipeaktemp=i
         EndIf Else Begin
            If y LT (yValleyTemp-ycrit) Then Begin
               yValleyTemp=y    ; keeps going down significantly
               tValleyTemp=t
               iValleyTemp=i
            EndIf
         EndElse
      Endif
   EndFor
   
   If iPeak gt 0 And iValley Gt 0 then Begin
      ypeak=ypeak(1:*)          ; truncate first elements (from initialization).
      yvalley=yvalley(1:*)
      tpeak=tpeak(1:*)
      tvalley=tvalley(1:*)
   Endif
   
   number=iPeak                 ; return number of peaks.
   

End

