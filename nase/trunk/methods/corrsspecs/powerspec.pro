;+
; NAME:                  PowerSpec
;
; AIM:                   computes power spectrum
;
; PURPOSE:               Computes the power spectrum for a single or
;                        multiple time series.
;
; CATEGORY:              METHODS CORRS+SPECS
;
; CALLING SEQUENCE:      ps = PowerSpec( series [,xaxis] [,/HAMMING] [,/DOUBLE] [,SAMPLEPERIOD=sampleperiod]
;                                        [,PHASE=phase]
;                                        [,TRUNC_PHASE=trunc_phase]
;                                        [,KERNEL=kernel])
;
; INPUTS:                series : a single time series or multiple
;                                 time series (dimension: iter, time)
;                                 with at least 10 elements
;
; KEYWORD PARAMETERS:    HAMMING:      filtering with a hamming window
;                                      (see IDL Online Help)
;                        DOUBLE:       calculation is done with double
;                                      precision (only working for IDL
;                                      versions >= 4.0)
;                        TRUNC_PHASE:  phase contributions dP will be
;                                      set to zero, if dP <= (TRUNC_PHASE * MAX(ps))
;                                      with 0 <= TRUNC_PHASE <= 1
;                        KERNEL:       filter kernel for smoothinh the
;                                      cross spectrum (useful if
;                                      PHASES are evaluated)
;                        SAMPLEPERIOD: sample period of time series in
;                                      seconds (default: 0.001 sec) 
;                        COMPLEX:      if set, the complex fourier
;                                      spectrum is returned, instead
;                                      of their absolute value
;                        NEGFREQ:      outputs also negative frequency
;                                      components
;
;
; OUTPUTS:               ps : the calculated power spectra
;
; OPTIONAL OUTPUTS:      xaxis : returns the corresponding frequencies to ps
;                        phase : returns the phase angles 
;
;
; SIDE EFFECTS:          xaxis will be overwritten
;
; RESTRICTIONS:          series has to contain at least 10 elements
;
; EXAMPLE:          
;                        f1 = 3
;                        f2 = 30
;                        f3 = 13
;                        
;                        series = 0.1*sin(findgen(1000)/1000.*2*!Pi*f1)
;                        series = series + 0.05*sin(findgen(1000)/1000.*2*!Pi*f2)
;                        series = series + 0.07*sin(findgen(1000)/1000.*2*!Pi*f3)
;                        
;                        Window,/FREE
;                        !P.Multi = [0,1,2,0,0]
;                        
;                        Plot, series, TITLE='Time Series'
;                        
;                        ps = PowerSpec(series, xaxis)
;                        Plot, xaxis(0:40), ps(0:40),
;                              TITLE='Powerspektrum', 
;                              XTITLE='Frequency / Hz', YTITLE='Power'
;
;-
; MODIFICATION HISTORY:
;
; $Log$
; Revision 1.12  2000/07/26 14:10:47  saam
;       + corrected problem with strange
;         behaviour from PHASE in
;         crosspower
;       + removed obsolete SAMPLPERIOD
;         keyword, use SAMPLEPERIOD
;         instead
;
; Revision 1.11  2000/07/26 09:25:45  saam
;       + translated doc header
;       + now handles multiple powerspecs
;
; Revision 1.10  1998/08/24 10:34:00  saam
;       think i programmed perl a little bit too much
;
; Revision 1.9  1998/08/24 10:30:31  saam
;       keyword SAMPLPERIOD replaced by SAMPLEPERIOD, the old
;       version produces a warning but still works
;
; Revision 1.8  1998/05/04 17:55:29  gabriel
;       COMPLEX Keyword neu
;
; Revision 1.7  1998/01/27 18:48:35  gabriel
;      Kosmetische Korrektur
;
; Revision 1.6  1998/01/27 18:45:09  gabriel
;      Smooth Kernel Keyword neu
;
; Revision 1.5  1998/01/27 11:29:49  gabriel
;      ruft jetzt crosspower auf
;
; Revision 1.4  1998/01/07 15:03:18  thiel
;      Jetzt auch mit im Header.
;
;
;       Tue Aug 19 20:58:57 1997, Mirko Saam
;       <saam@ax1317.Physik.Uni-Marburg.DE>
;		Schon vorher bestehende Funktion 
;               dokumentiert und in den CVS-Baum
;               hinzugefuegt
;
;

FUNCTION PowerSpec, series, xaxis, hamming=HAMMING, DOUBLE=Double ,Phase=Phase ,NEGFREQ=NegFreq ,$
                    TRUNC_PHASE=TRUNC_PHASE, KERNEL=kernel, SAMPLEPERIOD=sampleperiod, COMPLEX=Complex
 
   IF (SIZE(series))(0) EQ 2 THEN BEGIN
       slicec = (SIZE(series))(1)
       IF Set(Phase) THEN _PHASE=0 ; crosspower has a somewhat strange handling of the phase keyword....
       FOR i=0l, slicec-1 DO BEGIN
           _series = REFORM(series(i,*))
           _PSpec = crosspower( _series, _series, xaxis, hamming=HAMMING,NEGFREQ=NegFreq ,$
                                DOUBLE=Double ,Phase=_Phase ,TRUNC_PHASE=TRUNC_PHASE,KERNEL=kernel,SAMPLEPERIOD=SAMPLEPERIOD,COMPLEX=Complex)
           IF Set(PSpec) THEN PSpec = [PSpec, _PSpec] ELSE PSpec=_PSpec
           IF Set(PHASE) THEN BEGIN
               IF i EQ 0 THEN Phase=_Phase ELSE Phase = [Phase, _Phase]
           END
       END
       PSpec = TRANSPOSE(REFORM(PSpec, N_Elements(xaxis), slicec))
       IF Set(PHASE) THEN Phase = TRANSPOSE(REFORM(Phase, N_Elements(xaxis), slicec))
   END ELSE BEGIN
       PSpec = crosspower( series, series, xaxis, hamming=HAMMING,NEGFREQ=NegFreq ,$
                           DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE,KERNEL=kernel,SAMPLEPERIOD=SAMPLEPERIOD,COMPLEX=Complex)
   END

 Return,PSpec
END
