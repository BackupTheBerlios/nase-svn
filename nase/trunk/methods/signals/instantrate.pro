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
;  the spike trains with a Gaussian window of given width. Averaging
;  over a number of spiketrains is also supported. Fnord.
;
; CATEGORY: 
;  Statistics
;  Signals
;
; CALLING SEQUENCE: 
;* rate = Instantrate( spikes [,SAMPLEPERIOD=...]  
;*                            [,SSIZE=...] [,SSHIFT=...]
;*                            [,TVALUES=...] [,TINDICES=...] 
;*                            [,AVERAGE=...]
;*                            [,/GAUSS] [,/TFIRST] )
;
;
; INPUTS: 
;  spikes:: A twodimensional binary array whose entries NE 0 are
;           interpreted as action potentials. First index: time, second
;           index: neuron- or trialnumber. See keyword <*>TFIRST</*>.
;
; INPUT KEYWORDS:
;  SAMPLEPERIOD:: Length of a BIN in seconds, default: 0.001s
;  SSIZE:: Width of window used to calculate the firing rate. If
;         keyword <*>/GAUSS</*> is set, <*>SSIZE</*> sets the standard deviation of
;         the Gaussian filter. Default: <*>GAUSS=0</*>: 128ms, <*>GAUSS=1</*>: 20ms.
;  SSHIFT:: Shift of positions where firing rate is to be
;          computed. Default: 1BIN with keyword <*>/GAUSS</*> set, else <*>SSIZE/2</*>.
;  GAUSS:: Calculates firing rate by convolving the spiketrain with a
;         Gaussian filter, resembling a probabilistic interpretation.
;         Computation takes longer, but gives a smoother result. Note
;         that defaults for <*>SSIZE</*> and <*>SSHIFT</*> are different when
;         setting this keyword.
;  TFIRST:: Turn around index interpretation of the input and output
;           arrays. If <*>TFIRST=0</*>, the first index is taken as neuron
;           number, the second index as time. This option is included
;           for compatibility reasons. Default: <*>TFIRST=1</*>.
;
; OUTPUTS: 
;  rate:: Twodimensional array, containing the firing rates at the
;        desired times in Hz. First index: time, second index:
;        neuron-/trialnumber (See keyword <*>TFIRST</*>). 
;        The result may be shorter than
;        the original depending on <*>SSHIFT</*>.
;
; OPTIONAL OUTPUTS: 
;  TVALUES:: Array containing the starting positions of the windows
;           used for rate calculation in ms. (See also <A>Slices()</A>.)
;  TINDICES:: Array containing the starting indices of the windows
;            used for rate calculation relative to the original
;            array. (See also <A>Slices()</A>.)
;  AVERAGE:: Array containing the firing rate averaged over all 
;            neurons/trials.
;
; PROCEDURE: 
;  1. Rectanglular window: using <A>Slices</A> to obtain parts of the
;     spiketrains, then summing over those parts using <*>Total</*>.<BR>
;  2. Gaussian window: Constructing Gaussian filter and convoling
;     spiktrain with this.
;
; EXAMPLE: 
;*  a=fltarr(1000,10)
;*  a(0:499,*)=Randomu(s,500,10) le 0.01    ; 10 Hz 
;*  a(500:999,*)=Randomu(s,500,10) le 0.05  ; 50 Hz
;*  r=instantrate(a, ssize=100, sshift=10, tvalues=axis, average=av)
;*  rg=instantrate(a, /GAUSS, ssize=20, tvalues=axisg, average=avg)
;*  !p.multi=[0,1,4,0,0] 
;*  trainspotting, Transpose(a) 
;*  plot, axis+50, r(*,0) ; axis contains starting times of windows.
;*                          Interpreting results as firing rates at the
;*                          time in the middle of the window,
;*                          axis+ssize/2 corrects the display 
;*                          
;*  plot, axis+50, av
;*  plot, axisg, avg
;
; SEE ALSO: <A>Slices()</A>, <A>ISI()</A>.
;
;-
;
; MODIFICATION HISTORY:
;
;        $Log$
;        Revision 1.7  2002/01/29 15:44:22  thiel
;           Corrected misspelling of AVERAGE-Keyword.
;
;        Revision 1.6  2001/06/12 11:41:55  thiel
;           Now uses new NASE spiketrain array convention: first index: time.
;           Still can be turned to old behavior by TFIRST=0.
;
;        Revision 1.5  2000/09/28 10:02:55  gabriel
;             AIM tag added
;
;        Revision 1.4  2000/08/01 15:04:13  thiel
;            Now handles 1-dim spiketrains with /GAUSS correctly.
;
;        Revision 1.3  2000/04/11 12:11:13  thiel
;            Rates may also be computed by convolution with Gaussian.
;
;        Revision 1.2  1999/12/06 16:27:02  thiel
;            Turn on watch?
;
;        Revision 1.1  1999/12/06 15:37:12  thiel
;            Neu.
;
;

FUNCTION InstantRate, _nt, SAMPLEPERIOD=sampleperiod $
                      , SSIZE=ssize, SSHIFT=sshift $
                      , TVALUES=tvalues, TINDICES=tindices $
                      , AVERAGE=average, GAUSS=gauss, TFIRST=tfirst

   Default, gauss, 0
   Default, sampleperiod, 0.001
   Default, tfirst, 1

   IF NOT Keyword_Set(TFIRST) THEN BEGIN
      Console, /WARNING $
       , 'Why not swap your array indices and set TFIRST=1?'
      nt = Transpose(_nt)
   ENDIF ELSE nt = _nt

   IF Keyword_Set(GAUSS) THEN BEGIN

      Default, ssize, 20
      __ssize = ssize*0.001/sampleperiod
      
      IF Set(sshift) THEN __sshift = sshift*0.001/sampleperiod $
      ELSE __sshift = 1
      
      tindices = __sshift*LIndGen((Size(nt))(1)/__sshift)
      tvalues = tindices*1000.*sampleperiod
      gausslength = 8*__ssize
      gaussx = FIndGen(gausslength)-gausslength/2
      gaussarr= Exp(-gaussx^2/2/__ssize^2)/__ssize/sqrt(2*!PI)

;      IF (Size(nt))(1) NE 1 THEN $
;       result = Convol(Float(nt), gaussarr, /EDGE_TRUNC)/sampleperiod $
;      ELSE $
      result = Convol(Float(nt), gaussarr, /EDGE_TRUNC)/sampleperiod

      result = (Temporary(result))(tindices, *)

   ENDIF ELSE BEGIN ;; Keyword_Set(GAUSS) 

      sli = Slices(nt, SSIZE=ssize, SSHIFT=sshift, TVALUES=tvalues $
                   , TINDICES=tindices, SAMPLEPERIOD=sampleperiod, /TFIRST)
;      result = Transpose(Float(Total(sli,3))/ssize/sampleperiod)
      result = Float(Total(sli,1))/ssize/sampleperiod

   ENDELSE ;; Keyword_Set(GAUSS) 
   
   IF (Size(nt))(0) NE 1 THEN $
    average= Total(result,2)/(Size(result))(2) $ ;; two dimensional array
   ELSE $
    average = result ;; one dimensional array
   
   IF NOT Keyword_Set(TFIRST) THEN result = Temporary(Transpose(result))

   Return, result


END
