;+
; NAME:               IFTEMPLATE
;
; PURPOSE:            This is a prototype for an IFfilter. These functions are normally
;                     called by input.pro (MIND), but you can also you them by hand.
;                     This template realizes a filter for the genertion of a vertical bar.
;                     You can use the file as prototype for new filter functions. These
;                     should be located in $MINDDIR/input and should have the prefix 'IF'.
;                     The Keywords already provided MUST NOT BE CHANGED, but you could 
;                     add various new ones the specify your filter options.
;
; CATEGORY:           MIND INPUT TEMPLATES 
;
; CALLING SEQUENCE:   
;                     ignore_me  = IFTemplate( MODE=0, 
;                                              TEMP_VALS=temp_vals
;                                              [,WIDTH=width] [,HEIGHT=height] [,DELTA_T=delta_t] 
;                                              {various filter options} )
;
;                     newPattern = IFTemplate( [MODE=1], PATTERN=pattern )
;
;                     ignore_me  = IFTemplate( MODE=2 )
;	
; KEYWORD PARAMETERS: DELTA_T   : passing time between two sucessive calls of this filter function
;                     HEIGHT    : height of the input to be created
;                     MODE      : determines the performed action of the filter. 
;                                  0: INIT, 1: STEP (Default), 2: FREE
;                     PATTERN   : filter input
;                     TEMP_VALS : internal structure that reflects the filter function/status. This
;                                 is initialized when MODE=0, read/modified for MODE=1 and freed for
;                                 MODE=2
;                     WIDTH     : width of the input to be created
;                     {various filter options}: to be added by the author
;
;
; OUTPUTS:            newPattern: the filtered version of PATTERN
;                     ignore_me : just ignore it
;
; SIDE EFFECTS:       TEMP_VALS is changed by a function call!
;
; MODIFICATION HISTORY:
;
;     $Log$
;     Revision 1.3  2000/01/14 15:12:27  saam
;           + DocHeader rewritten
;           + default return pattern is !NONE now
;
;     Revision 1.2  2000/01/14 14:08:45  alshaikh
;           bugfix
;
;     Revision 1.1  2000/01/14 10:35:02  alshaikh
;           done
;
;
;-


FUNCTION iftemplate, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_temp_vals, DELTA_T=delta_t

   Default, mode   , 1          ; i.e. step
   Default, pattern, !NONE
   
   Handle_Value,_temp_vals,temp_vals,/no_copy
   
   
   CASE mode OF
      
;
; INITIALIZE
;
      0: BEGIN                  
         
         temp_vals =  { $
                       sim_time : 0l $
                      }
         
         print,'INPUT:filter ''iftemplate'' initialized'         
      END
      

;
; STEP
;
      1: BEGIN                    
         
         FOR x=0,h-1 DO BEGIN   ; e.g. draw a vertical bar
            FOR y=w/2-3,w/2+3 DO BEGIN 
               pattern(y,x) = 1.0
            ENDFOR
         endfor 
         
         
         temp_vals.sim_time =  temp_vals.sim_time + delta_t
         
      END
      
      
;
; FREE
;
      2:BEGIN
         
         print,'INPUT:filter ''iftemplate'' stopped'
         
      END 
      ELSE: BEGIN
         Message, 'unknown mode'
      END
      
   ENDCASE 
   
   Handle_Value,_temp_vals,temp_vals,/no_copy,/set
   
   RETURN, pattern 
END 
