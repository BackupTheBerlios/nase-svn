;+
; NAME:               SIFuJitter
;
; PURPOSE:            Jitters the incoming spikes randomly in time by a uniform
;                     distribution (so each spike has an individual jitter).
;                     Note that the average output is shifted by jitter/2 to
;                     later times. If two input spikes of one neuron are accidentally
;                     jittered into the same BIN then only one spike survives.
;                     Output is binary, jitter is specified in 
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
;                     JITTER    : spikes are (uniformly distributed) jittered between 0..jitter-1 ms
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
;     Revision 1.2  2000/01/26 16:11:22  saam
;           got the bug, its working now
;
;     Revision 1.1  2000/01/24 10:10:24  saam
;           xtracted from poissoninput.pro. WARNING! this
;           version is NOT WORKING YET
;
;


FUNCTION SIFnjitter, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, JITTER=jitter, CUT=cut
                     
   COMMON COMMON_random, seed
   ON_ERROR, 2

   Default, mode  , 1          ; i.e. step
   Default, R     , !NONE
   Default, jitter, 10
   Default, cut   , .99

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      
         
         rj = 2*fix(jitter/delta_t*gauss_cvf(1-cut)+1)
         TV =  {                              $
                w        : w                 ,$
                h        : h                 ,$
                s        : w*h               ,$
                ja       : BytArr(rj,h,w)    ,$ ; jitter array 
                jitter   : jitter/delta_t    ,$
                as       : rj-1              ,$ ; array size
                ji       : 0l                ,$ ; jitter index
                delta_t  : delta_t           ,$
                sim_time : .0d                $
               }
         print,'SIFnJitter: hmw: '+STR(jitter/delta_t)+' ms, cutoff: '+STR(cut)+', average shift: '+STR(rj/2*delta_t)+' ms'
      END
      
      ; STEP
      1: BEGIN                             
         ; jitter the current spikes (if any) into the array
         spikes = WHERE(pattern GE 1, c)
    
         IF c GT 0 THEN BEGIN
            cj = (TV.as/2 + FIX(TV.jitter*RandomN(seed, c))) < TV.as > 0; current jitter for spikes
            TV.ja((TV.ji+cj) MOD TV.as, spikes MOD TV.h, spikes / TV.h) = 1 ; assign to jitter array
         END
         
         ; read the current output
         R = TV.ja(TV.ji, *, *) 
ü
         ; clear this time step
         TV.ja(TV.ji, *, *) = 0

         ; increment internal time
         TV.ji = (TV.ji+1) MOD TV.as
         TV.sim_time =  TV.sim_time + TV.delta_t
      END
      
      ; FREE
      2: BEGIN
         print,'SIFnJitter: done'
      END 

      ; PLOT
      3: BEGIN
         print, 'SIFnJitter: display mode not implemented, yet'
      END
      ELSE: BEGIN
         Message, 'SIFnJitter: unknown mode'
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
