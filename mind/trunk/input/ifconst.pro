;+
; NAME:
;   IFconst()
;
; AIM:
;   provides temporally constant input for a layer of neurons
;
; PURPOSE:
;   This filter generates a constant value for all neurons of the
;   layer or allows the user to specify invidual values for all neurons.
;   These values are by default ADDED to the already existing input.
;
; CATEGORY:
;  Input
;  Layers
;  MIND
;
; CALLING SEQUENCE:   
;*ignore_me  = IFconst( MODE=0, 
;*                       TEMP_VALS=temp_vals
;*                       [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;*                       [,LOGIC=logic] 
;*                       [,VALUE=value])
;*
;*newPattern = IFconst( [MODE=1], PATTERN=pattern )
;*ignore_me  = IFconst( MODE=[2|3] )
;	
; INPUT KEYWORDS: 
;   DELTA_T   :: passing time in ms between two sucessive calls of this filter function
;   HEIGHT    :: height of the input to be created
;   LOGIC     :: logical operation :
;               NEW_INPUT = OLD_INPUT #LOGIC# HERE_GENERATED_INPUT 
;               valid values can be found <A HREF=http://neuro.physik.uni-marburg.de/mind/sim/#OPID>here</A>
;   MODE      :: determines the performed action of the filter. 
;               0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;   PATTERN   :: filter input
;   TEMP_VALS :: internal structure that reflects the filter function/status. This
;               is initialized when MODE=0, read/modified for MODE=1 and freed for
;               MODE=2
;   WIDTH     :: width of the input to be created
;   VALUE     :: an arbitrary scalar or a two-dimensional array
;                (height,width) that is assigned to the specified
;                input of a layer 
;
; OUTPUTS:
;   newPattern:: the filtered version of PATTERN
;   ignore_me :: just ignore it
;
; COMMON BLOCKS:
;   ATTENTION
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
;-
FUNCTION IFconst, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                  LOGIC=op, VALUE=value, FILE=file, WRAP=wrap

   COMMON ATTENTION
   ON_ERROR, 2

   Default, mode , 1          ; i.e. step
   Default, R    , !NONE
   Default, op   , 'ADD'
   Default, value, 0.0
   Default, file, ''
   Default, wrap, 0

   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN      
          sv = SIZE(value)
          IF sv(0) EQ 0 THEN BEGIN ; user provided scalar, use for all neurons
              T = REPLICATE(value, h, w)
              Console, P.CON, 'homogenous value: '+STR(value)+', '+op
          END ELSE IF sv(0) EQ 2 THEN BEGIN 
              IF ((sv(1) EQ h) AND (sv(2) EQ w)) THEN BEGIN
                  T = VALUE
                  console, P.CON, 'user values, min: '+STR(min(T))+', max: '+STR(MAX(t))+', '+op
              END ELSE Console, 'wrong input dimensions: ('+STR(sv(1))+','+STR(sv(2))+') instead of ('+STR(h)+','+Str(w)+')', /FATAL
          END ELSE Console, 'wrong input format: scalar or 2d array', /FATAL
          TV =  {                                  $
                  R        : TEMPORARY(T)          ,$
                  delta_t  : delta_t               ,$
                  sim_time : .0d                   ,$
                  myop     : opID(op)               $
                }
      END
      
      ; STEP
      1: BEGIN                             
         R = Operator(TV.myop, pattern, TV.R)
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
         console, P.CON, 'unknown mode', /FATAL
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
