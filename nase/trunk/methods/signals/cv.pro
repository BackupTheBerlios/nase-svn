;+
; NAME:               CV
;
; PURPOSE:            Berechnet den "Coefficient of Variation" (CV) fuer ein oder mehrere
;                     Spiketrains. Der CV ist ein Mass fuer die Irregularitaet eines
;                     Prozesses und ist definiert als Verhaeltnis von Standardabweichung
;                     zum Mittelwert des InterSpikeIntervall-Histogramm des Spiketrains.
;
; AUTHOR:             Mirko Saam
;
; CATEGORY:           METHODS SIGNALS STATISTIC
;
; CALLING SEQUENCE:   CVs = CV(suas [,MEAN=mean] [,SDEV=sdev])
;
; INPUTS:             suas: ein Spiketrain oder ein Array (Neuronindex, Zeit) von Spiketrains 
;
; OUTPUTS:            CVs : die Coefficient of Variations entsprechend der Zahl der
;                           uebergebenen Spiketrains
;
; OPTIONAL OUTPUTS:   MEAN: Mittelwert(e) des InterSpikeIntervall-Histogramms
;                     SDEV: Standardabweichung(en) des Mittelwertes
;
; PROCEDURE:          + berechnet ISI
;                     + bestimmt Mittelwert und Standardabweichung
;
; EXAMPLE:
;                     ; rhythmisches Signal
;                     SUA=BytArr(1000)
;                     FOR i=0,1000/20-1 DO SUA(i*20)=1
;                     print, CV(SUA)
;                     -> 0.0
;         
;                     ;Poisson Signal
;                     SUA=BytArr(1000)
;                     AP=WHERE(RandomU(seed,1000) LT 0.04,c)
;                     IF c NE 0 THEN SUA(AP)=1
;                     print, CV(SUA)
;                     -> 1.0 (variiert stark)
;       
; SEE ALSO:           <A HREF="#ISI">Isi</A>
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1998/12/15 10:59:50  saam
;           inspired by Softky&Koch '93
;
;
;-
FUNCTION CV, suas, MEAN=mean, SDEV=sdev

   On_Error, 2

   IF N_Params() NE 1 THEN Message, 'suas expected!'
   
   s = SIZE(suas)
   IF s(0) GT 2 THEN Message, 'one- or two-dimensional array expected'


   isih = ISI(suas)
   

   IF s(0) EQ 2 THEN BEGIN
      iters = s(1) 
   END ELSE BEGIN
      iters = 1
      isih = REFORM(isih,1,N_Elements(isih), /OVERWRITE)
   END

   R    = DblArr(iters)
   mean = DblArr(iters)
   sdev = DblArr(iters)
   FOR i=0,iters-1 DO BEGIN
      ; get mean and sd of isi in histogram by weighing isi values with
      ; their relative frequency
      tisih = isih(i,*)
      tisih = tisih/total(tisih)
      x = dindgen(n_elements(tisih))
      mean(i) = total(tisih*(x+1))-1
      sdev(i) =  sqrt(total(tisih*((x-mean(i))^2)))
      R(i) = sdev(i)/mean(i)
   END


   IF iters EQ 1 THEN BEGIN
      R = R(0)
      MEAN = MEAN(0)
      SDEV = SDEV(0)
   END

   RETURN, R
END
