;+
; NAME:   ifscale
;
;
; PURPOSE: input = input * factor 
;
;
; CATEGORY: input
;
;
; CALLING SEQUENCE:  internal
;
; 
; INPUTS:    FACTOR : scaling factor
;
;
; OPTIONAL INPUTS:
;
;	
; KEYWORD PARAMETERS:
;
;
; OUTPUTS:
;
;
; OPTIONAL OUTPUTS:
;
;
; COMMON BLOCKS:
;
;
; SIDE EFFECTS:
;
;
; RESTRICTIONS:
;
; PROCEDURE:
;
;
; EXAMPLE:
;
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.2  2000/01/19 14:51:00  alshaikh
;           now EVERY parameter is stored in temp_vals
;
;     Revision 1.1  2000/01/17 15:05:04  alshaikh
;           initial version
;
;
;-

FUNCTION ifscale, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h, TEMP_VALS=_temp_vals, DELTA_T=delta_t,$
                  FACTOR=factor
                  

   Default, mode   , 1          ; i.e. step
   Default, pattern, !NONE
   Default, FACTOR, 1.0
   
   Handle_Value,_temp_vals,temp_vals,/no_copy
   
   
   CASE mode OF
      
;
; INITIALIZE
;
      0: BEGIN                  
         
         temp_vals =  { $
                       sim_time : 0l ,$
                       factor   : factor, $
                       delta_t  : delta_t $
                      }
         
         print,'INPUT:filter ''ifscale'' initialized'         
      END
      

;
; STEP
;
      1: BEGIN                    
         
         pattern =  pattern * temp_vals.factor
         temp_vals.sim_time =  temp_vals.sim_time + temp_vals.delta_t
         
      END
      
      
;
; FREE
;
      2:BEGIN
         
         print,'INPUT:filter ''ifscale'' stopped'
         
      END 
      ELSE: BEGIN
         Message, 'unknown mode'
      END
      
   ENDCASE 
   
   Handle_Value,_temp_vals,temp_vals,/no_copy,/set
   
   RETURN, pattern 
END 
