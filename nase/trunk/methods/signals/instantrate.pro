;+
; NAME: 
;  InstantRate()
;
; VERSION:
;  $Id$
;
; AIM:
;  Calculation of the instantaneous firing rate from spiketrains.
;
; PURPOSE: 
;  Calculation of the instantaneous firing rate from one or more 
;  trains of action
;  potentials. Computation is done either by counting the spikes
;  inside a given time window sliding over the trains or by convolving
;  the spike trains with a Gaussian window of given width, wich
;  results in a smoothed firing rate time course. Averaging
;  over a number of spiketrains is also supported. Fnord.
;
; CATEGORY: 
;  Statistics
;  Signals
;
; CALLING SEQUENCE: 
;* rate = Instantrate( spikes [,SAMPLEPERIOD=...]  
;*                            [,/GAUSS] [,SSIZE=...] [,SSHIFT=...]
;*                            [,TVALUES=...] [,TINDICES=...] 
;*                            [,AVERAGE=...])
;
;
; INPUTS: 
;  spikes:: A twodimensional binary array whose entries NE 0 are
;           interpreted as action potentials. First index: time, second
;           index: neuron- or trialnumber.
;
; INPUT KEYWORDS:
;  SAMPLEPERIOD:: Length of a BIN in seconds, needed to correctly
;                 compute firing rates in Hz, default: 0.001s
;  /GAUSS:: Calculates firing rate by convolving the spiketrain with a
;         Gaussian filter, resembling a probabilistic
;         interpretation. Otherwise, a rectangular mask is used for
;         convolution, corresponding to simply counting the spikes in
;         a given time window.
;         Using a gaussian gives a smoother result, but takes longer
;         to compute. 
;  SSIZE:: Width of window used to calculate the firing rate. If
;         keyword <*>/GAUSS</*> is set, <*>SSIZE</*> sets the standard
;         deviation of 
;         the Gaussian filter, if <*>GAUSS=0</*>, <*>SSIZE</*> sets
;         the half width of the rectangular convolution mask. Default: 20ms.
;  SSHIFT:: Shift of positions where firing rate is to be
;          computed. Default: 1BIN.
;
; OUTPUTS: 
;  rate:: Twodimensional array, containing the firing rates at the
;        desired times in Hz. First index: time, second index:
;        neuron-/trialnumber.
;
; OPTIONAL OUTPUTS: 
;  TVALUES:: Array containing the starting positions of the windows
;           used for rate calculation in ms.
;  TINDICES:: Array containing the starting indices of the windows
;            used for rate calculation relative to the original
;            array.
;  AVERAGE:: Array containing the firing rate averaged over all 
;            neurons/trials.
;
; RESTRICTIONS:
;  IDL's <C>Smooth</C> is used, which always increments its
;  smoothing range by 1 of the range supplied es even. Thus, the actual
;  width of the rectangular window used to count the spikes is
;* 2*Fix(ssize*0.001/sampleperiod)+1
; 
; PROCEDURE: 
;  Construct filter and convolve spiktrain with this. If
;  <*>GAUSS=0</*>, use IDL's <C>Smooth</C> with some array reformations.
;  <C>Smooth</C> in IDL5.4 cannot handle different ranges in different
;  dimensions, so the spike array is transformed to 1dim, smoothed and
;  transformed back. Average the result if desired.
;
; EXAMPLE: 
;*  a=fltarr(1000,10)
;*  a(0:499,*)=Randomu(s,500,10) le 0.01    ; 10 Hz 
;*  a(500:999,*)=Randomu(s,500,10) le 0.05  ; 50 Hz
;*  r=instantrate(a, ssize=100, sshift=10, tvalues=axis, average=av)
;*  rg=instantrate(a, /GAUSS, ssize=20, tvalues=axisg, average=avg)
;*  !p.multi=[0,1,4,0,0] 
;*  trainspotting, a 
;*  plot, axis, r(*,0)      
;*  plot, axis, av
;*  plot, axisg, avg
;
; SEE ALSO: <A>ISI()</A>.
;
;-


FUNCTION InstantRate, nt, SAMPLEPERIOD=sampleperiod $
                      , SSIZE=ssize, SSHIFT=sshift $
                      , TVALUES=tvalues, TINDICES=tindices $
                      , AVERAGE=average, GAUSS=gauss

   Default, gauss, 0
   Default, sampleperiod, 0.001
   Default, ssize, 20
;   __ssize = ssize*0.001/sampleperiod
   __ssize = Fix(ssize*0.001/sampleperiod) ;;__ssize is in array indices, thus integer

   snt = Size(nt)
   ;; add dimension if 1dim array is supplied
   IF snt[0] EQ 1 THEN snt = [snt[0:1], 1, snt[2:3]]

   IF Set(sshift) THEN __sshift = sshift*0.001/sampleperiod $
   ELSE __sshift = 1
      
   tindices = __sshift*LIndGen(snt[1]/__sshift)
   tvalues = tindices*1000.*sampleperiod

   IF Keyword_Set(GAUSS) THEN BEGIN
      ;; generate gaussian and convolve
      gausslength = 8*__ssize
      gaussx = FIndGen(gausslength)-gausslength/2
      mask = Exp(-gaussx^2/2./__ssize^2)/__ssize/sqrt(2*!PI)
      rates = Convol(Float(nt), mask, /EDGE_TRUNC)/sampleperiod
   ENDIF ELSE BEGIN
      ;; Smooth() works faster and is equivalent to convolution with
      ;; rectangular array
      ;; rates = Smooth(Float(nt), [__ssize, 1], /EDGE_TRUNC)/sampleperiod
      ;; works in IDL5.6, but not IDL5.4???

      ;; this version uses 1dim smoothing and correctly computes rates
      ;; at edges by adding 0s
      addlength = __ssize
      add = FltArr(addlength, snt[2])
      newnt = Reform([add, Float(nt), add], snt[4]+(addlength*2*snt[2]))
      rates = Smooth(newnt, 2*__ssize)/sampleperiod
      rates = Reform(rates, snt[1]+addlength*2, snt[2], /OVERWRITE)
      i1 = LIndGen(snt[1])+addlength
      rates = (Temporary(rates))[[i1], *]

      ;; old version: beware of edge effects if first or last entry is
      ;; a spike
      ;; mask = FltArr(2*__ssize+1)+1./(2.*__ssize+1)
      ;; rates = Convol(Float(nt), mask, /EDGE_TRUNC)/sampleperiod

   ENDELSE ;; Keyword_Set(GAUSS)

   rates = (Temporary(rates))[tindices, *]

   IF snt[0] NE 1 THEN $
    average= Total(rates,2)/snt[2] $ ;; two dimensional array
   ELSE $
    average = rates ;; one dimensional array
   
   Return, rates


END
