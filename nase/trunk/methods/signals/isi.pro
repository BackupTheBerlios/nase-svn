;+
; NAME:                ISI
;
; PURPOSE:             berechnen der InterSpikeIntervalle eines oder mehrerer Trails,
;                      optional kann ein Histogramm berechnet werden
;
; CATEGORY:            STAT
;
; CALLING SEQUENCE:    IStimI = Isi(trial [, /HISTO]) 
;
; INPUTS:              trial: ein eindimensionaler Spiketrain oder ein Spiketrainarray
;                             mit Indizes trial(neuron,time)
;
; KEYWORD PARAMETERS:  HISTO  : wenn gesetzt, wird die Summe ueber alle uebergebenen 
;                               Trials gebildet und zurueckgegeben
;
; OUTPUTS:             IStimI : das berechnet ISI-Array oder -Histogramm
;
; EXAMPLE:
;                      trials = BytArr(100, 1000)
;                      trials(WHERE(RandomU(seed, 100, 1000) GT 0.9)) = 1
;                      IStiI = ISI(trials)
;                      tvscl, IStiI
;                      IStiIH = ISI(trials, /HISTO)
;                      plot, IStiIH
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1997/11/03 18:12:34  saam
;           im archiv gefunden und an Nase angepasst
;
;
;-



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
   
   times = WHERE(trial GE 1)
   IF times(0) EQ -1 THEN BEGIN
      histo = 0
      RETURN, -2
   ENDIF

   nr_spikes = (Size(times))(1)
   IF nr_spikes LE 1 THEN BEGIN
      histo = 0
      RETURN, -2
   ENDIF
   
   
   FOR i = 1, nr_spikes-1 DO BEGIN
      isi_p = times(i) - times(i-1)
      histo(isi_p) = histo(isi_p) + 1
      IF isi_p GT max_isi THEN max_isi = isi_p
   ENDFOR

   histo = histo(0:max_isi)
   RETURN, 0
END




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FUNCTION ISI, trial, histo=HISTO

   IF (Size(trial))(0) LT 1 THEN Message, 'no array passed!'
   IF (Size(trial))(0) GT 2 THEN Message, 'only one- or two-dimensional arrays will be processed!'
   

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

      IF KEYWORD_SET(histo) THEN BEGIN
         RETURN, TOTAL(isi_arr(*,0:max_isi), 1)
      ENDIF ELSE BEGIN
         RETURN, isi_arr(*,0:max_isi)
      ENDELSE

   ENDIF ELSE BEGIN
; one dimensional trial
      tmp = MYISI(trial, isi)
      RETURN, isi
   ENDELSE
   
END


