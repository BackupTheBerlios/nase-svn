;+
; NAME:               SIFpoisson
;
; AIM:                creates poisson-distributed spike trains
;
; PURPOSE:            Generates poisson distributed spike-trains for a complete layer of
;                     neurons. The average rate is chosen uniformly for all neurons. The
;                     output is binary and by default 'OR'ed with the provided input pattern.
;
; CATEGORY:           MIND INPUT
;
; CALLING SEQUENCE:   
;                     ignore_me  = SIFpoisson( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,LOGIC=logic] 
;                                              [,RATE=rate] )
;
;                     newPattern = SIFpoisson( [MODE=1], PATTERN=pattern )
;                     ignore_me  = SIFpoisson( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     LOGIC     : logical operation (Default: OR):
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
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  2000/09/29 08:10:35  saam
;     added the AIM tag
;
;     Revision 1.5  2000/08/11 10:30:43  thiel
;         Added FILE and WRAP keywords.
;
;     Revision 1.4  2000/01/31 09:19:18  saam
;           print, message -> console
;
;     Revision 1.3  2000/01/24 10:07:24  saam
;           added the logic scheme of iftemplate2
;
;     Revision 1.2  2000/01/19 17:55:45  saam
;           forgot to translate to purpose
;
;     Revision 1.1  2000/01/19 09:05:21  saam
;           derived from poissoninput.pro
;
;
;-


FUNCTION SIFpoisson, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, LOGIC=op, RATE=rate, FILE=file,  WRAP=wrap

   COMMON attention
   COMMON COMMON_random, seed

   ON_ERROR, 2

   Default, mode,  1          ; i.e. step
   Default, op  , 'OR'
   Default, R   , !NONE
   Default, rate, 40.0
   Default, file, ''
   Default, wrap, 0
   
   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF
      ; INITIALIZE
      0: BEGIN                  
         IF (rate LE 0.0) THEN console, P.CON, "a negative/zero rate doesn't make sense: rate="+STR(rate), /FATAL

         TV = {info     : 'SIFpoisson'              ,$
               w        : w                         ,$
               h        : h                         ,$
               p        : FLOAT(rate)*DELTA_T*0.001 ,$
               myop     : opID(op)                  ,$
               delta_t  : delta_t                   ,$
               sim_time : .0d                        }
         
         Console, P.CON, STR(rate)+' Hz'         
      END
      
      ; STEP
      1: BEGIN                             
         R = RandomU(seed, TV.h, TV.w) LE TV.p ; uncorrlated poisson processes generating spikes for each neuron
         TV.sim_time = TV.sim_time + TV.delta_t
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
         console, P.CON, 'unknown mode', /FATAL
      END

   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
