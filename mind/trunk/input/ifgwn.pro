;+
; NAME:               IFgwn
;
; PURPOSE:            Generates independent analog Gaussian white noise with a
;                     standard deviation of 1 for each neuron of the
;                     layer. The mean of the distribution is 0.
;
; CATEGORY:           MIND INPUT 
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFgwn( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              {various filter options} )
;
;                     newPattern = IFgwn( [MODE=1], PATTERN=pattern )
;                     ignore_me  = IFgwn( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: CORR      : all input receive fraction CORR of a
;                                 correlated GWN process
;                     DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
; COMMON BLOCKS:      ATTENTION    : for output to console 
;                     COMMON_RANDOM: for correct handling of pseudo randoms
; 
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.1  2000/04/06 09:35:43  saam
;           added CORR keyword
;
;
;


FUNCTION IFgwn, MODE=mode, PATTERN=pattern, CORR=corr, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t

 COMMON ATTENTION
 Common COMMON_RANDOM, seed

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   
   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN                  
          Default, corr, 0.0
          TV =  {                     $
                  h        : h       ,$
                  w        : w       ,$
                  corr     : corr    ,$
                  delta_t  : delta_t ,$
                  sim_time : .0d      $
                }
          console, P.CON, 'sigma=1, corr='+STR(TV.corr),/msg         
      END
      
      ; STEP
      1: BEGIN                             
         R = pattern + (1-TV.corr)*RandomN(seed, TV.h, TV.w) + TV.corr*Rebin(RandomN(seed,1), TV.h, TV.w)
         TV.sim_time =  TV.sim_time + TV.delta_t
      END
      
      ; FREE
      2: BEGIN
         console, P.CON, 'done', /msg
      END 

      ; PLOT
      3: BEGIN
         console, P.CON, 'display mode not implemented, yet', /warning
      END
      ELSE: BEGIN
         console, P.CON, 'unknown mode', /fatal
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
