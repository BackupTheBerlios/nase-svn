;+
; NAME:
;  Zhang()
;
; VERSION:
;  $Id$
;
; AIM:
;  Estimate stimulus from neuronal response using Bayesian inference.
;
; PURPOSE:
;  <C>Zhang()</C> is based on the one-step probabilistic method proposed
;  by Zhang et al. to reconstuct a rat's position from its
;  hippocampal place cell activity (Zhang et al.,
;  J. Neurophysiol. 79:1017, 1998). It statistically exploits the
;  simultaneous occurences of certain stimuli and neural activity to
;  estimate stimulus features from nerve cell responses. In doing so,
;  quantitative results about the coding accuracy of the respective
;  features may be obtained given the response measure. In its present
;  form, <C>Zhang()</C> is able to use as its input multidimensional
;  stimuli (as e.g. the position of an object in two-dimensional visual
;  space) and action potentials from multiple nerve cells.
;
; CATEGORY:
;  CombinationTheory
;  Math
;  Statistics
;  Signals
;
; CALLING SEQUENCE:
;* estimate = Zhang( s, r, [,EXTPRIOR=...][,PROBE=...]
;*                         [,SNBINS=...][,TAU=...][,SMEARTUNING=...]
;*                         [,/OPTIMAL][,/CENTER][,/VERBOSE]
;*                         [,GET_MEAN=...][,GET_PRIOR=...] )
;
; INPUTS:
;  s:: A floating point array containing the stimulus as a function of
;      time. The stimulus may have multiple dimensions or features, in
;      this case, the first dimension of the array <*>s</*> represents
;      time, the second dimension contains the stimulus features.
;  r:: Response, i.e. spike trains as a function of time. The format
;      is <*>r[time,neuron no.]</*>.
;
; INPUT KEYWORDS:
;  extprior:: In case of evaluating multiple response arrays that
;             share the same stimulus, the <I>a priori</I> distribution of
;             stimuli may be computed once and then supplied
;             externally using this keyword to save computational
;             time. See also optional output <*>get_prior</*>.   
;  probe:: <C>Zhang()</C> uses the response supplied with this keyword
;          only for estimation, not for the determination
;          of firing rates. This may be used to avoid
;          overfitting. When set, the result of the function is
;          determined by the <*>probe</*> response. Note that the
;          algorithm considers the <I>a priori</I>
;          distribution of stimuli <*>s</*> used to obtain the mean responses
;          and the probe responses to be the same.   
;  snbins:: Integer array specifying the number of bins to be used to
;           discretize the stimulus. The array needs to have as many
;           entries as there are stimulus features.
;  tau:: Width of the sliding time window that is used to count the
;        spike numbers and copmute the mean firing rates from the neuronal
;        response. Small <*>tau</*> increases the temporal resolution
;        of the response, but choosing it too low results in bad
;        reconstruction because of the lack of spikes inside the
;        intervals if activity is low. You should trade off <*>tau</*>
;        against firing rate, as choosing <*>tau</*> too large
;        smoothes the response too much. Thus, <*>tau</*> has to be
;        adapted to the timescale of stimulus changes <I>and</I> the
;        firing rate. Furthermore,
;        extra large <*>tau</*> may result in mathematical overflows
;        because of the computation of <*>rate^(no. of spikes)</*>.
;  smeartuning:: Floating point value.
;  /OPTIMAL:: As the final estimate, <C>Zhang()</C> may either use the
;             maximum (MAP method) or
;             the average of the <I>a posteriori</I> distribution (optimal
;             method). By default, the MAP method is used, but by
;             setting <*>/OPTIMAL</*>, the respective method is
;             applied. Optimal estimation may yield smoother 
;             results, as it is not restricted to the discrete
;             stimulus bins. On the other hand, optimal estimation is
;             not recommended with two-peak 
;             distributions, because the second peak shifts the mean
;             towards lower values. MAP does not have this problem. If
;             e.g. velocity and direction of motion is estimated, this
;             effect becomes profound. Default: <*>OPTIMAL=0</*>
;  /CENTER:: If rate is interpreted as firing during some short <I>past</I>
;            time interval, shift the rate array because smooth
;            returns rates centered within the tau
;            interval. <*>CENTER=0</*> corresponds to measuring the
;            rates by counting the spikes in the interval <*>[t-tau,t]</*>,
;            <*>CENTER=1</*> corresponds to Zhangs original algorithm,
;            counting spikes in the interval <*>[t-tau/2,t+tau/2]</*>,
;            but maybe less realistic when exact timing is
;            relevant. The setting of <*>CENTER</*> is passed to
;            <A>InstantRate()</A>. Default: <*>CENTER=0</*>
;  /VERBOSE:: Print information about the routines progress into the
;             <A NREF=INITCONSOLE>console</A>. Default: <*>VERBOSE=0</*>.
;
; OUTPUTS:
;  estimate::
;
; OPTIONAL OUTPUTS:
;  get_mean:: Double array giving the mean firing rates of each neuron
;             as a function of the stimulus. The first <*>n</*> dimensions
;             indicate the stimulus dimensions, the last index is used
;             for the neurons.  
;  get_prior:: Structure containing information about the <I>a priori</I>
;              distribution of stimuli. In particular, the following
;              tags are contained:<BR>
;              <*>get_prior.pr</*>: prior distribution, i.e. the relative
;                            frequency of stimuli. The dimensions are
;                            corresponding to the setting of
;                            <*>snbins</*>.<BR>
;              <*>get_prior.bv</*>: Data values corresponding to the
;                            histogram bins.<BR>
;              <*>get_prior.ri</*>: List of reverse indices, see
;                            documentation of IDL's
;                            <C>Histogram()</C>.<BR>
;              <*>get_prior.th</*>: Total number of prior histogram
;                                   entries. This may be used to
;                                   recompute the number of entries in
;                                   each stimulus histogram bin, to
;                                   check how often each stimulus
;                                   actually occurred. 
;
; RESTRICTIONS:
;  Stimulus dimension GT 2 tested only marginally.
;
; PROCEDURE:
;  Essentially counting.
;  
; EXAMPLE:
;* duration = 1000
;* ;; Array to save spikes of 20 neurons in
;* r = BytArr(duration, 20)
;* ;; Stimulus moves in Cosine-wave along single dimension
;* pos = 6.*Cos(FIndGen(duration)/duration*24.*!PI)+10.
;* ;; Gaussian receptive field of the neurons, amplitude scales firing
;* ;; rate
;* rf = 0.1*Gauss_2D(9, 1, 3, 0, 0)
;* 
;* ;; generate responses, RFs of cells are positioned along stimulus
;* ;; motion, cells are thus activated sequentially
;* FOR t=0, duration-1 DO BEGIN
;*    s = FltArr(20)
;*    s(pos(t)) = 1.
;*    r(t, *) = RandomU(seed, 20) LE Convol(s, rf, /EDGE_TRUNC)
;* ENDFOR
;* 
;* ;; Compute estimate of position for the first 3 quarters of the
;* ;; "experiment".
;* e1 = Zhang(pos(0:duration/4*3-1) $
;*            , r(0:duration/4*3-1, *) $
;*            , SNBINS=[15], TAU=17)
;* ;; "Training" of algorithm with first 3 quarters of the data, then
;* ;; estimate the stimulus from reponses in the fourth quarter.
;* e2 = Zhang(pos(0:duration/4*3-1) $
;*            , r(0:duration/4*3-1, *) $
;*            , PROBE=r(duration/4*3:duration-1, *) $
;*            , SNBINS=[15], TAU=17)
;* 
;* ;; Display response spike trains, stimulus (white) and estimate
;* ;; (green/yellow).
;* !P.multi = [0, 1, 2, 0, 0]
;* Trainspotting, r
;* Plot, pos
;* OPlot, IndGen(duration/4*3), e1(*, 0), COLOR=RGB('green')
;* OPlot, IndGen(duration/4)+duration/4*3, e2(*, 0), COLOR=RGB('yellow')
;
; SEE ALSO:
;  <A>Instantrate()</A>
;-

;; NOTES
;;
;; estimation
;; for each time take numbers ni and potentiate fi accordingly
;; maybe faster: first find all occurences of same ni. maybe seldom,
;;               not really needed?
;;
;; CHOOSE binsize such that no cells contains zeros? Or choose binsize
;; such that all bins ne 0 contain certain minimum number?
;;
;;
;; Best possibility to avoid outliers: Measure tuning curves as
;; smoothly as possible by repeating stimuli as opften as possible.
;; If only few sweeps are available: Smooth tuning curves by:
;; + adding constant offset to elements eq 0. (works, but adds some
;; offset to the mean activity).
;; + smearing tuning curves gy gaussian convol (seems to make more
;; sense, argue that tuning is not measuerd exactly by few samples, so
;; it really may be broader. Convolution with normalized function
;; keeps the overall firing rates). Probe with different sigma, seems
;; rather robust???
;; - adding noise to explore surround af tuning curves results in
;; fewer instances with the "right" stimulus and therefore in lesser
;; reconstruction quality. 
;;
;; ??? 
;; strange fluctuations of estimation depending on tau?


FUNCTION Zhang, s, r, EXTPRIOR=extprior $
                , PROBE=probe, SNBINS=snbins, TAU=tau $
                , SMEARTUNING=smeartuning $
                , OPTIMAL=optimal, CENTER=center $
                , VERBOSE=verbose $
                , GET_MEAN=get_mean, GET_PRIOR=get_prior

   Default, snbins, [11, 11]
   Default, tau, 11 ;; ms
   tau = Float(tau)
   Default, center, 0
   Default, optimal, 0
   Default, verbose, 0


   ssize = Size(s)
   sdur = ssize(1)
   IF ssize(0) EQ 1 $
    THEN sdim = 1 $
   ELSE sdim = ssize(2)
   IF sdim GT 1 THEN BEGIN
      smin = IMin(s, 1)
      smax = IMax(s, 1)
   ENDIF ELSE BEGIN
      smin = Min(s, MAX=smax)
   ENDELSE 

   sbinsize = (smax-smin)/(snbins-1)

   IF Set(extprior) THEN BEGIN
      IF Keyword_Set(VERBOSE) THEN  BEGIN
         Console, /MSG, '.'
         Console, /MSG, 'External prior supplied.'
      ENDIF
      prior = extprior.pr
      sbinval = extprior.bv
      srevidx = extprior.ri
      totshist = extprior.th
   ENDIF ELSE BEGIN
      IF Keyword_Set(VERBOSE) THEN  BEGIN
         Console, /MSG, '.'
         Console, /MSG, 'Determining prior.'
      ENDIF
      shist = HistMD(s, NBINS=snbins, GET_BINVALUES=sbinval $
                     , REVERSE_INDICES=srevidx)
      totshist = Total(shist)
      prior = shist/totshist
      UnDef, shist
   ENDELSE

   sp = Size(prior)


   IF Keyword_Set(VERBOSE) THEN Console, /MSG, 'Computing likelihoods.'

   sr = Size(r)
   lr = sr(1) ;; length of response
   
   IF sr(0) GT 1 THEN $
    nr = sr(2) $ ;; number of responses
   ELSE $
    nr = 1 ;; number of responses
 
      
   srate = sr
   srate(srate(0)+1) = 4 ;; make rate array float type
   rate = Make_Array(SIZE=srate)


   realtau = NOT(tau MOD 2)+tau

   IF Keyword_Set(VERBOSE) AND NOT(tau MOD 2) THEN $
    Console, /WARN, 'Width of window in rate computing is actually ' $
     +Str(realtau)

   rate = InstantRate(r, SSHIFT=1, SSIZE=tau/2, /MEMORYSAVE, CENTER=center)
    
   ;; compute spike numbers from rates, consider SMOOTH can only
   ;; handle odd window lengths, so correct for this by using
   ;; realtau which is always odd.

; Less memory consuming, but beware of precision when converting to
; integer type, some 0.999999 may be set to 0
;   IF Set(probe) THEN $
;     ni = Fix(InstantRate(probe, SSHIFT=1, SSIZE=tau/2)*realtau*0.001) $
;   ELSE $
;    ni = Fix(rate*realtau*0.001)
   IF Set(probe) THEN BEGIN
      ;; see above
      ni = InstantRate(probe, SSHIFT=1, SSIZE=tau/2, CENTER=center) $
       *realtau*0.001
   ENDIF ELSE $
    ni = rate*realtau*0.001


   sf = [sp(0)+1, sp(1:sp(0)), nr, 5, sp(sp(0)+2)*nr]
   ;; f is DOUBLE to avoid overflows when potentiation is done later
   f = Make_Array(SIZE=sf)

   sum = Make_Array(SIZE=sp, /DOUBLE)

   IF Set(smeartuning) THEN BEGIN
      IF smeartuning GT 0. THEN BEGIN
         xmask = Double(DistMD(IntArr(sdim)+Fix(6*smeartuning+1)))
         mask = Exp(-0.5/smeartuning^2*xmask^2)
         mask = mask/Total(mask)
         sm = Size(mask)
         IF Min(sp[1:sp[0]]-sm[1:sm[0]]) LT 0. THEN Console, /FATAL $
          , 'SMEARTUNING is too large.'
      ENDIF
   ENDIF ELSE smeartuning = 0.


   ;; loop of response dimensions
   FOR rdimidx=0, nr-1 DO BEGIN
      ;; loop of stimulus bins
      FOR sbinidx=0, sp(sp(0)+2)-1 DO BEGIN
         ;; stimulus bin not empty?
         IF srevidx(sbinidx) NE srevidx(sbinidx+1) THEN BEGIN
            flatf = FlatIndex(sf, [Subscript(sbinidx, SIZE=sp), rdimidx])
            current = $
             (UMoment(rate(srevidx(srevidx(sbinidx):srevidx(sbinidx+1)-1) $
                           , rdimidx), ORDER=0))(0)
            f(flatf) = current
         ENDIF ;; stimulus bin not empty?
      ENDFOR ;; sbinidx

      ;; 1dim array with slice consisting of f(*,*,rdimidx)
      sliceidx = IndGen(sp(sp(0)+2))+rdimidx*sp(sp(0)+2)
      fcurrent = Reform(f(sliceidx), sp(1:sp(0)))

      IF smeartuning GT 0. THEN BEGIN
         fnew = Convol(fcurrent, mask, /EDGE_TRUNC)
         f(sliceidx) = fnew
         sum = sum+fnew    
      ENDIF ELSE BEGIN
         sum = sum+fcurrent
         ENDELSE ;; smeartuning GT 0.

   ENDFOR ;; rdimidx

   ;; This adds offset activity to all tuning curves, see header   
   ;;   feq0 = Where(f EQ 0.)
   ;;   f(feq0) = 0.1

   esum = Exp(-tau*0.001*sum)
   ep = esum*prior

   ;; use length of probe response instead of length of training
   ;; response 
   IF Set(probe) THEN lr = (Size(probe))[1] 

   ;; Start estimation
   IF Keyword_Set(VERBOSE) THEN BEGIN
      Console, /MSG, 'Estimate stimuli.'
      SimTimeInit, MAXSTEPS=100, /PRINT, CONSOLE=!CONSOLE
   ENDIF

   se = [sdim+1, lr, sdim, 4, sdim*lr]
   estimate = Make_Array(SIZE=se)
   sdimidx = IndGen(sdim)

   FOR t=0l, lr-1 DO BEGIN
      prod = Make_Array(SIZE=sp, VALUE=1., /DOUBLE)
      ;; loop of response dimensions
      FOR rdimidx=0, nr-1 DO BEGIN
         ;; 1dim array with slice consisting of f(*,*,rdimidx)
         sliceidx = IndGen(sp(sp(0)+2))+rdimidx*sp(sp(0)+2)
         fcurrent = Reform(f(sliceidx), sp(1:sp(0)))
         prod = Temporary(prod)*fcurrent^ni(t, rdimidx)

         ;; smear products, tuning curve gets broader when no spikes
         ;; arrive, similar to Jäkel, but without continuity???
         ;; prod = Convol(prod, Gauss_2D(5, 5, 0.2, /NORM), /EDGE_TRUNC)

         IF Min(Finite(prod)) LT 1 THEN Console, /FATAL $
          , 'Overflow during potentiation. Try lower TAU.'
      ENDFOR ;; rdimidx

      posterior = prod*ep

      ;; determine index of maximum or mean of posterior
      IF Keyword_Set(OPTIMAL) THEN BEGIN
         ;; normalization needed for optimal estimator
         posterior = posterior/Total(posterior)
         smultidimidx = CenterOfMass(posterior)
         IF smultidimidx(0) EQ !NONE THEN BEGIN
            Console, /FATAL $
             , 'No center of mass could be found at time '+Str(tidx)+'.'
         ENDIF
         ;; use intermediate values returned by CenterofMass, not
         ;; integer array indices, to result in smoother estimate
         estimate[t, *] = smin+smultidimidx*sbinsize
      ENDIF ELSE BEGIN
         dummy = Max(posterior, estidx)
         smultidimidx = Subscript(estidx, SIZE=sp)
         ;; select stimulus values by smultidimidx and return estimate
         estimate[t, *] = sbinval[smultidimidx+1,sdimidx]
      ENDELSE

      IF Keyword_Set(VERBOSE) AND (((t+1) MOD (lr/100)) EQ 0) THEN SimTimeStep

   ENDFOR ;; time 

   IF Keyword_Set(VERBOSE) THEN SimTimeStop

   get_mean = f
   get_prior = {pr: prior $
                , bv: sbinval $
                , ri: srevidx $
                , th: totshist}

   Return, estimate

END 
