;+
; NAME:               SlidPowerSpec
;
; PURPOSE:            Diese Routine fuehrt ein gleitendes Powerspectrum durch.
;                     Dadurch kann man auf Kosten der Frequenzaufloesung die
;                     zeitliche Entwicklung eines Spektrums untersuchen.
;
; CATEGORY:           STAT
;
; CALLING SEQUENCE:   SlidSpec = SlidPowerSpec(series, slicesize, f [,PHASE=phase] [,TRUNC_PHASE=trunc_phase])
;
; INPUTS:             series   : die zu analysierende Zeitreihe als 1-d Float-Array
;                     slicesize: die Groesse eines Stuecks der Zeitreihe
;
; KEYWORD PARAMETERS: TRUNC_PHASE: Phasenbeitraege werden fuer Werte <= (TRUNC_PHASE (in Prozent) * MAX(ps))
;                                     auf Null gesetzt.
;
;
; OUTPUTS:            SlidSpec : das 2d-Array von Powerspektren, der erste Index
;                                steht fuer das i-te Spektrum
;
; OPTIONAL OUTPUTS:   f        : die zugehoerige Frequenzachse wird optional 
;                                zurueckgegeben    
;                     phase   : gibt die zu ps entsprechende Phasenwinkel zu den Frequenzwerten zuruek
;
;
; SIDE EFFECTS:       falls f uebergeben wird, wird es neu definiert
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
;     Revision 1.4  1998/08/23 12:50:47  saam
;           the old integer->long--bug
;
;     Revision 1.3  1998/06/22 09:56:52  saam
;           inadvertently inserted line removed
;
;     Revision 1.2  1998/01/27 11:35:29  gabriel
;          an powerspec angepasst
;
;     Revision 1.1  1997/11/03 15:54:57  saam
;           Im archiv gefunden, dokumentiert
;
;
;-
FUNCTION SlidPowerSpec, series, slicesize, x,DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE

   default,double,0
   
   

   IF (N_PARAMS() NE 3 )     THEN Message, 'wrong number of arguments'
   IF (Size(series))(0) NE 1 THEN Message, 'wrong format for signal'
   IF set(TRUNC_PHASE) AND NOT set(PHASE)   THEN Message, 'Keyword TRUNC_PHASE must be set with Keyword PPHASE'
   
   N = N_Elements(series)
   IF (N LT slicesize) THEN Message, 'number of elements less than slicesize!!'
   
   i = 0l
   FOR slicestart= 0l, N - slicesize, slicesize / 2 DO BEGIN
      IF SET(Phase) THEN BEGIN
         sliceSpec = PowerSpec(series(slicestart : slicestart+slicesize-1), x, /DOUBLE, /HAMMING,PPHASE=slidephase)
      END ELSE BEGIN 
         sliceSpec = PowerSpec(series(slicestart : slicestart+slicesize-1), x, /DOUBLE, /HAMMING)
      ENDELSE
       
      IF (slicestart EQ 0) THEN BEGIN
         IF double THEN BEGIN
            PSpec = FltArr(N/slicesize*2, N_Elements(slicespec)) 
            IF set(PHASE) THEN  PHASE =  FltArr(N/slicesize*2, N_Elements(slicespec)) 
         END ELSE BEGIN 
            PSpec = DBLArr(N/slicesize*2, N_Elements(slicespec))
            IF set(PHASE) THEN  PHASE =  DblArr(N/slicesize*2, N_Elements(slicespec)) 
         END
         
      END ELSE BEGIN
         PSpec(i,*) = slicespec
         IF set(PHASE) THEN PHASE(i,*) = slidephase
      END
      i = i + 1
   END
   PSpec = PSpec / FLOAT(N/(2*slicesize))
   
   RETURN, PSpec
END
