;+
; NAME:               IFgwn
;
; AIM:                creates pairwise-independent or partly correlated GWN for all neurons
;
; PURPOSE:            Generates independent analog Gaussian white noise with a
;                     standard deviation of A for each neuron of the
;                     layer. The mean of the distribution is 0.
;
; CATEGORY:           MIND INPUT 
;
; CALLING SEQUENCE:   
;* ignore_me  = IFgwn( MODE=0, TEMP_VALS=temp_vals
;*                     [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;*                     [,CORR=corr] [,A=a] )
;*
;* newPattern = IFgwn( [MODE=1], PATTERN=pattern )
;* ignore_me  = IFgwn( MODE=[2|3] )
;	
; INPUT KEYWORDS: 
;                     A         :: amplitude of noise process (Default:1)
;                     CORR      :: all input receive fraction <*>CORR</*> of a
;                                 correlated GWN process
;                     DELTA_T   :: passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    :: height of the input to be created
;                     MODE      :: determines the performed action of the filter. 
;                                  <*>0</*>: INIT, <*>1</*>: STEP (Default), <*>2</*>: FREE, <*>3</*>: PLOT (filter characteristics (if useful))
;                     PATTERN   :: filter input
;                     TEMP_VALS :: internal structure that reflects the filter function/status. This
;                                 is initialized when <*>MODE=0</*>, read/modified for <*>MODE=1</*> and freed for
;                                 <*>MODE=2</*>
;                     WIDTH     :: width of the input to be created
;
; OUTPUTS:            newPattern:: the filtered version of <*>PATTERN</*>
;                     ignore_me :: just ignore it
;
; SIDE EFFECTS:       <*>TEMP_VALS</*> is changed by the function call!
;
; COMMON BLOCKS:      ATTENTION    :: for output to console 
;                     COMMON_RANDOM:: for correct handling of pseudo randoms
; 
; EXAMPLE:
;*
;* stim_amp = 0.1
;* stim_noise = 0.8
;* MFILTER(5) = Handle_Create(!MH, $
;*                            VALUE={NAME: 'IFgwn', $
;*                                   start: 0, $
;*                                   stop: simulation.time-1, $
;*                                   params: {A:stim_noise*stim_amp} $
;*                                  } $
;*                            )
;-
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.6  2004/03/16 10:58:30  zwickel
;     ... now really header according to latest convention; example added
;
;     Revision 1.5  2004/03/16 10:44:10  zwickel
;     introduced new header style
;
;     Revision 1.4  2000/09/29 08:10:35  saam
;     added the AIM tag
;
;     Revision 1.3  2000/06/29 14:46:14  saam
;           + _EXTRA added
;
;     Revision 1.2  2000/06/20 13:20:07  saam
;          + new keyword A to specify amplitude
;
;     Revision 1.1  2000/04/06 09:35:43  saam
;           added CORR keyword
;
;
;


FUNCTION IFgwn, MODE=mode, PATTERN=pattern, CORR=corr, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, A=a, _EXTRA=e

 COMMON ATTENTION
 Common COMMON_RANDOM, seed

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   
   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN                  
          Default, a   , 1.
          Default, corr, 0.0
          TV =  {                     $
                  h        : h       ,$
                  w        : w       ,$
                  a        : a       ,$
                  corr     : corr    ,$
                  delta_t  : delta_t ,$
                  sim_time : .0d      $
                }
          console, P.CON, 'sigma=1, a='+STR(TV.a)+', corr='+STR(TV.corr),/msg         
      END
      
      ; STEP
      1: BEGIN                             
         R = pattern + TV.a*((1-TV.corr)*RandomN(seed, TV.h, TV.w) + TV.corr*Rebin(RandomN(seed,1), TV.h, TV.w))
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
