;+
; NAME:
;  SlidPowerSpec()
;
; VERSION:
;  $Id$
;
; AIM:
;  time resolved power spectrum for one or several signals 
;
; PURPOSE:
;  This routine performs a sliding power spectrum. Using
;  <*>SlidPowerSpec</*> instead of <A>PowerSpec</A> allows to analyze
;  the temporal development of a spectrum at the cost of decreased
;  frequency resolution.
;
; CATEGORY:
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* sps = SlidPowerSpec(series [,slicesize [,f]] [,PHASE=phase]
;*                     [,TRUNC_PHASE=trunc_phase],
;*                     [,SAMPLEPERIOD=sampleperiod]
;*                     [,SLICESIZE=...] [,F=f]
;*                     [,/AVERAGE]
;
; INPUTS:
;  series:: a single time series or multiple
;           time series (time, other-dimensions), all other
;           dimensions are iterated
;  slicesize:: the size of the sliding window in ms (default: 256). Specify either
;              the positional or the keyword parameter.
;
; INPUT KEYWORDS:
;  TRUNC_PHASE::  phase contribution for values <*>LE (TRUNC_PHASE (in Prozent) * MAX(ps))</*>
;                 will be set to zero
;  SAMPLEPERIOD:: sample period of <*>series</*> in seconds (default: 0.001)
;  SLICESIZE:: the size of the sliding window in ms (default: 256). Specify either
;              the positional or the keyword parameter.
;  AVERAGE:: computes time resolved spectra and then averages across
;            all slices of the same time series. This is not the same
;            as using <A>PowerSpec</A>!
;
; OUTPUTS:
;  sps:: resulting time-resolved powerspectra (frequency, slice,
;        other-dimensions) or averaged time-resolved powerspectra
;        (frequency, other-dimensions), if <*>/AVERAGE</*> is set.
;
; OPTIONAL OUTPUTS:
;  F:: the frequency axis corresponding to the first index of
;      <*>sps</*> will be returned on request. Please specify either
;      the positional or the keyword parameter!
;  phase:: returns the phase angles corresponding to the frequency values
;  tvalues:: Returns the times/ms at which parts start.
;  tindices:: Returns starting time array indices of the parts.
;
; SIDE EFFECTS:
;  <*>f</*> will be redefined, if passed
;
; PROCEDURE:
;  uses <A>PowerSpec</A> and <A>Slices</A>
;
; EXAMPLE:
;* series = RandomU(seed, 4000, 20)
;* SlidSpec = SlidPowerSpec(series, SLICESIZE=256, F=f)
;
;-

FUNCTION SlidPowerSpec, series, slicesize, x,DOUBLE=Double ,Phase=Phase ,TRUNC_PHASE=TRUNC_PHASE, SAMPLEPERIOD=sampleperiod, TVALUES=TVALUES, TINDICES=TINDICES, AVERAGE=average, SLICESIZE=_slicesize, F=f

   default,double,0
   
   
   IF (N_PARAMS() LT 1 )     THEN console, /fatal , 'wrong number of arguments'
   Default, _slicesize, 256
   Default, slicesize, _slicesize

   IF set(TRUNC_PHASE) AND NOT set(PHASE)   THEN console, /fatal, 'Keyword TRUNC_PHASE must be set with Keyword PPHASE'
   
   N = N_Elements(series)
   IF (N LT slicesize) THEN Console, /fatal, 'number of elements less than slicesize!!'
   
   signal_slice = slices(series, SSIZE=slicesize, SAMPLEPERIOD=SAMPLEPERIOD, TVALUES=TVALUES, TINDICES=TINDICES, /TFIRST)
   s_s = size(signal_slice)
   
   
   IF SET(Phase) THEN BEGIN
       PSpec = PowerSpec(signal_slice, x, /DOUBLE,$
                         /HAMMING,PPHASE=slidephase,  SAMPLEPERIOD=sampleperiod)
   END ELSE BEGIN 
       PSpec = PowerSpec(signal_slice, x, /DOUBLE,$
                         /HAMMING, SAMPLEPERIOD=sampleperiod)
   ENDELSE
   PSpec = TEMPORARY(PSpec) / FLOAT(N/(2*slicesize))

   IF Keyword_Set(AVERAGE) THEN RETURN, TOTAL(PSpec, 2) $
                           ELSE RETURN, PSpec
END
