;+
; NAME:               IFconst
;
; AIM:                provides constant input from all neurons
;
; PURPOSE:            This filter generates a constant value for all neurons of the layer.
;                     This value is by default ADDED to the already existing input.
;
; CATEGORY:           MIND INPUT
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFconst( MODE=0, 
;                                           TEMP_VALS=temp_vals
;                                           [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                           [,LOGIC=logic] 
;                                           [,VALUE=value])
;
;                     newPattern = IFconst( [MODE=1], PATTERN=pattern )
;                     ignore_me  = IFconst( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     LOGIC     : logical operation :
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
;                     VALUE     : an arbitrary scalar that is assigned to all inputs
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
;     Revision 1.5  2000/09/29 08:10:34  saam
;     added the AIM tag
;
;     Revision 1.4  2000/08/11 10:30:43  thiel
;         Added FILE and WRAP keywords.
;
;     Revision 1.3  2000/05/04 09:13:45  saam
;           forgot the ATTENTION block
;
;     Revision 1.2  2000/01/31 09:19:17  saam
;           print, message -> console
;
;     Revision 1.1  2000/01/27 10:49:06  saam
;            useful
;
;
;
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
            
         TV =  {                                  $
                R        : REPLICATE(value, h, w),$
                delta_t  : delta_t               ,$
                sim_time : .0d                   ,$
                myop     : opID(op)               $
               }
         console, P.CON, STR(value)+', '+op
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
