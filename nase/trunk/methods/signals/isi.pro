;+
; NAME:                ISI
;
; AIM:                 the inter spike intervall (ISI) of trials
;
; PURPOSE:             berechnen der InterSpikeIntervalle eines oder mehrerer Trails,
;                      optional kann ein Histogramm berechnet werden
;
; CATEGORY:            STAT
;
; CALLING SEQUENCE:    IStimI = Isi(trial [, HISTO=histo]) 
;
; INPUTS:              trial: ein eindimensionaler Spiketrain oder ein Spiketrainarray
;                             mit Indizes trial(neuron,time)
;
; OPTIONAL OUTPUTS:    HISTO  : wenn gesetzt, wird die Summe ueber alle uebergebenen 
;                                Trials gebildet und zurueckgegeben
;
; OUTPUTS:             IStimI : das berechnet ISI-Array oder -Histogramm
;
; EXAMPLE:
;                      trials = BytArr(100, 1000)
;                      trials(WHERE(RandomU(seed, 100, 1000) GT 0.9)) = 1
;                      IStiI = ISI(trials)
;                      tvscl, IStiI
;                      dummy = ISI(trials, HISTO=IStiIH)
;                      plot, IStiIH
;-
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/09/28 11:36:50  gabriel
;          AIM tag added , message <> console
;
;     Revision 1.4  1999/04/16 14:21:23  saam
;           + ugly bug in IDLs histogram routine bypassed
;
;     Revision 1.3  1998/12/15 13:09:49  saam
;           performance improvements
;
;     Revision 1.2  1998/03/31 11:36:01  saam
;           now histo is an optional output
;
;     Revision 1.1  1997/11/03 18:12:34  saam
;           im archiv gefunden und an Nase angepasst
;
;
;



;***********************************************************
;***********************************************************
; Aufruf nur ueber isi.pro sinnvoll!!!!!!!!!!!!!!
;***********************************************************
;***********************************************************
;
; ERROR-CODES:
;      -1 : wrong dimension of trial
;      -2 : less than two spikes in trial
;      histo will be zero
;      

FUNCTION MYISI, trial, histo

   
   IF (Size(trial))(0) NE 1 THEN BEGIN
      histo = 0
      RETURN, -1
   ENDIF

   histo   = LonArr( (Size(trial))(1) )
   max_isi = 0
   
   times = WHERE(trial GE 1, c)
   IF c LE 1 THEN BEGIN
      histo = 0
      RETURN, -2
   ENDIF

   histo = HISTOGRAM([(Shift(times,-1)-times)(0:c-2),0])
   histo(0) = histo(0)-1
   RETURN, 0
END




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION ISI, trial, histo=HISTO

   IF (Size(trial))(0) LT 1 THEN Console, /fatal , 'no array passed!'
   IF (Size(trial))(0) GT 2 THEN Console, /fatal , 'only one- or two-dimensional arrays will be processed!'
   

; two dimensional trial
   IF (SIZE(trial))(0) EQ 2 THEN BEGIN  

      isi_arr = LonArr( (SIZE(trial))(1), (SIZE(trial))(2) )
      max_isi = 0L

      FOR i=0, (SIZE(trial))(1)-1 DO BEGIN 
         IF (myisi(REFORM(trial(i,*)), isi) EQ 0) THEN BEGIN
            act_isi = (SIZE(isi))(1) - 1
            max_isi = MAX([max_isi, act_isi])
            isi_arr(i, 0:act_isi) = isi
         END
      ENDFOR

      histo = TOTAL(isi_arr(*,0:max_isi), 1)
      RETURN, isi_arr(*,0:max_isi)

   ENDIF ELSE BEGIN
; one dimensional trial
      tmp = MYISI(trial, isi)
      histo = isi
      RETURN, isi
   ENDELSE
   
END


