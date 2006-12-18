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
;* estimate = Zhang( s[, r] [,PRIORDIST=...][,PRIORSTRUCT=...]
;*                          [,PROBERESPONSE=...]
;*                          [,RATEFILE=...]
;*                          [,PROBEIDX=...]
;*                          [,SNBINS=...][,TAU=...][/SPASS]
;*                          [,/OPTIMAL][,/CENTER][,/VERBOSE]
;*                          [,GET_MEAN=...][,GET_PRIOR=...] )
;
; INPUTS:
;  s:: A floating point array containing the stimulus as a function of
;      time. The stimulus may have multiple dimensions or features, in
;      this case, the first dimension of the array <*>s</*> represents
;      time, the second dimension contains the stimulus features.
;
; OPTIONAL INPUTS:
;  r:: Response, i.e. spike trains as a function of time. The format
;      is <*>r[time,neuron no.]</*>. Alternatively, the neural
;      response may be supplied as a file. In this case, <*>r</*> may be
;      omitted. See keyword <*>RATEFILE</*>. 
;
; INPUT KEYWORDS:
;  priordist:: A priori distribution of stimuli...   
;  priorstruct:: In case of evaluating multiple response arrays that
;             share the same stimulus, the <I>a priori</I> distribution of
;             stimuli may be computed once and then supplied
;             externally using this keyword to save computational
;             time. See also optional output <*>get_prior</*>.   
;  proberesponse:: <C>Zhang()</C> uses the response supplied with this keyword
;          only for estimation, not for the determination
;          of firing rates. This may be used to avoid
;          overfitting. When set, the result of the function is
;          determined by the <*>probe</*> response. Note that the
;          algorithm considers the <I>a priori</I>
;          distribution of stimuli <*>s</*> used to obtain the mean responses
;          and the probe responses to be the same.
;  ratefile:: Supply a filename here that is used to obtain firing
;             rate information, in case the amount of data is too
;             large to be kept in memory completely. The firing rate
;             file has to be generated using the NASE video
;             function. Its frames are floating type arrays containing
;             the firing rates of single cells (prototypes) as a function of
;             time. For multiple cell data, such single cell frames
;             have to be concatenated within the video. Experimental
;             repetitions using the same stimulus (sweeps) can then be
;             concatenated as well, starting with the frame of the
;             first neuron's firing rates. Thus, correct video
;             generation looks like this:
;*
;*             FOR sweepidx=0, nsweeps-1 DO BEGIN
;*              FOR prototypeidx=0, nproto-1 DO BEGIN
;*
;*               frame=array[timeidx, pridx, swidx]
;*               frno=CamCord(myvideo, frame)
;*
;*              ENDFOR
;*             ENDFOR
;*     
;  probeidx:: For data supplied in a <*>rate file</*> video, this keyword
;             specifies which of the sweeps is used for
;             validation, corresponding to the <*>proberesponse</*>
;             keyword of the case which keeps all data in memory.
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
;  /SPASS:: Indicates that the <*>r</*> and <*>probe</*> input is in 
;           <A NREF=SPASSMACHER>sparse</A> or
;           <A NREF=SSPASSMACHER>binary</A> sparse format. The setting
;           of this keyword is passed to the <A>InstantRate()</A>
;           routine, which works with both 
;           formats. Note that the sparse array has to be generated
;           with the <*>/DIMENSIONS</*> option of <A>Spassmacher()</A> and
;           <A>SSpassmacher()</A> set. Supplying sparse inputs may save some
;           memory, since the input has not to be kept in a nearly
;           empty array. Default: <*>SPASS=0</*>.
;  /OPTIMAL:: As the final estimate, <C>Zhang()</C> may either use the
;             maximum (MAP method) or
;             the average of the <I>a posteriori</I> distribution (optimal
;             method). By default, the MAP method is used, but by
;             setting <*>/OPTIMAL</*>, the respective method is
;             applied. Optimal estimation may yield smoother 
;             results, as it is not restricted to the discrete
;             stimulus bins. On the other hand, optimal estimation is
;             not recommended with bimodal
;             distributions, because the second peak shifts the mean
;             towards lower values. MAP does not have this problem. If
;             e.g. velocity and direction of motion is estimated, this
;             effect becomes profound. Default: <*>OPTIMAL=0</*>
;  /CENTER:: <*>CENTER=0</*> corresponds to measuring the
;            rates by counting the spikes in the interval <*>[t-tau,t]</*>,
;            <*>CENTER=1</*> corresponds to Zhangs original algorithm,
;            counting spikes in the interval <*>[t-tau/2,t+tau/2]</*>,
;            but maybe less realistic when exact timing is
;            relevant, since in this case future information is
;            included into the present estimation. The setting of
;            <*>CENTER</*> is passed to
;            <A>InstantRate()</A>. Default: <*>CENTER=0</*>
;  /VERBOSE:: Print information about the routines progress into the
;             <A NREF=INITCONSOLE>console</A>. Default: <*>VERBOSE=0</*>.
;
; OUTPUTS:
;  estimate:: The estimate of the stimulus vector as a function of
;             time.
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


FUNCTION Zhang, s, r, PRIORSTRUCT=priorstruct, PRIORDIST=priordist $
                , PROBERESPONSE=proberesponse, SNBINS=snbins, TAU=tau $
;                , SMEARTUNING=smeartuning $
                , OPTIMAL=optimal, CENTER=center $
                , SPASS=spass $
                , VERBOSE=verbose $
                , RATEFILE=ratefile $
                , PROBEIDX=probeidx $
                , SYMMETRIC=symmetric $
                , GET_MEAN=get_mean, GET_PRIOR=get_prior

   Default, tau, 11 ;; ms
   tau = Float(tau)
   Default, center, 0
   Default, optimal, 0
   Default, verbose, 0
   Default, spass, 0
   Default, probeidx, 0


   IF Set(priorstruct) THEN BEGIN
      IF Keyword_Set(VERBOSE) THEN  BEGIN
         Console, /MSG, '.'
         Console, /MSG, 'Prior structure supplied.'
      ENDIF
   ENDIF ELSE BEGIN
      IF Keyword_Set(VERBOSE) THEN  BEGIN
         Console, /MSG, '.'
         Console, /MSG, 'Determining prior structure.'
      ENDIF

      priorstruct=ZhangPrior(s, SNBINS=snbins, PRIORDIST=priordist $
                             , SYMMETRIC=symmetric)

   ENDELSE

   sp = Size(priorstruct.pr)
   nelemprior = sp[sp[0]+2]
   idxarr = LIndGen(nelemprior)

   IF Keyword_Set(VERBOSE) THEN Console, /MSG, 'Computing likelihoods.'

   
   IF Set(ratefile) THEN BEGIN

      IF Keyword_Set(SPASS) THEN Console, /FATAL $
       , 'Keyword SPASS not allowed when reading rates from disc.' 

      ratevideo=LoadVideo(ratefile, UDS=info, /SHUTUP)

      sr = info.sizearray
      tau = info.tau
      realtau = info.realtau

      IF sr[0] NE 3 THEN Console, /FATAL $
       , 'Rate array on disc is not 3dimensional.' 

      lr = sr[1] 
      nr = sr[2] ;; number of responses
      nsweeps = sr[3] ;; number of sweeps
 
      sf = [sp[0]+1, sp[1:sp[0]], nr, 4, nelemprior*nr]
      f = Make_Array(SIZE=sf)
      sum = Make_Array(SIZE=sp)

      totf=Make_Array(SIZE=sf)

      FOR swidx=0, nsweeps-1 DO BEGIN

         ;; loop of response dimensions
         FOR rdimidx=0, nr-1 DO BEGIN
         
            ;; skip those frames that are later used for probing
            IF swidx EQ probeidx THEN BEGIN
               dummy=Replay(ratevideo)
            ENDIF ELSE BEGIN ;; swidx EQ probeidx 

               rate=Replay(ratevideo)

               ;; loop of stimulus bins
               FOR sbinidx=0, nelemprior-1 DO BEGIN

                  nentries=priorstruct.ri[sbinidx+1]-priorstruct.ri[sbinidx]
                  ;; stimulus bin not empty?
                  IF nentries NE 0 THEN BEGIN
                     flatf = FlatIndex(sf $
                                       , [Subscript(sbinidx, SIZE=sp) $
                                          , rdimidx])
                     f[flatf] = f[flatf] + $
                                Total(rate $
                                      [priorstruct.ri[priorstruct.ri[sbinidx]: $
                                               priorstruct.ri[sbinidx+1]-1]])
                     ;; count the entries to average later
                     totf[flatf]=totf[flatf] + nentries
                  ENDIF ;; stimulus bin not empty
               ENDFOR ;; sbinidx
               
            ENDELSE ;; swidx EQ probeidx 
            
         ENDFOR ;; rdimidx

      ENDFOR ;; swidx

      totnzero=Where(totf NE 0., count)

      IF count EQ 0 THEN Console, /FATAL, 'No entries for tuning function.' $
       ELSE f[totnzero]=f[totnzero]/totf[totnzero]

      sum=Total(f,sp[0]+1)

   ENDIF ELSE BEGIN ;; Set(ratefile)

      IF Keyword_Set(SPASS) THEN BEGIN
         IF (Size(r))[0] EQ 1 THEN BEGIN
            ;; SSPASS
            sr = [r[r[0]+2], r[r[0]+3:*], 1, r[1]]
         ENDIF ELSE BEGIN
            ;; SPASS
            sr = [r[0, r[0, 0]+1], r[0, r[0, 0]+2], r[0, r[0, 0]+3], 4, r[1, 0]]
         ENDELSE
      ENDIF ELSE BEGIN
         sr = Size(r)
      ENDELSE

      IF sr[0] GT 1 THEN $
       nr = sr[2] $ ;; number of responses
      ELSE $
       nr = 1 ;; number of responses
 
      ;; consider SMOOTH inside InstantRate() can only
      ;; handle odd window lengths, so correct for this by using
      ;; realtau which is always odd.   
      realtau = NOT(tau MOD 2)+tau
      IF Keyword_Set(VERBOSE) AND NOT(tau MOD 2) THEN $
       Console, /WARN, 'Width of window in rate computing is actually ' $
                +Str(realtau)

      rate = InstantRate(r, SSHIFT=1, SSIZE=realtau  $
                         , CENTER=center, SPASS=spass)
      
      sf = [sp[0]+1, sp[1:sp[0]], nr, 4, nelemprior*nr]
      f = Make_Array(SIZE=sf)
      sum = Make_Array(SIZE=sp)

      ;; loop of response dimensions
      FOR rdimidx=0, nr-1 DO BEGIN
         
         ;; loop of stimulus bins
         FOR sbinidx=0, nelemprior-1 DO BEGIN
            ;; stimulus bin not empty?
            IF priorstruct.ri(sbinidx) NE priorstruct.ri(sbinidx+1) THEN BEGIN
               flatf = FlatIndex(sf, [Subscript(sbinidx, SIZE=sp), rdimidx])
               f[flatf] = $
                Total(rate[priorstruct.ri[priorstruct.ri[sbinidx]:priorstruct.ri[sbinidx+1]-1] $
                           , rdimidx])/(priorstruct.ri[sbinidx+1]-priorstruct.ri[sbinidx])
            ENDIF ;; stimulus bin not empty
         ENDFOR ;; sbinidx
         
         ;; 1dim array with slice consisting of f(*,*,rdimidx)
         ;; sliceidx = idxarr+rdimidx*nelemprior
         
         ;; sum = Temporary(sum)+Reform(f[sliceidx], sp[1:sp[0]])
         
      ENDFOR ;; rdimidx

      sum=Total(f,sp[0]+1)


      ;; compute spike numbers from rates, either for probe or for
      ;; training stimulus

      ;; rate contains now integer spike numbers, this was formerly
      ;; contained in the variable "ni". To save memory, non-integer rates
      ;; are now overwritten, because they are no longer needed.
      IF Set(proberesponse) THEN BEGIN
         rate = InstantRate(proberesponse, SSHIFT=1, SSIZE=realtau $
                            , CENTER=center, SPASS=spass, /COUNT)
      ENDIF ELSE $
       rate = Temporary(rate)*realtau*0.001
      
      ;; use length of probe response instead of length of training
      ;; response 
      lr = (Size(rate))[1] 

   ENDELSE ;; Set(ratefile)


   ;; Avoid empty
   ;; and therefore zero tuning bins that cannot be evaluated when
   ;; taking the logarithm  
   feq0 = Where(f LE 0., count)
   IF count NE 0 THEN BEGIN
      fne0 = DiffSet(LIndgen(N_Elements(f)), feq0)
      ;; Offset is minimum of "real" tuning values divided by 1000 
      f[feq0] = 1.E-3*Min(f[fne0])
   ENDIF

   ;;old, non log version
   ;;   esum = Exp(-tau*0.001*sum)
   ;;   ep = esum*prior
   ;;new, logarithmic version
   bias = ALog(priorstruct.pr)-tau*0.001*sum
   lnf = ALog(f)

   ;; Start estimation
   IF Keyword_Set(VERBOSE) THEN BEGIN
      Console, /MSG, 'Estimating stimuli.'
      SimTimeInit, MAXSTEPS=10, /PRINT, CONSOLE=!CONSOLE
   ENDIF

   se = [priorstruct.sdim+1, lr, priorstruct.sdim, 4, priorstruct.sdim*lr]
   estimate = Make_Array(SIZE=se)
   sdimidx = IndGen(priorstruct.sdim)

   ;; rewind video array to probe sweep
   IF Set(ratefile) THEN BEGIN
      Rewind, ratevideo, probeidx*nr
      rate=Make_Array(lr, nr, /FLOAT)
      FOR rdimidx=0, nr-1 DO BEGIN
         rate[*, rdimidx]=Replay(ratevideo)*info.realtau*0.001
      ENDFOR
      Eject, ratevideo, /SHUTUP
   ENDIF
      

   FOR t=0l, lr-1 DO BEGIN
      ;; old non log version
      ;; prod = Make_Array(SIZE=sp, VALUE=1., /DOUBLE)
      lnsum = Make_Array(SIZE=sp, VALUE=0., /DOUBLE)
      ;; loop of response dimensions
      FOR rdimidx=0, nr-1 DO BEGIN
         ;; 1dim array with slice consisting of f(*,*,rdimidx)
         sliceidx = idxarr+rdimidx*nelemprior
         ;; old non log version
         ;; fcurrent = Reform(f(sliceidx), sp(1:sp(0)))
         ;; prod = Temporary(prod)*fcurrent^ni(t, rdimidx)

         ;; new log version
         lnsum = Temporary(lnsum)+ $
                 Reform(lnf[sliceidx], sp[1:sp[0]])*rate[t, rdimidx]

         IF Min(Finite(lnsum)) LT 1 THEN Console, /FATAL $
          , 'Overflow during potentiation.'
      ENDFOR ;; rdimidx

      ;;old, non log version
      ;; posterior = prod*ep
      ;; new log version
      lnposterior = lnsum+bias

      ;; determine index of maximum or mean of posterior
      IF Keyword_Set(OPTIMAL) THEN BEGIN
         ;; reverse logarithm
         posterior = Exp(lnposterior)
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
         dummy = Max(lnposterior, estidx)
         smultidimidx = Subscript(estidx, SIZE=sp)
         ;; select stimulus values by smultidimidx and return estimate
         estimate[t, *] = priorstruct.bv[smultidimidx+1,sdimidx]
      ENDELSE

      IF Keyword_Set(VERBOSE) AND (((t+1) MOD (lr/10)) EQ 0) THEN SimTimeStep

   ENDFOR ;; time 

   IF Keyword_Set(VERBOSE) THEN SimTimeStop

   get_mean = f
   get_prior = priorstruct

   Return, estimate

END 
