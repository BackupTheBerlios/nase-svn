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
;-
;
; MODIFICATION HISTORY:
;
;
;     $Log$
;     Revision 1.6  2000/01/28 15:24:09  saam
;           console changes updates
;
;     Revision 1.5  2000/01/27 17:44:25  alshaikh
;           new console-syntax
;
;     Revision 1.4  2000/01/26 16:20:39  alshaikh
;           print,message -> console
;
;     Revision 1.3  2000/01/19 14:51:00  alshaikh
;           now EVERY parameter is stored in temp_vals
;
;     Revision 1.2  2000/01/14 14:10:09  alshaikh
;           bugfix
;
;     Revision 1.1  2000/01/14 10:33:43  alshaikh
;           first filter ever made
;
;
FUNCTION iffadein,MODE=mode,PATTERN=pattern,WIDTH=w,HEIGHT=h,temp_vals=_temp_vals,DELTA_t=delta_t,TIME=time

   COMMON ATTENTION
   
   DEFAULT, mode, 1             ; i.e. step
   DEFAULT, time,10.0
   
   Handle_Value,_temp_vals,temp_vals,/no_copy

   CASE mode OF

      0: BEGIN                  ; init

         step =  1.0/time
         
         temp_vals =  { $
                       sim_time : 0d, $
                       step     : step, $
                       time     : time, $
                       delta_t  : delta_t $
                      }
     
          console,P.CON,'initialized',/msg         
      END 

      
      1: BEGIN                    ; step
         
         
         IF temp_vals.sim_time LE temp_vals.time THEN  mult_fac= temp_vals.sim_time * temp_vals.step $
          ELSE mult_fac = 1
         pattern =  pattern * mult_fac
         
       
 
       temp_vals.sim_time =  temp_vals.sim_time + temp_vals.delta_t

      END

      2: BEGIN
         pattern = 0.0  
         console,P.CON,'stopped',/msg

         END

    ENDCASE 
 Handle_Value,_temp_vals,temp_vals,/no_copy,/set

return, pattern 
END 
