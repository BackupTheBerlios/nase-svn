;+
; NAME:               SIFpoissonC
;
; PURPOSE:            Generates poisson distributed pulses assigned to a fraction or all 
;                     neurons of a layer simultanously. The output is binary and by default
;                     'OR'ed with the provided input pattern.
;
; CATEGORY:           MIND INPUT
;
; CALLING SEQUENCE:   
;                     ignore_me  = SIFpoisson( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,LOGIC=logic] 
;                                              [,RATE=rate] [,FRAC=frac])
;
;                     newPattern = SIFpoisson( [MODE=1], PATTERN=pattern )
;                     ignore_me  = SIFpoisson( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     LOGIC     : logical operation (default: OR):
;                                 NEW_INPUT = OLD_INPUT #LOGIC# HERE_GENERATED_INPUT 
;                                 valid values can be found <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#OPID>here</A>
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;
;
;                     RATE      : average firing rate for each neuron (Default: 40Hz)
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; COMMON BLOCKS:      COMMON_RANDOM for random generator
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/05/04 09:15:51  saam
;           various changes
;
;     Revision 1.2  2000/01/31 09:19:18  saam
;           print, message -> console
;
;     Revision 1.1  2000/01/24 10:09:24  saam
;           created by merging sifpoisson and poissoninput
;
;
;


FUNCTION SIFpoissonC, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, LOGIC=op, RATE=rate, FRAC=frac

   COMMON COMMON_random, seed
   COMMON ATTENTION
   ON_ERROR, 2

   Default, mode,  1          ; i.e. step
   Default, op  , 'OR'
   Default, R   , !NONE
   Default, rate, 40.0
   Default, frac,  1.0


   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF
      ; INITIALIZE
      0: BEGIN                  
         IF (rate LE 0.0) THEN console, P.CON, "a negative/zero rate doesn't make sense: rate="+STR(rate), /FATAL
         IF ((frac LE 0.0) OR (frac GT 1.0)) THEN console, P.CON, "a fraction of "+STR(frac)+" doesn't make sense", /FATAL

         TV = {info     : 'SIFpoissonc'             ,$
               w        : w                         ,$
               h        : h                         ,$
               p        : FLOAT(rate)*DELTA_T*0.001 ,$
               frac     : LONG(w*h*frac)            ,$
               myop     : opID(op)                  ,$
               delta_t  : delta_t                   ,$
               sim_time : .0d                        }
         
          console, P.CON, STR(rate)+' Hz, fraction of neurons: '+STR(frac)         
      END
      
      ; STEP
      1: BEGIN                             
         R = BytArr(TV.h, TV.w) 
         IF ((RandomU(seed, 1))(0) LE TV.p) THEN BEGIN
            nI = FracRandom(TV.w*TV.h, TV.frac)
            R(nI) = 1
            TV.sim_time = TV.sim_time + TV.delta_t
         END 
         R = Operator(TV.myop, pattern, R)
      END
      ; FREE
      2: BEGIN
         ;print,''
      END 

      ; PLOT
      3: BEGIN
         console, P.CON, 'display mode not implemented, yet', /WARNING
      END
      ELSE: BEGIN
         console, P.CON, 'unknown mode'
      END

   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
