;+
; NAME: 
;  InstantRate
;
; PURPOSE: 
;  Calculation of the momentary firing rate from a train of action
;  potentials. Computation is done either by counting the spikes
;  inside a given time window sliding over the train or by convolving
;  the spike train with a Gaussian window of given width. Averaging
;  over a number of spiketrains is also supported. Fnord.
;
; CATEGORY: 
;  METHODS / SIGNALS
;
; CALLING SEQUENCE: 
;  rate = Instantrate( spikes [,SAMPLEPERIOD=sampleperiod]  
;                             [,SSIZE=ssize] [,SSHIFT=sshift]
;                             [,TVALUES=tvalues] [,TINDICES=tindices] 
;                             [,AVARAGED=avaraged]
;                             [,/GAUSS])
;
;
; INPUTS: 
;  spikes: A twodimensional array, first index: neuron- or
;          trialnumber, second index: time.
;
; OPTIONAL INPUTS: 
;  sampleperiod: Length of a BIN in seconds, default: 0.001s
;  ssize: Width of window used to calculating the firing rate. If
;         keyword /GAUSS is set, ssize sets the standard deviation of
;         the Gaussian filter. Default: GAUSS=0: 128ms, GAUSS=1: 20ms
;  sshift: Shift of positions where firing rate is to be
;          computed. Default: 1BIN with keyword /GAUSS set, else ssize/2 
;
; KEYWORD PARAMETERS:
;  GAUSS: Calculates firing rate by convolving the spiketrain with a
;         Gaussian filter, resembling a probabilistic interpretation.
;         Computation takes longer, but gives a smoother result. Note
;         that defaults for ssize and sshift are different when
;         setting this keyword. 
;
; OUTPUTS: 
;  rate: Twodimensional array, containing the firing rates at the
;        desired times. First index: neuron-/trialnumber, second
;        index: time. The result may be shorter than the original
;        depending on sshift.
;
; OPTIONAL OUTPUTS: 
;  tvalues: Array containing the starting positions of the windows
;           used for rate calculation in ms. (See also <A HREF="../#SLICES">Slices</A>.)
;  tindices: Array containing the starting indices of the windows
;            used for rate calculation relative to the original
;            array. (See also <A HREF="../#SLICES">Slices</A>.)
;  avaraged: Array containing the firing rate avaraged over all 
;            neurons/trials.
;
; PROCEDURE: 
;  1. Rectanglular window: using <A HREF="../#SLICES">Slices</A> to obtain parts of the
;     spiketrains, then summing over those parts using Total.
;  2. Gaussian window: Constructing Gaussian filter and convoling
;     spiktrain with this.
;
; EXAMPLE: 
;  a=fltarr(10,1000)
;  a(*,0:499)=Randomu(s,10,500) le 0.01    ; 10 Hz 
;  a(*,500:999)=Randomu(s,10,500) le 0.05  ; 50 Hz
;  r=instantrate(a, ssize=100, sshift=10, tvalues=axis, avaraged=av)
;  rg=instantrate(a, /GAUSS, ssize=20, tvalues=axisg, avaraged=avg)
;  !p.multi=[0,1,4,0,0] 
;  trainspotting, a 
;  plot, axis+50, r(0,*) ; axis contains starting times of windows.
;                          Interpreting results as firing rates at the
;                          time in the middle of the window,
;                          axis+ssize/2 corrects the display 
;                          
;  plot, axis+50, av
;  plot, axisg, avg
;
; SEE ALSO: <A HREF="../#SLICES">Slices</A>, <A HREF="../#ISI">ISI</A>.
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.3  2000/04/11 12:11:13  thiel
;            Rates may also be computed by convolution with Gaussian.
;
;        Revision 1.2  1999/12/06 16:27:02  thiel
;            Turn on watch?
;
;        Revision 1.1  1999/12/06 15:37:12  thiel
;            Neu.
;
;-

FUNCTION InstantRate, nt, SAMPLEPERIOD=sampleperiod $
                      , SSIZE=ssize, SSHIFT=sshift $
                      , TVALUES=tvalues, TINDICES=tindices $
                      , AVARAGED=avaraged, GAUSS=gauss

   Default, gauss, 0
   Default, sampleperiod, 0.001

   IF Keyword_Set(GAUSS) THEN BEGIN
      Default, ssize, 20
      __ssize = ssize*0.001/sampleperiod
      IF Set(sshift) THEN __sshift = sshift*0.001/sampleperiod $
       ELSE __sshift = 1
      tindices = __sshift*LIndGen((Size(nt))(2)/__sshift)
      tvalues = tindices*1000.*sampleperiod
      gausslength = 8*__ssize
      gaussx = FIndGen(gausslength)-gausslength/2
      gaussarr= Exp(-gaussx^2/2/__ssize^2)/__ssize/sqrt(2*!PI)
      result = Convol(Float(nt), Transpose(gaussarr), /EDGE_TRUNC) $
       /sampleperiod
      result = (Temporary(result))(*,tindices)
   ENDIF ELSE BEGIN
      sli = Slices(nt, SSIZE=ssize, SSHIFT=sshift, TVALUES=tvalues $
                   , TINDICES=tindices, SAMPLEPERIOD=sampleperiod)
      result = Transpose(Float(Total(sli,3))/ssize/sampleperiod)
   ENDELSE
   
   avaraged = Total(result,1)/(Size(result))(1)
   
   Return, result


END
