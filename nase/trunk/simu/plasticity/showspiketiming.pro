;+
; NAME:
;  ShowSpikeTiming
;
; AIM: Show results of pre-/postsynaptic spike interval count. 
;
; PURPOSE: -Visualisierung der mittels DoSpikeTiming gezaehlten Abstaende von prae- und postsynaptischen
;           Spikes durch ein Histogramm 
;          -Berechnung des Verhaeltnisses von anzahl(t_post-t_prae<0) zu anzahl(t_post-t_prae>0)   
;          -Rueckgabe der Werte in einem Array 
;
; CATEGORY:
;  Simulation / Plasticity
;
; CALLING SEQUENCE: ShowSpikeTiming, Counter [,RATIO=ratio] [,RESULT=result]
;
; 
; INPUTS:   Counter : mit InitSpikeTiming initialisierte Zaehlstruktur
; OUTPUTS:  Histogramm ...   mittels plot
;           RATIO=ratio ...  Verhaeltnis der Anzahl von Spikes mit t_post > t_prae zu t_prae < t_post  
;           RESULT=result... Array, welches die Anzahl der jeweiligen Abstaende t_post-t_pre enthaelt :
;                    result=[groesse Fenster<0,groesse Fenster>0,anzahl...]    
;
;
; EXAMPLE:  ShowSpikeTiming, Counter, RATIO=ratio, RESULT=result
;           print,'Verhaeltnis von neg. zu pos. Abstaenden :', ratio
;           print,'Anzahl der Spikes mit t_post-t_pre<0', $
;                                      total(result(2:(1+result(0))))
;           print,'Anzahl der Spikes mit t_post-t_pre>0', $
;                              total(result((3+result(0)):(N_elements(result)-1)))
;
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 2.2  2000/09/26 15:13:43  thiel
;         AIMS added.
;
;     Revision 2.1  1999/11/10 15:06:01  alshaikh
;           initial version
;


PRO ShowSpikeTiming, _COUNT, RATIO=ratio, RESULT=result
   
   HANDLE_VALUE, _COUNT, COUNT, /NO_COPY

   data_pts =COUNT.LWPos(2:(N_elements(COUNT.LWPos)-1))
   x_axis =  INDGEN(N_elements(COUNT.LWPos)-2)-Count.LWPos(0)
   minimum = MIN(data_pts(0:(N_elements(data_pts)-1)))*0.95   
   max_x = Count.LWPos(1)
   min_x = Count.LWPos(0)


   ratio =total(Count.LWPos((2+min_x+1):(N_elements(Count.LWPos)-1)))/ total(Count.LWPos(2:(2+min_x-1)))
   result = COUNT.LWPos
   
   
   PLOT, x_axis, $
    data_pts, $
    XTITLE='t_post-t_pre [ms]', $
    YTITLE='counts',/XSTYLE,/YSTYLE,YRANGE=[minimum,max(data_pts)]
   
   POLYFILL,[x_axis,max_x,-min_x,-min_x],[data_pts,minimum,minimum,data_pts(0)]
   
   HANDLE_VALUE, _COUNT, COUNT, /NO_COPY, /SET
   
END

