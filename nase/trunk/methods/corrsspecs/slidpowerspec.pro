;+
; NAME:               SlidPowerSpec
;
; PURPOSE:            Diese Routine fuehrt ein gleitendes Powerspectrum durch.
;                     Dadurch kann man auf Kosten der Frequenzaufloesung die
;                     zeitliche Entwicklung eines Spektrums untersuchen.
;
; CATEGORY:           STAT
;
; CALLING SEQUENCE:   SlidSpec = SlidPowerSpec(series, slicesize, t)
;
; INPUTS:             series   : die zu analysierende Zeitreihe als 1-d Float-Array
;                     slicesize: die Groesse eines Stuecks der Zeitreihe
;
; OUTPUTS:            SlidSpec : das 2d-Array von Powerspektren, der erste Index
;                                steht fuer das i-te Spektrum
;
; OPTIONAL OUTPUTS:   t        : die zugehoerige Frequenzachse wird optional 
;                                zurueckgegeben    
;
; SIDE EFFECTS:       falls t uebergeben wird, wird es neu definiert
;
; PROCEDURE:          PowerSpec
;
; EXAMPLE:
;                     schwierig!! series sei die Zeitreihe aus 10000 BINS
;                      SlidSpec = SlidPowerSpec(series, 1000, t)
;                      plot, t, SlidSpec(0,*) 
;                      FOR i=1, (SIZE(SlidSpec))(1) DO oplot, t, SlidSpec(i,*)
;                 
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  1997/11/03 15:54:57  saam
;           Im archiv gefunden, dokumentiert
;
;
;-
FUNCTION SlidPowerSpec, series, slicesize, x

   
   IF (N_PARAMS() NE 3 )     THEN Message, 'wrong number of arguments'
   IF (Size(series))(0) NE 1 THEN Message, 'wrong format for signal'

   
   N = N_Elements(series)
   IF (N LT slicesize) THEN Message, 'number of elements less than slicesize!!'
   

   i = 0
   FOR slicestart= 0, N - slicesize, slicesize / 2 DO BEGIN
      sliceSpec = PowerSpec(series(slicestart : slicestart+slicesize-1), x)
      IF (slicestart EQ 0) THEN BEGIN
         PSpec = FltArr(N/slicesize*2, N_Elements(slicespec))
      END ELSE BEGIN
         PSpec(i,*) = slicespec
      END
      i = i + 1
   END
   PSpec = PSpec / FLOAT(N/(2*slicesize))
   
   RETURN, PSpec
END
