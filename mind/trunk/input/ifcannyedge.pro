;+
; NAME:               IFcannyEdge
;
; AIM:                convolution of stimulus with orientation detector
;
; PURPOSE:            Convolves the input given in STIMULUS with a Canny-Edge
;                     (orientation) detector
;
; CATEGORY:           MIND INPUT 
;
; CALLING SEQUENCE:   
;                     ignore_me  = Ifcannyedge( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,/WRAP]
;                                              [,FILE=file]
;                                              [,A=a]
;                                              [,ORIENT=orient]
;                                              [,SIZE=size] )
;
;                     newPattern = Ifcannyedge( [MODE=1], PATTERN=pattern )
;                     ignore_me  = Ifcannyedge( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: A         : amplification of canny-edge detector
;                                 (Default: 1)
;                     DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     FILE      : provides a file skeleton (string) to save
;                                 data in an ordered way. 
;                     HEIGHT    : height of the input to be created
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     ORIENT    : orientation of the detector in DG
;                                 (0..360, Default: 0)
;                     PATTERN   : filter input
;                     SIZE      : quadratic size of the orientation
;                                 detector (Default: 25)
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;                     WRAP      : set, if the underlying layer has
;                                 toroidal boundary conditions
;                                 (default: no)
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
;
;     $Log$
;     Revision 1.1  2000/07/04 14:23:36  saam
;           grrr
;
;
;

FUNCTION IFcannyEdge, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, WRAP=wrap, TEMP_VALS=_TV, DELTA_T=delta_t, $
                      A=a, ORIENT=detectorient, SIZE=size, _EXTRA=e

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      
          Default, a, 1.
          Default, detectorient, 0
          Default, size, 25

          detect=Orient_2d(size, DEGREE=DETECTORIENT-90.)    

          TV =  {                             $
                  a            : a           ,$
                  w            : w           ,$
                  h            : h           ,$
                  wrap         : wrap        ,$
                  detect       : detect      ,$
                  detectorient : detectorient,$
                  delta_t      : delta_t     ,$
                  sim_time     : .0d          $
                }
          IF TV.wrap THEN s=', wrap' ELSE s=', nowrap'
         Console, 'a = '+STR(TV.a)+', orientation = '+STR(TV.detectorient)+' dg, size = '+STR(size)+s
      END
      
      ; STEP
      1: BEGIN                             
          IF TV.WRAP THEN R = TV.a*((convol(pattern, TV.detect, /EDGE_WRAP))) ELSE R = TV.a*((convol(pattern, TV.detect)))
          TV.sim_time =  TV.sim_time + TV.delta_tA/2:YS-A/2-1
      END
      
      ; FREE
      2: BEGIN
         console, 'done'
      END 

      ; PLOT
      3: BEGIN
         console, 'display mode not implemented, yet', /WARN
      END
      ELSE: BEGIN
         console, 'unknown mode', /FATAL
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
