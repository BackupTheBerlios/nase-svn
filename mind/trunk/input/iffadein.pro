;+
; NAME:   iffadein
;
;
; PURPOSE: linear fade-in of whatever 
;
;
; CATEGORY: input
;
;
; CALLING SEQUENCE:   internal
;
; KEYWORD PARAMETERS:    TIME : time for fade-in
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
;     Revision 1.2  2000/01/14 14:10:09  alshaikh
;           bugfix
;
;     Revision 1.1  2000/01/14 10:33:43  alshaikh
;           first filter ever made
;
;
;-


FUNCTION iffadein,MODE=mode,PATTERN=pattern,WIDTH=w,HEIGHT=h,temp_vals=_temp_vals,DELTA_t=delta_t,TIME=time

DEFAULT, mode, 1      ; i.e. step

Handle_Value,_temp_vals,temp_vals,/no_copy

   CASE mode OF

      0: BEGIN                  ; init

         step =  1.0/time

      temp_vals =  { $
                    sim_time : 0l, $
                    step     : step $
                    }
     
         
      END 

      
      1: BEGIN                    ; step
         
         IF temp_vals.sim_time LE time THEN  mult_fac= temp_vals.sim_time * temp_vals.step $
          ELSE mult_fac = 1
         pattern =  pattern * mult_fac

       print, temp_vals.sim_time

       temp_vals.sim_time =  temp_vals.sim_time + delta
      END

      2: BEGIN
         pattern = 0.0  
         print,'INPUT:filter ''iffadein'' stopped'

         END

    ENDCASE 
 Handle_Value,_temp_vals,temp_vals,/no_copy,/set

return, pattern 
END 
