;+
; NAME:               SIFuJitter
;
; PURPOSE:            Jitters the incoming spikes randomly in time by a uniform
;                     distribution (so each spike has an individual jitter).
;                     If two input spikes of one neuron are accidentally
;                     jittered into the same BIN then only one spike survives.
;                     Note that the average output is shifted by jitter/2 to
;                     later times. Output is binary, jitter is specified in 
;                     milliseconds.
;
; CATEGORY:           MIND INPUT 
;
; CALLING SEQUENCE:   
;                     ignore_me  = SIFuJitter( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,JITTER=jitter]
;                                            )
;
;                     newPattern = SIFuJitter( [MODE=1], PATTERN=pattern )
;                     ignore_me  = SIFuitter( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     JITTER    : spikes are (uniformly distributed) jittered between 0..jitter-1 ms (Default: 10)
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/01/26 16:11:05  saam
;           expanded the doc header
;
;     Revision 1.2  2000/01/26 14:36:39  saam
;           expanded the log message
;
;     Revision 1.1  2000/01/24 10:09:52  saam
;           xtracted from poissoninput.pro
;
;


FUNCTION SIFujitter, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, JITTER=jitter
                     
   COMMON COMMON_random, seed
   ON_ERROR, 2

   Default, mode  , 1          ; i.e. step
   Default, R     , !NONE
   Default, jitter, 10
   
   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      
         
         rj = fix(jitter/delta_t)
         TV =  {                              $
                w        : w                 ,$
                h        : h                 ,$
                s        : w*h               ,$
                ja       : BytArr(rj,h,w)    ,$ ; jitter array 
                jitter   : rj                ,$
                ji       : 0l                ,$ ; jitter index
                delta_t  : delta_t           ,$
                sim_time : .0d                $
               }
         print,'SIFuJitter: '+STR(TV.jitter*TV.delta_t)+' ms, average signal shift: '+STR(TV.jitter*TV.delta_t/2)+' ms'
      END
      
      ; STEP
      1: BEGIN                             
         ; jitter the current spikes (if any) into the array
         spikes = WHERE(pattern GE 1, c)
         IF c GT 0 THEN BEGIN
            cj = FIX(TV.jitter*RandomU(seed, c))          ; current jitter for spikes
            TV.ja(cj, spikes MOD TV.h, spikes / TV.h) = 1 ; assign to jitter array
         END
         
         ; read the current output
         R = TV.ja(TV.ji, *, *) 

         ; clear this time step
         TV.ja(TV.ji, *, *) = 0

         ; increment internal time
         TV.ji = (TV.ji+1) MOD TV.jitter
         TV.sim_time =  TV.sim_time + TV.delta_t
      END
      
      ; FREE
      2: BEGIN
         print,'SIFuJitter: done'
      END 

      ; PLOT
      3: BEGIN
         print, 'SIFuJitter: display mode not implemented, yet'
      END
      ELSE: BEGIN
         Message, 'SIFuJitter: unknown mode'
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
