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
;*                            [,AVERAGE=...] 
;*                            [,/SPASS][,/CENTER])
;
; INPUTS: 
;  spikes:: A twodimensional binary array whose entries NE 0 are
;           interpreted as action potentials. First index: time, second
;           index: neuron- or trialnumber. Alternatively, spikes can
;           be an array in sparse format, see also keyword <*>SPASS/*>
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
;         keyword <*>/GAUSS</*> is set, <*>SSIZE</*> sets the double standard
;         deviation of 
;         the Gaussian filter, if <*>GAUSS=0</*>, <*>SSIZE</*> sets
;         the width of the rectangular convolution mask. Default: 20ms.
;  SSHIFT:: Shift of positions where firing rate is to be
;          computed. Default: 1BIN.
;  /SPASS:: Indicates that the <*>spikes</*> input is in 
;           <A NREF=SPASSMACHER>sparse</A> or
;           <A NREF=SSPASSMACHER>binary</A> sparse format
;           (<C>InstantRate()</C> works with both 
;           formats). Note that the sparse array has to be generated
;           with the <*>/DIMENSIONS</*> option of <A>Spassmacher()</A> and
;           <A>SSpassmacher()</A> set. Supplying sparse inputs has no effect
;           on the output format of this routine, but it may save some
;           memory, since the input has not to be kept in a nearly
;           empty array.
;  /CENTER:: Center the sliding spike count window such that the spike
;            rate at time <*>t</*> is computed by counting the spikes
;            in the interval <*>[t-ssize/2,t+ssize/2]</*>. If
;            <*>CENTER</*> is not set, then the interval <*>[t-ssize,t]</*>
;            is used. Default: <*>CENTER=1</*>.
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
;* Round(NOT((ssize*0.001/sampleperiod) MOD 2)+__ssize)
;  which is always odd.
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
; SEE ALSO: <A>ISI()</A>, <A>Spassmacher()</A>, <A>SSpassmacher()</A> .
;
;-

FUNCTION InstantRate, nt, SAMPLEPERIOD=sampleperiod $
                      , SSIZE=ssize, SSHIFT=sshift $
                      , TVALUES=tvalues, TINDICES=tindices $
                      , AVERAGE=average, GAUSS=gauss $
                      , CENTER=center, SPASS=spass $
                      , MEMORYSAVE=memorysave 

   Default, spass, 0
   Default, center, 1
   Default, gauss, 0
   Default, sampleperiod, 0.001
   Default, ssize, 20
   __ssize = ssize*0.001/sampleperiod

   smoothssize = Round(NOT(__ssize MOD 2)+__ssize)
   IF NOT(__ssize MOD 2) THEN $
    Console, /WARN, 'Width of window in rate computing is actually ' $
     +Str(smoothssize)+'bins instead of '+Str(Round(__ssize))+'bins.'

   IF Set(sshift) THEN __sshift = sshift*0.001/sampleperiod $
       ELSE __sshift = 1

   snt = Size(nt)
   
   IF Keyword_Set(SPASS) THEN BEGIN

      ;; generate kernel: either gaussian or box
      IF Keyword_Set(GAUSS) THEN BEGIN
         gausslength = 4*__ssize
         gaussx = FIndGen(gausslength)-gausslength/2
         kernel = 2.*Exp(-2.*gaussx^2/__ssize^2)/__ssize/sqrt(2*!PI)
         addlength = gausslength
         halfadd = addlength/2
      ENDIF ELSE BEGIN
         kernel = Make_Array(smoothssize, /FLOAT, VALUE=1./smoothssize)
         addlength = smoothssize
         halfadd = addlength/2
      ENDELSE

      kidxarr = LIndGen(addlength)-halfadd ;; indices for kernel addition

      IF snt[0] EQ 1 THEN BEGIN
         ;; one dim sparse input -> SSPASS
         sdim = nt[nt[0]+2]
         IF sdim GT 2 THEN Console, /FATAL $
          , 'Only two dimensional spike arrays can be processed.'
         dur = nt[nt[0]+3]
         IF sdim EQ 1 THEN nsweeps = 1 $
          ELSE nsweeps = nt[nt[0]+4]

         ;; since sparse input uses onedimensional indices for the
         ;; rate array, putting the kernel at the end or the beginning
         ;; of sweeps would lead to overlap into the next
         ;; sweep. Therefore, the two dim rate array is temporarily expanded
         ;; at its beginning and end (variable addlength) such that
         ;; overlap does not matter. This expansion is later removed
         ;; again to regain the original array dimensions. The same
         ;; technique is used for non-sparse input as well to avoid
         ;; edge effects. 
         sizeratearray = [2, 2*addlength+dur, nsweeps, 4 $
                         , (2*addlength+dur)*nsweeps]
         rates = Make_Array(SIZE=sizeratearray)

         ;; put the kernel at spike positions
         FOR ispike=2l, nt[0]+1 DO BEGIN
            nownt = nt[ispike]
            isweep = Fix(nownt/dur) ;; integer result needed here
            i = kidxarr $
               +addlength*(2*isweep+1) $
               +nownt
            rates[i] = rates[i]+kernel
         ENDFOR

      ENDIF ELSE BEGIN
         ;; two dim sparse input -> SPASS
         sdim = nt[0, nt[0, 0]+1]
         IF sdim GT 2 THEN Console, /FATAL $
          , 'One and two dimensional spike arrays can be processed.'
         dur = nt[0, nt[0, 0]+2] 
         IF sdim EQ 1 THEN nsweeps = 1 $
          ELSE nsweeps = nt[0, nt[0, 0]+3]

         sizeratearray = [2, 2*addlength+dur, nsweeps, 4 $
                         , (2*addlength+dur)*nsweeps]
         rates = Make_Array(SIZE=sizeratearray)

         FOR ispike=1l, nt[0, 0] DO BEGIN
            nownt = nt[0, ispike]
            isweep = Fix(nownt/dur) ;; integer result needed here
            i = kidxarr $
               +addlength*(2*isweep+1) $
               +nownt
            rates[i] = rates[i]+nt[1, ispike]*kernel
         ENDFOR

      ENDELSE ;; SPASS

   ENDIF ELSE BEGIN

      IF snt[0] GT 2 THEN Console, /FATAL $
          , 'One and two dimensional spike arrays can be processed.'

      ;; add dimension if 1dim array is supplied
      IF snt[0] EQ 1 THEN snt = [snt[0:1], 1, snt[2:3]]

      dur = snt[1]
      nsweeps = snt[2]
      addlength = smoothssize

      IF Keyword_Set(GAUSS) THEN BEGIN
         add = FltArr(addlength, nsweeps)
         rates = [add, Float(nt), add]
         ;; generate gaussian and convolve
         gausslength = 4*__ssize
         gaussx = FIndGen(gausslength)-gausslength/2
         mask = 2.*Exp(-2.*gaussx^2/__ssize^2)/__ssize/sqrt(2*!PI)
         rates = Convol(rates, mask, EDGE_TRUNC=1, CENTER=1)
      ENDIF ELSE BEGIN
         ;; Smooth() works faster and is equivalent to convolution with
         ;; rectangular array
         ;; rates = Smooth(Float(nt), [__ssize, 1], /EDGE_TRUNC)/sampleperiod
         ;; works in IDL5.6, but not IDL5.4???
         
         ;; this version uses 1dim smoothing and correctly computes rates
         ;; at edges by adding 0s
         add = FltArr(addlength, nsweeps)
         rates = [add, Float(nt), add]
         rates = Reform(rates, snt[4]+(addlength*2*nsweeps), /OVERWRITE)
         rates = Smooth(rates, smoothssize)
         rates = Reform(rates, dur+addlength*2, nsweeps, /OVERWRITE)

         ;; old version: beware of edge effects if first or last entry is
         ;; a spike
         ;; mask = FltArr(2*__ssize+1)+1./(2.*__ssize+1)
         ;; rates = Convol(Float(nt), mask, /EDGE_TRUNC)/sampleperiod

      ENDELSE ;; Keyword_Set(GAUSS)

   ENDELSE ;; Keyword_Set(SPASS)

   IF NOT Keyword_Set(CENTER) THEN $
    IF snt[0] EQ 1 THEN rates = NoRot_Shift(rates, smoothssize/2) $
     ELSE rates = NoRot_Shift(rates, smoothssize/2, 0)
         
   ;; remove margins to obtain original dimensions
   i1 = LIndGen(dur)+addlength
   rates = rates[[i1], *]/sampleperiod

   tindices = __sshift*LIndGen(dur/__sshift)
   tvalues = tindices*1000.*sampleperiod
   
   IF __sshift NE 1 THEN $
   rates = rates[tindices, *]

   IF nsweeps NE 1 THEN $
    average= Total(rates,2)/nsweeps $ ;; two dimensional array
   ELSE $
    average = rates ;; one dimensional array
   
   Return, rates


END
