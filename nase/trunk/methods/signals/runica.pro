;+
; NAME: RUNICA
;
;
; PURPOSE:    Perform Independent Component Analysis (ICA) decomposition
;             of psychophysiological data using the ICA algorithm of 
;             Bell & Sejnowski (1995) with the natural gradient feature 
;             of Amari, Cichocki & Yang, or the extended-ICA algorithm 
;             of Lee, Girolami & Sejnowski (in press).
;
;
; CATEGORY: METHODS
;
;
; CALLING SEQUENCE:    result=runica(data[,weights][,sphere][,activations][,bias][,signs][,lrates][,sphering=sphering][,PCA=PCA],$
;                                   [weights=weights][,lrate=lrate][,block=block][,annealstep=annealstep][,annealdeg=annealdeg],$
;                                   [nochange=nochange][,maxsteps=maxsteps][,bias=bias][,momentum=momentum],$
;                                   [extended=extended][,posact=posact[,verbose=verbose]
;
; 
; INPUTS:
;            data:     input data (chans,frames*epochs)
;                      Note: If data consists of multiple discontinuous epochs, 
;                           each epoch should be separately baseline-zero'd.
;
;	
; KEYWORD PARAMETERS:
;
;            ncomps    = number of ICA components to compute     (default -> chans)
;                        using rectangular ICA decomposition
;            pca       = decompose a principal component subspace(default -> 0=off)
;                        of the data. Value is the number of PCs to retain.
;            sphering  = flag sphering of data (on/off)      (default -> 1=on)
;            weights   = initial weight matrix                   (default -> eye())
;                                (Note: if sphering off,        (default -> spher())
;            lrate     = initial ICA learning rate << 1          (default -> heuristic)
;            block     = ICA block size (integer << datalength)  (default -> heuristic)
;            annealstep = annealing constant (0,1] (defaults -> 0.90, or 0.98, extended)
;                         controls speed of convergence
;            annealdeg = degrees weight change for annealing     (default -> 60)
;            stop      = stop training when weight-change < this (default -> 1e-6)
;            maxsteps  = maximum number of ICA training steps    (default -> 512)
;            bias      = perform bias adjustment (on/off)    (default -> 1=on)
;            momentum  = momentum gain [0,1]                     (default -> 0)
;            extended  = [N] perform tanh() "extended-ICA" with kurtosis estimation 
;                        every N training blocks. If N < 0, fix number of sub-Gaussian
;                        components to -N [faster than N>0]      (default|0 -> off)
;            posact    = make all component activations net-positive(default 1=on}
;            verbose   = give ascii messages (on/off)        (default -> 1=on)
;
;
;
; OUTPUTS:
;           result:   activation time courses of the output components (ncomps,frames*epochs)
;
; OPTIONAL OUTPUTS:
;
;           weights:       ICA weight matrix (comps,chans)     [RO]
;           sphere:        data sphering matrix (chans,chans) = spher(data)
;                          Note: unmixing_matrix = weights*sphere {sphering off -> eye(chans)}
;           activations:   activation time courses of the output components (ncomps,frames*epochs)
;           bias:          vector of final (ncomps) online bias [RO]    (default = zeros())
;           signs:         extended-ICA signs for components    [RO]    (default = ones())
;                          [-1 = sub-Gaussian; 1 = super-Gaussian]
;           lrates:        vector of learning rates used at each training step
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/06/08 10:19:43  gabriel
;             Floating underflow corrected (changed data to double)
;
;     Revision 1.1  1999/07/20 08:16:15  gabriel
;            ICA (Independent Component Analysis) ported from MatLab-Code
;            Perform Independent Component Analysis (ICA) decomposition
;            of psychophysiological data using the ICA algorithm of
;            Bell & Sejnowski (1995) with the natural gradient feature
;            of Amari, Cichocki & Yang, or the extended-ICA algorithm
;            of Lee, Girolami & Sejnowski (in press).
;
;
;-


FUNCTION runica_eye,N,M,SIZE=_SIZE
   ;; CREATES AN IDENTITY MATRIX
   default,M,N
   IF SET(_SIZE) THEN BEGIN
      N = size(1)
      M = size(2)
   END ELSE BEGIN
      _SIZE = [2,N,M,4,N*M]
   ENDELSE
   NM = N < M
   A = MAKE_ARRAY(SIZE=_SIZE)
   INDEX = LINDGEN(N < M)
   A(index,index) = 1
   return,A
END
FUNCTION runica_diag,v,k
   s = size(v)
   default,k,0
   IF s(0) EQ 1 THEN BEGIN
      index = lindgen(s(1))
      A = make_array(SIZE=[2,s(1),s(1),s(N_ELEMENTS(s)-2),s(1)^2])
      A(index,index) = v(index)
      return,A
   END ELSE BEGIN
      ;;print,"only vectors are supported",s
      index = lindgen(min(s(1:2)))
      return, v(index,index)
   END
END

FUNCTION runica_RANK, A ,tol ,_EXTRA=e
   svdc,DOUBLE(A),W,U,V
   sa = size(A)
   res_machar = machar(/double)    
   tol = max(sa(1:2))*W(1)*res_machar.eps
   return,total(W GT tol)
END

FUNCTION runica_rem ,x,y
   return,X - FLOAT(long(FLOAT(X)/Y)) * Y
end

FUNCTION runica,_data,weights,sphere,activations,bias,signs,lrates,sphering=sphering,PCA=PCA,$
                weights=weights_in,lrate=lrate,block=block,annealstep=annealstep,annealdeg=annealdeg,$
                nochange=nochange,maxsteps=maxsteps,bias=biasflag,momentum=momentum,$
                extended=extended,posact=posactflag,verbose=verbose
   On_Error, 2
   np = N_Params()
   IF (np LT 1) OR (np GT 7)THEN Message, 'wrong number of arguments'
   data = double(_data)
   data_size = size(data)
   nchans = data_size(1)
   urchans = nchans
   frames = data_size(2)
   datalength = frames
   if nchans LT 2 OR frames LT nchans THEN BEGIN
      message,'runica() - data size (' + str(nchans)+ ',' + str(frames) +') too small.' 
   END 
   ;;
   ;; ;;;;;;;;;;;;;;;;;;;; Declare defaults used below ;;;;;;;;;;;;;;;;;;;;;;;;
   ;;
   MAX_WEIGHT           = 1e8       ;; guess that weights larger than this have blown up
   DEFAULT_BLOWUP       = 1000000000.0 ;; = learning rate has 'blown up'
   DEFAULT_BLOWUP_FAC   = 0.8          ;; when lrate 'blows up,' anneal by this fac
   DEFAULT_RESTART_FAC  = 0.9          ;; if weights blowup, restart with lrate lower by this factor
   MIN_LRATE            = 0.000001     ;; if weight blowups make lrate < this, quit
   MAX_LRATE            = 0.1          ;; guard against uselessly high learning rate
   ;;
   ;; Extended-ICA option:
   ;;
   SIGNCOUNT_THRESHOLD  = 25           ;; raise extblocks when sign vector unchanged after this many steps
   SIGNCOUNT_STEP       = 2            ;; extblocks increment factor 
   epochs = 1			       ;; do not care how many epochs in data
   default,pcaflag,0     ;;   don't use PCA reduction
   default,sphering,1    ;;   use the sphere matrix as the default starting weight matrix
   default,posactflag,0  ;;   don't use PCA reduction
   IF posactflag THEN BEGIN
      message,'posact not yet supported'
   END
   default,verbose,1     ;;   write ascii info to calling screen
   default,block      , floor(sqrt(frames/3.)) ;; heuristic default  - may need adjustment!   
   default,lrate      , 0.0010/alog(nchans) ;; heuristic default - may need adjustment for large or tiny data sets!
   default,extended   , 0         ;; default off
   default,nochange   , 0.000001  ;; stop training if weight changes below this
   default,momentum   , 0.0       ;; default momentum weight
   default,maxsteps   , 512       ;; stop training after this many steps 
   default,biasflag   , 1         ;; default to using bias in the ICA update rule
   default,extblocks  , 1         ;; number of blocks per kurtosis calculation
   default,kurtsize   , 6000      ;; max points to use in kurtosis calculation
   default,MIN_KURTSIZE , 2000    ;; minimum good kurtosis size (flag warning)
   default,signsbias  , 0.02      ;; bias towards super-Gaussian components
   default,extmomentum, 0.5       ;; momentum term for computing extended-ICA kurtosis
   default,nsub       , 1         ;; initial default number of assumed sub-Gaussians
   default,wts_blowup , 0         ;; flag =1 when weights too large
   default,wts_passed , set(weights_in) ;; flag weights passed as argument
   _ncomps = nchans

   IF set(ncomps) THEN BEGIN
      IF _ncomps LT urchans AND _ncomps NE ncomps THEN $
       message,'runica(): Use either PCA or ICA dimension reduction'
      ;;ncomp already setted
   END ELSE BEGIN
      ;;default
      ncomps = nchans
   END
   IF set(PCA) THEN BEGIN
      IF ncomps LT urchans AND ncomps NE PCA THEN $
       message,'runica(): Use either PCA or ICA dimension reduction'
      ncomps = PCA
      pcaflag = 1
      if ncomps GE chans OR ncomps LT 1 THEN $
       message,'runica(): pca value must be in range [1,'+str(chans-1)+']'
      nchans = ncomps
   END ELSE IF set(extended) THEN BEGIN
      extblocks = fix(extended) ;; number of blocks per kurt() compute
      extended = 1 ;; turn on extended-ICA
      IF extblocks LT 0 THEN nsub = -1*fix(extblocks) $ ;; fix this many sub-Gauss comps
      ELSE IF kurtsize GT frames THEN BEGIN  ;;length of kurtosis calculation
         kurtsize = frames
         IF kurtsize LT  MIN_KURTSIZE THEN $
          print,'runica() warning: kurtosis values inexact for << '+str(MIN_KURTSIZE)+' points.'
      END
   END
   IF NOT extended THEN default,annealstep , 0.90 $     ;; anneal by multiplying lrate by this
   ELSE default,annealstep , 0.98                       ;;or this if extended-ICA
   IF NOT SET(annealdeg) THEN BEGIN
      annealdeg = 60 - momentum *90  ;; when angle change reaches this value, heuristic
      IF  annealdeg LT 0 THEN annealdeg = 0
   END
   IF lrate GT MAX_LRATE OR lrate LT 0 THEN $
    message,'runica(): lrate value is out of bounds'
   IF maxsteps LT 0 THEN $
    message,'runica(): maxsteps value must be a positive integer'
   IF annealstep LE 0 OR  annealstep GT 1 THEN $
    message,'runica(): anneal step value must be (0,1]'
   IF annealdeg GT 180 OR annealdeg LT 0 THEN $
    message,'runica(): annealdeg value is out of bounds [0,180]'
   IF momentum GT 1.0 OR momentum LT 0 THEN $
    message,'runica(): momentum value is out of bounds [0,1]'

 
   IF ncomps LT nchans OR ncomps LT 1 THEN $
    message,'runica(): number of components must be 1 to '+STR(chans)

   IF set(weights_in) THEN BEGIN ;; initialize weights
      ;;starting weights are being passed to runica() from the commandline
      IF verbose THEN print,'Using starting weight matrix named in argument list ...'
      IF  nchans GT ncomps AND  set(weights_in)  THEN BEGIN
         ws = size(weights_in)
         IF s(1) NE ncomps OR s(2) NE nchans THEN $
          message,'runica(): weight matrix must have '+STR(nchans)+' rows, '+str(ncomps)+' columns.'
      END
   END
   ;; Check keyword values
   IF frames LT nchans THEN message,'runica(): data length '+str(frames)+' < data channels '+str(nchans)+'!' $
   ELSE IF block LT 2 THEN message,'runica(): block size '+str(block)+' too small!' $
   ELSE IF block GT frames THEN message,'runica(): block size exceeds data length!' $
   ELSE IF floor(epochs) NE epochs THEN message,'runica(): data length is not a multiple of the epoch length!' $
   ELSE IF nsub GT ncomps THEN message,'runica(): there can be at most '+str(ncomps)+' sub-Gaussian components!' 
   ;; Process the data 
   IF verbose THEN BEGIN
      print,'Input data size ['+str(nchans)+','+str(frames)+'] = '+str(nchans)+' channels, '+str(frames)+' frames.'
      IF pcaflag THEN print,'After PCA dimension reduction, finding' $
      ELSE print,'Finding '
      IF extended THEN print,str(ncomps)+' ICA components using logistic ICA.' $
      ELSE BEGIN
         print,str(ncomps)+' ICA components using logistic ICA.' 
         IF extblocks GT 0 THEN BEGIN
            print,'Kurtosis will be calculated initially every '+str(extblocks)+' blocks using '+str(kurtsize)+' data points.'
         END ELSE print,'Kurtosis will not be calculated. Exactly '+str(nub)+ ' sub-Gaussian components assumed.'
      END
      print,'Initial learning rate will be '+str(lrate)+', block size '+str(block)
      IF momentum GT 0.0 THEN print, 'Momentum will be '+ str(momentum)
      print,'Learning rate will be multiplied by '+str(annealstep)+' whenever angledelta >= '+str(annealdeg)+ ' deg.'
      print,'Training will end when wchange < '+str(nochange)+' after '+str(maxsteps)+ ' steps.'
      IF biasflag THEN print,'Online bias adjustment will be used.' $
      ELSE print,'Online bias adjustment will not be used.'
   END
   ;; remove overall row means
   IF verbose THEN print,'Removing mean of each channel ...'
   data = data - rebin((imoment(data,1))(*,0),nchans,frames)
   IF verbose THEN print,'Final training data range: '+str(min(data))+' to '+ str(max(data))
   ;; Perform PCA reduction
   IF pcaflag THEN BEGIN
      print,'Reducing the data to '+str(ncomps)+' principal dimensions...'
      message,'pca not yet supported'
      ;;make data its projection onto the ncomps-dim principal subspace
   END
   ;; Use the sphering matrix
   IF sphering EQ 1 THEN BEGIN  ;; sphering on
      IF verbose THEN print,'Computing the sphering matrix...'
      sphere = 2.0*invert(sqrtm(cov(transpose(data)),/double))
      IF NOT set(weights_in) THEN BEGIN
         IF verbose THEN print,'Starting weights are the identity matrix ...'
         weights = runica_eye(ncomps,chans)
      END ELSE BEGIN
         IF verbose THEN print,'Using starting weights named on commandline ...'
         weights = weights_in
      END
      IF verbose THEN print,'Sphering the data ...'
      data = sphere#data 
   END ELSE IF SPHERING EQ 0 THEN BEGIN ;; sphering off
      IF NOT set(weightsin) THEN BEGIN
         IF verbose THEN BEGIN
            print,'Using the sphering matrix as the starting weight matrix ...'
            print,'Returning the identity matrix in variable "sphere" ...'
         END
         sphere = 2.0*invert(sqrtm(cov(transpose(data)),/double)) ;; find the "sphering" matrix = spher()
         weights = runica_eye(ncomps,chans)#sphere ;;begin with the identity matrix
         sphere = runica_eye(chans) ;;return the identity matrix
      END ELSE BEGIN
         weights = weights_in
         sphere = runica_eye(chans) ;;return the identity matrix
      END
   END ELSE IF SPHERING EQ -1 THEN BEGIN  ;; sphering none
      IF NOT set(weightsin) THEN BEGIN
         IF verbose THEN BEGIN
            print,'Starting weights are the identity matrix ...'
            print,'Returning the identity matrix in variable "sphere" ...'
         END
         weights = runica_eye(ncomps,chans) ;;begin with the identity matrix
      END ELSE BEGIN
         if verbose THEN BEGIN 
            print,'Using starting weights named on commandline ...\n'
            print,'Returning the identity matrix in variable "sphere" ...\n'
         END 
         weights = weights_in
      END 
      sphere = runica_eye(chans)
      if verbose THEN print,'Returned variable "sphere" will be the identity matrix.'
   END ;; sphering

   ;; Initialize ICA training
   lastt = LONG((datalength/block-1)*block+1)
   BI = block*runica_eye(ncomps,ncomps)
   degconst = 180./!PI
   startweights = weights
   prevweights = startweights   
   oldweights = startweights    
   prevwtchange = make_array(nchans,ncomps,value=0.0)
   oldwtchange = make_array(nchans,ncomps,value=0.0)
   lrates = make_array(1,maxsteps,value=0.0)
   onesrow = make_array(1,block,value=1.0)
   bias = make_array(ncomps,1,value=0.0)
   signs = make_array(1,ncomps,value=1.0)  ;; initialize signs to nsub -1, rest +1
   FOR k=0,nsub-1 DO BEGIN
      signs(k) = -1
   END 
   olddata = data
   signs = runica_diag(reform(signs)) ;;make a diagonal matrix
   oldsigns = 0*signs
   signcount = 0               ;; counter for same-signs
   signcounts = [0]
   urextblocks = extblocks     ;;original value, for resets
   old_kk =  make_array(1,ncomps,value=0.0) ;;; for kurtosis momemtum

   ;; now we can begin
   if verbose THEN BEGIN
      print,'Beginning ICA training ...'
      if extended THEN print,'first training step may be slow ...' 
   END 
  
   step = 0
   laststep = 0
   blockno = 0 ;;; running block counter for kurtosis interrupts   
   WHILE  step LT maxsteps -1 DO BEGIN
      print,"shuffle data order at each step .........."
      permute=all_random(datalength) ;;; shuffle data order at each step
 
      
      FOR t=0L,lastt-1,block DO BEGIN ;;;;;;;;;;; ICA Training Block ;;;;;;;;;;;;;;;;;;;
         IF BIASFLAG THEN BEGIN
            u= weights # data(*,permute(t:t+block-1)) + bias # onesrow ;      
         END ELSE BEGIN
            u=weights*data(*,permute(t:t+block-1)) ;        
         ENDELSE
         
         if  NOT extended  THEN BEGIN ;; Logistic ICA weight update 
            y=1./(1+exp(-u))        
            weights=weights+lrate * (BI+(1-2*y) # transpose(u)) # weights
         END ELSE BEGIN ;; extended-ICA weight update 
            y=tanh(u)
            weights = weights + lrate * (BI-signs # y #transpose(u)-u # transpose(u)) # weights    
         ENDELSE
         
         if biasflag EQ 1 THEN BEGIN
            if  NOT extended THEN BEGIN
               ;;;;;;;;;;;;;;;;;;;;;;;;;; Logistic ICA bias ;;;;;;;;;;;;;;;;;;;;;;;
               bias = bias + lrate * transpose(total(transpose(1-2*y),2)) ;; ; for logistic nonlin. ;
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            END ELSE BEGIN  ;;; extended
               ;;;;;;;;;;;;;;;;;;;;; Extended-ICA bias ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
               bias = bias + lrate *  transpose(total(transpose(-2*y),2)) ;  ; for tanh() nonlin.   ;
               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            ENDELSE                                     
         ENDIF 
         
         IF  momentum GT 0 THEN BEGIN;;;;;;;;;;; Add momentum ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            weights = weights + momentum*prevwtchange ;                
            prevwtchange = weights-prevweights ;                      
            prevweights = weights ;                                  
         ENDIF  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         IF  max(max(abs(weights))) GT MAX_WEIGHT THEN BEGIN
            wts_blowup = 1           
            change = nochange        
         end
         if extended AND NOT wts_blowup THEN BEGIN 
            ;;;
            ;;;;;;;;;;;;; Extended-ICA kurtosis estimation ;;;;;;;;;;;;;;;;;;;;;
            ;;;
            if extblocks GT 0  AND runica_rem(blockno,extblocks) EQ  0 THEN  BEGIN
               ;;recompute signs vector using kurtosis
               if kurtsize LT frames THEN BEGIN
                  rp = long(randomu(S,kurtsize)*datalength)  ;;; pick random subset
                  ;;; of data. Compute
                  partact=weights # data(*,rp(0:kurtsize-1));;; partial activation
               END ELSE BEGIN                               ;;; for small data sets,
                  partact=weights#data                      ;;; use whole data
               ENDELSE 
               kk= (imoment(partact,1))(*,2)  ;;; kurtosis estimates        ;;; kurtosis estimates
                                ;print,kk," kurtosis estimates"
               IF  extmomentum GT 0 THEN BEGIN
                  kk = extmomentum*old_kk + (1.0-extmomentum)*kk ;; ; use momentum
                  old_kk = kk        
               ENDIF 
               signs=runica_diag(signum(reform(kk+signsbias)))            ;;; pick component signs
               IF  NOT total(signs NE oldsigns) THEN BEGIN 
                  signcount = signcount+1
               END ELSE begin
                  signcount = 0
               ENDELSE 
               oldsigns = signs
               signcounts = [signcounts, signcount] ;
               if signcount GE SIGNCOUNT_THRESHOLD THEN BEGIN
                  extblocks = long(extblocks * SIGNCOUNT_STEP) ;;; make kurt() estimation
                  signcount = 0                               ;;; less frequent if sign
               end                                            ;;; is not changing
            end ;; extblocks GT 0 AND . . .
         ENDIF ;; if extended ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         blockno = blockno + 1  ;
         if wts_blowup GT 0 THEN t = lastt
         
      ENDFOR ;; training block ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      IF  NOT (wts_blowup) THEN BEGIN
         oldwtchange = weights-oldweights
         step=step+1 
         ;; ;;;;;;; Compute and print weight and update angle changes ;;;;;;;;;
         lrates(0,step) = lrate
         angledelta=0.
         delta=reform(oldwtchange,1,nchans*ncomps)
         change=(delta#transpose(delta))(0) 
      ENDIF 
      
      ;; ;;;;;;;;;;;;;;;;;;;; Restart if weights blow up ;;;;;;;;;;;;;;;;;;;;
      ;;print, wts_blowup,change
      IF  wts_blowup EQ 1 OR change EQ !VALUES.F_NAN  OR change EQ !VALUES.F_INFINITY   THEN BEGIN ;; if weights blow up
         
         step = 0            ;; start again
         change = nochange
         wts_blowup = 0      ;; re-initialize variables
         blockno = 1
         lrate = lrate*DEFAULT_RESTART_FAC ;; with lower learning rate
         weights = startweights ;; and original weight matrix
         oldweights = startweights            
         change = nochange
         oldwtchange = make_ARRAY(nchans,ncomps,VAL=0.0)
         delta=make_ARRAY(1,nchans*ncomps,VAL=0.0)
         olddelta = delta
         extblocks = urextblocks
         prevweights = startweights
         prevwtchange = make_ARRAY(nchans,ncomps,VAL=0.0)
         lrates = make_ARRAY(1,maxsteps,VAL=0.0)
         bias = make_ARRAY(ncomps,1,VAL=0.0)
         IF  extended THEN BEGIN
            signs = make_array(1,ncomps,VAL=1.0)     ;; initialize signs to nsub -1, rest +1
            for k=0,nsub-1 DO signs(0,k) = -1
            
            signs = runica_diag(reform(signs));; make a diagonal matrix
            oldsigns = make_array(size=size(signs),VAL=0)
         END 
         if lrate GT  MIN_LRATE THEN BEGIN
            r = runica_rank(data)
            
            if r LT ncomps THEN BEGIN
               print,'Data has rank '+str(r)+' .Cannot compute '+str(ncomps)+' components'
               return,-1
            END ELSE BEGIN
               print,'Lowering learning rate to '+ str(lrate)+' and starting again.'
            ENDELSE
         END ELSE BEGIN
            print,'runica(): QUITTING - weight matrix may not be invertible'
            return,-1
         ENDELSE 
      END ELSE BEGIN ;; if weights in bounds 
         ;; ;;;;;;;;;;; Print weight update information ;;;;;;;;;;;;;;;;;;;;;;
         ;;if step GT  2 THEN print,delta#transpose(olddelta),sqrt(change*oldchange)
         IF STEP GT 2 THEN BEGIN
            IF sqrt(change*oldchange) NE 0.0 THEN $
             angledelta=acos(((delta#transpose(olddelta))(0))/sqrt(change*oldchange))$
            ELSE BEGIN
               angledelta = annealdeg
               PRINT,"something eq 0"
            END
         END
         ;;IF step GT 2 THEN stop
         if verbose THEN BEGIN
            if step GT 2 THEN BEGIN 
               if NOT extended THEN BEGIN
                  print,"step " +   str(step) +" - lrate "+ str(lrate)+" , wchange "+str(change) +" , angledelta " + $
                   str(degconst*angledelta) +" deg"
               END ELSE BEGIN 
                  print,"step " + str(step) + " - lrate " + str(lrate) + " , wchange " +  str(total(change)) +$
                   " , angledelta " + str(degconst*angledelta)+" deg, " +str(fix((ncomps-total(runica_diag(signs)))/2))+ $
                   " subgauss"
               END 
            END ELSE IF NOT extended THEN BEGIN
               print,"step "+str(step)+" - lrate "+str(lrate)+" , wchange "+str(change)
            END ELSE  BEGIN
               print,"step "+str(step)+" - lrate " +str(lrate)+" , wchange "+str(change)+" , "+ $
                str(fix((ncomps-total(runica_diag(signs)))/2))+" subgauss"
            END ;; step  GT 2
         END ;; if verbose
         ;;
         ;; ;;;;;;;;;;;;;;;;;; Save current values ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;;
         IF set(CHANGES) THEN  changes = [changes, change] $
         ELSE   changes = change 
         
         oldweights = weights
         ;;
         ;; ;;;;;;;;;;;;;;;;;; Anneal learning rate ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;;
         IF  degconst*angledelta GT annealdeg THEN BEGIN  
            lrate = lrate*annealstep           ;; anneal learning rate
            olddelta   = delta                ;; accumulate angledelta until
            oldchange  = change               ;; annealdeg is reached
         END ELSE IF step EQ 1 THEN BEGIN                     ;; on first step only
            ;;print,"------------------->>>>>>>>>>>>>>>>>>"
            olddelta   = delta                ;; initialize 
            oldchange  = change               
         END 
         ;;
         ;; ;;;;;;;;;;;;;;;; Apply stopping rule ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
         ;;
         if step  GT 2 AND change LT nochange THEN BEGIN ;; apply stopping rule
            laststep=step            
            step=maxsteps  ;; stop when weights stabilize
         END ELSE IF  change GT  DEFAULT_BLOWUP  THEN BEGIN ;; if weights blow up,
            lrate=lrate*DEFAULT_BLOWUP_FAC ;; keep trying 
         END ;; with a smaller learning rate
      END ;; end if weights in bounds

   END;; end training ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
   if NOT laststep THEN BEGIN
      laststep = step
   END 
   lrates = lrates(0,0:laststep-1)   ;; truncate lrate history vector      

   ;;Orient components towards positive activation
   IF posactflag THEN BEGIN 
    ;; not supported
   END ELSE activations = weights#data
   ;; If pcaflag, compose PCA and ICA matrices
   IF pcaflag THEN BEGIN
      message,'pca not yet supported'
      print,'Composing the eigenvector, weights, and sphere matrices'
      print,'into a single rectangular weights matrix; sphere=eye('+str(nchans)+')'
      weights= weights#sphere#eigenvectors(*,0:ncomps-1)
      sphere = eye(urchans)     
   ENDIF 
   ;;Sort components in descending order of max projected variance
   
   if verbose THEN print,'Sorting components in descending order of mean projected variance ...'
   if wts_passed eq 0 THEN BEGIN
      ;; Find mean variances
      meanvar = make_array(ncomps,1,val=1.0)
      IF NCOMPS EQ URCHANS THEN BEGIN
         winv = invert(weights#sphere)
      END ELSE BEGIN
         print,'Using pseudo-inverse of weight matrix to rank order component projections'
         message,'pseudo-inverse of weight matrix not yet supported'
         winv = pinv(weights#sphere)
      ENDELSE
   
      FOR s=0,ncomps-1 DO BEGIN
         IF verbose THEN print,str(s)  ;;onstruct single-component data matrix
         compproj = winv(*,s)#activations(s,*) ;
         meanvar(s) = (umoment((total(compproj#transpose(compproj),2))(*) / FLOAT((size(compproj))(1)-1)))(0)
      END
      ;; Sort components by mean variance
      windex = sort(meanvar)
      windex = reverse(windex) ;; order large to small 
      meanvar = meanvar(windex)
   ;; Filter data using final weights
      IF np GT 2 THEN BEGIN
         IF verbose THEN print,'Permuting the activation wave forms ...'
         activations = activations(windex,*)
         
      ENDIF
      weights = weights(windex,*) ;; reorder the weight matrix 
      bias = bias(windex) ;; reorder them
      signs = runica_diag(signs) ;; vectorize the signs matrix
      signs = signs(windex) ;; reorder them
   ENDIF
   return,activations
END



