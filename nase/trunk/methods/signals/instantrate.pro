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
;  SAMPLEPERIOD:: Length of a BIN in seconds, default: 0.001s
;  /GAUSS:: Calculates firing rate by convolving the spiketrain with a
;         Gaussian filter, resembling a probabilistic
;         interpretation. Otherwise, a rectangular mask is used for
;         convolution, corresponding to simply counting the spikes in
;         a given time window.
;         Using a gaussian gives a smoother result. Note
;         that <*>SSIZE</*> may have to be adjusted depending on
;         whether <*>GAUSS</*> is set or not. 
;  SSIZE:: Width of window used to calculate the firing rate. If
;         keyword <*>/GAUSS</*> is set, <*>SSIZE</*> sets the standard
;         deviation of 
;         the Gaussian filter, if <*>GAUSS=0</*>, <*>SSIZE</*> sets
;         the total width of the rectangular convolution mask. Default: 20ms.
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
; PROCEDURE: 
;  Construct filter and convolve spiktrain with this. Average if desired.
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
   __ssize = ssize*0.001/sampleperiod

   snt = Size(nt)

   IF Set(sshift) THEN __sshift = sshift*0.001/sampleperiod $
   ELSE __sshift = 1
      
   tindices = __sshift*LIndGen(snt[1]/__sshift)
   tvalues = tindices*1000.*sampleperiod

   IF Keyword_Set(GAUSS) THEN BEGIN

      ;; generate gaussian for convolution
      gausslength = 8*__ssize
      gaussx = FIndGen(gausslength)-gausslength/2
      mask = Exp(-gaussx^2/2./__ssize^2)/__ssize/sqrt(2*!PI)

   ENDIF ELSE BEGIN

      ;; rectangular array for convolution
      mask = Make_Array(__ssize, /FLOAT, VALUE=1./__ssize)

   ENDELSE ;; Keyword_Set(GAUSS)

   rates = Convol(Float(nt), mask, /EDGE_TRUNC)/sampleperiod

   rates = (Temporary(rates))[tindices, *]

   IF snt[0] NE 1 THEN $
    average= Total(rates,2)/snt[2] $ ;; two dimensional array
   ELSE $
    average = rates ;; one dimensional array
   
   Return, rates


END
