;+
; NAME:               SIFnJitter
;
; AIM:                jitters incoming spike with a Gaussian distribution
;
;
; PURPOSE:            Jitters the incoming spikes randomly in time by a gaussian
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
;                     ignore_me  = SIFnJitter( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,JITTER=jitter] [,CUT=cut]
;                                            )
;
;                     newPattern = SIFnJitter( [MODE=1], PATTERN=pattern )
;                     ignore_me  = SIFnJitter( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: CUT       : Since a gaussian extends from -infinity to +infinity the jitter has
;                                 to be restricted. Cut defines the fraction of the gaussians area to
;                                 be used. Values falling beyond this limit are restricted to the maximum
;                                 or minimum possible value. Default is 0.99. 
;                     DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     JITTER    : Sigma of the gaussian or in other words the half-width-half-maximum in ms.
;                                 Default is 2ms.
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
;     Revision 1.8  2000/09/29 08:10:35  saam
;     added the AIM tag
;
;     Revision 1.7  2000/08/11 10:30:43  thiel
;         Added FILE and WRAP keywords.
;
;     Revision 1.6  2000/01/31 09:19:17  saam
;           print, message -> console
;
;     Revision 1.5  2000/01/28 17:44:10  saam
;           just for transfer
;
;     Revision 1.4  2000/01/27 10:48:25  saam
;           illegal char was in program text
;
;     Revision 1.3  2000/01/26 16:18:08  saam
;           doc header written
;
;     Revision 1.2  2000/01/26 16:11:22  saam
;           got the bug, its working now
;
;     Revision 1.1  2000/01/24 10:10:24  saam
;           xtracted from poissoninput.pro. WARNING! this
;           version is NOT WORKING YET
;
;


FUNCTION SIFnjitter, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, JITTER=jitter, CUT=cut, FILE=file, WRAP=wrap
                     
   COMMON COMMON_random, seed
   COMMON ATTENTION
   ON_ERROR, 2

   Default, mode  , 1          ; i.e. step
   Default, R     , !NONE
   Default, jitter, 2
   Default, cut   ,  .99
   Default, file, ''
   Default, wrap, 0

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
         console, P.CON, 'hmw: '+STR(jitter/delta_t)+' ms, cutoff: '+STR(cut)+', average shift: '+STR(rj/2*delta_t)+' ms'
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

         ; clear this time step
         TV.ja(TV.ji, *, *) = 0

         ; increment internal time
         TV.ji = (TV.ji+1) MOD TV.as
         TV.sim_time =  TV.sim_time + TV.delta_t
      END
      
      ; FREE
      2: BEGIN
         console, P.CON, 'done'
      END 

      ; PLOT
      3: BEGIN
         console, P.CON, 'display mode not implemented, yet', /WARNING
      END
      ELSE: BEGIN
         console, P.CON, 'SIFnJitter: unknown mode', /FATAL
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
