;+
; NAME:               PoissonInput
;
; PURPOSE:            Erzeugt poissonverteilte Spiketrains einer mittleren
;                     Rate als Input fuer eine Layer oder eine DW-Struktur.
;
; CATEGORY:           INPUT STAT
;
; CALLING SEQUENCE:   p = PoissonInput( {Layer, | LAYER=Layer | WIDTH=width, HEIGHT=height }
;                                     [,RATE=rate] [,OVERSAMP=oversamp] [,CORR=corr] [,PULSE=pulse])
;
; INPUTS:             Layer : die Neuronenschicht, fuer die der Input erzeugt werden soll oder
;                             die den Ouput erzeugt
;
; KEYWORD PARAMETERS  LAYER           : die Neuronenschicht, fuer die der Input erzeugt werden soll
;                                         oder die den Ouput erzeugt
;                     WIDTH ,
;                     HEIGHT          : Hoehe und Breite der Schicht (nur erforderlich, wenn Layer
;                                         nicht angegeben wurde)
;                     RATE            : die mittlere Feuerrate pro Neuron (Default: 40Hz)
;                     SAMPLEPERIOD    : der Zeitaufloesung des erwuenschten Signals (Default: 0.001)
;                     V               : ist Option gesetzt wird statt einem SSpassarray ein normales
;                                         Array zurueckgegeben, wobei die Aktionspotentiale Amplitude V
;                                         haben.
;                     NOSPASS         : es wird ein normales Array zurueckgegeben
;                     CORR            : Bruchteil der Gesamtrate RATE, die fuer korrelierte Aktionspotentiale
;                                         benutzt wird
;                     FRAC            : Bruchteil der Neurone die einen korrelierten Puls erhalten 
;                     GAUSSIAN_JITTER : gaussfoermiges ver-jittern des correlierten Pulses mit der uebergebenen
;                                       Standardabweichung in ms
;                     UNIFORM_JITTER  : gleichverteiltes ver-jittern des correlierten Pulses mit der uebergebenen                                 
;                                       Amplitude in ms
;
;
; OPTIONAL OUTPUTS:   PULSE : boolsche Variable, die zum Zeitpunkt eines korrelierten Pulses TRUE (1) liefert.
;
; OUTPUTS:            V gesetzt: 
;                          p: Spass-Array, das Aktionspotentiale mit Amplitude V enthaelt. Dies 
;                             ist zur Weiterverarbeitung mit InputLayer_? gedacht.
;                     V NICHT gesetzt:
;                          p: SSpass-Array mit Aktionspotentialen zur Weiterverarbeitung mit
;                             DelayWeigh
;                     V beliebig, NOSPASS gesetzt:
;                          p: Array mit Aktionspotentialen der Amplitude V (oder 1.0)
; 
; COMMON BLOCKS:      Common_Random
;
; EXAMPLE:            
;                     w =  100
;                     t = 1000
;                     p = poissoninput(WIDTH=w,HEIGHT=1,RATE=40,CORR=0.7, FRAC=1, GAUSSIAN_JITTER=5, SAMPLEPERIOD=0.0002, /NOSpASS)
;                     d = FltArr(w,t)
;                     FOR i=0,t-1 DO d(*,i) = poissoninput(p)
;                     plottvscl, transpose(d), xrange=[0,t*1000.*0.0002], /FULLSHEET
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 2.5  1999/02/17 16:57:57  saam
;           + new optional output PULSE
;           + bug fix: Frac_Random crashed for FRAC near 1
;
;     Revision 2.4  1998/08/23 12:47:33  saam
;           now works with oversampling
;
;     Revision 2.3  1998/08/03 10:55:15  saam
;           header update
;
;     Revision 2.2  1998/03/03 18:00:38  saam
;           little bug
;
;     Revision 2.1  1998/03/03 17:27:37  saam
;           schwere Geburt, simple Funktion
;
;
;-
FUNCTION PoissonInput, PIS, LAYER=klayer, WIDTH=width, HEIGHT=height, RATE=rate, $
                       V=v, NOSPASS=nospass, CORR=corr, UNIFORM_JITTER=uniform_jitter, GAUSSIAN_JITTER=gaussian_jitter,$
                       FRAC=frac, SAMPLEPERIOD=sampleperiod, PULSE=pulse

   On_Error, 2

   COMMON Common_Random, seed
   
   IF N_Params() EQ 0 THEN BEGIN
      ;-----> INITIALIZATION OF INPUT-STRUCTURE
 
      IF NOT Set(v) THEN sspass = 1 ELSE sspass = 0
      Default, rate    , 40.0
      Default, v       ,  1.0
      Default, corr    ,  0.0
      Default, nospass ,  0
      Default, frac    ,  1.0
      Default, SAMPLEPERIOD, 0.001

      IF Set(GAUSSIAN_JITTER) THEN BEGIN
         jitter = gaussian_jitter
         gj = 1
      END ELSE IF Set(UNIFORM_JITTER) THEN BEGIN
         jitter = uniform_jitter
         gj = 0
      END ELSE BEGIN
         jitter = 1
         gj = 0
      END
      jitter = jitter/(SAMPLEPERIOD*1000.)


      IF Keyword_Set(KLAYER) THEN BEGIN
         w = KLayer.w
         h = KLayer.h
      END ELSE BEGIN
         IF N_Params() EQ 1 THEN BEGIN
            w = Layer.w
            h = Layer.h
         END ELSE IF Keyword_Set(WIDTH) AND Keyword_Set(HEIGHT) THEN BEGIN
            w = width
            h = height
         END ELSE BEGIN
            Message, 'LAYER or keywords WIDTH and HEIGHT must be set' 
         END
      END

      p_uncorr = (1.-corr)*rate*SAMPLEPERIOD;/FLOAT(1000*OverSamp)
      p_corr   = corr*rate*SAMPLEPERIOD;/FLOAT(1000*OverSamp)


      IF jitter EQ 0 THEN BEGIN
         ci = BytArr(1,w*h) 
         ciSize = 1
         gj = 0
      END ELSE  IF NOT gj THEN BEGIN
         ci = BytArr(jitter,w*h) 
         ciSize = jitter
      END ELSE BEGIN
         ci = BytArr(11*ROUND(jitter+1),w*h)
         ciSize = 11*ROUND(jitter+1)
      END

      PIS = {info    : 'PoissonInput'     ,$
             jitter  : jitter             ,$
             gj      : gj                 ,$
             p_corr  : p_corr             ,$
             p_uncorr: p_uncorr           ,$
             w       : w                  ,$
             h       : h                  ,$
             nospass : nospass            ,$
             sspass  : sspass             ,$
             v       : v                  ,$
             sampleperiod: sampleperiod   ,$
             ci      : ci                 ,$ 
             ciSize  : ciSize             ,$
             ciInd   : 0l                 ,$
             frac    : frac               }
      RETURN, PIS

   END ELSE BEGIN
      ;-----> ANOTHER TIME STEP
   
      
      sig_uncorr = RandomU(seed, PIS.w*PIS.h) LE PIS.p_uncorr ; uncorrlated poisson processes generating spikes for each neuron
      corrSpike  = (RandomU(seed,1) LE PIS.p_corr)(0)          ; correlated poisson process
      IF corrSpike THEN BEGIN
         PULSE = 1
         IF PIS.gj THEN BEGIN
            ja =  (FIX(PIS.jitter*(5+RandomN(seed, PIS.w*PIS.h))) < (PIS.ciSize-1)) >  0            
         END ELSE BEGIN
            ja =  FIX(PIS.jitter*RandomU(seed, PIS.w*PIS.h))            
            message, 'dont know if its working...'
