;+
; NAME:               SlidPowerSpec
;
; AIM:                calculates the timeresolved power spectrum of a given signal 
;
; PURPOSE:            Diese Routine fuehrt ein gleitendes Powerspectrum durch.
;                     Dadurch kann man auf Kosten der Frequenzaufloesung die
;                     zeitliche Entwicklung eines Spektrums untersuchen.
;
; CATEGORY:           STAT ,CORRS+SPECS
;
; CALLING SEQUENCE:   SlidSpec = SlidPowerSpec(series, slicesize, f [,PHASE=phase] [,TRUNC_PHASE=trunc_phase], [SAMPLEPERIOD=sampleperiod])
;
; INPUTS:             series   : die zu analysierende Zeitreihe als 1-d Float-Array
;                     slicesize: die Groesse eines Stuecks der Zeitreihe
;
; KEYWORD PARAMETERS: TRUNC_PHASE: Phasenbeitraege werden fuer Werte <= (TRUNC_PHASE (in Prozent) * MAX(ps))
;                                     auf Null gesetzt.
;                     SAMPLEPERIOD: Sampling-Periode (default: 0.001 sec) der Zeitreihe
;
;
; OUTPUTS:            SlidSpec : das 2d-Array von Powerspektren, der erste Index
;                                steht fuer das i-te Spektrum
;
; OPTIONAL OUTPUTS:   f        : die zugehoerige Frequenzachse wird optional 
;                                zurueckgegeben    
;                     phase   : gibt die zu ps entsprechende Phasenwinkel zu den Frequenzwerten zuruek
;
;                     tvalues  : Returns the times/ms at which parts start.
;                     tindices : Returns starting time array indices of the parts.
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
;-                 
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.5  2000/09/28 13:37:48  gabriel
;          AIM tag added, console <> message, now uses slices
;
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
;
FUNCTION SlidPowerSpec, series, slicesize, x,DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE, SAMPLEPERIOD=sampleperiod, TVALUES=TVALUES, TINDICES=TINDICES

   default,double,0
   
   
   
   IF (N_PARAMS() NE 3 )     THEN console, /fatal , 'wrong number of arguments'
   IF (Size(series))(0) NE 1 THEN console, /fatal , 'wrong format for signal'
   IF set(TRUNC_PHASE) AND NOT set(PHASE)   THEN console, /fatal, 'Keyword TRUNC_PHASE must be set with Keyword PPHASE'
   
   N = N_Elements(series)
   IF (N LT slicesize) THEN Console, /fatal, 'number of elements less than slicesize!!'
   
   signal_slice = slices(series, SSIZE=slicesize, SAMPLEPERIOD=SAMPLEPERIOD, TVALUES=TVALUES, TINDICES=TINDICES)
   
   s_s = size(signal_slice)
   
   
   for sl_i=0l, s_s(1)-1 do begin
      IF SET(Phase) THEN BEGIN
         sliceSpec = PowerSpec(reform(signal_slice( sl_i, *)), x, /DOUBLE,$
                               /HAMMING,PPHASE=slidephase,  SAMPLEPERIOD=sampleperiod)
      END ELSE BEGIN 
         sliceSpec = PowerSpec(reform(signal_slice( sl_i, *)), x, /DOUBLE,$
                               /HAMMING, SAMPLEPERIOD=sampleperiod)
      ENDELSE
      if sl_i EQ 0 then $
       IF double THEN BEGIN
         PSpec = FltArr(s_s(1), N_Elements(slicespec)) 
         IF set(PHASE) THEN  PHASE =  FltArr(s_s(1), N_Elements(slicespec)) 
       END ELSE BEGIN 
         PSpec = DBLArr(s_s(1), N_Elements(slicespec))
         IF set(PHASE) THEN  PHASE =  DblArr(s_s(1), N_Elements(slicespec)) 
       END
      
      PSpec(sl_i,*) = slicespec
      IF set(PHASE) THEN PHASE(sl_i,*) = slidephase
      
   endfor ;;sl_i

 ;  i = 0l
;   FOR slicestart= 0l, N - slicesize, slicesize / 2 DO BEGIN
;      IF SET(Phase) THEN BEGIN
;         sliceSpec = PowerSpec(series(slicestart : slicestart+slicesize-1), x, /DOUBLE, /HAMMING,PPHASE=slidephase,  SAMPLEPERIOD=sampleperiod)
;      END ELSE BEGIN 
;         sliceSpec = PowerSpec(series(slicestart : slicestart+slicesize-1), x, /DOUBLE, /HAMMING, SAMPLEPERIOD=sampleperiod)
;      ENDELSE
       
;      IF (slicestart EQ 0) THEN BEGIN
;         IF double THEN BEGIN
;            PSpec = FltArr(N/slicesize*2, N_Elements(slicespec)) 
;            IF set(PHASE) THEN  PHASE =  FltArr(N/slicesize*2, N_Elements(slicespec)) 
;         END ELSE BEGIN 
;            PSpec = DBLArr(N/slicesize*2, N_Elements(slicespec))
;            IF set(PHASE) THEN  PHASE =  DblArr(N/slicesize*2, N_Elements(slicespec)) 
;         END
         
;      END ELSE BEGIN
;         PSpec(i,*) = slicespec
;         IF set(PHASE) THEN PHASE(i,*) = slidephase
;      END
;      i = i + 1
;   END
   PSpec = PSpec / FLOAT(N/(2*slicesize))
   
   RETURN, PSpec
END
