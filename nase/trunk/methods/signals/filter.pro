;+
; NAME: FILTER
;
;
; PURPOSE: 
;
;               The FILTER function returns the coefficients of a non-recursive, 
;               digital filter for evenly spaced data points. 
;               Frequencies are expressed in terms of the Nyquist frequency,
;               1/2T, where T is the time between data samples. Highpass, lowpass, bandpass and 
;               bandstop filters may be constructed with this function. The resulting vector of 
;               coefficients has (2 x Nterms + 1) elements.
;
;
; CATEGORY: SIGNALS
;
;
; CALLING SEQUENCE:
;                          Result = FILTER(Flow, Fhigh, A, Nterms,[SAMPLEPERIOD=SAMPLEPERIOD])
;
; 
; INPUTS:                  
;                          Flow:         The lower frequency of the filter in Hz (default: 0 Hz)
;                          Fhigh:        The upper frequency of the filter in Hz (default: 1/(2*SamplPeriod) Hz)
;
;                                        · No Filtering: Flow = 0, Fhigh = 1/(2*SamplPeriod)
;                                        · Low Pass: Flow = 0, 0 < Fhigh < 1/(2*SamplPeriod)
;                                        · High Pass: 0 < Flow < 1/(2*SamplPeriod), Fhigh =1/(2*SamplPeriod)
;                                        · Band Pass: 0 < Flow < Fhigh < 1/(2*SamplPeriod)
;                                        · Band Stop: 0 < Fhigh < Flow < 1/(2*SamplPeriod)
;
;                          A:            The size of Gibbs phenomenon wiggles in -db. 50 is a good choice.
;                          Nterms:       The number of terms in the filter formula. The order of filter.
;	
;
; KEYWORD PARAMETERS:
;                          SAMPLEPERIOD:  The time between data samples (default: 0.001 s)
;
; OUTPUTS:                 The result are the Coefficents of the filter
;
;
; EXAMPLE:                 
;              Coeff = DIGITAL_FILTER(Flow, Fhigh, A, Nterms)    ;To get coefficients.
;
;              Followed by:
;
;              Yout = CONVOL(Yin, Coeff)          ;To apply the filter.
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  1998/08/17 16:20:05  gabriel
;           Keyword SAMPLPERIOD auf SAMPLEPERIOD umbenannt
;
;     Revision 1.1  1998/07/27 09:58:21  gabriel
;          First Commit
;
;
;-
FUNCTION filter,flow,fhigh,a,Nterms,SAMPLEPERIOD=SamplePeriod

default,Sampleperiod, 0.001
default,flow,0
nyquistfreq =  1./(2. * Sampleperiod)
default,fhigh,nyquistfreq

nyflow = flow/nyquistfreq

nyfhigh = fhigh/nyquistfreq

IF nyflow GT 1 OR nyfhigh GT 1 THEN message,'flow or fhigh greater than Nyquest-Frequency (1/(2*SamplePeriod))'

coeff = digital_filter(nyflow,nyfhigh,A,Nterms)

return,coeff

END