;            ja(frac_random(PIS.w*PIS.h,PIS.frac)) = (FIX(PIS.jitter*RandomU(seed, FIX(PIS.frac*PIS.w*PIS.h)))) ; jitter array for each neuron, new for each correlated spike
         END
         IF PIS.frac GE 0.999 THEN neuronInd = LIndgen(PIS.w*PIS.h) ELSE neuronInd = Frac_Random(PIS.w*PIS.h, PIS.frac)
         FOR i=0,N_Elements(neuronInd)-1 DO PIS.ci((ja(neuronInd(i))+PIS.ciInd) MOD PIS.ciSize, neuronInd(i)) =  1 ; set spikes (distributed during following time steps)
      END ELSE PULSE = 0
      vec        = (sig_uncorr+PIS.ci(PIS.ciInd,*,*)) < 1      ; add un- and -correlated processes (only one spike at a time)
      PIS.ci(PIS.ciInd,*,*) = 0                                ; distributed spikes will be forgotten
      
      PIS.ciInd = (PIS.ciInd+1) MOD PIS.ciSize                     ; index for the jitter array
      IF PIS.nospass THEN RETURN, vec*PIS.v
      IF PIS.sspass THEN RETURN, SSpassmacher(vec) ELSE RETURN, Spassmacher(vec*PIS.v)
      
   END
   
END
