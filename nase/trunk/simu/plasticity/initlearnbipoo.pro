;+
; NAME:               InitLearnBiPoo
;
; PURPOSE:            Initialisiert das Lernfenster fuer die LearnBiPoo - Lernregel:
;                                    
;                        Delta_W = LWin(t_pre - t_post)
;
;                                   /
;                                  |  postv * exp(-t/posttau)  fuer t>0
;                        LWin(t) = <  0                        fuer t=0
;                                  |  -prev * exp(t/pretau)    fuer t<0
;                                   \
;
; CATEGORY:           SIMULATION PLASTICITY
;
; CALLING SEQUENCE:   LS = InitLearnBiPoo( [, POSTV=postv] [, POSTTAU=posttau] [, PREV=prev] [, PRETAU=pretau] $
;                                          [, CUTFRAC=cutfrac] [, SAMPLE=sample] [,/PREBAL | ,/POSTBAL] )
;
; KEYWORD PARAMETERS: 
;                     POSTV   : Verstaerkung des Leckintegrators  | Default: 0.0001 |  CORRELATION    ,    LERNEN 
;                     POSTTAU : Abfall in ms                      | Default: 5      |  CORRELATION    ,    LERNEN
;                     PREV    : Verstaerkung des Leckintegrators  | Default: 0.0001 |  ANTICORRELATION, ENTLERNEN
;                     PRETAU  : Abfall in ms                      | Default: 5      |  ANTICORRELATION, ENTLERNEN
;                     CUTFRAC : die Fensterlaenge wird so gewaehlt, dass nur Werte beinhaltet sind, die groesser
;                               CUTFRAC*Maximum(LWIN) sind, Default: 0.01
;                     SAMPLE  : die Laenge eines Abtastbins in Sekunden, Default: 0.001
;                     PREBAL  : falls gesetzt, wird der negative Teil des Fensters auf betragsmaessig gleiche
;                               Flaeche normiert wie der positive Teil
;                     POSTBAL : die Invertierung von PREBAL
;
; OUTPUT:             LS: ein Array zur Weiterverwendung mit LearnBiPoo
;                         
;                         interne Struktur: [tmaxpre, tmaxpost, lwin]
;                                   tmaxpre : zahl der elemente im negativen Bereich der Fensters 
;                                   tmaxpost: zahl der elemente im positiven Bereich der Fensters 
;                                   lwin    : das Lernfenster von [-tmaxpre,tmaxpost]
;
; EXAMPLE: 
;           sample=0.001
;           T = InitLearnBiPoo( PRETAU=15, /POSTBAL, SAMPLE=sample)
;           n = N_Elements(T)
;           xaxis = FIndGen(n-2)*sample*1000.-T(0)
;           plot, xaxis, T(2:n-1), XSTYLE=1, XTITLE='t_post - t_pre / ms', YTITLE='Delta_W'
;
; MODIFICATION HISTORY: 
;
;       $Log$
;       Revision 2.1  1999/02/03 13:35:59  saam
;              + part of the new learning system
;
;
;-
FUNCTION InitLearnBiPoo, POSTTAU=posttau, PRETAU=pretau, POSTV=postv, PREV=prev, SAMPLE=sample, CUTFRAC=cutfrac, PREBAL=prebal, POSTBAL=postbal

   Default, POSTV  , 0.0001
   Default, POSTTAU, 5
   Default, PREV   , 0.0001
   Default, PRETAU , 5
   Default, CUTFRAC, 0.01
   Default, SAMPLE , 0.001d
   

   ;---> do the pre-part
   ; cut if value < cutfrac*maxValue
   tmaxms   = LONG(pretau*alog(1./cutfrac)) + 1   ; tmax in ms
   tmaxpre  = LONG(tmaxms/1000.d/DOUBLE(SAMPLE))  ; tmax in elements
   
   deltat   = DIndgen(tmaxpre+1)*DOUBLE(SAMPLE)*1000.d
   deltapre = REVERSE(-prev*exp(-deltat/DOUBLE(pretau)))



   ;---> do the post-part
   ; cut if value < maxValue/100.
   tmaxms   = LONG(posttau*alog(1./cutfrac)) + 1       ; tmax in ms
   tmaxpost = LONG(tmaxms/1000.d/DOUBLE(SAMPLE))  ; tmax in elements
   
   deltat = DIndgen(tmaxpost+1)*DOUBLE(SAMPLE)*1000.d
   deltapost = [postv*exp(-deltat/DOUBLE(posttau))]
   
   ;---> BALANCE THE INTEGRAL??
   ipre  = TOTAL(ABS(deltapre))
   ipost = TOTAL(ABS(deltapost))
   IF Keyword_Set(PREBAL)+Keyword_Set(POSTBAL) GT 1 THEN Message, 'either specify PRECAL or POSTBAL'
   IF Keyword_Set(PREBAL) THEN deltapre = deltapre/ipre*ipost 
   IF Keyword_Set(POSTBAL) THEN deltapost = deltapost/ipost*ipre 

   RETURN, [tmaxpre, tmaxpost, deltapre, 0.0, deltapost]
   
END
