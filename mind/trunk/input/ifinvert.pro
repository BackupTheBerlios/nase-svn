;+
; NAME:               IFinvert
;
; AIM:                inverts a given input
;
; PURPOSE:            this filter inverts the given input
;                     it performs the following action :
;
;                        NEW_INPUT = base_value - OLD_INPUT,
;                     
;                     with the default base_value = 1 
;
; CATEGORY:           MIND INPUT  
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFinvert( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              [,BASE_VALUE=base_value] )
;
;                     newPattern = IFTemplate( [MODE=1], PATTERN=pattern )
;                     ignore_me  = IFTemplate( MODE=[2|3] )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time in ms between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE, 3: PLOT (filter characteristics (if useful))
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;                     BASE_VALUE: fixpoint ... NEW_VAL = BASE_VALUE - OLD_VAL  
;
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; SIDE EFFECTS:       TEMP_VALS is changed by the function call!
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/09/29 08:10:35  saam
;     added the AIM tag
;
;     Revision 1.1  2000/01/20 11:01:33  alshaikh
;           initial version
;
;
;-




FUNCTION IFinvert, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_TV, DELTA_T=delta_t, $
                   BASE_VALUE=base_value

   ON_ERROR, 2

   Default, mode, 1          ; i.e. step
   Default, R   , !NONE
   Default, base_value, 1.0
   
   Handle_Value, _TV, TV, /NO_COPY
   CASE mode OF      
      ; INITIALIZE
      0: BEGIN                  
         TV =  {                    $
                delta_t  : delta_t ,$                
                sim_time : .0d     ,$
                base_value : base_value $
               }
         print,'IFINVERT: initialized'         
      END
      
      ; STEP
      1: BEGIN                             
         R = pattern
        R = TV.base_value-R
      END
      
      ; FREE
      2: BEGIN
         print,'IFINVERT: done'
      END 

      ; PLOT
      3: BEGIN
         print, 'IFINVERT: display mode not implemented, yet'
      END
      ELSE: BEGIN
         Message, 'IFINVERT: unknown mode'
      END
   ENDCASE 
   Handle_Value, _TV, TV, /NO_COPY, /SET

   RETURN, R
END
