;+
; NAME:    COHERENCE
;
;
; PURPOSE:      The coherence function is a good method to make an estimation, 
;               how strong two signals are coupled in phase and amplitude over several trials.
;               The result is an array of cohrenceindexes Values:[0..1] as a function of the frequency.
;               If time slices of signals are used, the result is an two dimensonal array of 
;               cohrenceindexes [0..1] as a function of frequency and time.
;
;               SignalX    | equal       | unequal
;               SignalY    | amplitude   | amplitude
;               N Trials   | modulation  | modulation
;               --------------------------------------
;               equal      | high        |  medium
;               phase      | coherence   |  coherence
;               difference |             |
;               --------------------------------------
;               unequal    | medium      |  low
;               phase      | coherence   |  coherence
;               difference |             |          
;
;
; CATEGORY: Corrs + Specs
;
;
; CALLING SEQUENCE:  
;                       result =  coherence( SignalX, SignalY, CXY , 
;                                          [dimension = dimension], 
;                                          [SAMPLEPERIOD = SAMPLEPERIOD],
;                                          [F=F], [NEGFREQU=NEGFREQU],
;                                          [correction = correction])
;
; 
; INPUTS:               SignalX:   Array of time signal channel 1 (first dimension is the time)
;                       SignalY:   Array of time signal channel 2 (first dimension is the time)
;                                  (Max allowed dimension of input signals is 4)
;
;
;	
; KEYWORD PARAMETERS:
;                       dimension:    The Dimension in which the trials in SignalX or SignalY are hold (default: 2) 
;                       correction:   Correction of coherence in respect to the number of trials     
;                       sampleperiod: The time period of data sampling [ms]
;                       negfrequ:     The result includes also the negative frequencies (in the manner of FFT)
;                                     and CXY is the crossspectrum (complex!!)
;                                     
; OUTPUTS:
;                       Coherence between SIgnalX und SignalY
;
; OPTIONAL OUTPUTS:
;                       CXY: CrossPower of SIgnalX und SignalY
;;                      F: Array with the values of the frequence axis [Hz]
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.1  1998/08/11 10:31:32  gabriel
;           Dem N.A.S.E Standard angepasst (Org. von A. Bruns)
;
;
;-

;***********************************************************************************************
;
;FUNCTION  KOHAERENZFUNKTION  , SignaleX, SignaleY,   CXY
;                               d = dimension, k = korrektur
;
;***********************************************************************************************
;-----------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------


FUNCTION  __HAMMING,   N,   nonorm = nonorm

   a = 25.0/46
   h = a - (1-a)*COS(2*!pi*FINDGEN(N)/N)
   IF  KEYWORD_SET(nonorm)  THEN  RETURN, h   $
                            ELSE  RETURN, h / SQRT(TOTAL(h^2)/N_ELEMENTS(h))

END


;----------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------


FUNCTION  COHERENCE,  SignalX, SignalY,   CXY,  $
                      dimension = dimension, correction = correction ,$
                      SAMPLEPERIOD=SAMPLEPERIOD, F=F , NEGFREQ=NEGFREQ

   default,sampleperiod, 0.001
   default,correction,0
   default,dimension,2
   default,negfreq,0

   AnzTrials = (SIZE(SignalX))(Dimension)

   DatenBins = N_ELEMENTS(SignalX(*,0,0,0))

   F = SHIFT((findgen(DatenBins)-Datenbins/2)*1./(Sampleperiod)/FLOAT(DATENBINS),DatenBins/2)

   D2Bins    = N_ELEMENTS(SignalX(0,*,0,0))
   D3Bins    = N_ELEMENTS(SignalX(0,0,*,0))
   D4Bins    = N_ELEMENTS(SignalX(0,0,0,*))

   FFunktion = __HAMMING(DatenBins)
   SpektrenX = COMPLEXARR(DatenBins, D2Bins, D3Bins, D4Bins,  /nozero)
   SpektrenY = COMPLEXARR(DatenBins, D2Bins, D3Bins, D4Bins,  /nozero)

   FOR D2Nr=0L,D2Bins-1 DO  FOR D3Nr=0L,D3Bins-1 DO  FOR D4Nr=0L,D4Bins-1 DO  BEGIN  $
      SpektrenX(*,D2Nr,D3Nr,D4Nr) = FFT((SignalX(*,D2Nr,D3Nr,D4Nr) * FFunktion), -1)
      SpektrenY(*,D2Nr,D3Nr,D4Nr) = FFT((SignalY(*,D2Nr,D3Nr,D4Nr) * FFunktion), -1)
   ENDFOR

   CXY = TOTAL(SpektrenX * CONJ(SpektrenY), Dimension)
   CXX = TOTAL(ABS(SpektrenX)^2           , Dimension)
   CYY = TOTAL(ABS(SpektrenY)^2           , Dimension)

   K = ABS(CXY)^2 / (CXX*CYY)
   IF  KEYWORD_SET(correction)  THEN  K = K - (1-K)/AnzTrials

   IF NOT KEYWORD_SET(negfreq) THEN BEGIN
      K = K(0:DatenBins/2,*,*,*)
      CXY = abs(CXY(0:DatenBins/2,*,*,*))*2
      F = abs(F(0:DatenBins/2))
   ENDIF

   RETURN, K


END


;-----------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------
