;+
; NAME:   IFscale
;
; AIM: multiplies input with a constant factor
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
;     Revision 1.4  2000/09/29 08:10:35  saam
;     added the AIM tag
;
;     Revision 1.3  2000/08/11 10:30:43  thiel
;         Added FILE and WRAP keywords.
;
;     Revision 1.2  2000/01/19 14:51:00  alshaikh
;           now EVERY parameter is stored in temp_vals
;
;     Revision 1.1  2000/01/17 15:05:04  alshaikh
;           initial version
;
;
;-

FUNCTION ifscale, MODE=mode, PATTERN=pattern, WIDTH=w, HEIGHT=h $
                  , TEMP_VALS=_temp_vals, DELTA_T=delta_t $
                  , FACTOR=factor,  FILE=file,  WRAP=wrap
                  

   COMMON attention

   Default, mode, 1          ; i.e. step
   Default, pattern, !NONE
   Default, factor, 1.0
   Default, file, ''
   Default, wrap, 0
   
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
         
         Console, P.con, ' initialized.'         
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
         
         Console, P.con, ' stopped.'
         
      END
      
      ELSE: BEGIN
         Console, P.con, ' unknown mode.', /FATAL
      END
      
   ENDCASE 
   
   Handle_Value,_temp_vals,temp_vals,/no_copy,/set
   
   RETURN, pattern 

END
 
